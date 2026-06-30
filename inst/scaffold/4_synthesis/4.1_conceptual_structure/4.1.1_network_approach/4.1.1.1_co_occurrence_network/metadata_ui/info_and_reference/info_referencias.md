# Info & References — Co-occurrence Network

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `coOccurrenceNetwork`).
> Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Co-occurrence Network · tabName: `coOccurenceNetwork`

## Resumen (español)

- **Qué es:** la Red de Co-ocurrencia mapea la *estructura conceptual* de un campo de investigación; los nodos son términos (palabras clave, palabras del título o del resumen) y las aristas conectan términos que aparecen juntos en un mismo documento.
- **Fundamento:** se basa en el análisis de co-palabras (Callon et al., 1983): términos que co-ocurren con frecuencia están semánticamente relacionados y suelen pertenecer al mismo tema de investigación.
- **Qué revela:** temas de investigación (clústeres densos), puentes interdisciplinares (términos que conectan clústeres) y conceptos centrales (nodos muy conectados).
- **Parámetros clave:** campo de análisis (DE, ID, títulos, resúmenes), algoritmo de layout, normalización (association strength, Jaccard, Inclusion, coseno de Salton, Equivalence), algoritmo de clustering (Louvain, Walktrap…), número de nodos y mínimo de aristas.
- **Interpretación:** el tamaño del nodo refleja la frecuencia del término; el grosor de la arista, la fuerza de co-ocurrencia; el color, la pertenencia a un clúster (tema). La centralidad de intermediación detecta términos puente y la de cercanía, términos centrales; los clústeres aislados pueden ser temas nicho o emergentes.
- **Referencias:** Callon et al. (1983), Aria & Cuccurullo (2017, 2026), Van Eck & Waltman (2010), Cobo et al. (2011).

---

## Info & References (original, en inglés)

### 🔗 Co-occurrence Network

The **Co-occurrence Network** is a powerful tool for mapping the **conceptual structure** of a research field. It builds a network where nodes represent terms (keywords, title words, or abstract terms) and edges connect terms that appear together in the same document. The strength of an edge reflects how frequently two terms co-occur, revealing the thematic relationships within a scientific domain.

#### 🎓 Theoretical Foundations

Co-occurrence analysis is rooted in the idea that terms appearing together in scientific documents are semantically related. When two keywords frequently co-occur across multiple publications, they are likely associated with the same research theme or concept. This principle has been widely used in scientometrics since the pioneering work of **Callon et al. (1983)** on co-word analysis.

The resulting network provides a map of the **knowledge structure** of a field, highlighting:

- **Research themes:** Clusters of densely connected terms represent distinct research topics
- **Interdisciplinary bridges:** Terms connecting different clusters indicate cross-topic relationships
- **Central concepts:** Highly connected nodes represent foundational or widely used concepts

#### ⚙️ Parameters and Options

The analysis can be configured through several parameters:

- **Field:** Choose between Author's Keywords (DE), Keywords Plus (ID), Title words, or Abstract words as the unit of analysis
- **Network layout:** Select from various layout algorithms (e.g., Fruchterman-Reingold, Kamada-Kawai) to optimize the visual representation
- **Normalization:** Apply association strength, Jaccard, Inclusion, Salton's cosine, or Equivalence index to normalize co-occurrence frequencies
- **Clustering algorithm:** Choose between Louvain, Walktrap, or other community detection algorithms to identify thematic groups
- **Number of nodes:** Control how many top terms to include in the network
- **Minimum edges:** Filter weak connections to focus on meaningful associations

#### 🔍 Interpreting Results

- **Node size:** Proportional to the term's frequency (larger nodes = more frequently used terms)
- **Edge thickness:** Proportional to the co-occurrence strength between two terms
- **Node color:** Indicates cluster membership; terms in the same cluster belong to the same thematic group
- **Centrality measures:** Betweenness centrality identifies terms that bridge different clusters, while closeness centrality highlights terms central to the overall network
- **Isolated clusters:** Disconnected groups of terms may represent niche or emerging topics

##### 📚 Key References

**Callon, M., Courtial, J.-P., Turner, W. A., & Bauin, S. (1983).** *From translations to problematic networks: An introduction to co-word analysis.* **Social Science Information**, 22(2), 191-235. [https://doi.org/10.1177/053901883022002003](https://doi.org/10.1177/053901883022002003)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Van Eck, N. J., & Waltman, L. (2010).** *Software survey: VOSviewer, a computer program for bibliometric mapping.* **Scientometrics**, 84(2), 523-538. [https://doi.org/10.1007/s11192-009-0146-3](https://doi.org/10.1007/s11192-009-0146-3)

**Cobo, M. J., Lopez-Herrera, A. G., Herrera-Viedma, E., & Herrera, F. (2011).** *An approach for detecting, quantifying, and visualizing the evolution of a research field.* **Journal of Informetrics**, 5(1), 146-166. [https://doi.org/10.1016/j.joi.2010.10.002](https://doi.org/10.1016/j.joi.2010.10.002)
