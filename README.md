# Tech Challenge Fase 1 — NPS Preditivo (E-commerce)

[![Notebook](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml/badge.svg)](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml)

Projeto da **Pós Tech AI Scientist (FIAP)** para entender a experiência do cliente em um e-commerce a partir do NPS e dos dados do pedido.

O objetivo é identificar sinais de insatisfação **antes** da pesquisa ser respondida, para que áreas como logística, atendimento e CRM possam agir de forma preventiva.

Este repositório é a **entrega** do Tech Challenge: ambiente, base e notebook autônomos. Não depende de nenhum outro repositório.

## Vídeo da entrega

A apresentação em vídeo que faz parte da entrega está no YouTube:

[![Vídeo da entrega — NPS Preditivo (Fase 1)](https://img.youtube.com/vi/cUDiVQGjfMM/maxresdefault.jpg)](https://youtu.be/cUDiVQGjfMM)

[Assistir no YouTube](https://youtu.be/cUDiVQGjfMM)

---

## Pré-requisitos

| Ferramenta | Versão | Como instalar |
| --- | --- | --- |
| Python | 3.12 ou superior | [python.org/downloads](https://www.python.org/downloads/) — no Windows, marque a opção **Add Python to PATH** |
| Git | qualquer | [git-scm.com/downloads](https://git-scm.com/downloads) |

Não é preciso instalar mais nada: a base de dados já vem junto com o repositório e todas as bibliotecas são instaladas dentro de um ambiente virtual isolado, sem mexer no Python do sistema.

## Passo 1 — Clonar o repositório

```bash
git clone https://github.com/Cleivin/fiap-nps-preditivo-ecommerce.git
cd fiap-nps-preditivo-ecommerce
```

## Passo 2 — Preparar o ambiente

Existe um script que faz tudo: cria o ambiente virtual, instala as bibliotecas nas versões corretas e registra o kernel do Jupyter.

**Windows (PowerShell)**

```powershell
.\setup.ps1
```

**macOS e Linux**

```bash
bash setup.sh
```

Se preferir fazer na mão, o equivalente é:

<details>
<summary>Passos manuais</summary>

**Windows (PowerShell)**

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name nps-fase1 --display-name "Python (NPS Fase 1)"
```

**macOS e Linux**

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name nps-fase1 --display-name "Python (NPS Fase 1)"
```

</details>

## Passo 3 — Abrir o notebook

Escolha um dos dois caminhos.

**No navegador, com JupyterLab**

```bash
# Windows:            .\.venv\Scripts\Activate.ps1
# macOS e Linux:      source .venv/bin/activate
jupyter lab notebooks/desafio_nps_fase_01.ipynb
```

**No Cursor ou VS Code**

Abra a pasta do projeto, abra `notebooks/desafio_nps_fase_01.ipynb` e, no canto superior direito, selecione o kernel **Python (NPS Fase 1)** (ou o interpretador `.venv` do próprio projeto).

Depois é só rodar as células de cima para baixo. O notebook encontra a base sozinho: a função `locate_csv()` sobe a árvore de pastas a partir da pasta atual, então funciona tanto com o kernel na raiz do projeto quanto dentro de `notebooks/`.

---

## Estrutura

```text
data/raw/desafio_nps_fase_1.csv        # base do desafio (2.500 pedidos), versionada junto
notebooks/desafio_nps_fase_01.ipynb    # a entrega (negócio + target + EDA + estatística)
notebooks/guia_eda_nps_passo_a_passo.md
apresentacao/NPS_Preditivo_Fase1.pptx  # apresentação final
requirements.txt                       # dependências em versões exatas
setup.ps1 / setup.sh                   # preparam o ambiente do zero
.github/workflows/notebook.yml         # CI que executa o notebook a cada push
```

## O que o notebook cobre

1. **Entendimento de negócio** — dor, áreas impactadas, NPS versus recompra, boca a boca e market share
2. **Target** — `nps_score` (por pedido), classes de NPS e leakage (`repeat_purchase_30d`, com atenção ao CSAT)
3. **EDA** — qualidade, filtro de inconsistências, descritivas, relações e hipóteses
4. **Estatística (Parte 6)** — intervalo de confiança, testes H1 a H4, regressão simples e baseline sem leakage
5. **Respostas ao gerente** — fatores críticos, detratores, ponto de ruptura e perfil de cliente

A análise usa a base filtrada (`df_mov_ecom_filtrado`, 2.356 pedidos) depois de remover os registros com inconsistência lógica (cerca de 5,8%).

---

## Reprodutibilidade

O `requirements.txt` fixa as versões exatas (`==`) que foram usadas para gerar os resultados da entrega. Com faixas abertas como `pandas>=2.2`, uma instalação futura poderia trazer uma versão com comportamento diferente e produzir números que não batem com os do notebook.

Para garantir que isso não é só teoria, o GitHub Actions clona o repositório limpo, instala as dependências e executa o notebook inteiro em **Windows, macOS e Linux**, com **Python 3.12, 3.13 e 3.14** — além de rodar os próprios scripts de setup nos três sistemas. O selo no topo deste README mostra o resultado da última execução.

O piso é o Python 3.12 porque as versões de `numpy` e `scipy` usadas na entrega não suportam a 3.11. Preferimos manter as bibliotecas exatamente nas versões que geraram os resultados a rebaixá-las para alcançar uma versão mais antiga do Python.

## Solução de problemas

**`setup.ps1 não pode ser carregado porque a execução de scripts foi desabilitada`**

O PowerShell bloqueia scripts por padrão. Libere só para esta janela do terminal:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup.ps1
```

**O ambiente parou de funcionar depois que atualizei o Python**

O `.venv` guarda o caminho absoluto do Python que o criou. Se esse Python for movido, atualizado ou desinstalado, o ambiente quebra com uma mensagem do tipo `did not find executable at ...`. Basta rodar o script de setup de novo: ele detecta o ambiente quebrado e o recria automaticamente. Para forçar manualmente, apague a pasta `.venv` antes.

**`ModuleNotFoundError: No module named 'pandas'` ao rodar as células**

O notebook está usando outro Python, não o do projeto. Selecione o kernel **Python (NPS Fase 1)** no canto superior direito do notebook e rode as células de novo.

**`FileNotFoundError` ao carregar o CSV**

Acontece se o notebook for aberto fora da pasta do repositório. Confirme que `data/raw/desafio_nps_fase_1.csv` existe e que o Jupyter ou o editor foi aberto a partir da raiz do projeto.

**Os gráficos não aparecem quando executo fora do Jupyter**

Em ambientes sem interface gráfica (servidores, CI), defina a variável de ambiente `MPLBACKEND=Agg` antes de executar.
