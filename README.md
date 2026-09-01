# Tech Challenge Fase 1 — NPS Preditivo (E-commerce)

[![Notebook](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml/badge.svg)](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce/actions/workflows/notebook.yml)

**Curso:** Pós Tech AI Scientist — FIAP  
**Entrega:** Tech Challenge — Fase 1  
**Autor:** Cleivin Lauermann — RM376917  
**Repositório:** [github.com/Cleivin/fiap-nps-preditivo-ecommerce](https://github.com/Cleivin/fiap-nps-preditivo-ecommerce)

## Objetivo

O projeto analisa a experiência do cliente em um e-commerce a partir do NPS e dos dados do pedido, para responder à pergunta central do case: **quais fatores operacionais realmente influenciam a satisfação do cliente?**

O objetivo prático é identificar sinais de insatisfação **antes** da pesquisa ser respondida, para que áreas como logística, atendimento e CRM possam agir de forma preventiva, em vez de descobrir o problema quando o cliente já foi prejudicado.

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

## A base de dados

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

## Metodologia

A análise seguiu sete etapas, nesta ordem. A sequência importa: as hipóteses foram registradas **antes** dos testes estatísticos, para não escolher o teste depois de já ter visto o resultado.

**1. Qualidade antes de insight.** Completude, duplicados, faixas de valores e consistência lógica foram verificados antes de qualquer conclusão de negócio. A base não tem nulos nem `order_id` duplicado, mas tem inconsistências lógicas.

**2. Filtro explícito.** Dois critérios removeram 144 pedidos (5,8%), deixando 2.356 para a análise:

- **Atendimento inconsistente** (~23 pedidos): `resolution_time_days` maior que zero e/ou `csat_internal_score` maior que zero em pedidos sem nenhum contato com o SAC e sem nenhuma reclamação. Sem canal de atendimento aberto, esses valores não têm como existir.
- **Atraso incoerente** (~121 pedidos): `delivery_delay_days` maior que `delivery_time_days`, ou seja, atraso maior que o próprio tempo total de entrega.

A opção foi documentar e remover o que é logicamente impossível, em vez de imputar valores ou corrigir as linhas.

**3. Definição do alvo.** O target é o `nps_score` do pedido. Para os cortes de negócio, a nota vira classe pela régua padrão do NPS: 0 a 6 é detrator, 7 e 8 é neutro, 9 e 10 é promotor.

**4. Exploração com foco em negócio.** Descritivas, cortes por faixa de atraso, de contatos no SAC, de reclamações, por região e por tempo de relacionamento, além de correlações e gráficos para localizar um possível ponto de ruptura.

**5. Hipóteses registradas.** Quatro hipóteses no formato Observação, Evidência, Hipótese e Próximos passos — SAC (H1), tentativas de entrega (H2), atraso (H3) e reclamações (H4).

**6. Validação estatística.** Cada hipótese foi testada com a técnica adequada ao tipo da variável, sempre sobre a base filtrada e sem usar as duas colunas com leakage:

| Técnica | O que responde | Resultado |
| --- | --- | --- |
| IC 95% da média | Qual a nota típica da operação? | 4,45 (de 4,35 a 4,55) |
| IC 95% da proporção | Quão grave é a taxa de detratores? | 73,5% (de 71,7% a 75,3%) |
| ANOVA por região | A geografia muda a nota? | Não (p ≈ 0,50) |
| t de Welch e Mann-Whitney | Atraso, reclamações e SAC separam detratores? | Sim nos três (p ≪ 0,001) |
| t de Welch | Tentativas de entrega separam? | Não (p ≈ 0,45) |
| Qui-quadrado | A proporção de detratores muda por faixa de atraso? | Sim (χ² ≈ 333; p ≪ 0,001) |
| Pearson e regressão OLS | Qual a magnitude do atraso? | r ≈ −0,57; −1,03 ponto de NPS por dia; R² ≈ 0,33 |
| Baseline OLS sem leakage | Quanto as variáveis operacionais explicam? | R² ≈ 0,47, com atraso e SAC dominando |

Usar dois testes para a mesma comparação é proposital: o t de Welch trabalha com médias e o Mann-Whitney não assume normalidade, então quando os dois apontam na mesma direção o resultado não depende da forma da distribuição.

**7. Tradução para o negócio.** As quatro perguntas do gerente de operações respondidas em linguagem executiva, sem jargão estatístico.

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

## Limitações e riscos

O que a empresa precisa ter em mente antes de decidir com base nestes números.

**É uma amostra, não a operação inteira.** São 2.356 pedidos, já sem os 144 excluídos por inconsistência. Os percentuais descrevem esta base, e não necessariamente a operação ao vivo de hoje.

**Associação não é causa.** Atraso, contatos no SAC e reclamações andam juntos: o mesmo pedido problemático costuma ter os três. Os testes confirmam associação forte, e o baseline mostra cerca de um ponto de NPS perdido por dia de atraso mesmo controlando o SAC, mas isso não prova que o atraso é a única causa. Serve para priorizar a operação, não para fechar a discussão.

**O NPS aqui é transacional.** Cada linha é um pedido, não um cliente. O mesmo cliente pode dar notas diferentes em pedidos diferentes, então nada aqui descreve a satisfação de um cliente ao longo do tempo.

**Duas variáveis ficaram fora das recomendações.** `csat_internal_score` e `repeat_purchase_30d` são medidas depois da experiência ou são consequência dela. Elas aparecem na exploração, mas não entraram como alavanca de ação nem como preditor, porque usá-las produziria um resultado bom no papel e inútil na prática.

**Nem todo achado sobreviveu ao teste.** Região e tentativas de entrega pareciam relevantes na exploração e não se sustentaram estatisticamente. Investir nesses dois pontos com base só nos gráficos seria gastar esforço onde a evidência não apoia.

**O que não foi feito.** Não há modelo preditivo nesta fase — o baseline da Parte 6 é apenas uma referência do quanto as variáveis operacionais explicam a nota, não uma solução pronta para produção. A construção do modelo é o passo seguinte.

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
