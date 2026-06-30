# Info & References — Bradford's Law

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `bradfordLaw`).
> Ruta de menú: ANALYSIS › Sources › Bradford's Law · tabName: `bradford`

## Resumen (español)

- "Ley de Bradford de la dispersión" (Bradford, 1934): describe la concentración y dispersión de la literatura científica; pocas revistas "núcleo" concentran gran parte de los artículos y el resto se dispersa en muchas revistas periféricas.
- Formulación original: al ordenar revistas por productividad decreciente y dividirlas en tres zonas con igual número de artículos, el número de revistas por zona crece según la razón 1 : k : k² (k = multiplicador de Bradford).
- Distribución de Bradford: el "bibliograph" (artículos acumulados vs. log del rango) muestra una región cóncava inicial (núcleo) seguida de una región lineal: C(r) = a + b · log(r).
- Tres zonas: Zona 1 (núcleo, revistas esenciales, máxima prioridad de adquisición), Zona 2 (productividad moderada) y Zona 3 (periferia, cola larga que aporta poco individualmente pero mucho en conjunto).
- Diagnóstico de la curva: una caída inicial pronunciada indica alta concentración (campo dominado por pocas revistas); una curva más plana indica mayor dispersión.
- Prueba de bondad de ajuste: test de Kolmogorov-Smirnov más R² (ajuste del modelo lineal), estadístico KS (D) y p-valor; si p ≥ 0.05 los datos son consistentes con la Ley de Bradford.

---

## Info & References (original, en inglés)

### Bradford's Law of Scattering

**Bradford's Law** is one of the foundational laws of bibliometrics, first formulated by Samuel C. Bradford in 1934. The law describes the phenomenon of *concentration and dispersion* in scientific publishing: a small number of core journals account for a disproportionately large share of the literature on a given topic, while the remaining literature is scattered across an increasingly large number of peripheral journals.

#### The Original Formulation

Bradford observed that if scientific journals are ranked in order of decreasing productivity on a given subject and then divided into groups (zones) that each contain approximately the same number of articles, the number of journals in successive zones increases geometrically. Specifically, if the journals are partitioned into three zones such that each zone contains roughly one-third of the total articles, the number of journals in each zone follows the ratio:

**1 : k : k²**

where **k** is the **Bradford multiplier**. The first zone (Zone 1, or the "core") contains a small number of highly productive journals; the second zone (Zone 2) contains a larger number of moderately productive journals; and the third zone (Zone 3, or the "periphery") contains a very large number of journals that each contribute only one or a few articles.

#### The Bradford Distribution

More formally, the law can be expressed through the **Bradford distribution**. If sources are ranked in decreasing order of productivity (*n*<sub>1</sub> ≥ *n*<sub>2</sub> ≥ … ≥ *n*<sub>S</sub>) and the cumulative number of articles is plotted against the logarithm of the source rank, the resulting curve — known as the **Bradford bibliograph** — shows a characteristic pattern: an initial concave region (corresponding to the core journals) followed by a linear region (corresponding to the intermediate and peripheral journals).

The linear portion of the curve indicates that:

**C(r) = a + b · log(r)**

where **C(r)** is the cumulative number of articles contributed by the top *r* sources, and *a* and *b* are constants estimated via linear regression.

This logarithmic relationship implies that each successive "doubling" of the number of journals yields a roughly constant increment in the total number of articles — a fundamental feature of the skewed, heavy-tailed distributions that pervade bibliometric data.

#### Practical Interpretation of Bradford Zones

Biblioshiny implements Bradford's Law by partitioning the sources in the collection into zones. The partition serves multiple analytical and practical purposes:

- **Core zone (Zone 1):** Contains the most productive journals — the "essential" outlets of the field. These are the journals that a researcher working in the domain should monitor regularly, as they collectively publish a substantial share of the relevant literature. For library acquisition policies, these journals represent the highest priority.
- **Intermediate zone (Zone 2):** Contains journals with moderate productivity. These outlets publish relevant articles with some regularity but are not exclusively devoted to the topic. Researchers may encounter relevant articles in these journals but would not rely on them as primary sources.
- **Peripheral zone (Zone 3):** Contains the long tail of journals that each contribute very few articles — often just one or two. These may be multidisciplinary venues, regional journals, or outlets in adjacent disciplines where the topic occasionally appears. Although individually these journals contribute little, collectively they account for a substantial share of the total literature.

#### Diagnostic Information from the Bradford Curve

The shape of the Bradford curve provides diagnostic information about the field:

- A **steep initial drop** (with a small core zone) indicates *high concentration* — a field dominated by a few key journals.
- A **flatter curve** indicates *greater dispersion* — a field where the literature is spread more evenly across many outlets.
- The position of a particular journal along the curve reveals its role in the field's publication landscape: journals in the core zone are the field's "home" outlets, while journals in the periphery are incidental contributors.

#### Goodness-of-Fit Test

To assess whether the empirical source distribution conforms to the theoretical Bradford distribution, Biblioshiny performs a **Kolmogorov-Smirnov (KS) goodness-of-fit test**. This test compares the empirical cumulative distribution of articles across sources with the theoretical distribution predicted by the fitted Bradford model.

- **R² (coefficient of determination):** Measures how well the linear model C(r) = a + b · log(r) fits the empirical data. Values close to 1 indicate an excellent fit.
- **KS statistic (D):** The maximum absolute difference between the empirical and theoretical cumulative distributions. Smaller values indicate a better fit.
- **p-value:** If *p* ≥ 0.05, the empirical distribution is consistent with Bradford's Law (we cannot reject the null hypothesis that the data follow the theoretical distribution). If *p* < 0.05, there is a statistically significant deviation.

#### References

**Bradford, S. C. (1934).** *Sources of information on specific subjects.* **Engineering**, 137, 85–86.

**Brookes, B. C. (1969).** *Bradford's law and the bibliography of science.* **Nature**, 224(5223), 953–956. [https://doi.org/10.1038/224953a0](https://doi.org/10.1038/224953a0)

**Egghe, L. (1986).** *The dual of Bradford's law.* **Journal of the American Society for Information Science**, 37(4), 246–255. [https://doi.org/10.1002/(SICI)1097-4571(198607)37:4<246::AID-ASI10>3.0.CO;2-F](https://doi.org/10.1002/(SICI)1097-4571(198607)37:4<246::AID-ASI10>3.0.CO;2-F)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.
