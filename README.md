# Tech Challenge Fase 1 — NPS Preditivo (E-commerce)

Projeto da **Pós Tech AI Scientist (FIAP)** para entender a experiência do cliente em um e-commerce a partir do NPS e dos dados do pedido.

O objetivo é identificar sinais de insatisfação **antes** da pesquisa ser respondida, para que áreas como logística, atendimento e CRM possam agir de forma preventiva.

Este repositório é a **entrega** do Tech Challenge: ambiente, base e notebook autônomos. Não depende do repositório de estudos da pós.

## Como executar

Requer **Python 3.11+** (testado com 3.14).

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

No Cursor / VS Code, abra `notebooks/desafio_nps_fase_01.ipynb` e escolha o interpretador `.venv\Scripts\python.exe`. Depois rode as células de cima para baixo.

O notebook localiza sozinho `data/raw/desafio_nps_fase_1.csv`, tanto se o kernel estiver na raiz do projeto quanto em `notebooks/`.

## Estrutura

```text
data/raw/desafio_nps_fase_1.csv      # base do desafio (~2.500 pedidos)
notebooks/desafio_nps_fase_01.ipynb  # entrega (negócio + target + EDA)
notebooks/guia_eda_nps_passo_a_passo.md
requirements.txt
```

## O que o notebook cobre

1. **Entendimento de negócio** — dor, áreas impactadas, NPS vs recompra / boca a boca / market share  
2. **Target** — `nps_score` (pedido), classes NPS, leakage (`repeat_purchase_30d`, cuidado com CSAT)  
3. **EDA** — qualidade, filtro de inconsistências, descritivas, relações e hipóteses  
4. **Estatística (Parte 6)** — IC, testes H1–H4, regressão simples e baseline sem leakage  
5. **Respostas ao gerente** — fatores críticos, detratores, ponto de ruptura e perfil de cliente  

A análise usa a base filtrada (`df_mov_ecom_filtrado`, 2.356 pedidos) após remover registros com inconsistência lógica (~5,8%).
