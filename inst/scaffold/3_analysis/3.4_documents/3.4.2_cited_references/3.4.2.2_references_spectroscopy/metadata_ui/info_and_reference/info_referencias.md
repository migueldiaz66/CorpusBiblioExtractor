# Info & References — References Spectroscopy (RPYS)

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `rpys`).
> Ruta de menú: ANALYSIS › Documents › Cited References › References Spectroscopy · tabName: `ReferenceSpect`

## Resumen (español)

- **RPYS (Reference Publication Year Spectroscopy)** detecta las *raíces históricas* de campos, temas o investigadores analizando los años de publicación de las referencias citadas (Marx et al., 2014; extendido por Thor et al., 2018).
- El **espectrograma** traza dos curvas: el número de referencias citadas por año de publicación (línea negra; los picos señalan obras seminales) y la desviación respecto a la mediana móvil de 5 años (línea roja), que resalta los picos eliminando la tendencia de fondo. Se etiquetan automáticamente los 10 picos principales.
- La ventana por defecto es la mediana centrada de 5 años (Y−2 a Y+2); también hay una mediana retrospectiva (Y−4 a Y).
- Mediante **Análisis de Frecuencia Configural (CFA)** y residuos estandarizados (z-scores), cada año citante se clasifica como "+" (z > 1), "o" (−1 ≤ z ≤ 1) o "−" (z < −1).
- Se identifican cuatro **tipos de secuencias de citación**: Sleeping Beauty (citada poco al inicio y mucho después), Constant Performer (citada de forma constante en >80% de los años), Hot Paper (muy citada en los primeros años) y Life Cycle (ciclo completo: bajo, alto, bajo).
- Una misma referencia puede pertenecer a más de un tipo; en ese caso se reportan todos los aplicables.

---

## Info & References (original, en inglés)

### Reference Publication Year Spectroscopy (RPYS)

**Reference Publication Year Spectroscopy (RPYS)** is a method for detecting the *historical roots* of research fields, topics, or researchers by analysing the publication years of the cited references in a body of literature. The method was introduced by Marx et al. (2014) and later extended by Thor et al. (2018).

#### The Spectrogram

The RPYS spectrogram plots two curves:

- **Number of Cited References (black line):** The total count of cited references for each reference publication year (RPY). Peaks in this curve indicate years in which an unusually large number of references were published — often pointing to seminal works.
- **Deviation from the 5-Year Median (red line):** The difference between the observed count and the median count over a 5-year window. This smoothed curve highlights peaks more clearly by removing background trends. The default window uses the centred 5-year median (Y−2 to Y+2) as proposed by Marx et al. (2014). An alternative backward 5-year median (Y−4 to Y) is also available.

The **top 10 peaks** of the deviation curve are automatically identified and labelled in the spectrogram. These peaks correspond to the most influential reference publication years.

#### Types of Citation Sequences

Following the methodology of Thor et al. (2018), Biblioshiny applies **Configural Frequency Analysis (CFA)** to classify the citation dynamics of individual cited references over time. For each cited reference, CRExplorer computes standardised residuals (z-scores) that compare the observed citation counts with expected values under a model of independence. Based on the z-scores, each citing year is classified as:

- **"+"** (above average): z > 1
- **"o"** (on average): −1 ≤ z ≤ 1
- **"−"** (below average): z < −1

The resulting sequence of symbols across citing years characterises the citation trajectory of each reference. Four types of sequences are identified:

| Type | Definition |
| --- | --- |
| **Sleeping Beauty** | Publication cited *below average* ("−"; z < −1) in at least **two of the first three** citing years, and *above average* ("+"; z > 1) in at least one of the following citing years. |
| **Constant Performer** | Publication cited in more than **80%** of the citing years at least once. In more than 80% of the citing years it has been cited at least on the average level ("o"; −1 ≤ z ≤ 1) or above ("+"; z > 1). |
| **Hot Paper** | Publication cited *above average* ("+"; z > 1) in at least **two of the first three** citing years after publication. |
| **Life Cycle** | Publication cited in at least **two of the first four** years on the average level ("o") or lower ("−"), in at least **two** of the following years *above average* ("+"; z > 1), and in the **last three** years on the average level ("o") or lower ("−"). |

A single cited reference may belong to more than one type. When this occurs, all applicable types are reported.

#### References

**Marx, W., Bornmann, L., Barth, A., & Leydesdorff, L. (2014).** *Detecting the historical roots of research fields by reference publication year spectroscopy (RPYS).* **Journal of the Association for Information Science and Technology**, 65(4), 751–764. [https://doi.org/10.1002/asi.23089](https://doi.org/10.1002/asi.23089)

**Thor, A., Bornmann, L., Marx, W., & Mutz, R. (2018).** *Identifying single influential publications in a research field: New analysis opportunities of the CRExplorer.* **Scientometrics**, 116, 591–608. [https://doi.org/10.1007/s11192-018-2733-7](https://doi.org/10.1007/s11192-018-2733-7)

**Barth, A., Marx, W., Bornmann, L., & Mutz, R. (2014).** *On the origins and the historical roots of the Higgs boson research from a bibliometric perspective.* **The European Physical Journal Plus**, 129, 111. [https://doi.org/10.1140/epjp/i2014-14111-6](https://doi.org/10.1140/epjp/i2014-14111-6)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.
