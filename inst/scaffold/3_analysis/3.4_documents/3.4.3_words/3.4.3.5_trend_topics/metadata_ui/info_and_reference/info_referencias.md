# Info & References — Trend Topics

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `trendTopics`).
> Ruta de menú: ANALYSIS › Documents › Words › Trend Topics · tabName: `trendTopic`

## Resumen (español)

- **Trend Topics** identifica y visualiza la dinámica temporal de los términos clave de la colección, rastreando la frecuencia de palabras clave a lo largo de los años para mostrar qué temas crecen, maduran o declinan (evolución de los intereses de investigación).
- **Fundamento teórico**: el vocabulario de las publicaciones refleja las prioridades intelectuales de la comunidad; el ascenso/descenso de términos revela cambios de enfoque, nuevos paradigmas y obsolescencia. Complementa la evolución temática centrándose en términos individuales, no en clústeres.
- **Funcionamiento**: extracción de términos (Author's Keywords, Keywords Plus, palabras de título/resumen), agregación temporal de frecuencias por año, selección de los términos más relevantes y visualización en una línea de tiempo.
- **Parámetros**: campo a analizar, número de términos, frecuencia mínima de palabra y número de palabras por año.
- **Interpretación del gráfico**: las barras horizontales representan el rango intercuartílico (Q1–Q3) de la distribución temporal del término; la burbuja se sitúa en el año mediano; su tamaño es proporcional a la frecuencia total. Permite distinguir términos emergentes, en declive y persistentes, así como agrupamientos temporales.
- **Consejos**: combinar con Thematic Evolution, comparar campos (Author's Keywords vs. Keywords Plus) y considerar que un pico puede deberse a eventos externos.

---

## Info & References (original, en inglés)

### 📈 Trend Topics

The **Trend Topics** analysis identifies and visualises the temporal dynamics of key terms within a bibliometric collection. By tracking the frequency of keywords (or other terms) across publication years, this tool reveals which topics are gaining momentum, which have reached maturity, and which are declining, providing a clear picture of the **evolution of research interests** over time.

#### 🎓 Theoretical Foundations

Trend analysis in bibliometrics is based on the observation that the vocabulary used in scientific publications reflects the intellectual priorities of a research community at a given point in time. By monitoring the rise and fall of specific terms across successive years, it is possible to detect shifts in research focus, the emergence of new paradigms, and the obsolescence of older topics.

This approach complements other temporal analyses (such as thematic evolution) by focusing on **individual terms** rather than thematic clusters, offering a more granular view of how specific concepts gain or lose traction within a field.

#### 📈 How It Works

1. **Term extraction:** Keywords or other terms (Author's Keywords, Keywords Plus, title words, etc.) are extracted from each document in the collection
2. **Temporal aggregation:** For each term, the frequency of occurrence is computed for each publication year
3. **Term selection:** The top terms are selected based on their overall frequency or their trend characteristics
4. **Visualisation:** The selected terms are plotted along a timeline, showing for each term the year range in which it appears and its frequency peak

#### ⚙️ Parameters and Options

- **Field:** Choose the bibliographic field to analyze (Author's Keywords, Keywords Plus, Title words, Abstract words, etc.)
- **Number of terms:** Set how many top terms to display in the trend plot
- **Minimum word frequency:** Filter out rare terms that appear below a given threshold
- **Number of words per year:** Control how many terms to display for each year

#### 🔍 Interpreting Results

- **Horizontal bars:** Each bar represents the **interquartile range** (from the first quartile Q1 to the third quartile Q3) of the temporal distribution of a term. This captures the central period of activity, filtering out sporadic early or late occurrences
- **Bubble position:** The bubble is placed at the **median year** of the term's temporal distribution, indicating the central tendency of its usage over time
- **Bubble size:** Proportional to the overall **frequency** of the term across the entire collection; larger bubbles indicate more frequently used terms
- **Rising terms:** Terms whose median year and interquartile range fall in the recent period represent emerging research interests
- **Declining terms:** Terms whose median and IQR are concentrated in earlier years indicate topics losing relevance
- **Persistent terms:** Terms with a wide interquartile range spanning most of the time window represent the stable core of the field
- **Temporal clustering:** Groups of terms with similar median years may indicate the rise of a new research paradigm or the impact of an external event

#### 💡 Tips for Analysis

- **Combine with Thematic Evolution:** Use Trend Topics for a term-level view and Thematic Evolution for a cluster-level perspective to obtain a comprehensive understanding of temporal dynamics
- **Field comparison:** Compare trends across different fields (e.g., Author's Keywords vs. Keywords Plus) to distinguish author-driven terminology from indexer-assigned categories
- **Context matters:** A sudden spike in a keyword may reflect external events (e.g., a pandemic, a policy change) rather than purely intellectual evolution

##### 📚 Key References

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Cobo, M. J., Lopez-Herrera, A. G., Herrera-Viedma, E., & Herrera, F. (2011).** *An approach for detecting, quantifying, and visualizing the evolution of a research field.* **Journal of Informetrics**, 5(1), 146-166. [https://doi.org/10.1016/j.joi.2010.10.002](https://doi.org/10.1016/j.joi.2010.10.002)

**Noyons, E. C. M., Moed, H. F., & van Raan, A. F. J. (1999).** *Integrating research performance analysis and science mapping.* **Scientometrics**, 46(3), 591-604. [https://doi.org/10.1007/BF02459614](https://doi.org/10.1007/BF02459614)
