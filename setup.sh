#!/usr/bin/env bash
# Setup do ambiente - Tech Challenge NPS (Fase 1) - macOS e Linux
#
# Uso:
#   bash setup.sh

set -euo pipefail

cd "$(dirname "$0")"

VENV=".venv"
PYTHON_VENV="$VENV/bin/python"

# O python3 do PATH vem primeiro para respeitar a versao que a pessoa ja
# escolheu (pyenv, conda, asdf). Os nomes com versao sao o plano B para
# sistemas cujo python3 padrao ainda e antigo demais.
encontrar_python() {
    for candidato in python3 python python3.14 python3.13 python3.12; do
        if ! command -v "$candidato" >/dev/null 2>&1; then
            continue
        fi
        if "$candidato" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 12) else 1)' 2>/dev/null; then
            echo "$candidato"
            return 0
        fi
    done
    return 1
}

if ! PYTHON=$(encontrar_python); then
    echo "Erro: nenhum Python 3.12 ou superior encontrado." >&2
    echo "Instale com 'brew install python' (macOS) ou pelo gerenciador de pacotes da sua distribuicao." >&2
    exit 1
fi

echo "==> Usando: $PYTHON ($("$PYTHON" --version))"

# Um .venv apontando para um Python que nao existe mais e a causa mais comum
# de falha depois de atualizar ou reinstalar o Python. Nesse caso, recriamos.
if [ -d "$VENV" ]; then
    if "$PYTHON_VENV" --version >/dev/null 2>&1; then
        echo "==> Reaproveitando o .venv existente."
    else
        echo "==> .venv existente esta quebrado. Recriando..."
        rm -rf "$VENV"
    fi
fi

if [ ! -d "$VENV" ]; then
    echo "==> Criando o ambiente virtual em .venv"
    "$PYTHON" -m venv "$VENV"
fi

echo "==> Atualizando o pip"
"$PYTHON_VENV" -m pip install --upgrade pip --quiet

echo "==> Instalando as dependencias do requirements.txt"
"$PYTHON_VENV" -m pip install -r requirements.txt

echo "==> Registrando o kernel do Jupyter"
"$PYTHON_VENV" -m ipykernel install --user --name nps-fase1 --display-name "Python (NPS Fase 1)"

echo
echo "Ambiente pronto."
echo
echo "Para abrir o notebook no navegador:"
echo "  source .venv/bin/activate"
echo "  jupyter lab notebooks/desafio_nps_fase_01.ipynb"
echo
echo "No Cursor ou VS Code, abra o notebook e selecione o kernel 'Python (NPS Fase 1)'."
