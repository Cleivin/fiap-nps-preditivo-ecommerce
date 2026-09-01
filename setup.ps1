# Setup do ambiente - Tech Challenge NPS (Fase 1) - Windows / PowerShell
#
# Uso:
#   .\setup.ps1
#
# Se o PowerShell bloquear a execucao, rode antes:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$ErrorActionPreference = "Stop"

Set-Location -Path $PSScriptRoot

$Venv = Join-Path $PSScriptRoot ".venv"
$PythonVenv = Join-Path $Venv "Scripts\python.exe"

# Cada candidato e um array: primeiro item o executavel, o resto os argumentos.
$Candidatos = @(
    @("py", "-3"),
    @("python"),
    @("python3")
)

function Find-Python {
    foreach ($candidato in $Candidatos) {
        $exe = $candidato[0]
        $extras = @($candidato | Select-Object -Skip 1)

        if (-not (Get-Command $exe -ErrorAction SilentlyContinue)) { continue }

        try {
            $versao = & $exe @extras -c "import sys; print('%d.%d' % sys.version_info[:2])" 2>$null
        }
        catch {
            continue
        }

        if ($LASTEXITCODE -ne 0 -or -not $versao) { continue }
        if ([Version]$versao -ge [Version]"3.12") { return $candidato }
    }
    return $null
}

# $ErrorActionPreference nao interrompe o script quando um programa externo
# retorna codigo de erro, entao cada etapa e conferida na mao.
function Assert-Sucesso {
    param([string]$Etapa)
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Falha ao $Etapa (codigo $LASTEXITCODE)."
    }
}

# Remove-Item -Recurse falha com "a pasta nao esta vazia" em arvores profundas
# como site-packages, ainda mais em pastas sincronizadas pelo OneDrive.
# A API do .NET e o 'rd' do cmd dao conta desses casos.
function Remove-Diretorio {
    param([string]$Caminho)

    try {
        [System.IO.Directory]::Delete($Caminho, $true)
    }
    catch {
        & cmd.exe /c "rd /s /q `"$Caminho`"" 2>$null
    }

    if (Test-Path $Caminho) {
        Write-Error "Nao foi possivel remover '$Caminho'. Feche editores e terminais que estejam usando o ambiente e rode o script de novo."
    }
}

function Test-VenvSaudavel {
    if (-not (Test-Path $PythonVenv)) { return $false }
    try {
        & $PythonVenv --version *> $null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

$python = Find-Python
if (-not $python) {
    Write-Error "Nenhum Python 3.12 ou superior encontrado. Instale em https://www.python.org/downloads/ e rode o script de novo."
}

$exe = $python[0]
$extras = @($python | Select-Object -Skip 1)

Write-Host "==> Usando: $($python -join ' ')" -ForegroundColor Cyan

# Um .venv apontando para um Python que nao existe mais e a causa mais comum
# de falha depois de atualizar ou reinstalar o Python. Nesse caso, recriamos.
if (Test-Path $Venv) {
    if (Test-VenvSaudavel) {
        Write-Host "==> Reaproveitando o .venv existente." -ForegroundColor Cyan
    }
    else {
        Write-Host "==> O .venv existente esta quebrado. Recriando..." -ForegroundColor Yellow
        Remove-Diretorio $Venv
    }
}

if (-not (Test-Path $Venv)) {
    Write-Host "==> Criando o ambiente virtual em .venv" -ForegroundColor Cyan
    & $exe @extras -m venv $Venv
    Assert-Sucesso "criar o ambiente virtual"
}

Write-Host "==> Atualizando o pip" -ForegroundColor Cyan
& $PythonVenv -m pip install --upgrade pip --quiet
Assert-Sucesso "atualizar o pip"

Write-Host "==> Instalando as dependencias do requirements.txt" -ForegroundColor Cyan
& $PythonVenv -m pip install -r (Join-Path $PSScriptRoot "requirements.txt")
Assert-Sucesso "instalar as dependencias"

Write-Host "==> Registrando o kernel do Jupyter" -ForegroundColor Cyan
& $PythonVenv -m ipykernel install --user --name nps-fase1 --display-name "Python (NPS Fase 1)"
Assert-Sucesso "registrar o kernel do Jupyter"

Write-Host ""
Write-Host "Ambiente pronto." -ForegroundColor Green
Write-Host ""
Write-Host "Para abrir o notebook no navegador:"
Write-Host "  .\.venv\Scripts\Activate.ps1"
Write-Host "  jupyter lab notebooks/desafio_nps_fase_01.ipynb"
Write-Host ""
Write-Host "No Cursor ou VS Code, abra o notebook e selecione o kernel 'Python (NPS Fase 1)'."
