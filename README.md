# Tech Challenge Fase 1 — NPS Preditivo (E-commerce)

[![Notebook](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml/badge.svg)](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml)

**Curso:** Pós Tech AI Scientist — FIAP  
**Entrega:** Tech Challenge — Fase 1  
**Autor:** Cleivin Lauermann — RM376917  
**Repositório:** [github.com/Cleivin/fiap-nps-preditivo-ecommerce](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce)

O projeto analisa a experiência do cliente em um e-commerce a partir do NPS e dos dados do pedido.

O objetivo é identificar sinais de insatisfação **antes** da pesquisa ser respondida, para que áreas como logística, atendimento e CRM possam agir de forma preventiva.

Este repositório é a **entrega** do Tech Challenge: ambiente, base e notebook autônomos. Não depende de nenhum outro repositório.

## Entregáveis

| Artefato | Onde está |
| --- | --- |
| Notebook da análise (entrega principal) | [`notebooks/desafio_nps_fase_01.ipynb`](notebooks/desafio_nps_fase_01.ipynb) |
| Vídeo da apresentação | [youtu.be/cUDiVQGjfMM](https://youtu.be/cUDiVQGjfMM) |
| Slides da apresentação | [`apresentacao/NPS_Preditivo_Fase1.pptx`](apresentacao/NPS_Preditivo_Fase1.pptx) |
| Base de dados usada | [`data/raw/desafio_nps_fase_1.csv`](data/raw/desafio_nps_fase_1.csv) |

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

O notebook está salvo apontando para o kernel padrão (`python3`), que dentro do `.venv` já é o Python do projeto — então ele abre pronto para rodar. Se quiser deixar explícito, use **Kernel → Change Kernel** e escolha **Python (NPS Fase 1)**.

**No Cursor ou VS Code**

Abra a pasta do projeto, abra `notebooks/desafio_nps_fase_01.ipynb` e, no canto superior direito, selecione o kernel **Python (NPS Fase 1)** (ou o interpretador `.venv` do próprio projeto).

Depois é só rodar as células de cima para baixo. O notebook encontra a base sozinho: a função `locate_csv()` sobe a árvore de pastas a partir da pasta atual, então funciona tanto com o kernel na raiz do projeto quanto dentro de `notebooks/`.

---

## Estrutura

```text
data/raw/desafio_nps_fase_1.csv          # base do desafio (2.500 pedidos), versionada junto
notebooks/desafio_nps_fase_01.ipynb      # a entrega (negócio + target + EDA + estatística)
notebooks/guia_eda_nps_passo_a_passo.md  # roteiro de estudo que guiou a EDA, material de apoio
apresentacao/NPS_Preditivo_Fase1.pptx    # apresentação final
requirements.txt                         # dependências em versões exatas
setup.ps1 / setup.sh                     # preparam o ambiente do zero
.github/workflows/notebook.yml           # CI que executa o notebook a cada push
```

## A base

São 2.500 pedidos e 19 colunas em [`data/raw/desafio_nps_fase_1.csv`](data/raw/desafio_nps_fase_1.csv), sem nenhum valor nulo. Cada linha é um pedido (`order_id`, único na base) com o NPS daquele pedido — a unidade de análise é a transação, não o cliente.

**Cliente**

| Coluna | Descrição | Valores |
| --- | --- | --- |
| `customer_id` | Identificador do cliente | 1 a 2.500 |
| `customer_age` | Idade em anos | 18 a 69 |
| `customer_region` | Região do país | Centro-Oeste, Nordeste, Norte, Sudeste, Sul |
| `customer_tenure_months` | Tempo de relacionamento em meses | 1 a 119 |

**Pedido**

| Coluna | Descrição | Valores |
| --- | --- | --- |
| `order_id` | Identificador do pedido | 50.001 a 52.500 |
| `order_value` | Valor do pedido | 7,76 a 1.983,81 |
| `items_quantity` | Quantidade de itens | 1 a 6 |
| `discount_value` | Desconto aplicado | 0,02 a 230,33 |
| `payment_installments` | Parcelas do pagamento | 1 a 11 |

**Entrega**

| Coluna | Descrição | Valores |
| --- | --- | --- |
| `delivery_time_days` | Dias até a entrega | 2 a 14 |
| `delivery_delay_days` | Dias de atraso sobre o prazo | 0 a 8 |
| `freight_value` | Valor do frete | 2,62 a 76,13 |
| `delivery_attempts` | Tentativas de entrega | 1 a 3 |

**Atendimento**

| Coluna | Descrição | Valores |
| --- | --- | --- |
| `customer_service_contacts` | Contatos com o SAC | 0 a 7 |
| `resolution_time_days` | Dias até a resolução | 0 a 11 |
| `complaints_count` | Reclamações registradas | 0 a 11 |

**Satisfação**

| Coluna | Descrição | Valores |
| --- | --- | --- |
| `nps_score` | Nota do NPS — **é o target** | 0 a 10, com casas decimais |
| `csat_internal_score` | Nota interna de satisfação | 0 a 10, com casas decimais |
| `repeat_purchase_30d` | Recomprou em 30 dias | 0 ou 1 |

Duas colunas exigem cuidado com **leakage**: `repeat_purchase_30d` só é conhecida depois da pesquisa, então não pode ser usada para prever o NPS; `csat_internal_score` só entra como preditor se o momento da coleta for conhecido. Por isso a Parte 6 do notebook fecha com um baseline sem leakage.

## O que o notebook cobre

O notebook tem três seções, e cada pergunta do desafio tem um lugar fixo.

**`# 01 — Entendendo o Negócio`**

1. Qual problema de negócio está sendo resolvido?
2. Por que o NPS é importante para um e-commerce?
3. Quais áreas poderiam se beneficiar desses insights?
4. Como o NPS impacta recompra, boca a boca e market share
5. Quais indicadores de mercado poderiam complementar a análise?

**`# 02 — Definição de Target`**

1. Qual variável representa a satisfação do cliente?
2. Por que ela foi escolhida?
3. Em que momento da jornada essa informação é coletada?
4. Existe algum risco de usar essa variável de forma inadequada?

**`# 03 — Análise Exploratória de Dados`**, dividida em oito partes:

| Parte | Conteúdo |
| --- | --- |
| 0 | Setup e carregamento da base |
| 1 | Estrutura, tipos e dicionário de dados |
| 2 | Qualidade, inconsistências e veredito de usabilidade |
| 3 | Descritivas e cortes de negócio |
| 4 | Relações, gráficos e ponto de ruptura |
| 5 | Hipóteses registradas antes de qualquer teste |
| 6 | Estatística: intervalo de confiança, testes H1 a H4, regressão e baseline sem leakage |
| 7 | As quatro perguntas do gerente de operações |

As quatro perguntas respondidas na Parte 7:

1. Quais fatores parecem mais críticos para a satisfação?
2. O que mais gera detratores?
3. Existe algum "ponto de ruptura" na experiência do cliente?
4. Que tipo de cliente tende a ter NPS mais alto ou mais baixo?

A análise usa a base filtrada (`df_mov_ecom_filtrado`, 2.356 pedidos) depois de remover os registros com inconsistência lógica (cerca de 5,8%).

---

## Reprodutibilidade

O `requirements.txt` fixa as versões exatas (`==`) que foram usadas para gerar os resultados da entrega. Com faixas abertas como `pandas>=2.2`, uma instalação futura poderia trazer uma versão com comportamento diferente e produzir números que não batem com os do notebook.

Para garantir que isso não é só teoria, o GitHub Actions clona o repositório limpo, instala as dependências e executa o notebook inteiro em **Windows, macOS e Linux**, com **Python 3.12, 3.13 e 3.14** — além de rodar os próprios scripts de setup nos três sistemas. O selo no topo deste README mostra o resultado da última execução.

O piso é o Python 3.12 porque as versões de `numpy` e `scipy` usadas na entrega não suportam a 3.11. Preferimos manter as bibliotecas exatamente nas versões que geraram os resultados a rebaixá-las para alcançar uma versão mais antiga do Python.

Para conferir na sua máquina, sem abrir o Jupyter, é o mesmo comando que o CI usa — ele executa o notebook do início ao fim e falha se qualquer célula der erro:

```bash
python -m jupyter nbconvert --to notebook --execute --output-dir build notebooks/desafio_nps_fase_01.ipynb
```

O resultado sai em `build/` (pasta ignorada pelo git). Em servidor ou terminal sem interface gráfica, defina `MPLBACKEND=Agg` antes.

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
