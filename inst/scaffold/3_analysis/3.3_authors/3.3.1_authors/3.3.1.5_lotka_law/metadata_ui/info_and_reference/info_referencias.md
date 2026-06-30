# Info & References — Lotka's Law

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `lotkaLaw`).
> Ruta de menú: ANALYSIS › Authors › Lotka's Law · tabName: `lotka`

## Resumen (español)

- La **Ley de Lotka** (Lotka, 1926) describe la distribución de frecuencias de la productividad científica: muchos autores publican un solo artículo y pocos son muy prolíficos.
- Sigue una ley de potencia inversa **f(n) = C / n^β**, donde f(n) es la proporción de autores con exactamente *n* artículos, C es una constante y β es el exponente de productividad (pendiente en escala log-log). En la formulación original β = 2 (aprox. 1/n² de los autores).
- **Estimación**: biblioshiny ajusta los parámetros mediante regresión lineal en espacio log-log, obteniendo β, C y el R² de bondad de ajuste. El gráfico muestra tres curvas: distribución empírica (negra), Lotka teórica con β = 2 (roja discontinua) y modelo ajustado (azul punto-raya).
- **Pruebas KS**: dos tests de Kolmogorov-Smirnov evalúan el ajuste; un p-valor ≥ 0.05 indica consistencia con la ley teórica (Test 1, β = 2) o con el modelo ajustado (Test 2, β empírico).
- **Interpretación del exponente**: β ≈ 2 sigue la ley clásica; β > 2 productividad más concentrada (campos especializados); β < 2 productividad más dispersa (campos amplios y consolidados).
- **R²**: alto = la ley de potencia ajusta bien (distribución sesgada robusta); bajo = posible desviación por patrones de colaboración, coautoría o artefactos de datos.

---

## Info & References (original, en inglés)

### Lotka's Law of Scientific Productivity

**Lotka's Law** is one of the foundational laws of bibliometrics, first formulated by Alfred J. Lotka in 1926. The law describes the *frequency distribution of scientific productivity* among authors: a large proportion of authors publish only one paper, while a small proportion are highly prolific.

#### The Inverse Power Law

Lotka observed that the number of authors who publish exactly *n* articles follows an inverse power law:

**f(n) = C / n<sup>β</sup>**

where:

- **f(n)**: the proportion of authors who publish exactly *n* articles
- **C**: a constant (approximately equal to the proportion of authors with one publication)
- **β**: the productivity exponent (slope in log-log space)

In Lotka's original formulation, **β = 2**, meaning that approximately *1/n²* of the authors who publish one paper will publish *n* papers. For example, about 1/4 of authors with one paper will have two papers, about 1/9 will have three papers, and so on.

#### Estimation Method

Biblioshiny estimates the parameters of Lotka's Law using **linear regression in log-log space**:

**log<sub>10</sub>(f) = log<sub>10</sub>(C) − β · log<sub>10</sub>(n)**

This provides the estimated β and C coefficients, along with the R² goodness-of-fit measure. The plot displays three curves:

- **Solid black line**: the empirical distribution observed in the data
- **Dashed red line**: the theoretical Lotka's Law with β = 2
- **Dot-dash blue line**: the fitted model using the estimated β

#### Kolmogorov-Smirnov Goodness-of-Fit Tests

Two Kolmogorov-Smirnov (KS) tests are performed to assess how well the data conform to Lotka's Law:

- **Test 1 – Theoretical (β = 2):** Compares the empirical distribution to the classical Lotka's Law. A p-value ≥ 0.05 indicates the data are consistent with the original formulation.
- **Test 2 – Fitted (empirical β):** Compares the empirical distribution to the fitted model. A p-value ≥ 0.05 indicates the generalized inverse power law provides a good fit, even if β ≠ 2.

#### Interpreting the Results

- **β ≈ 2:** The field follows the classical Lotka's Law. Author productivity is distributed according to the original inverse-square pattern.
- **β > 2:** Productivity is *more concentrated* than predicted by Lotka — the proportion of prolific authors drops off more steeply. This is common in specialized or niche fields.
- **β < 2:** Productivity is *more dispersed* than predicted — there are relatively more prolific authors than expected. This may occur in established, broad fields with sustained research communities.
- **High R²:** The inverse power law model fits well, confirming that the skewed productivity distribution is a robust feature of the field.
- **Low R²:** The data may deviate from a simple power law, possibly due to collaboration patterns, multi-authorship conventions, or data artifacts.

#### References

**Lotka, A. J. (1926).** *The frequency distribution of scientific productivity.* **Journal of the Washington Academy of Sciences**, 16(12), 317–323.

**Pao, M. L. (1985).** *Lotka's law: A testing procedure.* **Information Processing & Management**, 21(4), 305–320. [https://doi.org/10.1016/0306-4573(85)90055-X](https://doi.org/10.1016/0306-4573(85)90055-X)

**Nicholls, P. T. (1986).** *Empirical validation of Lotka's law.* **Information Processing & Management**, 22(5), 417–419. [https://doi.org/10.1016/0306-4573(86)90007-0](https://doi.org/10.1016/0306-4573(86)90007-0)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.
