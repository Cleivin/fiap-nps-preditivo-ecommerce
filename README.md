# Tech Challenge Fase 1 — NPS Preditivo (E-commerce)

Projeto da **Pós Tech AI Scientist (FIAP)** para entender a experiência do cliente em um e-commerce a partir do NPS e dos dados do pedido.

O objetivo é identificar sinais de insatisfação **antes** da pesquisa ser respondida, para que áreas como logística, atendimento e CRM possam agir de forma preventiva.

## Estrutura

```text
data/raw/desafio_nps_fase_1.csv   # base do desafio (~2.500 pedidos)
notebooks/desafio_nps_fase_01.ipynb
notebooks/guia_eda_nps_passo_a_passo.md
requirements.txt
```

## Como executar

1. Crie o ambiente e instale as dependências:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

2. Abra o notebook `notebooks/desafio_nps_fase_01.ipynb` no Jupyter Lab ou no VS Code/Cursor.

3. Siga o roteiro de EDA em `notebooks/guia_eda_nps_passo_a_passo.md`.
