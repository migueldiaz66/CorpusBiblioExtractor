# Info & References — Thematic Evolution

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `thematicEvolution`).
> Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Evolution · tabName: `thematicEvolution`

## Resumen (español)

- **Qué es:** la Evolución Temática rastrea cómo los temas de investigación emergen, crecen, se fusionan, se dividen y declinan a lo largo del tiempo, dividiendo la línea temporal en *cortes temporales* y haciendo análisis de co-ocurrencia dentro de cada uno.
- **Marco integrado (Aria et al., 2025):** reconceptualiza la evolución como un proceso totalmente basado en redes, integrando detección temática transversal, afiliación graduada de documentos y enlace inter-temporal en una arquitectura relacional coherente.
- **Tres innovaciones:** (1) asignación difusa publicación-clúster mediante centralidad *PageRank*; (2) fuerza de linaje basada en red, que combina un *índice de inclusión ponderado* (cobertura direccional) y un *índice de importancia* (relevancia estructural mutua); (3) detección automática de linaje con doble umbral (absoluto + top-k).
- **Cómo funciona:** corte temporal → identificación temática por corte → asignación difusa de documentos → cálculo de la matriz de fuerza de linaje → detección automática → mapeo de la evolución como diagrama tipo Sankey.
- **Interpretación:** el tamaño del nodo refleja la cardinalidad difusa; el grosor de la arista, la fuerza de linaje. Patrones: continuación (1-a-1), división (varias aristas salientes), fusión (varias entrantes), temas emergentes (sin entrantes), temas desaparecidos (sin salientes) y trayectorias evolutivas (secuencias dirigidas máximas).
- **Referencias:** Aria et al. (2025), Cobo et al. (2011), Aria & Cuccurullo (2017, 2026), Callon et al. (1991), Morris & Van der Veer Martens (2008).

---

## Info & References (original, en inglés)

### 🕐 Thematic Evolution

The **Thematic Evolution** analysis tracks how research themes emerge, grow, merge, split, and decline over time. By dividing the publication timeline into consecutive **time slices** and performing co-occurrence analysis within each slice, this method reveals the dynamic evolution of a field's conceptual structure. The implementation in bibliometrix adopts the integrated framework proposed by **Aria et al. (2025)**, which reconceptualises thematic evolution as a fully network-based process where cross-sectional thematic detection, graded document affiliation, and inter-temporal linkage are jointly modelled within a coherent relational architecture.

#### 🎓 Theoretical Foundations

This approach extends static thematic mapping into a **longitudinal framework**. It was originally formalised by **Cobo et al. (2011)**, who introduced overlap-based similarity measures to identify continuities, splits, and mergers between themes across consecutive periods. **Aria et al. (2025)** further developed the methodology by addressing a key structural asymmetry in existing approaches: while cross-sectional theme detection is explicitly relational (based on weighted co-occurrence networks), lineage construction was traditionally reduced to set-theoretic comparisons of term lists, discarding the relational structure that defines a theme's semantic core.

The integrated framework resolves this asymmetry through three key innovations:

- **Fuzzy publication-to-cluster assignment:** Instead of hard partitioning, each publication receives a graded membership degree across all thematic clusters, computed using *PageRank centrality* of shared terms. This captures the multithematic nature of publications, particularly relevant in interdisciplinary research.
- **Network-based lineage strength:** Inter-temporal connections are quantified through a *lineage strength* measure that integrates two complementary dimensions: a *weighted inclusion index* (directional coverage weighted by PageRank centrality) and an *importance index* (mutual structural relevance of shared terms). This ensures that lineage reflects the preservation of structural relations, not merely lexical overlap.
- **Automatic lineage detection:** Significant evolutionary connections are identified through a dual-thresholding approach combining absolute and relative (top-k) criteria, preventing the loss of important evolutionary paths while filtering noise.

#### 📈 How It Works

1. **Time slicing:** The publication period is divided into consecutive time windows (e.g., 2000-2005, 2006-2010, 2011-2015)
2. **Thematic identification:** Within each slice, a co-occurrence matrix is built and normalised using association strength. Community detection is applied to identify thematic clusters, characterised by centrality and density measures
3. **Fuzzy document assignment:** Each publication is assigned graded membership degrees to all clusters, based on the PageRank centrality of the terms it shares with each cluster
4. **Lineage computation:** For each pair of consecutive periods, a lineage strength matrix is computed combining weighted inclusion (directional coverage) and importance (mutual structural relevance) of shared terms
5. **Automatic lineage detection:** Significant evolutionary connections are identified using dual thresholding (absolute strength + top-k per source cluster)
6. **Evolution mapping:** The result is a temporally ordered directed graph visualised as a Sankey-like flow diagram, where edge thickness reflects lineage strength

#### ⚙️ Parameters and Options

- **Field:** Choose the bibliographic field (Keywords, Title words, etc.)
- **Time slices:** Define the number and boundaries of time periods for the analysis
- **Number of terms:** Set how many top terms to include per time slice
- **Minimum cluster frequency:** Filter out small or insignificant clusters
- **Clustering algorithm:** Select the community detection method (Louvain, Walktrap, etc.)

#### 🔍 Interpreting Results

- **Node size:** Proportional to the fuzzy cardinality of the cluster (cumulative partial memberships), reflecting the substantive weight of the theme
- **Edge thickness:** Proportional to the lineage strength between themes across consecutive time slices, capturing both the extent of term overlap and the centrality of shared content
- **Continuation:** A one-to-one link (single incoming and single outgoing edge) indicates a stable thematic trajectory across consecutive periods
- **Splitting themes:** A theme with multiple outgoing edges suggests differentiation or thematic specialisation
- **Merging themes:** A theme with multiple incoming edges indicates thematic consolidation
- **Emerging themes:** Clusters with no incoming edges represent newly appearing topics
- **Disappearing themes:** Clusters with no outgoing edges represent themes that are fading from the research landscape
- **Evolutionary pathways:** Maximal directed sequences through the evolution graph represent coherent thematic trajectories spanning multiple periods, characterised by pathway strength, length, and cumulative size

##### 📚 Key References

**Aria, M., D'Aniello, L., Misuraca, M., & Spano, M. (2025).** *Rethinking Thematic Evolution in Science Mapping: An Integrated Framework for Longitudinal Analysis.* Working Paper.

**Cobo, M. J., Lopez-Herrera, A. G., Herrera-Viedma, E., & Herrera, F. (2011).** *An approach for detecting, quantifying, and visualizing the evolution of a research field.* **Journal of Informetrics**, 5(1), 146-166. [https://doi.org/10.1016/j.joi.2010.10.002](https://doi.org/10.1016/j.joi.2010.10.002)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Callon, M., Courtial, J.-P., & Laville, F. (1991).** *Co-word analysis as a tool for describing the network of interactions between basic and technological research: The case of polymer chemistry.* **Scientometrics**, 22(1), 155-205. [https://doi.org/10.1007/BF02019280](https://doi.org/10.1007/BF02019280)

**Morris, S. A., & Van der Veer Martens, B. (2008).** *The cognitive structure of scientific revolutions.* **Scientometrics**, 75(3), 423-442. [https://doi.org/10.1007/s11192-007-1804-x](https://doi.org/10.1007/s11192-007-1804-x)
