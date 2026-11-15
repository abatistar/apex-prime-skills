#Requires -Version 5.1
<#
.SYNOPSIS
    Confere mecanicamente uma ITS em Markdown: a estrutura, a rastreabilidade
    (D, RG, unidades, testes, Referencias), a autossuficiencia (identificadores
    de outros documentos fora de Referencias), as ancoras (caminhos e simbolos
    citados existem no projeto) e o alcance (quem referencia um tipo alterado).

.DESCRIPTION
    Parte do its-generator, executado no Passo 6 (checklists/its-checklist.md).
    So le arquivos. Sai com codigo 1 quando ha ERRO, 0 caso contrario.
    ERRO  = o documento viola o its-contract; corrija antes de entregar.
    AVISO = heuristica; quem escreve decide e age conforme o checklist.

    Escrito em ASCII e so com cmdlets e operadores, para rodar no Windows
    PowerShell 5.1 sob ConstrainedLanguage (mesma restricao do install.ps1).
    Os padroes usam "." no lugar de letras acentuadas pelo mesmo motivo.
    Cobre o formato Markdown; uma ITS no formato Confluence e conferida a mao.

.PARAMETER Its
    Caminho do arquivo da ITS.

.PARAMETER Root
    Raiz do repositorio do codigo que a ITS planeja alterar.

.PARAMETER SourceExtensions
    Extensoes tratadas como codigo-fonte na busca de tipos e de referencias.

.EXAMPLE
    .\check-its.ps1 -Its docs\its\ITS-S-131-limite-de-credito.md -Root .
#>
param(
    [Parameter(Mandatory = $true)][string] $Its,
    [Parameter(Mandatory = $true)][string] $Root,
    [string[]] $SourceExtensions = @('.java', '.kt', '.cs', '.ts', '.tsx', '.js', '.py', '.go', '.sql')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:Errors   = 0
$script:Warnings = 0
function Add-Finding {
    param([string] $Level, [string] $Check, [string] $Message)
    if ($Level -eq 'ERRO') { $script:Errors++ } else { $script:Warnings++ }
    Write-Host ("{0,-5} [{1}] {2}" -f $Level, $Check, $Message)
}

$lines = @(Get-Content -LiteralPath $Its -Encoding UTF8)

# --- Secoes (titulos de nivel 2) ---------------------------------------------
$section  = ''
$sections = @{}          # numero da linha -> nome da secao
$inFence = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*```') { $inFence = -not $inFence }
    if (-not $inFence -and $lines[$i] -match '^##\s+(.+?)\s*$') {
        $section = $Matches[1]
        if ($section -notmatch '^(Descri|O que muda|Plano de implementa|Refer.ncias)') {
            Add-Finding 'ERRO' 'secoes' "linha $($i + 1): titulo de nivel 2 fora das quatro secoes do contrato: '$section'"
        }
    }
    $sections[$i] = $section
}
function Test-Section { param([int] $Index, [string] $Pattern) return ($sections[$Index] -match $Pattern) }
$reChange = '^O que muda'
$rePlan   = '^Plano de implementa'
$reRefs   = '^Refer.ncias'
foreach ($required in @('^Descri', $reChange, $rePlan, $reRefs)) {
    if (-not ($sections.Values | Where-Object { $_ -match $required })) {
        Add-Finding 'ERRO' 'secoes' "secao obrigatoria ausente (padrao: $required)"
    }
}

# --- Cabecalho, premissas e fecho do plano -----------------------------------
function Test-Line {
    param([string] $Pattern, [string] $SectionPattern)
    for ($k = 0; $k -lt $lines.Count; $k++) {
        if ($SectionPattern -and -not (Test-Section $k $SectionPattern)) { continue }
        if ($lines[$k] -match $Pattern) { return $true }
    }
    return $false
}
if (-not (Test-Line '^\*\*N.vel de detalhe:\*\*\s+(simplificado|m.dio|detalhista)\b' '')) {
    Add-Finding 'ERRO' 'cabecalho' 'falta a linha de nivel de detalhe sob o titulo (copiada do template)'
}
if (-not (Test-Line '^\*\*Como implementar este documento:\*\*' '')) {
    Add-Finding 'ERRO' 'cabecalho' 'falta o bloco fixo "Como implementar este documento" (copiado do template)'
}
foreach ($field in @('Premissas t.cnicas', 'Calibra..o', 'Base do plano')) {
    if (-not (Test-Line ('^\*\*' + $field + ':\*\*') $rePlan)) {
        Add-Finding 'ERRO' 'premissas' "falta o campo de premissas (padrao: $field)"
    }
}
foreach ($closing in @('Entrega', 'Fora de escopo', 'Riscos', 'Verifica..o')) {
    if (-not (Test-Line ('^###\s+' + $closing) $rePlan)) {
        Add-Finding 'ERRO' 'secoes' "falta a subsecao de fecho do plano (padrao: $closing)"
    }
}

# --- Itens D e RG declarados em "O que muda" ---------------------------------
$declaredD  = @{}   # id -> texto da linha
$declaredRG = @{}
for ($i = 0; $i -lt $lines.Count; $i++) {
    if (-not (Test-Section $i $reChange)) { continue }
    if ($lines[$i] -match '^\s*[-*]\s+\*\*(D\d+):\*\*')     { $declaredD[$Matches[1]]  = $lines[$i] }
    if ($lines[$i] -match '^\s*[-*]\s+\*\*(RG-\d+):\*\*')   { $declaredRG[$Matches[1]] = $lines[$i] }
}
if ($declaredD.Count -eq 0) { Add-Finding 'ERRO' 'delta' 'nenhum item D declarado em O que muda (- **D1:** ...)' }

# --- Unidades do plano -------------------------------------------------------
$units   = @()      # cada uma: @{ N; Title; Start; End; NoEffect }
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ((Test-Section $i $rePlan) -and $lines[$i] -match '^###\s+(\d+)\.\s+(.+)$') {
        $units += @{ N = $Matches[1]; Title = $Matches[2]; Start = $i; End = $lines.Count - 1; NoEffect = ($Matches[2] -match 'sem efeito') }
    }
}
for ($u = 0; $u -lt $units.Count; $u++) {
    for ($i = $units[$u].Start + 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^#{2,3}\s') { $units[$u].End = $i - 1; break }
    }
}
$allMet = $true
foreach ($id in $declaredD.Keys) { if ($declaredD[$id] -notmatch 'j. atendido hoje') { $allMet = $false } }
if ($units.Count -eq 0 -and -not ($declaredD.Count -gt 0 -and $allMet)) {
    Add-Finding 'ERRO' 'plano' 'nenhuma unidade numerada (### N. Titulo) no Plano de implementacao'
}

function Get-Ids {
    param([string] $Text, [string] $Pattern)
    $found = @()
    foreach ($m in ($Text | Select-String -Pattern $Pattern -AllMatches)) {
        foreach ($x in $m.Matches) { $found += $x.Value }
    }
    return $found
}

$servedD   = @{}    # D -> unidades que o atendem
$claimedRG = @{}    # RG -> unidades cujos Testes o reivindicam
$testedD   = @{}    # D citado por ao menos um teste
foreach ($unit in $units) {
    if ($unit.NoEffect) { continue }
    $serves  = ''
    $inTests = $false
    for ($i = $unit.Start + 1; $i -le $unit.End; $i++) {
        $line = $lines[$i]
        if ($line -match '^\*\*([^:*]+):\*\*(.*)$') {
            $field   = $Matches[1]
            $rest    = $Matches[2]
            $inTests = ($field -match '^Testes')
            if ($field -match '^Atende') { $serves = $rest.Trim() }
            if (-not $inTests) { continue }
            $line = $rest
        }
        if ($inTests) {
            $rgIds = @(Get-Ids $line 'RG-\d+')
            $dIds  = @(Get-Ids $line '\bD\d+\b')
            foreach ($id in $rgIds) {
                if (-not $claimedRG.ContainsKey($id)) { $claimedRG[$id] = @() }
                if ($claimedRG[$id] -notcontains $unit.N) { $claimedRG[$id] += $unit.N }
            }
            foreach ($id in $dIds) { $testedD[$id] = $true }
            if ($line -match '^\s*\d+\.\s+\S' -and ($rgIds.Count + $dIds.Count) -eq 0) {
                Add-Finding 'AVISO' 'teste' "linha $($i + 1): teste sem o item ou o ponto de regressao que prova, entre parenteses"
            }
        }
    }
    if (-not $serves) {
        Add-Finding 'ERRO' 'plano->delta' "unidade $($unit.N) sem campo Atende (item D ou consequencia tecnica)"
    }
    foreach ($id in (Get-Ids $serves '\bD\d+\b')) {
        if (-not $servedD.ContainsKey($id)) { $servedD[$id] = @() }
        $servedD[$id] += $unit.N
        if (-not $declaredD.ContainsKey($id)) {
            Add-Finding 'ERRO' 'plano->delta' "unidade $($unit.N) atende $id, que nao existe em O que muda"
        }
    }
}

foreach ($id in ($declaredD.Keys | Sort-Object)) {
    $alreadyMet = ($declaredD[$id] -match 'j. atendido hoje')
    if (-not $servedD.ContainsKey($id) -and -not $alreadyMet) {
        Add-Finding 'ERRO' 'delta->plano' "$id nao e atendido por nenhuma unidade nem declara 'ja atendido hoje'"
    }
    if ($alreadyMet) {
        # A prova e' o teste existente nomeado na linha, ou o teste de caracterizacao de uma unidade.
        $named = ($declaredD[$id] -match 'j. atendido hoje:.*`[^`]+`')
        if (-not $named -and -not $testedD.ContainsKey($id)) {
            Add-Finding 'AVISO' 'delta->teste' "$id declara 'ja atendido hoje' sem nomear o teste existente que o prova e sem teste de caracterizacao numa unidade"
        }
    } elseif (-not $testedD.ContainsKey($id)) {
        Add-Finding 'ERRO' 'delta->teste' "$id nao e citado por nenhum teste de nenhuma unidade"
    }
}
foreach ($id in ($declaredRG.Keys | Sort-Object)) {
    if (-not $claimedRG.ContainsKey($id)) {
        Add-Finding 'ERRO' 'regressao->plano' "$id nao e reivindicado nos Testes de nenhuma unidade"
    } elseif ($claimedRG[$id].Count -gt 1) {
        Add-Finding 'ERRO' 'regressao->plano' "$id reivindicado por mais de uma unidade: $($claimedRG[$id] -join ', ')"
    }
}
foreach ($id in ($claimedRG.Keys | Sort-Object)) {
    if (-not $declaredRG.ContainsKey($id)) {
        Add-Finding 'ERRO' 'regressao->plano' "$id aparece em Testes mas nao existe em O que muda"
    }
}

# --- Referencias: todo D e RG na coluna Usada em; nenhum ID externo no corpo --
$refsText = ''
for ($i = 0; $i -lt $lines.Count; $i++) { if (Test-Section $i $reRefs) { $refsText += $lines[$i] + "`n" } }
foreach ($id in (@($declaredD.Keys) + @($declaredRG.Keys) | Sort-Object)) {
    if ($refsText -notmatch ('\b' + $id + '\b')) {
        Add-Finding 'ERRO' 'fonte->item' "$id nao aparece em Referencias (coluna Usada em)"
    }
}
$external = '\b(UC-\d+|RN-\d+|CA-\d+|QM-[A-Z]{2}-\d+|CS-[A-Z]{2}-\d+)\b'
for ($i = 0; $i -lt $lines.Count; $i++) {
    if (Test-Section $i $reRefs) { continue }
    foreach ($id in (Get-Ids $lines[$i] $external)) {
        Add-Finding 'ERRO' 'autossuficiencia' "linha $($i + 1): identificador de outro documento fora de Referencias: $id"
    }
    # O ADR e citado uma vez, na linha Decisoes registradas das premissas, e em nenhuma instrucao.
    if ($lines[$i] -notmatch '^\*\*Decis.es registradas:\*\*') {
        foreach ($id in (Get-Ids $lines[$i] '\bADR-\d+\b')) {
            Add-Finding 'ERRO' 'autossuficiencia' "linha $($i + 1): $id citado fora da linha Decisoes registradas"
        }
    }
}

# --- Hedge dentro do plano ---------------------------------------------------
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ((Test-Section $i $rePlan) -and $lines[$i] -match '(?i)\b(provavelmente|talvez|se necess.rio|sugere-se|seria interessante|a definir)\b') {
        Add-Finding 'AVISO' 'hedge' "linha $($i + 1): '$($Matches[1])' numa instrucao do plano"
    }
}

# --- Ancoras: caminhos -------------------------------------------------------
$rootPath = (Resolve-Path -LiteralPath $Root).ProviderPath
for ($i = 0; $i -lt $lines.Count; $i++) {
    if (-not (Test-Section $i $rePlan)) { continue }
    $line = $lines[$i]
    foreach ($m in ($line | Select-String -Pattern '`([^`\s]+/[^`\s]+\.[A-Za-z0-9]{1,6})`' -AllMatches)) {
        foreach ($x in $m.Matches) {
            $relative = $x.Groups[1].Value
            if ($relative -match '[<>*]') { continue }
            $exists   = Test-Path -LiteralPath (Join-Path $rootPath $relative)
            $creating = ($line -match '\(criar\)')
            if ($creating -and $exists) {
                Add-Finding 'ERRO' 'ancora' "linha $($i + 1): marcado (criar), mas ja existe: $relative"
            } elseif (-not $creating -and -not $exists) {
                Add-Finding 'ERRO' 'ancora' "linha $($i + 1): caminho citado nao existe no projeto: $relative"
            }
        }
    }
}

# --- Arquivos de codigo-fonte do projeto -------------------------------------
# Com git, so os arquivos versionados: e rapido e ja deixa de fora o que o build gera.
# Sem git, a arvore inteira, filtrada por extensao (no 5.1, -Include com -LiteralPath nao filtra).
$sources = @()
$tracked = @()
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { $tracked = @(& git -C $rootPath ls-files 2>$null) } catch { $tracked = @() }
$ErrorActionPreference = $previousPreference
foreach ($t in $tracked) {
    if ("$t" -match '(\.[A-Za-z0-9]+)$' -and $SourceExtensions -contains $Matches[1]) { $sources += (Join-Path $rootPath "$t") }
}
if ($sources.Count -eq 0) {
    $sources = @(Get-ChildItem -LiteralPath $rootPath -Recurse -File |
        Where-Object { $SourceExtensions -contains $_.Extension -and $_.FullName -notmatch '[\\/](target|build|dist|bin|obj|node_modules|\.git)[\\/]' } |
        ForEach-Object { $_.FullName })
}
function Find-InSources {
    param([string] $Pattern)
    if ($sources.Count -eq 0) { return @() }
    return @(Select-String -LiteralPath $sources -Pattern $Pattern -CaseSensitive -List)
}

# --- Ancoras: simbolos alvo das instrucoes -----------------------------------
# Alvo = o primeiro codigo em linha de um item numerado ou subitem de "O que fazer".
$checked = @{}
# Um tipo cujo arquivo a lista de Arquivos marca (criar) e' novo, mesmo sem a marca na instrucao.
foreach ($line in $lines) {
    if ($line -match '\(criar\)' -and $line -match '`[^`]*?([A-Za-z0-9_]+)\.[A-Za-z0-9]{1,6}`') { $checked[$Matches[1]] = 'novo' }
}
foreach ($unit in $units) {
    $field = ''
    for ($i = $unit.Start + 1; $i -le $unit.End; $i++) {
        $line = $lines[$i]
        # So as instrucoes de "O que fazer" tem alvo: os testes e os casos de borda nomeiam o que ainda nao existe.
        if ($line -match '^\*\*([^:*]+):\*\*') { $field = $Matches[1] }
        if ($field -notmatch '^O que fazer') { continue }
        # -cnotmatch: o padrao depende de maiusculas (tipo em PascalCase, membro em camelCase).
        if ($line -cnotmatch '^\s*(\d+\.|-)\s+`([A-Z][A-Za-z0-9_]*)(?:\.([a-z][A-Za-z0-9_]*))?[^`]*`') { continue }
        $type   = $Matches[2]
        $member = ''
        if ($Matches.ContainsKey(3)) { $member = $Matches[3] }
        $creating = ($line -match '\(criar\)')
        if ($creating -and -not $member) { $checked[$type] = 'novo'; continue }
        if (-not $checked.ContainsKey($type)) {
            $decl = @(Find-InSources ('\b(class|interface|record|enum|struct|type)\s+' + $type + '\b'))
            if ($decl.Count -gt 0) { $checked[$type] = $decl[0].Path } else { $checked[$type] = '' }
        }
        if ($checked[$type] -eq 'novo') { continue }
        if (-not $checked[$type]) {
            # Tipo.membro (criar) num tipo que nao existe: o tipo inteiro e' novo.
            if ($creating) { $checked[$type] = 'novo' }
            else { Add-Finding 'ERRO' 'ancora' "linha $($i + 1): tipo '$type' nao esta declarado no projeto nem marcado (criar)" }
            continue
        }
        if (-not $member) { continue }
        $memberExists = [bool](Select-String -LiteralPath $checked[$type] -Pattern ('\b' + $member + '\s*\(') -CaseSensitive -Quiet)
        if ($creating -and $memberExists) {
            Add-Finding 'ERRO' 'ancora' "linha $($i + 1): '$type.$member' marcado (criar), mas ja existe em $(Split-Path -Leaf $checked[$type])"
        } elseif (-not $creating -and -not $memberExists) {
            Add-Finding 'AVISO' 'ancora' "linha $($i + 1): '$type.$member' nao encontrado em $(Split-Path -Leaf $checked[$type]) (membro novo sem a marca (criar), ou inexistente)"
        }
    }
}

# --- Alcance: quem referencia um tipo alterado e nao aparece no documento -----
# Para cada tipo existente que o plano altera, e cada interface que ele implementa,
# lista os arquivos do projeto que o referenciam e que a ITS nao cita em lugar nenhum
# (nem em Arquivos, nem em Fora de escopo, nem em Riscos). E' aviso: quem decide e' o autor.
$itsText = ($lines -join "`n")
foreach ($type in ($checked.Keys | Sort-Object)) {
    $declaredIn = $checked[$type]
    if (-not $declaredIn -or $declaredIn -eq 'novo') { continue }
    $names = @($type)
    foreach ($m in (Select-String -LiteralPath $declaredIn -Pattern '\b(?:implements|extends)\s+([A-Za-z0-9_,\s]+?)\s*\{' -CaseSensitive)) {
        foreach ($n in ($m.Matches[0].Groups[1].Value -split ',')) { if ($n.Trim()) { $names += $n.Trim() } }
    }
    $missing = @()
    foreach ($name in $names) {
        foreach ($hit in (Find-InSources ('\b' + $name + '\b'))) {
            $leaf = (Split-Path -Leaf $hit.Path) -replace '\.[A-Za-z0-9]+$', ''
            if ($hit.Path -eq $declaredIn -or $names -contains $leaf) { continue }
            if ($itsText -notmatch ('\b' + $leaf + '\b') -and $missing -notcontains $leaf) { $missing += $leaf }
        }
    }
    if ($missing.Count -gt 0 -and $missing.Count -le 8) {
        Add-Finding 'AVISO' 'alcance' "'$type' e' referenciado por arquivo(s) que a ITS nao cita: $($missing -join ', ')"
    } elseif ($missing.Count -gt 8) {
        Add-Finding 'AVISO' 'alcance' "'$type' e' referenciado por $($missing.Count) arquivos que a ITS nao cita (tipo de uso amplo; confira por amostragem)"
    }
}

Write-Host ''
Write-Host ("{0}: {1} item(ns) D, {2} ponto(s) RG, {3} unidade(s), {4} arquivo(s) de codigo | {5} erro(s), {6} aviso(s)" -f `
    (Split-Path -Leaf $Its), $declaredD.Count, $declaredRG.Count, $units.Count, $sources.Count, $script:Errors, $script:Warnings)
if ($script:Errors -gt 0) { exit 1 }
exit 0
