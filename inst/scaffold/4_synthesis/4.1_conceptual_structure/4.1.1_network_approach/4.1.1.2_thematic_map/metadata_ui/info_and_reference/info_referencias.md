# Info & References — Thematic Map

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `thematicMap`).
> Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Map · tabName: `thematicMap`

## Resumen (español)

- **Qué es:** el Mapa Temático (o Diagrama Estratégico) es una visualización 2D que clasifica los temas de investigación según su *centralidad* (importancia en el campo) y *densidad* (coherencia interna del tema). Propuesto por Callon et al. (1991) y desarrollado por Cobo et al. (2011).
- **Métricas:** la **centralidad** (de Callon) mide la fuerza de los lazos externos entre clústeres (qué tan central es un tema); la **densidad** (de Callon) mide la fuerza de los lazos internos de un clúster (qué tan desarrollado y coherente es).
- **Asignación difusa:** siguiendo a Aria et al. (2025), cada publicación recibe un grado de pertenencia graduado a todos los clústeres (no partición rígida), ponderado por la centralidad *PageRank* de los términos compartidos. Esto permite representación multitemática y una "cardinalidad difusa" (suma de pertenencias) como medida de peso del tema.
- **Cuatro cuadrantes:** Motor (alta centralidad + alta densidad), Básicos/Transversales (alta centralidad + baja densidad), Nicho (baja centralidad + alta densidad) y Emergentes/Declinantes (baja centralidad + baja densidad).
- **Interpretación:** el tamaño de la burbuja refleja la cardinalidad difusa del clúster; su posición, la centralidad (eje x) y densidad (eje y); las etiquetas muestran las palabras clave más representativas.
- **Referencias:** Aria et al. (2025), Callon et al. (1991), Cobo et al. (2011, 2012), Aria & Cuccurullo (2017, 2026).

---

## Info & References (original, en inglés)

### 🗺 Thematic Map

The **Thematic Map** (also known as the **Strategic Diagram**) is a two-dimensional visualization that classifies research themes according to their **centrality** (importance within the field) and **density** (internal coherence of the theme). Originally proposed by **Callon et al. (1991)** and further developed by **Cobo et al. (2011)**, it provides a comprehensive snapshot of the thematic landscape of a scientific domain.

#### 🎓 Theoretical Foundations

The Thematic Map is built from a co-occurrence network of terms. After applying a clustering algorithm (e.g., Louvain or Walktrap) to identify thematic groups, each cluster is characterized by two metrics:

- **Centrality (Callon's centrality):** Measures the strength of external ties between a cluster and other clusters. High centrality indicates that a theme is strongly connected to other themes, making it central to the field.
- **Density (Callon's density):** Measures the strength of internal ties within a cluster. High density indicates that a theme is well-developed and internally coherent.

#### 📋 Fuzzy Publication-to-Cluster Assignment

Following the framework proposed by **Aria et al. (2025)**, publications are not assigned to a single cluster through hard partitioning. Instead, each publication receives a **graded membership degree** across all thematic clusters, reflecting the multithematic nature of scientific documents. The membership score is based on the overlap between a publication's terms and each cluster's vocabulary, weighted by the *PageRank centrality* of shared terms within the cluster. This means that a publication's affiliation with a cluster is stronger when its terms are central (high PageRank) and distinctive (low global frequency) within that cluster's semantic structure. The resulting fuzzy membership is then normalised to produce a distribution over clusters summing to one.

This approach has two key advantages:

- **Multithematic representation:** A publication working at the intersection of two research themes contributes proportionally to both, rather than being forced into a single category
- **Fuzzy cardinality:** The effective size of each theme is computed as the sum of membership degrees (rather than a simple document count), providing a more accurate measure of the substantive weight of each theme

#### 📈 The Four Quadrants

These two dimensions define four quadrants, each with a distinct strategic interpretation:

- **Upper-right (Motor themes):** High centrality + High density. These are well-developed themes that are central to the field. They drive the research agenda and are both internally mature and externally relevant.
- **Lower-right (Basic/Transversal themes):** High centrality + Low density. These themes are important to the field but not yet well-developed. They represent general, transversal topics that cut across many research areas.
- **Upper-left (Niche themes):** Low centrality + High density. These are well-developed but peripheral themes. They represent specialized topics with a strong internal structure but limited connections to the broader field.
- **Lower-left (Emerging/Declining themes):** Low centrality + Low density. These themes are both peripheral and underdeveloped. They may represent either newly emerging topics or themes that are fading from the research landscape.

#### ⚙️ Parameters and Options

- **Field:** Choose the bibliographic field to analyze (Keywords, Title words, Abstract terms, etc.)
- **Number of terms:** Set how many top terms to include in the analysis
- **Minimum cluster frequency:** Filter out small clusters below a given size threshold
- **Clustering algorithm:** Select between Louvain, Walktrap, or other community detection methods
- **Label size:** Adjust the size of theme labels for readability

#### 🔍 Interpreting Results

- **Bubble size:** Proportional to the fuzzy cardinality of the cluster (the sum of publication membership degrees), reflecting the substantive weight of the theme rather than a simple document count
- **Bubble position:** Determined by the centrality (x-axis) and density (y-axis) of the cluster
- **Theme labels:** Show the most representative keywords of each cluster
- **Quadrant analysis:** Focus on the strategic position of each theme to understand the field's structure

##### 📚 Key References

**Aria, M., D'Aniello, L., Misuraca, M., & Spano, M. (2025).** *Rethinking Thematic Evolution in Science Mapping: An Integrated Framework for Longitudinal Analysis.* Working Paper.

**Callon, M., Courtial, J.-P., & Laville, F. (1991).** *Co-word analysis as a tool for describing the network of interactions between basic and technological research: The case of polymer chemistry.* **Scientometrics**, 22(1), 155-205. [https://doi.org/10.1007/BF02019280](https://doi.org/10.1007/BF02019280)

**Cobo, M. J., Lopez-Herrera, A. G., Herrera-Viedma, E., & Herrera, F. (2011).** *An approach for detecting, quantifying, and visualizing the evolution of a research field.* **Journal of Informetrics**, 5(1), 146-166. [https://doi.org/10.1016/j.joi.2010.10.002](https://doi.org/10.1016/j.joi.2010.10.002)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Cobo, M. J., Lopez-Herrera, A. G., Herrera-Viedma, E., & Herrera, F. (2012).** *SciMAT: A new science mapping analysis software tool.* **Journal of the American Society for Information Science and Technology**, 63(8), 1609-1630. [https://doi.org/10.1002/asi.22688](https://doi.org/10.1002/asi.22688)
