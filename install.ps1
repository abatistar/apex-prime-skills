#Requires -Version 5.1

<#
.SYNOPSIS
    Instala ou remove o Apex Prime: as skills do prime-core e do
    prime-architect e o adapter do Jarvis.

.DESCRIPTION
    Achata prime-core + prime-architect em um unico diretorio de skills,
    instala o adapter do Jarvis no formato do agente e grava um manifesto
    (apex-prime.json) com o hash de cada arquivo instalado.

    Origem: rodando de dentro de um clone, instala o proprio clone. Baixado
    avulso -- ou com -Ref -- clona a versao pedida em um diretorio
    temporario, instala a partir dele e o remove ao final, mesmo em erro.

    O manifesto torna a reinstalacao segura. Arquivo cujo hash divergiu do
    gravado foi editado no destino e e' preservado; arquivo que ja existia e
    nao veio do Apex Prime tambem. -Force sobrescreve os dois. O que a
    instalacao anterior trouxe e esta nao traz -- skill ou adapter removido
    upstream -- e' podado. -Desinstalar remove exatamente o que o manifesto
    registra, e nada alem.

    Escrito para rodar sob ConstrainedLanguage mode (WDAC/AppLocker): sem
    [pscustomobject], sem New-Object, sem metodos fora dos tipos do core e
    sem $PSCmdlet.ShouldProcess(). Consequencia: -WhatIf funciona, -Confirm
    nao.

.PARAMETER Local
    usuario (padrao) - perfil do usuario (~/.copilot ou ~/.claude); nenhum
                       repositorio e' tocado.
    <caminho>        - raiz de um projeto (.github ou .claude), para commitar.

.PARAMETER Agente
    copilot (padrao) - skills/ + agents/jarvis.agent.md
    claude           - skills/ + commands/jarvis.md (/jarvis)

.PARAMETER Desinstalar
    Remove o que o manifesto de -Local/-Agente registra. Arquivo editado
    localmente e' mantido e continua no manifesto, para que um -Desinstalar
    -Force posterior conclua.

.PARAMETER Force
    Sobrescreve ou remove tambem o que foi editado localmente e o que nao
    veio do Apex Prime.

.PARAMETER Ref
    Tag ou branch a clonar. Sem -Ref, um clone instala a si mesmo e uma copia
    avulsa clona main. Prefira tag: main e' o topo do branch, justamente o
    que o versionamento existe para evitar. SHA avulso nao e' suportado.

.PARAMETER Repositorio
    Origem do clone. Aceita URL ou caminho local.

.EXAMPLE
    .\install.ps1 -WhatIf

.EXAMPLE
    .\install.ps1 -Agente claude

.EXAMPLE
    .\install.ps1 -Local C:\repos\meu-projeto

.EXAMPLE
    .\install.ps1 -Ref v1.0.0 -Agente claude

.EXAMPLE
    .\install.ps1 -Desinstalar -Agente claude
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string] $Local = 'usuario',

    [ValidateSet('copilot', 'claude')]
    [string] $Agente = 'copilot',

    [switch] $Desinstalar,

    [switch] $Force,

    [string] $Ref,

    [string] $Repositorio = 'https://github.com/abatistar/apex-prime-skills.git'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- O recorte. Nada fora destas listas e' lido. ----------------------------
$Layers = @('prime-core', 'prime-architect')
$Roles  = @('jarvis')

# --- Onde cada agente descobre skills e adapters. ---------------------------
$Formats = @{
    copilot = @{ ProjectDir = '.github'; UserDir = '.copilot'; Adapters = 'adapters/copilot';     AdapterDir = 'agents';   Suffix = '.agent.md' }
    claude  = @{ ProjectDir = '.claude'; UserDir = '.claude';  Adapters = 'adapters/claude-code'; AdapterDir = 'commands'; Suffix = '.md' }
}

# O dry run e' decidido aqui, uma vez, e a preferencia e' desligada: no 5.1 o
# Get-FileHash passa por um ForEach-Object que honra $WhatIfPreference e, sob
# -WhatIf, devolve nada. Toda escrita passa por Test-Apply.
$script:DryRun    = [bool]$WhatIfPreference
$WhatIfPreference = $false

$script:Root             = ''
$script:LegacyAgentsRoot = ''
$script:ForceRun         = [bool]$Force
$script:Written          = 0
$script:Unchanged        = 0
$script:Preserved        = 0
$script:Removed          = 0
$script:Kept             = 0

function Get-Sha256 {
    param([Parameter(Mandatory)][string] $Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

# ConstrainedLanguage bloqueia $PSCmdlet.ShouldProcess() -- $PSCmdlet nao e'
# tipo do core. O dry run passa por aqui, via $script:DryRun. -Confirm, por
# consequencia, nao e' honrado.
function Test-Apply {
    param(
        [Parameter(Mandatory)][string] $Action,
        [Parameter(Mandatory)][string] $Path
    )
    if ($script:DryRun) {
        Write-Host "WhatIf: $Action -> $Path"
        return $false
    }
    return $true
}

# Monta o caminho segmento a segmento: as chaves usam '/', e Join-Path com o
# caminho inteiro misturaria separadores no Windows.
function Join-Key {
    param(
        [Parameter(Mandatory)][string] $Base,
        [Parameter(Mandatory)][string] $Key
    )
    $path = $Base
    foreach ($segment in ($Key -split '/')) { $path = Join-Path $path $segment }
    return $path
}

function Get-InstallRoot {
    param(
        [string] $Location,
        [Parameter(Mandatory)][string] $Agent
    )
    if ($Location) { return (Join-Path $Location $Formats[$Agent].ProjectDir) }
    return (Join-Path $HOME $Formats[$Agent].UserDir)
}

# A v1.0.0 com -Target both gravava o manifesto em .claude, mas o adapter do
# Copilot em .github/.copilot. So nesse caso uma chave sai da raiz.
function Test-LegacyKey {
    param([Parameter(Mandatory)][string] $Key)
    return [bool]($script:LegacyAgentsRoot -and $Key -like 'agents/*')
}

function Resolve-ManagedPath {
    param([Parameter(Mandatory)][string] $Key)
    if (Test-LegacyKey -Key $Key) { return (Join-Key -Base $script:LegacyAgentsRoot -Key $Key) }
    return (Join-Key -Base $script:Root -Key $Key)
}

# Sobe a partir do arquivo removendo diretorios vazios, ate a raiz -- que
# nunca e' removida.
function Remove-EmptyParents {
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string] $Stop
    )
    $directory = Split-Path -Parent $Path
    while ($directory -and $directory -ne $Stop -and $directory.Length -gt $Stop.Length) {
        if (-not (Test-Path -LiteralPath $directory -PathType Container)) { return }
        if (Get-ChildItem -LiteralPath $directory -Force) { return }
        if (-not (Test-Apply -Action 'Remover diretorio vazio' -Path $directory)) { return }
        Remove-Item -LiteralPath $directory -Force
        $directory = Split-Path -Parent $directory
    }
}

# Devolve $true se o arquivo nao existe mais (ou deixaria de existir, em
# -WhatIf); $false se foi mantido por edicao local.
function Remove-ManagedFile {
    param(
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][string] $RecordedHash,
        [Parameter(Mandatory)][string] $Reason
    )
    $path = Resolve-ManagedPath -Key $Key
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $true }

    if ((Get-Sha256 -Path $path) -ne $RecordedHash -and -not $script:ForceRun) {
        Write-Warning "$Reason, mas editado localmente; mantido: $Key"
        return $false
    }
    if (Test-Apply -Action 'Remover' -Path $path) {
        Remove-Item -LiteralPath $path -Force
        $stop = $script:Root
        if (Test-LegacyKey -Key $Key) { $stop = $script:LegacyAgentsRoot }
        Remove-EmptyParents -Path $path -Stop $stop
    }
    $script:Removed++
    return $true
}

function Read-Manifest {
    param([Parameter(Mandatory)][string] $Path)
    $manifest = @{ Files = @{}; Legacy = $false; Version = '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $manifest }

    $data = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    $properties = @($data.PSObject.Properties.Name)
    $manifest['Legacy'] = $properties -notcontains 'agente'
    if ($properties -contains 'version') { $manifest['Version'] = [string]$data.version }
    if ($properties -contains 'files') {
        foreach ($entry in @($data.files)) { $manifest.Files[$entry.path] = $entry.sha256 }
    }
    return $manifest
}

function Write-Manifest {
    param(
        [Parameter(Mandatory)][string]    $Path,
        [Parameter(Mandatory)][hashtable] $Files,
        [Parameter(Mandatory)][string]    $ManifestVersion,
        [Parameter(Mandatory)][string]    $ManifestScope
    )
    # files e' lista ordenada por path, e nao mapa: hashtable em 5.1 nao
    # preserva ordem, e num projeto este arquivo entra no diff de um PR. Pelo
    # mesmo motivo nao ha data de instalacao: reinstalar igual nao gera diff.
    $list   = @()
    $skills = @()
    foreach ($key in ($Files.Keys | Sort-Object)) {
        $list += @{ path = $key; sha256 = $Files[$key] }
        if ($key -like 'skills/*') {
            $name = ($key -split '/')[1]
            if ($skills -notcontains $name) { $skills += $name }
        }
    }
    $manifest = @{
        package = 'apex-prime'
        version = $ManifestVersion
        agente  = $Agente
        local   = $ManifestScope
        skills  = $skills
        files   = $list
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
    param(
        [Parameter(Mandatory)][string]    $From,
        [Parameter(Mandatory)][string]    $Key,
        [Parameter(Mandatory)][hashtable] $Previous,
        [Parameter(Mandatory)][hashtable] $Next
    )
    $to         = Join-Key -Base $script:Root -Key $Key
    $sourceHash = Get-Sha256 -Path $From

    if (Test-Path -LiteralPath $to -PathType Leaf) {
        $currentHash = Get-Sha256 -Path $to
        if ($currentHash -eq $sourceHash) {
            $Next[$Key] = $sourceHash
            $script:Unchanged++
            return
        }
        if (-not $script:ForceRun) {
            if (-not $Previous.ContainsKey($Key)) {
                # Nao entra no manifesto: o que nao foi instalado aqui nunca
                # e' removido daqui.
                Write-Warning "ja existia e nao veio do Apex Prime; preservado: $to"
                $script:Preserved++
                return
            }
            if ($Previous[$Key] -ne $currentHash) {
                Write-Warning "editado localmente; preservado: $Key"
                $Next[$Key] = $Previous[$Key]
                $script:Preserved++
                return
            }
        }
    }

    if (Test-Apply -Action 'Instalar' -Path $to) {
        $parent = Split-Path -Parent $to
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item -LiteralPath $From -Destination $to -Force
    }
    $Next[$Key] = $sourceHash
    $script:Written++
}

function Get-TreeVersion {
    param([Parameter(Mandatory)][string] $Path)
    if (-not (Get-Command git -CommandType Application -ErrorAction SilentlyContinue)) { return 'desconhecida' }
    # Em 5.1, stderr de comando nativo redirecionado vira erro terminante sob
    # 'Stop' -- uma arvore sem .git nao pode derrubar a instalacao.
    $ErrorActionPreference = 'Continue'
    $described = (& git -C $Path describe --tags --always --dirty 2>$null | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $described) { return 'desconhecida' }
    return $described
}

# --- Destino ----------------------------------------------------------------
# 'usuario' com ou sem acento: o script fica em ASCII, que e' o que o 5.1 le
# sem BOM sem corromper.
if (-not $Local -or $Local -like 'usu?rio') {
    $location = ''
    $scope    = 'usuario'
} else {
    if (-not (Test-Path -LiteralPath $Local -PathType Container)) {
        throw "-Local: diretorio nao encontrado: $Local"
    }
    $location = (Resolve-Path -LiteralPath $Local).ProviderPath
    $scope    = 'projeto'
}

$format       = $Formats[$Agente]
$script:Root  = Get-InstallRoot -Location $location -Agent $Agente
$manifestPath = Join-Path $script:Root 'apex-prime.json'
$previous     = Read-Manifest -Path $manifestPath

if ($previous.Legacy -and $Agente -eq 'claude') {
    $script:LegacyAgentsRoot = Get-InstallRoot -Location $location -Agent 'copilot'
}

# ============================================================================
#  DESINSTALACAO
# ============================================================================
if ($Desinstalar) {
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        Write-Host ''
        Write-Host "Nada a remover: nenhum manifesto em $script:Root" -ForegroundColor Yellow
        Write-Host ''
        return
    }

    Write-Host ''
    Write-Host 'Apex Prime - desinstalacao' -ForegroundColor Cyan
    Write-Host "  manifesto: $manifestPath"
    Write-Host "  arquivos : $($previous.Files.Count)"
    Write-Host ''

    $remaining = @{}
    foreach ($key in ($previous.Files.Keys | Sort-Object)) {
        if (Remove-ManagedFile -Key $key -RecordedHash $previous.Files[$key] -Reason 'desinstalando') { continue }
        if (Test-LegacyKey -Key $key) {
            Write-Warning "fora do formato atual, deixa de ser gerenciado: $(Resolve-ManagedPath -Key $key)"
            continue
        }
        $remaining[$key] = $previous.Files[$key]
        $script:Kept++
    }

    if ($remaining.Count -gt 0) {
        # Reescreve o manifesto so com o que sobrou, para que um -Desinstalar
        # -Force posterior saiba exatamente o que ainda falta remover.
        Write-Manifest -Path $manifestPath -Files $remaining -ManifestVersion $previous.Version `
            -ManifestScope $scope
    } elseif (Test-Apply -Action 'Remover manifesto' -Path $manifestPath) {
        Remove-Item -LiteralPath $manifestPath -Force
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
$workspace = ''

try {
    # --- Origem -------------------------------------------------------------
    # Um -Ref explicito sempre clona: honrar o clone local o ignoraria em
    # silencio.
    $inClone = $PSScriptRoot -and (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'prime-core') -PathType Container)
    if ($inClone -and -not $Ref) {
        $source  = $PSScriptRoot
        $version = Get-TreeVersion -Path $source
    } else {
        if (-not $Ref) { $Ref = 'main' }
        if (-not (Get-Command git -CommandType Application -ErrorAction SilentlyContinue)) {
            throw 'git nao encontrado no PATH. Instale o Git ou clone o repositorio e rode o install.ps1 de dentro dele.'
        }
        $tempRoot = $env:TEMP
        if (-not $tempRoot) { $tempRoot = $env:TMPDIR }
        if (-not $tempRoot) { $tempRoot = '/tmp' }
        $workspace = Join-Path $tempRoot ('apex-prime-' + (Get-Random))

        Write-Host ''
        Write-Host "Clonando $Repositorio ($Ref)..." -ForegroundColor Cyan
        # --quiet e advice.detachedHead=false para que a saida lida seja a do
        # instalador. Clonar uma tag cai em detached HEAD.
        & git -c advice.detachedHead=false clone --quiet --depth 1 --branch $Ref -- $Repositorio $workspace
        if ($LASTEXITCODE -ne 0) {
            throw "git clone falhou (exit $LASTEXITCODE). Confira -Ref '$Ref' e o acesso a $Repositorio."
        }
        $source  = $workspace
        # Tag: o describe devolve a propria tag. Branch: devolve o SHA, que
        # vai junto do nome -- 'main' sozinho nao diz o que foi instalado.
        $version = Get-TreeVersion -Path $source
        if ($version -ne $Ref) { $version = "$Ref@$version" }
    }

    # --- Inventario ---------------------------------------------------------
    $items      = @()
    $skillNames = @()
    foreach ($layer in $Layers) {
        $layerPath = Join-Path $source $layer
        if (-not (Test-Path -LiteralPath $layerPath -PathType Container)) {
            throw "A origem nao parece ser a arvore do Apex Prime: falta '$layer' em $source"
        }
        foreach ($directory in (Get-ChildItem -LiteralPath $layerPath -Directory)) {
            if (-not (Test-Path -LiteralPath (Join-Path $directory.FullName 'SKILL.md') -PathType Leaf)) {
                Write-Warning "ignorando (sem SKILL.md): $layer/$($directory.Name)"
                continue
            }
            if ($skillNames -contains $directory.Name) {
                throw "Nome de skill repetido entre camadas: $($directory.Name)"
            }
            $skillNames += $directory.Name
            $skillPath = $directory.FullName
            foreach ($file in (Get-ChildItem -LiteralPath $skillPath -Recurse -File)) {
                $relative = $file.FullName.Substring($skillPath.Length).TrimStart('\', '/') -replace '\\', '/'
                $items += @{ From = $file.FullName; Key = 'skills/' + $directory.Name + '/' + $relative }
            }
        }
    }
    if ($skillNames.Count -eq 0) { throw "Nenhuma skill encontrada em: $($Layers -join ', ')" }

    foreach ($role in $Roles) {
        $from = Join-Key -Base $source -Key ($format.Adapters + '/' + $role + $format.Suffix)
        if (-not (Test-Path -LiteralPath $from -PathType Leaf)) {
            throw "Adapter ausente na origem: $from"
        }
        $items += @{ From = $from; Key = $format.AdapterDir + '/' + $role + $format.Suffix }
    }

    # --- Instalacao ---------------------------------------------------------
    Write-Host ''
    Write-Host "Apex Prime $version - agente $Agente" -ForegroundColor Cyan
    Write-Host "  local  : $scope ($script:Root)"
    Write-Host "  camadas: $($Layers -join ' + ')"
    Write-Host "  adapter: $($Roles -join ', ')"
    Write-Host ''

    $next = @{}
    foreach ($item in $items) {
        Copy-Managed -From $item.From -Key $item.Key -Previous $previous.Files -Next $next
    }

    # --- Poda: o que a instalacao anterior trouxe e esta nao traz -----------
    foreach ($key in ($previous.Files.Keys | Sort-Object)) {
        if ($next.ContainsKey($key)) { continue }
        if (Remove-ManagedFile -Key $key -RecordedHash $previous.Files[$key] -Reason 'fora desta instalacao') { continue }
        if (Test-LegacyKey -Key $key) {
            Write-Warning "fora do formato atual, deixa de ser gerenciado: $(Resolve-ManagedPath -Key $key)"
            continue
        }
        $next[$key] = $previous.Files[$key]
        $script:Preserved++
    }

    Write-Manifest -Path $manifestPath -Files $next -ManifestVersion $version -ManifestScope $scope

    Write-Host ''
    Write-Host ("{0} skill(s), {1} adapter(s) | {2} gravado(s), {3} ja atualizado(s), {4} preservado(s), {5} removido(s)" -f `
        $skillNames.Count, $Roles.Count, $script:Written, $script:Unchanged, $script:Preserved, $script:Removed) -ForegroundColor Green
    if ($script:Preserved -gt 0) {
        Write-Host 'Rode novamente com -Force para sobrescrever os preservados.' -ForegroundColor DarkYellow
    }

    # O Copilot tambem le .claude/skills: duas instalacoes no mesmo local
    # registram cada skill em dobro nele.
    $other = 'claude'
    if ($Agente -eq 'claude') { $other = 'copilot' }
    $otherManifest = Join-Path (Get-InstallRoot -Location $location -Agent $other) 'apex-prime.json'
    if (Test-Path -LiteralPath $otherManifest -PathType Leaf) {
        Write-Warning ("ha tambem uma instalacao para $other neste local ($otherManifest). O Copilot le as skills " +
            "das duas e as registra em dobro; mantenha uma so (-Desinstalar -Agente $other).")
    }
    Write-Host ''
} finally {
    # O dry run tambem clona, e o temporario sai de qualquer forma. Antivirus
    # e processos do git seguram arquivos recem-clonados por um instante.
    if ($workspace -and (Test-Path -LiteralPath $workspace)) {
        foreach ($attempt in 1..5) {
            Remove-Item -LiteralPath $workspace -Recurse -Force -ErrorAction SilentlyContinue
            if (-not (Test-Path -LiteralPath $workspace)) { break }
            Start-Sleep -Milliseconds 500
        }
        if (Test-Path -LiteralPath $workspace) {
            Write-Warning "nao foi possivel remover o temporario: $workspace"
        }
    }
}
