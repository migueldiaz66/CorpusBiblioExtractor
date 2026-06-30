# Info & References — Life Cycle

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `lifeCycle`).
> Ruta de menú: ANALYSIS › Overview › Life Cycle · tabName: `lifeCycle`

## Resumen (español)

- Módulo "Ciclo de vida de la producción científica": ajusta un modelo de crecimiento logístico a los conteos anuales de publicaciones para identificar en qué fase está un tema (emergencia, crecimiento rápido, madurez o declive).
- Fórmula base: P(t) = K / (1 + exp(-b(t - t₀))); la tasa anual es la derivada (curva en forma de campana) y la acumulada sigue una curva en S.
- Model Overview (4 parámetros): Saturation (K, máximo total de publicaciones), Peak Year (Tm, año de máxima producción anual), Peak Annual (publicaciones máximas por año) y Growth Duration (Δt, años del 10% al 90% de K).
- Model Fit Quality: R² (varianza explicada; >0.90 excelente), RMSE (error medio), AIC y BIC (equilibran ajuste y complejidad; menor es mejor). Clasifica el ajuste como Excellent/Good/Poor.
- Current Status y Milestone Years: progreso hacia la saturación (% de K) y años estimados para alcanzar 10%, 50% (inflexión = Tm), 90% y 99% de K, situando la fase actual del tema.
- Forecast: proyecta producción futura (acumulada y anual); válido solo si el modelo se mantiene (sin disrupciones); precaución con horizontes >10 años.
- Incluye visualizaciones (campana de publicaciones anuales y curva acumulada en S), integración con Biblio AI, casos de uso, buenas prácticas, advertencias y diagnóstico de ajustes pobres (R² < 0.70).

---

## Info & References (original, en inglés)

### 📈 Life Cycle of Scientific Production: Modeling Research Topic Evolution

The **Life Cycle of Scientific Production** module implements a **logistic growth model** to analyze the temporal dynamics of research topics. This approach, grounded in the theory of *scientific paradigms* and *innovation diffusion*, allows researchers to identify the current developmental stage of a field, predict future trends, and estimate when a topic will reach maturity or saturation.

By fitting a logistic curve to the annual publication counts in your collection, this analysis reveals whether a research area is in its **emergence phase**, **rapid growth phase**, **maturity phase**, or **decline phase**.

#### 📐 The Logistic Growth Model

The life cycle analysis is based on the **logistic growth function**, which models how the cumulative number of publications evolves over time:

**Formula:**

`P(t) = K / (1 + exp(-b(t - t₀)))`

Where:

- **P(t)**: Cumulative number of publications at time `t`
- **K**: Saturation level (maximum total publications the topic will produce)
- **b**: Growth rate parameter (determines the steepness of the curve)
- **t₀**: Inflection point (time when growth rate is highest)

The **annual publication rate** is derived as the first derivative of P(t), producing a bell-shaped curve that peaks at the inflection point and gradually declines as the topic approaches saturation.

#### 🔬 Model Overview: Key Parameters

The **Model Overview** section displays four fundamental indicators derived from the fitted logistic model:

#### 1. Saturation (K)

- **Definition:** The estimated maximum total number of publications that will ever be produced on this research topic.
- **Interpretation:**
  - High K values (>5,000) indicate a *broad, impactful research domain* with sustained long-term interest.
  - Low K values (<1,000) suggest a *niche topic* with limited scope or a specialized subtopic within a larger field.
  - The current cumulative total as a percentage of K reveals how close the topic is to exhaustion.
- **Example:** K = 8,980 publications suggests the topic will produce approximately 8,980 total documents before reaching saturation.

#### 2. Peak Year (T<sub>m</sub>)

- **Definition:** The year when annual publication output is predicted to reach its maximum.
- **Interpretation:**
  - If the peak year is in the **future**, the topic is still in a *growth phase* and attracting increasing attention.
  - If the peak year is in the **past**, the topic has entered a *maturity or decline phase*, with decreasing annual output.
  - If the peak year is **near the present**, the topic is at the *zenith of its popularity*.
- **Example:** Peak Year = 2029 indicates the topic will reach maximum annual productivity in 2029, suggesting it is currently in an accelerating growth phase.

#### 3. Peak Annual

- **Definition:** The maximum number of publications per year predicted to occur at the Peak Year.
- **Interpretation:** This metric reflects the *intensity of research activity* at the topic's peak. Higher values indicate greater scholarly attention and resource allocation.
- **Example:** Peak Annual = 592 pubs/year means the topic will generate approximately 592 publications annually at its zenith.

#### 4. Growth Duration (Δ<sub>t</sub>)

- **Definition:** The estimated time span (in years) from the topic's emergence (10% of K) to near-saturation (90% of K).
- **Interpretation:**
  - **Short duration (<10 years):** Rapid maturation, typical of *hot topics*, technological innovations, or crisis-driven research (e.g., COVID-19 studies).
  - **Medium duration (10-20 years):** Typical of *mainstream research domains* with sustained but gradual growth.
  - **Long duration (>20 years):** Slow-developing fields, foundational topics, or interdisciplinary areas requiring extensive infrastructure.
- **Example:** Growth Duration = 16.7 years suggests the topic will take approximately 17 years to mature from its early stage to near-saturation.

#### ✅ Model Fit Quality

The **Model Fit Quality** section assesses how well the logistic curve fits the observed publication data using four statistical metrics:

#### 1. R² (Coefficient of Determination)

- **Range:** 0 to 1 (higher is better)
- **Interpretation:** Proportion of variance in publication counts explained by the model.
  - **R² > 0.90:** Excellent fit—the logistic model accurately captures the publication trend.
  - **0.70 < R² < 0.90:** Good fit—the model is reasonable but may not capture all nuances (e.g., fluctuations due to external events).
  - **R² < 0.70:** Poor fit—the logistic model may not be appropriate for this dataset (non-logistic growth pattern, data quality issues).
- **Example:** R² = 0.953 indicates an excellent fit, with 95.3% of publication variance explained by the model.

#### 2. RMSE (Root Mean Squared Error)

- **Definition:** Average deviation between observed and predicted annual publications.
- **Interpretation:** Lower values indicate better fit. RMSE should be interpreted relative to the scale of annual publications (e.g., RMSE = 10 is negligible for topics with 500+ annual pubs, but significant for topics with <50 pubs/year).

#### 3. AIC (Akaike Information Criterion)

- **Purpose:** Balances model fit against complexity (penalizes overfitting).
- **Interpretation:** Lower AIC values indicate a better model. AIC is most useful for *comparing alternative models* rather than assessing absolute fit quality.

#### 4. BIC (Bayesian Information Criterion)

- **Purpose:** Similar to AIC but applies a stronger penalty for model complexity.
- **Interpretation:** Lower BIC values indicate better models. BIC is more conservative than AIC and favors simpler models.

**Overall Assessment:** Biblioshiny automatically classifies model fit as **Excellent**, **Good**, or **Poor** based primarily on R² values. An 'Excellent' fit (R² > 0.90) validates the use of logistic growth assumptions for forecasting.

#### 📍 Current Status

This section provides a snapshot of the topic's present state relative to its life cycle trajectory:

- **Last Observed Year:** The most recent year with publication data in your collection.
- **Annual Publications:** The number of publications in the last observed year.
- **Cumulative Total:** The total number of publications from the collection's start to the last observed year.
- **Progress to Saturation:** The percentage of K (saturation level) already reached.
  - **0-30%:** Emergence or early growth phase.
  - **30-70%:** Rapid growth phase (the topic is 'hot').
  - **70-90%:** Late growth phase, approaching maturity.
  - **>90%:** Maturity or decline phase, nearing exhaustion.

**Example Interpretation:** If Progress to Saturation = 10.0%, the topic is in the **rapid growth phase**, with 90% of its publication potential still ahead. This signals a *promising emerging field* attracting increasing scholarly attention.

#### 🏁 Milestone Years

The **Milestone Years** section predicts when the topic will reach specific saturation thresholds:

- **10% of K:** Emergence milestone—marks the topic's transition from niche to recognized research area.
- **50% of K (Midpoint):** The inflection point where growth rate is highest. This coincides with the Peak Year (T<sub>m</sub>).
- **90% of K:** Maturity milestone—indicates the topic is approaching saturation, with declining annual growth.
- **99% of K:** Near-complete saturation—the topic has exhausted most of its research potential.

**Example:**

```
10% of K: 2021.0
50% of K: 2029.3 (+9 years)
90% of K: 2037.6 (+18 years)
99% of K: 2046.7 (+27 years)
```

This indicates the topic emerged around 2021, will peak in 2029, and approach saturation by 2038, with a full life cycle spanning approximately 25 years.

The system also classifies the topic's current phase (e.g., **'rapid growth phase'** if between 10-50% of K) to aid interpretation.

#### 🚀 Forecast

The **Forecast** section projects future publication output based on the fitted logistic model:

- **Forecast Period:** The time range for predictions (typically 5-50 years into the future).
- **Projection for 2025:** Estimated cumulative total publications by 2025 (includes annual projection in parentheses).
- **Projection for 2030:** Estimated cumulative total publications by 2030 (includes annual projection in parentheses).

**Example:**

```
Projection for 2025: 2183 cumulative (436 annual)
Projection for 2030: 4898 cumulative (587 annual)
```

This suggests the topic will grow from ~900 publications (current) to over 4,800 by 2030, with annual output peaking around 587 publications per year.

**Important:** Forecasts assume the logistic model remains valid (no disruptive events, paradigm shifts, or external shocks). Long-term forecasts (>10 years) should be interpreted with caution.

#### 📊 Visualizations

The **Plot** tab provides two complementary graphs:

#### 1. Life Cycle - Annual Publications

- **Blue solid line:** Logistic fit to observed data
- **Blue dashed line:** Forecasted annual publications
- **Blue dots:** Observed annual publications from your collection
- **Red dashed vertical line:** Peak Year (T<sub>m</sub>)

**Interpretation:** This bell-shaped curve shows how publication activity rises, peaks, and eventually declines. The shape reveals the topic's maturity:

- **Steep ascent, pre-peak:** Emerging or rapidly growing topic.
- **Near or at peak:** Mature topic at maximum attention.
- **Descending curve, post-peak:** Declining topic losing relevance.

#### 2. Cumulative Growth Curve

- **Green solid line:** Logistic fit to observed cumulative data
- **Green dashed line:** Forecasted cumulative publications
- **Green dots:** Observed cumulative publications
- **Horizontal dashed lines:** Saturation thresholds (50%, 90%)

**Interpretation:** This S-shaped curve illustrates the topic's total knowledge accumulation over time. The curve's position and steepness reveal:

- **Lower left (shallow slope):** Emergence phase with slow initial growth.
- **Middle (steep slope):** Rapid growth phase with exponential accumulation.
- **Upper right (flattening):** Maturity phase approaching saturation asymptote (K).

#### 🧠 Biblio AI Integration

The **Biblio AI** tab allows you to generate AI-powered narrative interpretations of the life cycle analysis. Key features include:

- **Customizable Prompts:** Edit the default prompt to add context-specific details (e.g., research domain, database source, filter criteria).
- **Graph-Based Analysis:** Biblio AI analyzes the visualizations to identify trends, anomalies, and key transition points.
- **Automatic Interpretation:** Generates text suitable for research reports, explaining model parameters, growth phases, and forecasts in natural language.

**Example Prompt Enhancement:**

```
The analysis was performed on a collection downloaded from WOS focusing on machine learning applications in healthcare from 1990-2020.
```

This contextual information helps Biblio AI produce more accurate and domain-relevant interpretations.

#### 💡 Use Cases

- **Identifying Emerging Topics:** Detect rapidly growing fields in their early stages (10-30% of K) for strategic research investment.
- **Timing Research Entry:** Avoid entering saturated fields (>90% of K) where novelty is harder to achieve.
- **Forecasting Resource Needs:** Predict future publication volumes to plan journal submissions, conferences, or funding opportunities.
- **Comparative Life Cycle Analysis:** Run the analysis on multiple subtopics to identify which are growing vs. declining.
- **Paradigm Shift Detection:** Poor model fit (R² < 0.70) may signal non-logistic patterns caused by disruptive innovations or paradigm shifts.

#### 📌 Best Practices

- **Ensure sufficient data:** Logistic models require at least 10-15 years of publication data for reliable fitting. Collections with <10 years may produce unstable forecasts.
- **Check model fit:** Always review R² and visual fit before interpreting forecasts. Poor fits (R² < 0.70) indicate the logistic model may not be appropriate.
- **Consider external events:** The model assumes smooth, uninterrupted growth. Real-world shocks (e.g., pandemics, funding cuts, technological breakthroughs) can invalidate long-term forecasts.
- **Use relative comparisons:** Life cycle parameters (K, Peak Year) are most informative when comparing multiple topics or time periods within the same field.
- **Validate forecasts periodically:** Re-run the analysis with updated data every 2-3 years to recalibrate predictions.

#### ⚠️ Important Considerations

- **Database Coverage:** The model reflects only publications indexed in your source database(s). Incomplete coverage (e.g., missing journals, preprints) can distort saturation estimates.
- **Definition Drift:** Topic boundaries may shift over time (e.g., 'artificial intelligence' in 1990 vs. 2020), affecting the validity of K estimates.
- **Multiple Life Cycles:** Some broad topics exhibit *multiple overlapping life cycles* as subtopics emerge and decline independently. In such cases, aggregate logistic fits may be misleading.
- **Self-Fulfilling Prophecies:** Publishing forecasts may influence researcher behavior (e.g., avoiding 'saturated' topics), potentially altering actual trajectories.
- **Model Limitations:** The logistic model assumes a single saturation point and smooth growth. Topics experiencing *resurgence* (e.g., due to new technologies) may not fit this pattern.

#### 🔍 Interpreting Fit Quality Issues

If your model shows poor fit (R² < 0.70), consider these potential causes:

- **Insufficient Data:** Too few years or highly irregular publication patterns.
- **Non-Logistic Growth:** The topic may exhibit exponential, linear, or cyclic growth rather than logistic.
- **Recent Disruptions:** External shocks (e.g., COVID-19 boosting health research) create anomalies that deviate from smooth curves.
- **Topic Too Broad:** Aggregating multiple subtopics with different life cycles can obscure individual patterns.
- **Data Quality Issues:** Missing years, database indexing changes, or inconsistent metadata.

**Solution:** Try narrowing your collection (e.g., focusing on a specific subtopic or time range) or exploring alternative growth models.

#### 📚 References

**Aria, M., Misuraca, M., & Spano, M. (2020).** *Mapping the evolution of social research and data science on 30 years of Social Indicators Research.* **Social Indicators Research**, 149, 803–831. [https://doi.org/10.1007/s11205-020-02281-3](https://doi.org/10.1007/s11205-020-02281-3)

**Bettencourt, L. M., Kaiser, D. I., & Kaur, J. (2009).** *Scientific discovery and topological transitions in collaboration networks.* **Journal of Informetrics**, 3(3), 210–221. [https://doi.org/10.1016/j.joi.2009.03.001](https://doi.org/10.1016/j.joi.2009.03.001)

**Rogers, E. M. (2003).** *Diffusion of Innovations* (5th ed.). New York: Free Press.

**Small, H., & Upham, S. P. (2009).** *Citation structure of an emerging research area on the verge of application.* **Scientometrics**, 79(2), 365–375. [https://doi.org/10.1007/s11192-009-0424-0](https://doi.org/10.1007/s11192-009-0424-0)

**Wang, Q. (2018).** *A bibliometric model for identifying emerging research topics.* **Journal of the Association for Information Science and Technology**, 69(2), 290–304. [https://doi.org/10.1002/asi.23930](https://doi.org/10.1002/asi.23930)
