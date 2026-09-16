#Requires -Version 5.1
<#
.SYNOPSIS
    Instala ou remove a camada Jarvis do Apex Prime (prime-core + prime-architect).

.DESCRIPTION
    Achata as camadas em um unico diretorio de skills e instala o adapter da
    plataforma escolhida. O recorte Jarvis e' estrutural: prime-dev e os
    adapters do Friday nunca sao lidos por este script.

    O mesmo script atende a maquina do dev e o runner de CI -- por isso
    -Source e -Destination sao explicitos em vez de assumidos.

    Um manifesto (apex-prime.json) grava o hash de cada arquivo instalado. Na
    execucao seguinte, arquivo cujo hash divergiu do gravado foi editado
    localmente e e' preservado, a menos que -Force. O mesmo manifesto e' o que
    permite a -Uninstall remover exatamente o que foi instalado, e nada alem.

    Escrito para rodar sob ConstrainedLanguage mode (WDAC/AppLocker): sem
    [pscustomobject], sem New-Object, sem chamadas a [System.IO.*] e sem
    $PSCmdlet.ShouldProcess(). Consequencia: -WhatIf funciona, -Confirm nao.

.PARAMETER Target
    copilot (default) - .github/skills + .github/agents   (ou ~/.copilot/...)
    claude            - .claude/skills + .claude/commands (ou ~/.claude/...)
    both              - skills em .claude (lido pelas duas plataformas) mais
                        os dois adapters. Nao duplica as skills.

.PARAMETER Scope
    user (default) - instala no perfil; nada entra no repositorio.
    project        - instala na raiz de -Destination, para commitar.

.PARAMETER Uninstall
    Remove o que o manifesto registra. Arquivo editado localmente e' mantido e
    continua no manifesto, para que um -Uninstall -Force posterior conclua.

.EXAMPLE
    .\Install-ApexPrime.ps1 -WhatIf

.EXAMPLE
    .\Install-ApexPrime.ps1 -Target both

.EXAMPLE
    .\Install-ApexPrime.ps1 -Scope project -Destination C:\repos\meu-projeto

.EXAMPLE
    .\Install-ApexPrime.ps1 -Uninstall -Target both
#>
[CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Install')]
param(
    [Parameter(ParameterSetName = 'Uninstall', Mandatory = $true)]
    [switch] $Uninstall,

    [ValidateSet('copilot', 'claude', 'both')]
    [string] $Target = 'copilot',

    [ValidateSet('user', 'project')]
    [string] $Scope = 'user',

    [Parameter(ParameterSetName = 'Install')]
    [string] $Source,

    [string] $Destination,

    [Parameter(ParameterSetName = 'Install')]
    [string] $Version,

    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- O recorte Jarvis. Nada fora desta lista e' lido. -----------------------
$SkillLayers    = @('prime-core', 'prime-architect')
$CopilotAdapter = 'adapters/copilot/jarvis.agent.md'
$ClaudeAdapter  = 'adapters/claude-code/jarvis.md'

$script:ForceRun  = [bool]$Force
$script:Written   = 0
$script:Unchanged = 0
$script:Preserved = 0
$script:Removed   = 0
$script:Kept      = 0

function Get-Sha256 {
    param([Parameter(Mandatory)][string] $Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

# ConstrainedLanguage bloqueia $PSCmdlet.ShouldProcess() -- $PSCmdlet nao e'
# core type. -WhatIf continua alimentando $WhatIfPreference, entao o dry run
# passa por aqui. -Confirm, por consequencia, nao e' honrado.
function Test-Apply {
    param(
        [Parameter(Mandatory)][string] $Action,
        [Parameter(Mandatory)][string] $Path
    )
    if ($WhatIfPreference) {
        Write-Host "What if: $Action -> $Path"
        return $false
    }
    return $true
}

# Traduz uma chave do manifesto no caminho absoluto correspondente. Unica
# autoridade sobre esse mapeamento: a poda e a desinstalacao usam as duas.
function Resolve-ManagedPath {
    param(
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][string] $SkillsRoot,
        [Parameter(Mandatory)][string] $CopilotRoot,
        [Parameter(Mandatory)][string] $ClaudeRoot
    )
    $tail = $Key -replace '/', '\'
    if ($Key -like 'skills/*')      { return (Join-Path $SkillsRoot  $tail) }
    elseif ($Key -like 'agents/*')  { return (Join-Path $CopilotRoot $tail) }
    else                            { return (Join-Path $ClaudeRoot  $tail) }
}

function Remove-ManagedFile {
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][string] $RecordedHash,
        [Parameter(Mandatory)][string] $Reason
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $true }

    if ((Get-Sha256 -Path $Path) -ne $RecordedHash -and -not $script:ForceRun) {
        Write-Warning "$Reason mas editado localmente, mantido: $Key"
        $script:Kept++
        return $false
    }
    if (Test-Apply -Action 'Remover' -Path $Path) {
        Remove-Item -LiteralPath $Path -Force
        $script:Removed++
    }
    return $true
}

function Remove-EmptyDirectory {
    param([Parameter(Mandatory)][string] $Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return }
    if (Get-ChildItem -LiteralPath $Path -Recurse -File) { return }
    if (Test-Apply -Action 'Remover diretorio vazio' -Path $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

function Read-ManifestFiles {
    param([Parameter(Mandatory)][string] $Path)
    $map = @{}
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $map }
    $data = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    if (($data.PSObject.Properties.Name -contains 'files') -and $data.files) {
        foreach ($entry in @($data.files)) { $map[$entry.path] = $entry.sha256 }
    }
    return $map
}

function Write-Manifest {
    param(
        [Parameter(Mandatory)][string]    $Path,
        [Parameter(Mandatory)][hashtable] $Files,
        [Parameter(Mandatory)][string[]]  $Skills,
        [Parameter(Mandatory)][string]    $ManifestVersion,
        [Parameter(Mandatory)][string]    $ManifestTarget,
        [Parameter(Mandatory)][string]    $ManifestScope
    )
    # files e' lista ordenada por path, nao mapa: hashtable em 5.1 nao preserva
    # ordem, e com -Scope project este arquivo entra no diff de um PR.
    $list = @()
    foreach ($key in ($Files.Keys | Sort-Object)) {
        $list += @{ path = $key; sha256 = $Files[$key] }
    }
    $manifest = @{
        package     = 'apex-prime-jarvis'
        version     = $ManifestVersion
        target      = $ManifestTarget
        scope       = $ManifestScope
        installedAt = (Get-Date).ToUniversalTime().ToString('o')
        skills      = @($Skills | Sort-Object)
        files       = $list
    }
    if (Test-Apply -Action 'Gravar manifesto' -Path $Path) {
        $parent = Split-Path -Parent $Path
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        $manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $Path -Encoding UTF8
    }
}

function Copy-Managed {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]    $From,
        [Parameter(Mandatory)][string]    $To,
        [Parameter(Mandatory)][string]    $Key,
        [Parameter(Mandatory)][hashtable] $Previous,
        [Parameter(Mandatory)][hashtable] $Next
    )

    $sourceHash = Get-Sha256 -Path $From

    if (Test-Path -LiteralPath $To -PathType Leaf) {
        $currentHash = Get-Sha256 -Path $To

        if ($currentHash -eq $sourceHash) {
            $Next[$Key] = $sourceHash
            $script:Unchanged++
            return
        }

        if ($Previous.ContainsKey($Key) -and $Previous[$Key] -ne $currentHash -and -not $script:ForceRun) {
            Write-Warning "editado localmente, preservado: $Key"
            $Next[$Key] = $Previous[$Key]
            $script:Preserved++
            return
        }
    }

    if (Test-Apply -Action 'Instalar' -Path $To) {
        $parent = Split-Path -Parent $To
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item -LiteralPath $From -Destination $To -Force
    }

    $Next[$Key] = $sourceHash
    $script:Written++
}

# --- Destino ----------------------------------------------------------------
if ($Scope -eq 'user') {
    if ($Destination) { throw '-Destination so se aplica a -Scope project.' }
    $root        = $HOME
    $copilotHome = Join-Path $root '.copilot'
    $claudeHome  = Join-Path $root '.claude'
} else {
    if (-not $Destination) { $Destination = (Get-Location).Path }
    $root        = (Resolve-Path -LiteralPath $Destination).Path
    $copilotHome = Join-Path $root '.github'
    $claudeHome  = Join-Path $root '.claude'
}

# Com 'both' as skills vao para .claude, que o Claude Code E o Copilot leem.
# Instalar nos dois lugares registraria skills de nome duplicado no Copilot.
if ($Target -eq 'copilot') { $skillsRoot = $copilotHome } else { $skillsRoot = $claudeHome }

$skillsHome   = Join-Path $skillsRoot 'skills'
$manifestPath = Join-Path $skillsRoot 'apex-prime.json'
$agentsHome   = Join-Path $copilotHome 'agents'
$commandsHome = Join-Path $claudeHome  'commands'

# ============================================================================
#  DESINSTALACAO
# ============================================================================
if ($Uninstall) {
    # O manifesto e' a autoridade: seu diretorio define onde as skills estao,
    # independentemente do -Target informado.
    $candidates = @()
    foreach ($candidate in @((Join-Path $copilotHome 'apex-prime.json'), (Join-Path $claudeHome 'apex-prime.json'))) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { $candidates += $candidate }
    }

    if ($candidates.Count -eq 0) {
        Write-Host ''
        Write-Host "Nada a remover: nenhum manifesto em $copilotHome nem em $claudeHome" -ForegroundColor Yellow
        Write-Host ''
        return
    }

    if ($candidates.Count -eq 1 -and $candidates[0] -ne $manifestPath) {
        Write-Warning "manifesto encontrado em $($candidates[0]); ignorando o caminho de -Target $Target."
        $manifestPath = $candidates[0]
    } elseif ($candidates -notcontains $manifestPath) {
        throw "Ha manifestos em mais de um local e nenhum corresponde a -Target $Target. Rode novamente com o -Target correto."
    }

    $skillsRoot = Split-Path -Parent $manifestPath
    $skillsHome = Join-Path $skillsRoot 'skills'

    $installed = Read-ManifestFiles -Path $manifestPath
    if ($installed.Count -eq 0) {
        Write-Warning "Manifesto sem arquivos registrados: $manifestPath"
    }

    Write-Host ''
    Write-Host 'Apex Prime - Jarvis (desinstalacao)' -ForegroundColor Cyan
    Write-Host "  manifesto: $manifestPath"
    Write-Host "  arquivos : $($installed.Count)"
    Write-Host ''

    $remaining = @{}
    foreach ($key in ($installed.Keys | Sort-Object)) {
        $path = Resolve-ManagedPath -Key $key -SkillsRoot $skillsRoot -CopilotRoot $copilotHome -ClaudeRoot $claudeHome
        if (-not (Remove-ManagedFile -Path $path -Key $key -RecordedHash $installed[$key] -Reason 'desinstalando')) {
            $remaining[$key] = $installed[$key]
        }
    }

    if (Test-Path -LiteralPath $skillsHome -PathType Container) {
        foreach ($directory in (Get-ChildItem -LiteralPath $skillsHome -Directory)) {
            Remove-EmptyDirectory -Path $directory.FullName
        }
    }
    foreach ($directory in @($skillsHome, $agentsHome, $commandsHome)) {
        Remove-EmptyDirectory -Path $directory
    }

    if ($remaining.Count -gt 0) {
        # Reescreve o manifesto so com o que sobrou, para que um -Uninstall
        # -Force posterior saiba exatamente o que ainda falta remover.
        $remainingSkills = @()
        foreach ($key in $remaining.Keys) {
            if ($key -like 'skills/*') {
                $name = ($key -split '/')[1]
                if ($remainingSkills -notcontains $name) { $remainingSkills += $name }
            }
        }
        Write-Manifest -Path $manifestPath -Files $remaining -Skills $remainingSkills `
            -ManifestVersion 'partially-uninstalled' -ManifestTarget $Target -ManifestScope $Scope
    } else {
        if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
            if (Test-Apply -Action 'Remover manifesto' -Path $manifestPath) {
                Remove-Item -LiteralPath $manifestPath -Force
            }
        }
    }

    Write-Host ''
    Write-Host ("{0} removido(s), {1} mantido(s) por edicao local" -f $script:Removed, $script:Kept) -ForegroundColor Green
    if ($script:Kept -gt 0) {
        Write-Host 'Rode novamente com -Force para remover os mantidos.' -ForegroundColor DarkYellow
    }
    Write-Host ''
    return
}

# ============================================================================
#  INSTALACAO
# ============================================================================
if (-not $Source) { $Source = Split-Path -Parent $PSScriptRoot }
$Source = (Resolve-Path -LiteralPath $Source).Path

foreach ($layer in $SkillLayers) {
    if (-not (Test-Path -LiteralPath (Join-Path $Source $layer) -PathType Container)) {
        throw "-Source nao parece ser a arvore do Apex Prime: falta '$layer' em $Source"
    }
}

if (-not $Version) {
    $described = ''
    try {
        $described = (& git -C $Source describe --tags --always --dirty | Out-String).Trim()
    } catch {
        $described = ''
    }
    if ($described) { $Version = $described } else { $Version = 'unknown' }
}

$adapters = @()
if ($Target -eq 'copilot' -or $Target -eq 'both') {
    $adapters += @{
        From = $CopilotAdapter
        To   = Join-Path $agentsHome 'jarvis.agent.md'
        Key  = 'agents/jarvis.agent.md'
    }
}
if ($Target -eq 'claude' -or $Target -eq 'both') {
    $adapters += @{
        From = $ClaudeAdapter
        To   = Join-Path $commandsHome 'jarvis.md'
        Key  = 'commands/jarvis.md'
    }
}

$previousFiles = Read-ManifestFiles -Path $manifestPath
$nextFiles     = @{}

# --- Inventario das skills ---------------------------------------------------
$skills     = @()
$skillNames = @()
foreach ($layer in $SkillLayers) {
    $layerPath = Join-Path $Source $layer
    foreach ($directory in (Get-ChildItem -LiteralPath $layerPath -Directory)) {
        if (-not (Test-Path -LiteralPath (Join-Path $directory.FullName 'SKILL.md') -PathType Leaf)) {
            Write-Warning "ignorando (sem SKILL.md): $layer/$($directory.Name)"
            continue
        }
        if ($skillNames -contains $directory.Name) {
            throw "Nome de skill repetido entre camadas: $($directory.Name)"
        }
        $skillNames += $directory.Name
        $skills     += @{ Name = $directory.Name; Path = $directory.FullName; Layer = $layer }
    }
}

if ($skills.Count -eq 0) { throw "Nenhuma skill encontrada em: $($SkillLayers -join ', ')" }

Write-Host ''
Write-Host "Apex Prime - Jarvis $Version" -ForegroundColor Cyan
Write-Host "  target : $Target"
Write-Host "  scope  : $Scope"
Write-Host "  skills : $skillsHome"
foreach ($adapter in $adapters) { Write-Host "  adapter: $($adapter.To)" }
Write-Host ''

foreach ($skill in $skills) {
    $skillPath = $skill.Path
    foreach ($file in (Get-ChildItem -LiteralPath $skillPath -Recurse -File)) {
        $relative = $file.FullName.Substring($skillPath.Length).TrimStart('\', '/')
        $key = 'skills/' + $skill.Name + '/' + ($relative -replace '\\', '/')
        $to  = Join-Path $skillsHome (Join-Path $skill.Name $relative)
        Copy-Managed -From $file.FullName -To $to -Key $key -Previous $previousFiles -Next $nextFiles
    }
}

foreach ($adapter in $adapters) {
    $from = Join-Path $Source $adapter.From
    if (-not (Test-Path -LiteralPath $from -PathType Leaf)) {
        throw "Adapter ausente em -Source: $($adapter.From)"
    }
    Copy-Managed -From $from -To $adapter.To -Key $adapter.Key -Previous $previousFiles -Next $nextFiles
}

# --- Poda: o que o manifesto anterior instalou e esta versao nao traz ---------
foreach ($key in @($previousFiles.Keys)) {
    if ($nextFiles.ContainsKey($key)) { continue }
    $stale = Resolve-ManagedPath -Key $key -SkillsRoot $skillsRoot -CopilotRoot $copilotHome -ClaudeRoot $claudeHome
    if (-not (Remove-ManagedFile -Path $stale -Key $key -RecordedHash $previousFiles[$key] -Reason 'removido upstream')) {
        $nextFiles[$key] = $previousFiles[$key]
    }
}

if (Test-Path -LiteralPath $skillsHome -PathType Container) {
    foreach ($directory in (Get-ChildItem -LiteralPath $skillsHome -Directory)) {
        Remove-EmptyDirectory -Path $directory.FullName
    }
}

Write-Manifest -Path $manifestPath -Files $nextFiles -Skills $skillNames `
    -ManifestVersion $Version -ManifestTarget $Target -ManifestScope $Scope

Write-Host ''
Write-Host ("{0} skill(s) | {1} gravado(s), {2} ja atualizado(s), {3} preservado(s), {4} removido(s)" -f $skills.Count, $script:Written, $script:Unchanged, $script:Preserved, $script:Removed) -ForegroundColor Green
if ($Target -eq 'copilot') {
    Write-Host 'Formato Copilot. O Claude Code nao le estes caminhos - use -Target both para incluir.' -ForegroundColor DarkYellow
}
Write-Host ''
