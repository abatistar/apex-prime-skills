#Requires -Version 5.1
<#
.SYNOPSIS
    Bootstrap do Apex Prime - Jarvis. Clona a versao pedida e instala.

.DESCRIPTION
    Wrapper fino sobre scripts/Install-ApexPrime.ps1, para quem nao tem o
    repositorio clonado. Clona -Ref num diretorio temporario, chama o
    instalador e limpa o temporario ao final, mesmo em caso de erro.

    Uso pretendido (dois passos, deliberadamente):

        irm https://raw.githubusercontent.com/abatistar/apex-prime-skills/main/install.ps1 -OutFile install.ps1
        .\install.ps1 -Ref v1.0.0 -Target both

    Nao ha one-liner com `iex`. Sob ConstrainedLanguage mode -- o modo imposto
    por WDAC/AppLocker em Windows corporativo -- nem `iex` nem
    [scriptblock]::Create() sao confiaveis, e baixar antes de executar deixa o
    script legivel antes de rodar, o que e' o comportamento certo de qualquer
    forma.

.PARAMETER Ref
    Tag ou branch a instalar. Default: main. SHA avulso nao e' suportado
    (git clone --branch nao aceita commit).

.PARAMETER Repository
    Origem do clone. Aceita URL ou caminho local.

.EXAMPLE
    .\install.ps1 -Ref v1.0.0

.EXAMPLE
    .\install.ps1 -Ref v1.0.0 -Target both

.EXAMPLE
    .\install.ps1 -Scope project -Destination C:\repos\meu-projeto -WhatIf
#>
[CmdletBinding()]
param(
    [string] $Ref = 'main',

    [ValidateSet('copilot', 'claude', 'both')]
    [string] $Target = 'copilot',

    [ValidateSet('user', 'project')]
    [string] $Scope = 'user',

    [string] $Destination,

    [string] $Repository = 'https://github.com/abatistar/apex-prime-skills.git',

    [switch] $Uninstall,
    [switch] $Force,
    [switch] $WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Desinstalar nao depende da origem: o manifesto ja diz tudo. Se este arquivo
# esta dentro de um clone, usa o instalador ao lado e dispensa o git. Vale so
# para -Uninstall -- numa instalacao, honrar um clone local faria -Ref ser
# silenciosamente ignorado.
$sibling = Join-Path $PSScriptRoot 'scripts\Install-ApexPrime.ps1'
$useSibling = $Uninstall -and (Test-Path -LiteralPath $sibling -PathType Leaf)

$git = Get-Command git -CommandType Application -ErrorAction SilentlyContinue
if (-not $git -and -not $useSibling) {
    throw 'git nao encontrado no PATH. Instale o Git ou clone o repositorio manualmente e rode scripts/Install-ApexPrime.ps1.'
}

$workspace = Join-Path $env:TEMP ('apex-prime-' + (Get-Random))

try {
    if ($useSibling) {
        $installer = $sibling
    } else {
        Write-Host ''
        Write-Host "Clonando $Repository ($Ref)..." -ForegroundColor Cyan

        # --quiet e advice.detachedHead=false para que a saida do instalador
        # seja o que o usuario le. Clonar uma tag cai em detached HEAD.
        & git -c advice.detachedHead=false clone --quiet --depth 1 --branch $Ref -- $Repository $workspace
        if ($LASTEXITCODE -ne 0) {
            throw "git clone falhou (exit $LASTEXITCODE). Confira -Ref '$Ref' e o acesso a $Repository."
        }

        $installer = Join-Path $workspace 'scripts\Install-ApexPrime.ps1'
        if (-not (Test-Path -LiteralPath $installer -PathType Leaf)) {
            throw "Esta versao nao contem scripts/Install-ApexPrime.ps1. O -Ref '$Ref' e' anterior ao instalador?"
        }
    }

    $arguments = @{
        Target = $Target
        Scope  = $Scope
    }
    if ($Destination) { $arguments['Destination'] = $Destination }
    if ($Uninstall)   { $arguments['Uninstall']   = $true }
    if ($Force)       { $arguments['Force']       = $true }
    if ($WhatIf)      { $arguments['WhatIf']      = $true }

    # -Source e' o clone; -Version e' a ref pedida, e nao o git describe do
    # clone raso, que degeneraria para o SHA.
    if (-not $Uninstall) {
        $arguments['Source']  = $workspace
        $arguments['Version'] = $Ref
    }

    & $installer @arguments
} finally {
    if (Test-Path -LiteralPath $workspace) {
        Remove-Item -LiteralPath $workspace -Recurse -Force -ErrorAction SilentlyContinue
    }
}
