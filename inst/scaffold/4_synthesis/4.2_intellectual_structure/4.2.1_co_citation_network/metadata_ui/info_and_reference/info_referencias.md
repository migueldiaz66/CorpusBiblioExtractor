# Info & References — Co-citation Network

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `coCitationNetwork`).
> Ruta de menú: SYNTHESIS › Intellectual Structure › Co-citation Network · tabName: `coCitationNetwork`

## Resumen (español)

- **Qué es:** La Red de Co-citación mapea la *estructura intelectual* de un campo analizando cómo los documentos citan las mismas referencias; dos referencias están co-citadas cuando un mismo documento las cita juntas (técnica de Small, 1973).
- **Dos enfoques complementarios:** *co-citación* (Small, 1973) identifica la **base de conocimiento** del campo, y *acoplamiento bibliográfico* (Kessler, 1963) identifica los **frentes de investigación** actuales a partir del solapamiento de listas de referencias.
- **Estructura de la red:** los **nodos** son referencias citadas (o documentos citantes), las **aristas** miden la fuerza de co-citación/acoplamiento, y los **clústeres** representan escuelas de pensamiento o tradiciones de investigación.
- **Parámetros principales:** tipo de análisis, layout de la red, método de normalización (association strength, Jaccard, coseno de Salton), algoritmo de clustering (Louvain, Walktrap) y número de nodos.
- **Cómo se interpreta:** el tamaño del nodo es proporcional a las citas/referencias; el grosor de la arista a la fuerza del vínculo; los nodos centrales son obras fundacionales y los nodos puente conectan clústeres (trabajos interdisciplinarios o integradores).
- **Referencias clave:** Small (1973, 1999), Kessler (1963) y Aria & Cuccurullo (2017, 2026).

---

## Info & References (original, en inglés)

### 📑 Co-Citation Network

The **Co-Citation Network** maps the **intellectual structure** of a research field by analyzing patterns in how documents cite the same references. Two references are **co-cited** when they are both cited by the same document. The more frequently two references are co-cited, the stronger their intellectual relationship. This technique, introduced by **Small (1973)**, is one of the foundational methods of bibliometric analysis.

#### 🎓 Theoretical Foundations

Co-citation analysis rests on two complementary approaches:

- **Co-citation (Small, 1973):** Measures how often two references are cited together by subsequent publications. Highly co-cited references are perceived as intellectually related by the citing community. This method identifies the **knowledge base** of a field.
- **Bibliographic coupling (Kessler, 1963):** Measures the overlap in the reference lists of two documents. Documents that share many cited references are likely working on similar topics. This method identifies current **research fronts**.

Both approaches build networks where:

- **Nodes** represent cited references (co-citation) or citing documents (bibliographic coupling)
- **Edges** represent the strength of co-citation or bibliographic coupling between two nodes
- **Clusters** represent distinct schools of thought, theoretical frameworks, or research traditions

#### ⚙️ Parameters and Options

- **Analysis type:** Choose between co-citation analysis or bibliographic coupling
- **Network layout:** Select the layout algorithm for network visualization
- **Normalization:** Apply association strength, Jaccard, Salton's cosine, or other normalization methods
- **Clustering algorithm:** Choose community detection method (Louvain, Walktrap, etc.)
- **Number of nodes:** Control how many top references or documents to include

#### 🔎 Interpreting Results

- **Node size:** Proportional to citation frequency (co-citation) or number of references (coupling)
- **Edge thickness:** Proportional to the co-citation or coupling strength
- **Clusters:** Groups of co-cited references represent distinct intellectual traditions or theoretical perspectives
- **Central nodes:** Highly connected references represent foundational works that are widely cited across the field
- **Bridge nodes:** References connecting different clusters represent interdisciplinary or integrative works

##### 📚 Key References

**Small, H. (1973).** *Co-citation in the scientific literature: A new measure of the relationship between two documents.* **Journal of the American Society for Information Science**, 24(4), 265-269. [https://doi.org/10.1002/asi.4630240406](https://doi.org/10.1002/asi.4630240406)

**Kessler, M. M. (1963).** *Bibliographic coupling between scientific papers.* **American Documentation**, 14(1), 10-25. [https://doi.org/10.1002/asi.5090140103](https://doi.org/10.1002/asi.5090140103)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Small, H. (1999).** *Visualizing science by citation mapping.* **Journal of the American Society for Information Science**, 50(9), 799-813. [DOI link](https://doi.org/10.1002/(SICI)1097-4571(1999)50:9<799::AID-ASI9>3.0.CO;2-G)
