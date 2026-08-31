# Comparação: seu projeto × notebooks dos colegas

**Objetivo:** listar o que os 11 trabalhos em `Pos-Tech---IA-Scientist---IAST/modelos-tech-challenge-nps` fazem de diferente no **notebook e na análise de dados**, para você decidir o que copiar. Nada do seu código foi alterado.

**Fora do escopo (como combinado):** slides, PowerPoint, PDF, roteiro de vídeo e dashboard Streamlit. Esses itens aparecem só de passagem, quando ajudam a entender o que o notebook cobre.

**Como usar:** o que você já tem bem feito está na seção 2. O checklist da seção 5 é a lista de decisão. Cada item tem uma indicação de “vale olhar” vs “já está coberto”.

---

## 1. Visão rápida

| | Seu repo (`fiap-nps-preditivo-ecommerce`) | Colegas (em geral) |
|---|---|---|
| Artefato principal | 1 notebook único + guia MD | 1 notebook único **ou** EDA + modelo separados |
| Foco da Fase 1 | Negócio + target + EDA + estatística + respostas ao gerente | Quase todos também fazem **modelo de ML** (RF, XGBoost, HGB…) |
| Base usada na análise | **2.356** pedidos (filtro de inconsistência ~5,8%) | Quase todos usam os **2.500** brutos |
| Estatística inferencial | Forte (IC, ANOVA, t, Mann-Whitney, qui², Pearson, OLS) | Muitos só fazem 1 teste; alguns (Loschi, Ricardo, Leonardo) vão além |
| Qualidade dos dados | Completude, duplicados, faixas, **consistência lógica** e leakage | Poucos checam inconsistência lógica; vários pulam qualidade |
| Storytelling de gerente | Parte 7 com as 4 perguntas + elevator pitch | Quase todos fecham com insights; poucos tão estruturados |

**Leitura honesta:** no recorte “notebook + análise”, o seu trabalho já está **acima da média** em qualidade de dados, hipóteses e estatística. O que os colegas mais têm a mais é (a) **modelagem preditiva completa**, (b) alguns recortes de EDA que você ainda não fez (jornada compra/entrega/pós, Spearman, VIF, curva de risco dia a dia, recompra como *outcome*) e (c) gráficos mais “de apresentação” (Plotly, figuras exportadas).

---

## 2. O que você já cobre (não precisa “pegar” de ninguém)

Seu `notebooks/desafio_nps_fase_01.ipynb` (132 células: 95 markdown + 37 código) já entrega o roteiro do desafio:

1. **Negócio** — problema, importância do NPS, áreas, recompra/boca a boca/market share, indicadores complementares.
2. **Target** — `nps_score`, momento da jornada, leakage (`repeat_purchase_30d`, cuidado com CSAT).
3. **Qualidade** — nulos, duplicados, min/max, inconsistência SAC/resolução/CSAT e atraso > prazo, veredito.
4. **Filtro explícito** — 144 linhas (~5,8%) fora; análise em `df_mov_ecom_filtrado` (2.356). **Quase nenhum colega fez isso.**
5. **EDA** — classes NPS, faixas (atraso, SAC, idade, tenure, ticket, reclamações), descritivas, histograma, `groupby`, heatmap Pearson, scatter, boxplot, crosstab, ponto de ruptura.
6. **Hipóteses H1–H4** no formato Observação → Evidência → Hipótese.
7. **Estatística** — IC 95% da média e da % de detratores; ANOVA por região; t-test + Mann-Whitney (H1–H4); qui-quadrado faixa de atraso × detrator; Pearson + OLS simples; baseline OLS com 5 features sem leakage (R² ~0,47; ~−1,03 ponto por dia de atraso).
8. **Gerente** — 4 perguntas + pitch + ressalvas.

Há também o `notebooks/guia_eda_nps_passo_a_passo.md` (roteiro). Nenhum colega tem um guia equivalente.

**Conclusão de números (sua base filtrada):** NPS médio ~4,45 [4,35; 4,55]; ~73,5% detratores; ruptura candidata em **atraso ≥ 3 dias**; região **não** diferencia (ANOVA p ≈ 0,50). Colegas que usam 2.500 linhas reportam detratores mais altos (~80–84%) e NPS agregado mais negativo — diferença esperada por causa do filtro, não necessariamente erro de ninguém.

---

## 3. Cada colega, em uma página

### 01 — Bruna Rossi / grupo 24

- **Notebook:** 1 só, curto (24 células). Colab.
- **EDA:** inspeção + correlação de `nps_score` com numéricas. Sem dicionário, sem filtro de inconsistência, sem hipóteses formais, sem IC.
- **Estatística:** 1 teste t (com atraso vs sem atraso).
- **ML:** Random Forest classificando detrator vs não; AUC-ROC; feature importance. Features: atraso, tentativas, SAC, resolução, reclamações, ticket, frete.
- **O que você não tem:** modelo de classificação + importância de árvore.
- **O que você já tem melhor:** EDA, qualidade, estatística, respostas ao gerente.

### 02 — Antonio Lima (grupo 12)

- **Notebooks:** `01_eda_nps_Final.ipynb` (EDA) + `modelo.ipynb`. Há rascunhos da Luiza/Antonio (pode ignorar).
- **EDA:** responde as 4 perguntas do desafio de forma direta. Ponto de ruptura: atraso a partir de **2 dias** vira maioria detratora; **2ª reclamação** como divisor; perfil demográfico pouco importa. Gráficos **Plotly** interativos. Análise dedicada de **tempo de resolução**.
- **ML:** Logistic Regression (baseline) vs Random Forest; hold-out + validação cruzada; ROC; matriz de confusão; feature importance; **sistema de alertas** ALTO/MÉDIO/BAIXO exportado em CSV (`risco_clientes_sac.csv`). Leakage isolado no `src/`.
- **Extra fora do notebook:** `src/data_prep.py` + `train.py` + `main.py` (pipeline). Fora do seu pedido, mas o notebook do modelo é autoexplicativo.
- **Vale olhar:** (1) Plotly nas rupturas; (2) ruptura da **2ª reclamação** (seu corte é 0–2 / 3–5 / 6+ — vale conferir se 2 reclamações já quebram); (3) gráfico de `resolution_time_days`; (4) ideia de fila de alerta (se for modelar depois).

### 03 — Luis Loschi (grupo)

- **Notebook:** o mais próximo do seu em densidade (113 células), e o que mais **completa** a EDA/estatística que você ainda não fez.
- **Já alinhado com você:** CRISP-DM, negócio, target, leakage (CSAT e recompra fora do modelo), ruptura operacional, recomendações.
- **EDA a mais:**
  - assimetria (`skew`) e **curtose** de todas as numéricas;
  - tabela de **outliers IQR** por variável (não só do NPS);
  - Pearson **e Spearman** lado a lado;
  - ruptura também por **região**;
  - investigação de `delivery_time_days` vs atraso (o que realmente mexe no NPS);
  - **VIF / multicolinearidade** entre variáveis de entrega.
- **Estatística a mais:**
  - Shapiro-Wilk (NPS não é normal por região/idade → justifica teste não paramétrico);
  - **Kruskal-Wallis** (região e faixa etária) + eta² (tamanho de efeito);
  - associação NPS × **recompra 30d** (como *outcome*, não como feature);
  - qui-quadrado categoria NPS × região.
- **ML (se um dia for o caso):** Gradient Boosting (regressão) + Random Forest calibrado (3 classes); Precision-Recall; threshold da classe Neutro; **SHAP**; resíduos; artefatos `.joblib`.
- **Vale olhar com prioridade alta** — é o melhor “cardápio” de incrementos de análise, sem precisar do ML.

### 04 — Raphael Reis

- **Notebooks:** `01_eda_nps.ipynb` (curto, 21 células, bem focado) + `02_modelo_nps.ipynb`.
- **EDA a mais:** seção só de **CSAT interno vs NPS declarado**; figuras gravadas em `reports/`; features derivadas (`atraso_alto`, `reclama_alto`, `contato_atendimento`) no `scripts/prepare_data.py`.
- **ML:** `HistGradientBoostingRegressor` + importância por **permutação**.
- **Documento:** `docs/MEMORIA_ENTREGA.md` responde os itens 1–4 do enunciado em texto (você já faz isso na Parte 7 do notebook).
- **Vale olhar:** bloco CSAT × NPS (você trata CSAT como leakage; eles usam como checagem de consistência interna — útil no storytelling, sem colocar no modelo).

### 05 — Tainá Julianotti

- **Notebook:** só EDA (28 células). Sem modelo, sem testes formais.
- **Pontos de narrativa que você pode querer ecoar (conferir na sua base filtrada):**
  - NPS da empresa vs **benchmark** de e-commerce (eles citam 30–50 pontos);
  - “cada contato adicional reduz ~0,8 pontos”;
  - **recompra:** promotores recompram 100%, detratores 0% (na base bruta) — impacto financeiro direto;
  - Centro-Oeste com menor NPS médio (você, com filtro + ANOVA, concluiu que região **não** diferencia — se for citar região, deixe explícito o teste).
- **Vale olhar:** o gráfico/tabela de recompra por classe NPS (história de negócio; você já sabe que é leakage para prever).

### 06 — Guilherme Diniz

- **Notebooks:** `01_eda.ipynb` e `02_model.ipynb` **sem células markdown** (tudo em comentários).
- **EDA:** heatmap sem CSAT; ruptura **dia a dia** (eles marcam ruptura em **1 dia** de atraso); boxplots por região; exporta PNG em `reports/figures/`.
- **ML:** XGBoost 3 classes + **SHAP**.
- **Vale olhar:** o cálculo “maior queda de NPS ocorre em X dias” (você usa faixas 0 / 1–2 / 3–4 / 5+; eles usam o degrau diário). Pode enriquecer a Parte 4.5 sem mudar a conclusão dos 3 dias.

### 07 — Ana Carol

- **Notebook:** 1 só, no formato do enunciado (Partes 1, 2 e 3).
- **EDA:** nulos, classes NPS, heatmap, boxplots invertidos (atraso/reclamações/SAC **por grupo NPS**, não NPS por faixa), ruptura em **2 dias**.
- **Não tem:** estatística inferencial, filtro de inconsistência, modelo.
- **Pouco a copiar.** Seu notebook já cobre esse recorte com mais rigor.

### 08 — Camila Takemoto

- **Notebooks:** 3 (negócio / EDA / modelo), bem CRISP-DM.
- **EDA:** drivers um a um (`delivery_delay_days`, SAC, resolução, reclamações); tese de **fricção acumulada** (não um único evento); pontos de ruptura.
- **ML:** classificação binária detrator; score de risco (baixo/médio/alto ~25% / 73% / 93% de detratores); CSAT removido por leakage.
- **Vale olhar:** a ideia de “acúmulo de fricções” (atraso **e** reclamação **e** recontato) — você já sugere isso na Parte 7; eles deixam mais explícito com um score combinado. Sem ML, dá para fazer um `groupby` de atraso × reclamações.

### 09 — Albert Gus

- **Notebooks:** EDA curta (15 células) + modelagem.
- **EDA:** leakage, heatmap de multicolinearidade, distribuição do target, export CSV.
- **Cuidado:** o README trata `repeat_purchase_30d` como preditor de “lealdade prévia”. Isso conflita com o timing da variável (recompra **depois** do pedido). **Você já trata melhor** (leakage).
- **ML:** Random Forest regressor, depois corta a nota em classes (justificativa: fronteira do Neutro). R² ~0,62.
- **Pouco a copiar na EDA.** A justificativa “regressão contínua + corte de negócio” só importa se você for modelar.

### 10 — Ricardo Sallin

- **Notebook:** 1 só, EDA forte + regressão múltipla (sem árvore/boosting).
- **Diferencial analítico (o mais interessante depois do Loschi):**
  1. Feature `delivery_promise_days = delivery_time_days - delivery_delay_days` (prazo prometido).
  2. EDA **separada por etapa da jornada:** Compra / Entrega / Pós-venda. Conclusão: compra (ticket, desconto, parcelas) quase não correlaciona; entrega e pós-venda explicam a queda.
  3. **VIF** iterativo (atraso/prazo/promessa = VIF infinito; SAC × reclamações colineares).
  4. OLS múltipla: −0,95 por dia de atraso; −0,4 por reclamação; −0,3 por contato. R² ~0,56 com 4 preditores de pós-compra.
- **Vale olhar com prioridade alta:** o recorte por jornada e o VIF. Você já tem OLS de 5 features; o split compra/entrega/pós deixa a história do gerente mais nítida.

### 11 — Leonardo Mendoza / Payflow

- **Notebook de EDA:** 26 células, visual (Plotly): boxplot de ruptura logística, **curva de risco** (% detratores × dias de atraso), heatmap, região, **Mann-Whitney**, KDE de NPS por grupo.
- **Fora do escopo:** dashboard Streamlit, SMOTE, pytest — ignore por agora.
- **Vale olhar:** a curva de risco (um gráfico só vende o “a partir de X dias o risco explode”). Você já tem a tabela por faixa; o gráfico diário é o complemento visual.

---

## 4. Matriz: o que eles têm e você não

Legenda: **você já tem** · **eles têm, você não** · — não se aplica / irrelevante

| Tema | Você | 01 Bruna | 02 Antonio | 03 Loschi | 04 Raphael | 05 Tainá | 06 Guilherme | 07 Ana | 08 Camila | 09 Albert | 10 Ricardo | 11 Leonardo |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Negócio + target escritos | sim | sim | sim (docs) | sim | sim | sim | md à parte | sim | sim | pouco | sim | pouco |
| Qualidade (nulos/duplicados) | sim | pouco | sim | sim | sim | sim | sim | sim | sim | pouco | pouco | sim |
| Consistência lógica + filtro | **sim** | não | não | não | não | não | não | não | não | não | marca promise&lt;0, não filtra igual | não |
| Leakage documentado | sim | pouco | sim | sim | sim | pouco | sim | não | sim | sim (mas usa recompra) | sim | pouco |
| Hipóteses formais (H1–H4) | **sim** | 1 H só | implícitas | sim | pouco | pouco | pouco | não | implícitas | não | implícitas | 1 teste |
| IC 95% | **sim** | não | não | não (foco em testes) | não | não | não | não | não | não | não | não |
| ANOVA / Kruskal região | ANOVA | não | não | Kruskal + eta² | não | não | não | não | não | não | não | Mann-Whitney |
| Pearson + OLS | sim | corr. só | corr. | Pearson+Spearman | corr. | Pearson | corr. | heatmap | corr. | heatmap | OLS + VIF | heatmap |
| Spearman | não | não | não | **sim** | não | não | não | não | não | não | não | não |
| Shapiro / não-normalidade | não | não | não | **sim** | não | não | não | não | não | não | não | não |
| VIF / multicolinearidade | não (só comentário) | não | não | **sim** | não | não | não | não | não | heatmap | **sim** | não |
| Jornada compra vs entrega vs pós | não | não | não | não | não | não | não | não | implícito | não | **sim** | não |
| `delivery_promise_days` | não | não | não | não | não | não | não | não | não | não | **sim** | não |
| CSAT × NPS (bloco próprio) | leakage só | não | não | pouco | **sim** | não | exclui | não | exclui | exclui | pouco | não |
| Recompra como *outcome* | corr. + leakage | não | perfil | **teste** | cita | **100% vs 0%** | pouco | não | não | usa como feature | pouco | não |
| Curva de risco dia a dia | faixas | não | Plotly faixas | sim | faixas | faixas | **dia a dia** | 2 dias | sim | não | grupos | **sim** |
| Plotly | não | não | **sim** | não | não | não | não | não | não | não | não | **sim** |
| Figuras em `reports/` | não (inline) | não | não | **sim** | **sim** | **sim** | **sim** | não | não | não | não | não |
| ML completo (RF/XGB/HGB) | OLS baseline | RF | RF+alertas | GB+RF+SHAP | HGB | não | XGB+SHAP | não | classif. + score | RF regressor | OLS múltipla | RF (app) |
| SHAP / permutação | não | importance | importance | **SHAP** | permutação | não | **SHAP** | não | não | importance | coeficientes | — |

---

## 5. Checklist para você decidir (só análise / notebook)

Marque o que quiser incorporar. Ordem sugerida: o que muda a **história para o gerente** primeiro; ML por último (e só se o enunciado pedir).

### Prioridade A — enriquece a EDA que você já tem (baixo esforço)

- [ ] **Tabela NPS × recompra em 30 dias** (classe NPS → % que recompra). Continua leakage para prever; para o gerente é o “por que isso importa em reais”. Tainá e Loschi.
- [ ] **Cruzamento atraso × reclamações** (ou atraso × SAC) — “fricção acumulada” da Camila, sem modelo.
- [ ] **Ponto de ruptura dia a dia** (além das faixas 0 / 1–2 / 3–4 / 5+), estilo Guilherme/Leonardo. Um gráfico de NPS médio ou % detratores por `delivery_delay_days` = 0, 1, 2, 3…
- [ ] **Bloco CSAT interno vs NPS** (Raphael): “o termômetro interno acompanha o declarado” — e repetir que **não entra no modelo**.
- [ ] **Tempo de resolução** em gráfico próprio (Antonio), não só no `groupby` genérico.

### Prioridade B — estatística / robustez (alinha com a disciplina)

- [ ] **Spearman** ao lado do Pearson (Loschi). NPS e atraso não são bem gaussianos; Spearman costuma ser o teste “certo” da aula de não-paramétrico.
- [ ] **Shapiro** (ou só o argumento) + **Kruskal-Wallis** na região, para acompanhar a ANOVA que você já tem. Se os dois concordam (região n.s.), a conclusão fica mais difícil de atacar na banca.
- [ ] **VIF** nas features do baseline OLS (Ricardo / Loschi). Você já suspeita de colinearidade atraso × SAC × reclamações; o VIF deixa isso numérico.
- [ ] **Outliers IQR em todas as operacionais** (não só no NPS), com a decisão “mantém porque são casos críticos” (Loschi). Você já calcula IQR do NPS na 3.2.

### Prioridade C — recorte de jornada (muda o storytelling)

- [ ] **Três heatmaps / três blocos:** variáveis de **compra** (ticket, itens, desconto, parcelas, frete) vs **entrega** vs **pós-venda** (Ricardo). Conclusão típica: o problema não está no checkout.
- [ ] Feature auxiliar **`delivery_promise_days`** (prazo prometido). Ricardo usa para discutir expectativa; o VIF infinito com atraso/tempo é o alerta para **não** colocar as três juntas no OLS.

### Prioridade D — visual / entrega do notebook (opcional)

- [ ] Trocar 1–2 gráficos estáticos por **Plotly** (Antonio, Leonardo) — só se a banca for ver o `.ipynb` executado.
- [ ] `plt.savefig` em `reports/` (Tainá, Raphael, Loschi, Guilherme) — útil quando for montar o PowerPoint depois; **não precisa agora**.

### Prioridade E — modelagem (você já tem OLS; a maioria foi além)

Só vale se você quiser cumprir o “opcional de IA” do desafio. Não é buraco da EDA.

- [ ] Classificação detrator vs não (RF ou regressão logística) + ROC — Bruna, Antonio, Camila.
- [ ] Hold-out 80/20 e métricas MAE/RMSE/R² se permanecer em regressão — Raphael, Albert, Loschi.
- [ ] SHAP ou importância por permutação — Loschi, Guilherme, Raphael.
- [ ] Score de risco / fila de alerta (Antonio, Camila).

**Cuidado se for modelar:** não siga o Albert em usar `repeat_purchase_30d` como feature. Seu critério de leakage está mais correto.

---

## 6. Divergências de número / interpretação (para não se confundir)

| Achado | Você (base 2.356) | Colegas (em geral 2.500) | Comentário |
|---|---|---|---|
| % detratores | ~73,5% | ~80–84% (Tainá, Loschi) | Filtro de 144 linhas provavelmente tira casos ruins/incoerentes. Se citar o 80%, deixe claro que é a base **bruta**. |
| NPS agregado (%P − %D) | você calcula na 3.1 | −64 a −66 | Mesma história; o valor muda com o filtro. |
| Ruptura de atraso | **≥ 3 dias** (mediano 5 → 3; 91% detratores) | 1 dia (Guilherme, Loschi), 2 dias (Antonio, Ana), 3 dias (Tainá, Leonardo), 4+ (Raphael) | Não é contradição: o **primeiro** degrau ≠ o **pior** degrau. Você já descreve a queda contínua + o salto em 3 dias. Dá para mostrar os dois. |
| Reclamações | ruptura em **3+** (32% → 78% detratores) | 2ª reclamação (Antonio); 1 → 3% e 2 → 57% (Ricardo) | Seu bin 0–2 junta 0, 1 e 2. Se quiser alinhar com eles, recorte 0 / 1 / 2 / 3+. |
| Região | ANOVA n.s. | Tainá cita Centro-Oeste pior | Sua evidência estatística é mais forte. Prefira “região não é a alavanca”. |
| Efeito do atraso no OLS | **−1,03** ponto/dia; R² simples ~0,33; baseline ~0,47 | Ricardo −0,95; Loschi R² boosting ~0,64 | Mesma ordem de grandeza. Boosting ganha R² porque não é linear. |

---

## 7. O que **não** copiar (já está melhor no seu)

- Trocar o filtro de inconsistência por “usar 2.500 sem olhar”. Seu veredito 2.6 é um diferencial de ciência de dados.
- Transformar o notebook em 3 arquivos só porque os colegas fizeram. Um notebook único, no seu caso, já conta a história CRISP-DM.
- Colocar CSAT ou recompra como feature de previsão.
- SHAP / XGBoost / Streamlit / Makefile / pytest — são extras de engenharia, não de análise da Fase 1.
- Texto de negócio genérico: o seu 01 e 02 já respondem o enunciado.

---

## 8. Mapa dos arquivos (para abrir só o que importa)

```text
Seu projeto
  notebooks/desafio_nps_fase_01.ipynb     ← entrega
  notebooks/guia_eda_nps_passo_a_passo.md

Colegas (pasta modelos-tech-challenge-nps/)
  01-brunarossi-grupo24/tech_challenge_nps_entrega_final.ipynb
  02-AntoniLima-Fase_01/notebooks/01_eda_nps_Final.ipynb
  02-AntoniLima-Fase_01/notebooks/modelo.ipynb
  03-LuisLoschi-NPS_Preditivo/notebooks/tech_challenge_fase1.ipynb   ← melhor referência de EDA+stats
  04-nassereq-Raphael_Reis/notebooks/01_eda_nps.ipynb
  05-tainajulianotti-nps-ecommerce/notebook/notebook_analise_exploratoria.ipynb
  06-GuilhermeDiniz-Fiap-Nps/notebooks/01_eda.ipynb
  07-AnaCarol21-desafio_nps/desafio_nps_fase_1.ipynb
  08-camitak-case-nps/notebooks/02_eda_nps.ipynb
  09-AlbertGus-nps-preditivo/notebooks/1_exploracao_e_preparacao.ipynb
  10-ricardo-sallin-nps-eda/Ecommerce_NPS_Fase_1_EDA_e_modelos_preditivos.ipynb  ← melhor recorte de jornada
  11-LeonardoGMendoza-payflow/notebooks/analise_exploratoria_nps.ipynb
```

---

## 9. Resumo em três frases

1. **Você já tem** o núcleo que a banca da Fase 1 pede (negócio, target, qualidade, EDA, hipóteses, testes, respostas ao gerente), com um filtro de dados que os outros quase não fizeram.
2. **O que mais falta**, se quiser nivelar com os melhores de análise (Loschi + Ricardo), é Spearman/Kruskal/VIF, o split compra–entrega–pós, a curva de risco dia a dia e a tabela NPS × recompra.
3. **O que a maioria fez e você ainda não** é modelo de árvore/boosting + SHAP — ignore por enquanto, a menos que você decida entregar o opcional de ML depois do PowerPoint.
