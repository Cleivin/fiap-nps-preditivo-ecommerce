# Guia passo a passo — EDA do CSV NPS (Fase 1)

**Curso:** Pós Tech AI Scientist — FIAP  
**Base:** [`../data/raw/desafio_nps_fase_1.csv`](../data/raw/desafio_nps_fase_1.csv)  
**Notebook do desafio:** [`desafio_nps_fase_01.ipynb`](./desafio_nps_fase_01.ipynb)  
**Ritual:** EDA Aula 02 (exemplo IDHM) aplicado ao Tech Challenge NPS

Este guia replica o checklist da aula de exploração **na ordem certa**: primeiro entender e validar se os dados podem ser usados; só depois descritivas, relações, hipóteses e estatística para responder as perguntas de negócio da seção 03.

---

## Como usar

1. Abra um notebook (ou células novas na seção `# 03` do desafio) e rode **um bloco por vez**, na ordem.
2. **Não pule a Parte 2** (qualidade). Só depois do veredito de usabilidade entre em insights.
3. Em cada bloco: rode o código → preencha **Anote o resultado** → se precisar revisar a teoria, use o link **Referência da aula**.
4. Ao final, preencha o template do gerente (Parte 7). Depois analisamos juntos os números.

### Mapa do roteiro

```text
Carregar CSV
    → Estrutura e tipos
    → Dicionário de dados
    → Qualidade e "vilões"
    → Veredito: dados usáveis?
    → Descritivas e groupby
    → Relações e gráficos
    → Hipóteses (Observação → Evidência → Hipótese → Próximos passos)
    → Responder as 4 perguntas do gerente
    → Estatística (IC, testes, regressão simples)
```

### Pré-análise rápida (para você saber o que esperar)

| Item | Achado esperado ao rodar |
|------|--------------------------|
| Tamanho | ~2.500 linhas × 19 colunas |
| Nulos | 0 em todas as colunas |
| Duplicados de linha / `order_id` | 0 |
| Unidade de análise | 1 linha = 1 **pedido** (`order_id`) |
| Target | `nps_score` (0–10, com casas decimais) |
| Leakage (não usar como feature de previsão na entrega) | `repeat_purchase_30d`; cuidado com `csat_internal_score` |
| Ressalvas | inconsistências lógicas possíveis (SAC=0 com tempo de resolução > 0; atraso > tempo de entrega); muitas notas baixas (muitos detratores) |

Isso **não** substitui você rodar os comandos — só evita surpresa e calibra o roteiro.

---

## Parte 0 — Setup

**Objetivo:** carregar a base e deixar o ambiente pronto.

### Referência da aula

- [EDA Aula 02 — Projeto prático EDA](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md) (reconhecimento da estrutura / 2.1)
- [Anotações — checklist EDA](../../planejamento/anotacoes-importantes.md)
- [Resumo Aula 02](../../analise-exploratoria-de-dados/aula-2/00-resumo.md)

### Código

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Se estiver rodando de notebooks/, o caminho relativo é este:
path = "../data/raw/desafio_nps_fase_1.csv"

# Alternativa (caminho absoluto no seu PC), se o relativo falhar:
# path = r"c:\Users\cleiv\OneDrive\Documentos\GitHub\Pos-Tech---IA-Scientist---IAST\fiap-nps-preditivo-ecommerce\data\raw\desafio_nps_fase_1.csv"

df = pd.read_csv(path, encoding="utf-8")
df.head()
```

### Anote o resultado

- A base carregou? (sim/não)  
- Primeiras linhas fazem sentido visualmente?  

---

## Parte 1 — Entender a estrutura (antes de “tratar”)

**Objetivo:** saber **quem é o personagem** da análise, quantos registros existem, quais colunas e tipos. Sem isso, qualquer gráfico depois é chute.

### Referência da aula

- [EDA Aula 02 — Reconhecimento da estrutura](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#reconhecimento-da-estrutura-do-dataset)
- [EDA Aula 02 — Tipos de variáveis](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#entendendo-os-tipos-de-variáveis)
- [EDA Aula 02 — Dicionário de dados](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#dicionário-de-dados-o-manual-que-todos-ignoram)
- Dicionário já rascunhado: [projeto-fase-1/docs/dicionario_dados_nps.md](../../projeto-fase-1/docs/dicionario_dados_nps.md)
- Manual: [05 — Qualidade e dicionário](../../projeto-fase-1/manual/05-qualidade-e-dicionario.md)

### 1.1 — Forma, colunas e tipos

```python
print("shape:", df.shape)          # esperado: (2500, 19)
print("colunas:", df.columns.tolist())
display(df.dtypes)
df.info()
df.memory_usage(deep=True).sum()
```

```python
df.head(5)
df.tail(5)
```

### Anote o resultado

| Pergunta | Sua resposta |
|----------|--------------|
| Nº de linhas / colunas | |
| Unidade de análise (pedido? cliente? dia?) | |
| Cada linha representa o quê? | |

**Resposta esperada da aula no case NPS:** unidade = **pedido** (`order_id`). NPS aqui é **transacional** (nota da experiência daquele pedido).

### 1.2 — Classificar variáveis (tabela da aula)

Preencha com o que `dtypes` + negócio te disserem:

| Coluna | Tipo (aula: contínua / discreta / nominal / ordinal / booleana / ID) | Por que |
|--------|---------------------------------------------------------------------|--------|
| `customer_id` | ID | |
| `customer_age` | | |
| `customer_region` | | |
| `customer_tenure_months` | | |
| `order_id` | ID (unidade de análise) | |
| `order_value` | | |
| `items_quantity` | | |
| `discount_value` | | |
| `payment_installments` | | |
| `delivery_time_days` | | |
| `delivery_delay_days` | | |
| `freight_value` | | |
| `delivery_attempts` | | |
| `customer_service_contacts` | | |
| `resolution_time_days` | | |
| `nps_score` | (target) | |
| `repeat_purchase_30d` | | |
| `complaints_count` | | |
| `csat_internal_score` | | |

### 1.3 — Conferir valores únicos e categorias

```python
df.nunique().sort_values()
df["customer_region"].value_counts()
df["customer_region"].value_counts(normalize=True).round(3)
```

### Anote o resultado

- Quantas regiões aparecem? Nomes limpos ou com typo?  
- IDs (`customer_id`, `order_id`) são únicos? (confirme na Parte 2)

---

## Parte 2 — Validar se os dados podem ser usados (“estão tratados?”)

**Objetivo:** antes de insight, responder: *garbage in, garbage out?* Completude, consistência, validade, precisão, atualidade.

Mentalidade da aula: não “o que posso prever?”, e sim **“o que está errado aqui?”**.

### Referência da aula

- [EDA Aula 02 — Avaliação da qualidade](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#avaliação-da-qualidade-dos-dados)
- [EDA Aula 02 — Vilões clássicos](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#faltantes-duplicados-e-outliers-os-vilões-clássicos)
- Leakage / proxy: [CRISP Aula 2.3 — armadilhas](../../metodologia-crisp-dm/aula-2/03-armadilhas-metricas-mlops-e-fechamento.md)
- Manual: [05 — Qualidade e dicionário](../../projeto-fase-1/manual/05-qualidade-e-dicionario.md)
- Target e leakage no projeto: [02 — Target e leakage](../../projeto-fase-1/manual/02-target-e-leakage.md)

### 2.1 — Completude (faltantes)

```python
df.isnull().sum()
df.isna().sum().sum()   # total de células nulas

# strings vazias na região (às vezes não vira NaN)
(df["customer_region"].astype(str).str.strip() == "").sum()
```

### Anote o resultado

| Checagem | Resultado | Decisão |
|----------|-----------|---------|
| Faltantes por coluna | | |
| Total de nulos | | |

### 2.2 — Duplicados

```python
df.duplicated().sum()
df["order_id"].duplicated().sum()
df["customer_id"].duplicated().sum()
```

### Anote o resultado

- Linhas 100% iguais?  
- `order_id` repetido? (se sim, a unidade de análise quebra)

### 2.3 — Validade de faixas (min/max e `describe`)

```python
df.describe().T   # min, max, média, mediana (50%), desvio, quartis

# Zoom no que a aula cobra no case NPS
cols_check = [
    "nps_score", "customer_age", "delivery_delay_days",
    "delivery_time_days", "customer_service_contacts",
    "resolution_time_days", "complaints_count",
    "order_value", "freight_value", "csat_internal_score",
]
df[cols_check].agg(["min", "max", "mean", "median"])
```

```python
# NPS fora de 0–10?
((df["nps_score"] < 0) | (df["nps_score"] > 10)).sum()

# Atraso negativo?
(df["delivery_delay_days"] < 0).sum()

# NPS é inteiro clássico ou float?
df["nps_score"].nunique()
sorted(df["nps_score"].unique())[:15]  # amostra dos menores valores
```

### Anote o resultado

- `nps_score` está em 0–10?  
- É inteiro ou tem casas (ex.: 6.9)? Isso muda o corte de classes.  
- Idade, frete, ticket têm mínimos/máximos plausíveis?

### 2.4 — Consistência lógica (específica desta base)

A pré-análise apontou possíveis inconsistências. **Meça você** e decida: bloquear a análise, ou só documentar como ressalva.

```python
# SAC = 0 contatos, mas tempo de resolução > 0
incoerente_sac = (
    (df["customer_service_contacts"] == 0)
    & (df["resolution_time_days"] > 0)
)
print("SAC=0 com resolution>0:", incoerente_sac.sum())

# Atraso maior que o tempo total de entrega
incoerente_atraso = df["delivery_delay_days"] > df["delivery_time_days"]
print("delay > delivery_time:", incoerente_atraso.sum())

# Olhar exemplos (não apague ainda — a aula manda entender antes de "embelezar")
df.loc[incoerente_sac, [
    "order_id", "customer_service_contacts",
    "resolution_time_days", "nps_score"
]].head(10)

df.loc[incoerente_atraso, [
    "order_id", "delivery_time_days",
    "delivery_delay_days", "nps_score"
]].head(10)
```

### Anote o resultado

| Inconsistência | Quantidade | Interpretação de negócio | O que fazer agora |
|----------------|------------|--------------------------|-------------------|
| SAC=0 e resolution>0 | | | Documentar / investigar / filtrar? |
| delay > delivery_time | | | Documentar / investigar / filtrar? |

**Postura da aula:** não automatizar tratamento às cegas. Documente cada alteração. Pior erro = “embelezar” e criar falsa qualidade.

### 2.5 — Leakage e variáveis “pós-experiência”

Para **EDA de negócio** você pode **explorar** tudo. Para **prever NPS na entrega**, isole:

| Coluna | Uso na EDA | Uso como feature preditiva na entrega |
|--------|------------|----------------------------------------|
| `nps_score` | Target | Não (é o alvo) |
| `repeat_purchase_30d` | Insight de recompra | **Não** — futuro (leakage) |
| `csat_internal_score` | Exploração / proxy | Só se o timing for conhecido; risco de leakage |
| `complaints_count` | Exploração | Só se a contagem for conhecida no momento da decisão |
| Entrega, frete, SAC, perfil | Drivers de experiência | Em geral OK (com cuidado de timing do SAC) |

```python
# Só para lembrar no notebook — não "apague" ainda; só não use como feature depois
cols_leakage_risco = ["repeat_purchase_30d", "csat_internal_score"]
df[cols_leakage_risco].describe()
```

### 2.6 — Veredito de usabilidade

Marque **uma** opção depois de rodar 2.1–2.5:

- [ ] **Sim, limpa** — pronta para EDA e modelagem sem ressalvas  
- [ ] **Sim, com ressalvas** — dá para analisar; documentar inconsistências / leakage / desbalanceamento  
- [ ] **Não** — problemas bloqueiam qualquer conclusão

**Expectativa da pré-análise:** em geral **sim, com ressalvas** (sem nulos/duplicados; inconsistências lógicas a documentar; NPS em float; muitos detratores; leakage a isolar).

### Anote o resultado — veredito

- Sua escolha:  
- Ressalvas em uma frase:  

**Só avance para a Parte 3 se o veredito for “sim” ou “sim com ressalvas”.**

---

## Parte 3 — Descritivas (Aula 2.2) e cortes de negócio (Aula 2.3)

**Objetivo:** entender distribuição do NPS e como ele muda por atraso, SAC, região, perfil — ainda sem “provar” com teste formal.

### Referência da aula

- [EDA Aula 02 — Estatísticas descritivas](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#estatísticas-descritivas-e-exploração-inicial-dos-dados)
- Fórmulas 2.2 (média, mediana, moda, var, std, CV, IQR): [anotações importantes](../../planejamento/anotacoes-importantes.md#aula-22--fórmulas-para-usar-no-projeto)
- Playlist mental: **2.1** base → **2.2** descritivas → **2.3** `groupby` → **2.4** gráficos

### 3.1 — Criar colunas auxiliares de negócio

```python
# Classes clássicas NPS (Reichheld). Com float, use cortes inclusivos assim:
df["nps_classe"] = pd.cut(
    df["nps_score"],
    bins=[-0.01, 6, 8, 10],
    labels=["detrator", "neutro", "promotor"],
)

df["eh_detrator"] = (df["nps_score"] <= 6).astype(int)
df["tem_atraso"] = (df["delivery_delay_days"] > 0).astype(int)

# Faixas para achar "ponto de ruptura" do atraso
df["faixa_atraso"] = pd.cut(
    df["delivery_delay_days"],
    bins=[-0.01, 0, 2, 4, 8],
    labels=["0 dias", "1-2 dias", "3-4 dias", "5+ dias"],
)

df["faixa_sac"] = pd.cut(
    df["customer_service_contacts"],
    bins=[-0.01, 0, 1, 3, 10],
    labels=["0", "1", "2-3", "4+"],
)

df["faixa_idade"] = pd.cut(
    df["customer_age"],
    bins=[17, 29, 44, 59, 100],
    labels=["18-29", "30-44", "45-59", "60+"],
)

df["faixa_tenure"] = pd.cut(
    df["customer_tenure_months"],
    bins=[0, 12, 36, 60, 200],
    labels=["ate_12m", "13-36m", "37-60m", "60m+"],
)

df["faixa_ticket"] = pd.qcut(
    df["order_value"], q=4, labels=["Q1_baixo", "Q2", "Q3", "Q4_alto"]
)
```

```python
df["nps_classe"].value_counts()
df["nps_classe"].value_counts(normalize=True).round(4)
```

### Anote o resultado

| Classe | n | % |
|--------|---|---|
| Detrator | | |
| Neutro | | |
| Promotor | | |
| NPS da amostra (% promotores − % detratores) | | |

### 3.2 — Tendência central e dispersão do NPS (não só `describe`)

```python
s = df["nps_score"]

print("média:", s.mean())
print("mediana:", s.median())
print("moda:", s.mode().iloc[0])
print("desvio padrão:", s.std())
print("variância:", s.var())
print("CV (std/média):", s.std() / s.mean())

q1, q2, q3 = s.quantile([0.25, 0.5, 0.75])
iqr = q3 - q1
print("Q1, Q2, Q3:", q1, q2, q3)
print("IQR:", iqr)
print("limite inferior típico (outliers):", q1 - 1.5 * iqr)
print("limite superior típico (outliers):", q3 + 1.5 * iqr)
```

```python
# Compare média vs mediana — assimetria?
abs(s.mean() - s.median())
```

### Anote o resultado

- Média e mediana estão próximas? O que isso diz da distribuição?  
- Há muitos outliers pelo critério 1,5×IQR? São erro ou “pedido muito ruim”?

### 3.3 — Histograma do NPS

```python
df["nps_score"].hist(bins=20)
plt.xlabel("nps_score")
plt.ylabel("frequência")
plt.title("Distribuição do NPS")
plt.show()
```

### Referência da aula (gráfico)

- Histograma na [EDA Aula 02 — distribuição](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#conhecendo-a-distribuição-das-variáveis)
- Catálogo: [EDA Aula 03 — Melhores gráficos](../../analise-exploratoria-de-dados/aula-3/01-melhores-graficos.md)

### 3.4 — `groupby`: NPS e % detratores por fator operacional

```python
def resumo_nps(grupo):
    return pd.Series({
        "n": len(grupo),
        "nps_medio": grupo["nps_score"].mean(),
        "nps_mediano": grupo["nps_score"].median(),
        "pct_detratores": grupo["eh_detrator"].mean(),
    })

# Região
df.groupby("customer_region", observed=True).apply(resumo_nps, include_groups=False).round(3)

# Atraso (ponto de ruptura)
df.groupby("faixa_atraso", observed=True).apply(resumo_nps, include_groups=False).round(3)

# Contatos SAC
df.groupby("faixa_sac", observed=True).apply(resumo_nps, include_groups=False).round(3)

# Tentativas de entrega
df.groupby("delivery_attempts", observed=True).apply(resumo_nps, include_groups=False).round(3)

# Reclamações (faixa simples)
df["faixa_reclamacoes"] = pd.cut(
    df["complaints_count"],
    bins=[-0.01, 2, 5, 11],
    labels=["0-2", "3-5", "6+"],
)
df.groupby("faixa_reclamacoes", observed=True).apply(resumo_nps, include_groups=False).round(3)
```

Se `include_groups` der erro na sua versão do pandas, use:

```python
df.groupby("faixa_atraso", observed=True)[["nps_score", "eh_detrator"]].agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    nps_mediano=("nps_score", "median"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)
```

### 3.5 — Perfil de cliente (alto vs baixo NPS)

```python
df.groupby("faixa_idade", observed=True)[["nps_score", "eh_detrator"]].agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)

df.groupby("faixa_tenure", observed=True)[["nps_score", "eh_detrator"]].agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)

df.groupby("faixa_ticket", observed=True)[["nps_score", "eh_detrator"]].agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)

df.groupby("customer_region", observed=True)[["nps_score", "eh_detrator"]].agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)
```

### Anote o resultado — o que “salta aos olhos”

| Corte | Onde o NPS cai mais / sobe mais | Observação em 1 frase |
|-------|----------------------------------|------------------------|
| Região | | |
| Faixa de atraso | | |
| SAC | | |
| Tentativas | | |
| Reclamações | | |
| Idade / tenure / ticket | | |

---

## Parte 4 — Relações, gráficos e ponto de ruptura (Aulas 2.4 + 3)

**Objetivo:** ver se as variáveis se movem juntas; achar onde a experiência “quebra”; preparar evidência para as 4 perguntas do desafio.

### Referência da aula

- [EDA Aula 02 — Relação entre variáveis](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#relação-entre-variáveis-e-descoberta-de-padrões)
- [EDA Aula 02 — Visualização exploratória](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#visualização-exploratória-dos-dados)
- [EDA Aula 03 — Melhores gráficos](../../analise-exploratoria-de-dados/aula-3/01-melhores-graficos.md)
- Lembrete da aula: **correlação ≠ causalidade**

### 4.1 — Correlação numérica (heatmap)

```python
cols_num = [
    "customer_age", "customer_tenure_months", "order_value",
    "items_quantity", "discount_value", "payment_installments",
    "delivery_time_days", "delivery_delay_days", "freight_value",
    "delivery_attempts", "customer_service_contacts",
    "resolution_time_days", "complaints_count", "nps_score",
    # CSAT e recompra: explorar, mas marcar leakage na interpretação
    "csat_internal_score", "repeat_purchase_30d",
]

corr = df[cols_num].corr(numeric_only=True)

plt.figure(figsize=(12, 10))
sns.heatmap(corr, annot=True, fmt=".2f", cmap="vlag", center=0)
plt.title("Correlação (exploratória)")
plt.tight_layout()
plt.show()
```

```python
# Quem mais se associa ao NPS? (valor absoluto)
corr["nps_score"].drop("nps_score").abs().sort_values(ascending=False)
```

### Anote o resultado

| Variável | Corr. com `nps_score` | Interpretação em português simples |
|----------|----------------------|-------------------------------------|
| | | |
| | | |
| | | |

Marque se alguma das top correlações é **leakage** (`repeat_purchase_30d`, `csat_internal_score`).

### 4.2 — Scatter (numérica × numérica)

```python
df.plot.scatter(x="delivery_delay_days", y="nps_score", alpha=0.3)
plt.title("Atraso × NPS")
plt.show()

sns.scatterplot(data=df, x="customer_service_contacts", y="nps_score", alpha=0.3)
plt.title("Contatos SAC × NPS")
plt.show()

sns.scatterplot(data=df, x="complaints_count", y="nps_score", alpha=0.3)
plt.title("Reclamações × NPS")
plt.show()
```

### 4.3 — Boxplot (numérica × categórica)

```python
sns.boxplot(data=df, x="customer_region", y="nps_score")
plt.xticks(rotation=30)
plt.title("NPS por região")
plt.show()

sns.boxplot(data=df, x="faixa_atraso", y="nps_score")
plt.title("NPS por faixa de atraso")
plt.show()

sns.boxplot(data=df, x="delivery_attempts", y="nps_score")
plt.title("NPS por tentativas de entrega")
plt.show()

sns.boxplot(data=df, x="faixa_sac", y="nps_score")
plt.title("NPS por faixa de contatos SAC")
plt.show()
```

### 4.4 — Crosstab (categórica × categórica)

```python
pd.crosstab(df["customer_region"], df["nps_classe"], normalize="index").round(3)
pd.crosstab(df["faixa_atraso"], df["nps_classe"], normalize="index").round(3)
pd.crosstab(df["faixa_sac"], df["nps_classe"], normalize="index").round(3)
```

### 4.5 — Procurar o “ponto de ruptura”

Olhe a tabela da Parte 3 (`faixa_atraso`, `faixa_sac`) e os boxplots. Pergunte:

1. Em qual faixa o **% de detratores** sobe de forma clara?  
2. Em qual faixa a **mediana do NPS** despenca?  
3. Isso é gradual ou tem um “degrau”?

```python
ruptura_atraso = df.groupby("faixa_atraso", observed=True).agg(
    n=("nps_score", "size"),
    nps_medio=("nps_score", "mean"),
    nps_mediano=("nps_score", "median"),
    pct_detratores=("eh_detrator", "mean"),
).round(3)
ruptura_atraso
```

### Anote o resultado — ponto de ruptura

- Candidato a ruptura (atraso):  
- Candidato a ruptura (SAC):  
- Evidência (número que você viu):  

### 4.6 — Checklist das 4 perguntas do desafio (ainda rascunho)

Use só o que as tabelas/gráficos mostraram. Linguagem simples; estatística formal vem na Parte 6.

| Pergunta do desafio | Onde olhar no seu notebook | Rascunho (1–2 frases) |
|---------------------|----------------------------|------------------------|
| Quais fatores parecem mais críticos para a satisfação? | Correlação + gaps no `groupby` | |
| O que mais gera detratores? | `% detratores` por atraso/SAC/reclamações/tentativas | |
| Existe “ponto de ruptura” na experiência? | Faixas de atraso e SAC | |
| Que tipo de cliente tende a NPS alto/baixo? | Região, idade, tenure, ticket | |

---

## Parte 5 — Registrar hipóteses (antes da estatística)

**Objetivo:** transformar achados em hipóteses testáveis. Hipótese da EDA **não é prova** — prova vem nos testes.

### Referência da aula

- [EDA Aula 02 — Registro das descobertas e hipóteses](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md#registro-das-descobertas-e-hipóteses)
- [Manual 04 — Perguntas analíticas e hipóteses](../../projeto-fase-1/manual/04-perguntas-analiticas-eda.md)
- Artefato opcional: [docs/hipoteses_eda_nps.md](../../projeto-fase-1/docs/hipoteses_eda_nps.md)

### Tabela (preencha a coluna Evidência com o que você rodou)

| # | Observação | Evidência (tabela/gráfico) | Hipótese | Próximos passos |
|---|------------|----------------------------|----------|-----------------|
| **H1** | Pedidos com mais contatos no SAC e/ou CSAT interno baixo | *(preencher)* | Cliente aciona o SAC em geral quando já há problema; mais contatos + CSAT baixo ↔ NPS baixo / detrator. CSAT só na exploração (risco de leakage). | Parte 6 — teste SAC/detratores; não usar CSAT como feature sem timing |
| **H2** | Muitas entregas com mais de 1 tentativa | *(preencher)* | Mais tentativas ↑ fricção → NPS pior / mais detrator | Parte 6 — comparar 1 vs 2+ tentativas |
| **H3** | Atraso na entrega parece derrubar a nota | *(preencher)* | Quanto maior o atraso, menor o NPS; existe faixa em que a experiência “quebra” | Parte 6 — correlação/regressão NPS ~ atraso; IC / teste por faixa |
| **H4** | *(sua observação de perfil de cliente)* | | | |

---

## Parte 6 — Estatística para validar insights (depois da EDA)

**Objetivo:** só agora formalizar. Não pule para cá sem Partes 1–5.

### Referência da aula

- Plano do projeto: [06 — Estatística e baseline](../../projeto-fase-1/manual/06-estatistica-e-baseline.md)
- [Estatística Aula 1 — IC / amostragem](../../estatistica-essencial-para-cientistas-de-dados/aula-1/01-inferencia-amostragem-intervalos-confianca.md)
- [Estatística Aula 3 — Correlação e regressão](../../estatistica-essencial-para-cientistas-de-dados/aula-3/01-correlacao-regressao-linear.md)
- [Estatística Aula 4 — Testes de hipótese](../../estatistica-essencial-para-cientistas-de-dados/aula-4/01-testes-de-hipotese.md)
- [Estatística Aula 5 — A/B (opcional)](../../estatistica-essencial-para-cientistas-de-dados/aula-5/01-teste-ab.md)

### 6.1 — Intervalo de confiança 95% da média do NPS

```python
from scipy import stats

n = len(df)
media = df["nps_score"].mean()
se = df["nps_score"].std(ddof=1) / np.sqrt(n)
ic = stats.t.interval(0.95, df=n - 1, loc=media, scale=se)
print("média NPS:", round(media, 3))
print("IC 95%:", (round(ic[0], 3), round(ic[1], 3)))
```

### 6.2 — IC 95% da proporção de detratores (aproximação normal ou Wilson)

```python
p = df["eh_detrator"].mean()
n = len(df)
se_p = np.sqrt(p * (1 - p) / n)
z = stats.norm.ppf(0.975)
ic_p = (p - z * se_p, p + z * se_p)
print("% detratores:", round(p, 4))
print("IC 95% (approx. normal):", (round(ic_p[0], 4), round(ic_p[1], 4)))
```

### Anote o resultado

- Média NPS e IC:  
- % detratores e IC:  
- Em português para o gerente: “a nota média da amostra fica aproximadamente entre X e Y”

### 6.3 — Teste 1: NPS difere por região? (ANOVA)

```python
grupos = [
    g["nps_score"].values
    for _, g in df.groupby("customer_region")
]
stat, pvalor = stats.f_oneway(*grupos)
print("ANOVA F:", stat, "p-valor:", pvalor)
```

### 6.4 — Teste 2: atraso (ou SAC) em detratores vs não-detratores

```python
atraso_det = df.loc[df["eh_detrator"] == 1, "delivery_delay_days"]
atraso_ok = df.loc[df["eh_detrator"] == 0, "delivery_delay_days"]

# Teste t (se as premissas preocuparem, use Mann-Whitney)
stat, pvalor = stats.ttest_ind(atraso_det, atraso_ok, equal_var=False)
print("média atraso detratores:", atraso_det.mean())
print("média atraso não-detratores:", atraso_ok.mean())
print("t-teste p-valor:", pvalor)

# Alternativa não paramétrica
stat_u, p_u = stats.mannwhitneyu(atraso_det, atraso_ok, alternative="two-sided")
print("Mann-Whitney p-valor:", p_u)
```

Repita trocando `delivery_delay_days` por `customer_service_contacts` se H1 for prioritária.

### 6.5 — Qui-quadrado: faixa de atraso × ser detrator

```python
tab = pd.crosstab(df["faixa_atraso"], df["eh_detrator"])
chi2, p, dof, expected = stats.chi2_contingency(tab)
print("qui²:", chi2, "p-valor:", p, "gl:", dof)
tab
```

### 6.6 — Correlação e regressão linear simples (NPS ~ atraso)

```python
r, p = stats.pearsonr(df["delivery_delay_days"], df["nps_score"])
print("Pearson r:", r, "p-valor:", p)

# Regressão simples (baseline)
import statsmodels.api as sm

X = sm.add_constant(df["delivery_delay_days"])
y = df["nps_score"]
modelo = sm.OLS(y, X).fit()
print(modelo.summary())
```

**Lembrete obrigatório da aula:** correlação / associação **não prova** causa. Digitos altos de atraso ↔ NPS baixo sugerem prioridade operacional, não “prova jurídica”.

### 6.7 — Baseline opcional (só mencionar / esboçar)

Se o desafio pedir baseline preditivo simples, siga o manual [06 — Estatística e baseline](../../projeto-fase-1/manual/06-estatistica-e-baseline.md): regressão OLS com poucas features **sem leakage**, ou classificador simples de detrator, reportando MAE/RMSE/R² ou recall — não accuracy sozinha.

```python
# Esboço: features operacionais (ajuste depois do veredito de leakage)
features = [
    "delivery_delay_days", "customer_service_contacts",
    "delivery_attempts", "freight_value", "order_value",
]
X = sm.add_constant(df[features])
y = df["nps_score"]
baseline = sm.OLS(y, X).fit()
print(baseline.summary())
```

### Anote o resultado — plano estatístico preenchido

| Técnica | Hipótese / pergunta | Resultado (número + 1 frase) |
|---------|---------------------|------------------------------|
| IC 95% NPS / % detratores | | |
| ANOVA por região | | |
| t / Mann-Whitney (atraso ou SAC) | | |
| Qui² faixa × detrator | | |
| Pearson / OLS NPS ~ atraso | | |
| Baseline (se fizer) | | |

---

## Parte 7 — Resposta para o gerente de operações (seção 03 do desafio)

**Objetivo:** traduzir tudo em linguagem de quem opera logística, SAC e CX — **sem** jargão de estatística.

### Referência da aula

- [EDA Aula 04 — Storytelling com dados](../../analise-exploratoria-de-dados/aula-4/01-storytelling-com-dados.md)
- [Manual 07 — Storytelling e entrega](../../projeto-fase-1/manual/07-storytelling-e-entrega.md)
- Escreva com **%**, **dias**, **contatos** — não com “p-valor”, “IQR”, “heterocedasticidade”.

Preencha **depois** de rodar as Partes 3–6. Deixe em branco o que ainda não tiver evidência.

### 1) Quais fatores parecem mais críticos para a satisfação?

> Em uma frase: o que mais pesa na nota do cliente nesta base.  
> Cite 2–3 fatores com número (ex.: “quando o atraso passa de X dias, a nota média cai de A para B”).

**Sua resposta:**

```text
(escreva aqui)
```

### 2) O que mais gera detratores?

> Foque em % de clientes com nota ≤ 6. O que dispara esse grupo?

**Sua resposta:**

```text
(escreva aqui)
```

### 3) Existe algum “ponto de ruptura” na experiência do cliente?

> Descreva o degrau: “até Y dias/atraso ou Y contatos o cenário é um; depois disso a experiência desanda”.

**Sua resposta:**

```text
(escreva aqui)
```

### 4) Que tipo de cliente tende a ter NPS mais alto ou mais baixo?

> Perfil (região, tempo de casa, idade, ticket) — sem culpar o cliente; use para priorizar ação.

**Sua resposta:**

```text
(escreva aqui)
```

### Fechamento em 30 segundos (elevator pitch)

> “Olhando os pedidos desta base, o que mais derruba a satisfação é ___. O principal gerador de detratores é ___. A experiência parece quebrar quando ___. Clientes com perfil ___ tendem a notas melhores/piores. Próximo passo operacional: ___.”

**Sua resposta:**

```text
(escreva aqui)
```

---

## Checklist final (antes de colar no notebook do desafio)

- [ ] Parte 1: unidade de análise = pedido (`order_id`) documentada  
- [ ] Parte 2: nulos, duplicados, faixas, inconsistências e leakage anotados  
- [ ] Parte 2: veredito de usabilidade marcado  
- [ ] Parte 3: classes NPS + descritivas + `groupby` principais  
- [ ] Parte 4: heatmap / boxplot / crosstab + candidato a ponto de ruptura  
- [ ] Parte 5: tabela Observação → Evidência → Hipótese → Próximos passos  
- [ ] Parte 6: pelo menos IC + 2 testes alinhados às hipóteses  
- [ ] Parte 7: 4 respostas em linguagem de gerente  

Quando terminar de rodar e anotar, voltamos juntos para interpretar os números e fechar o texto da seção 03.

---

## Índice rápido das aulas citadas

| Bloco do guia | Onde revisar |
|---------------|--------------|
| Setup / estrutura / tipos / dicionário / qualidade / descritivas / relações / hipóteses | [EDA Aula 02](../../analise-exploratoria-de-dados/aula-2/01-projeto-pratico-eda.md) |
| Checklist + fórmulas 2.2 | [anotações importantes](../../planejamento/anotacoes-importantes.md) |
| Escolha de gráficos | [EDA Aula 03](../../analise-exploratoria-de-dados/aula-3/01-melhores-graficos.md) |
| Contar a história para negócio | [EDA Aula 04](../../analise-exploratoria-de-dados/aula-4/01-storytelling-com-dados.md) |
| Começar pela pergunta | [EDA Aula 01](../../analise-exploratoria-de-dados/aula-1/01-como-responder-perguntas-com-dados.md) |
| Leakage / target | [CRISP 2.3](../../metodologia-crisp-dm/aula-2/03-armadilhas-metricas-mlops-e-fechamento.md) · [manual target](../../projeto-fase-1/manual/02-target-e-leakage.md) |
| IC | [Estatística Aula 1](../../estatistica-essencial-para-cientistas-de-dados/aula-1/01-inferencia-amostragem-intervalos-confianca.md) |
| Correlação / regressão | [Estatística Aula 3](../../estatistica-essencial-para-cientistas-de-dados/aula-3/01-correlacao-regressao-linear.md) |
| Testes | [Estatística Aula 4](../../estatistica-essencial-para-cientistas-de-dados/aula-4/01-testes-de-hipotese.md) |
