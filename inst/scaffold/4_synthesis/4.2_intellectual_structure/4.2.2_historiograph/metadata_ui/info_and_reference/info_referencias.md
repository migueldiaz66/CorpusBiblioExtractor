# Info & References — Historiograph

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `historiograph`).
> Ruta de menú: SYNTHESIS › Intellectual Structure › Historiograph · tabName: `historiograph`

## Resumen (español)

- **Qué es:** El Historiógrafo (o mapa historiográfico) es una visualización cronológica de la evolución de un campo basada en relaciones de *citación directa* (Garfield, 2004; Garfield, Pudovkin e Istomin, 2003).
- **Fundamento:** a diferencia de la co-citación (relaciones indirectas), usa citas directas para trazar el desarrollo intelectual; la cadena de citas desde un trabajo fundacional revela la evolución de ideas y métodos en el tiempo.
- **Cómo funciona:** identifica citas locales dentro de la colección, construye una red dirigida de citación, ordena los documentos por año (eje x) e identifica las rutas principales de citación.
- **Parámetros:** número de nodos, mínimo de citas (locales) y layout de la red.
- **Cómo se interpreta:** la posición en x es el año de publicación; el tamaño del nodo es proporcional a las citas locales; las aristas dirigidas (flechas) van del documento citante al citado; seguir las flechas traza el linaje intelectual y los nodos hub son artículos hito.
- **Referencias clave:** Garfield (2004), Garfield, Pudovkin e Istomin (2003), Aria & Cuccurullo (2017, 2026) y Lucio-Arias & Leydesdorff (2008).

---

## Info & References (original, en inglés)

### 📚 Historiograph

The **Historiograph** (or **Historiographic Map**) is a chronological visualization of a research field's evolution based on **direct citation relationships**. Introduced by **Garfield (2004)** and further developed by **Garfield, Pudovkin, and Istomin (2003)**, this method constructs a time-based network where documents are positioned along a timeline and connected by citation links, identifying the most influential works and the intellectual pathways of a field.

#### 🎓 Theoretical Foundations

Unlike co-citation analysis, which measures indirect relationships, the historiograph uses **direct citations** to map the intellectual development of a field. The underlying idea is that the citation chain from a foundational paper through successive works traces the evolution of ideas and methodologies over time.

Key principles:

- **Direct citation:** A link exists from document A to document B if A cites B (or B cites A)
- **Chronological ordering:** Documents are positioned along the x-axis by publication year, creating a temporal map
- **Milestone identification:** Highly cited documents at key temporal junctions represent turning points in the field's evolution

#### 📈 How It Works

1. **Local citation analysis:** The algorithm identifies citation links among the documents in your collection
2. **Network construction:** A directed citation network is built where edges represent citation relationships
3. **Chronological layout:** Documents are arranged on a timeline based on their publication year
4. **Path identification:** The main citation paths through the network reveal the intellectual evolution of the field

#### ⚙️ Parameters and Options

- **Number of nodes:** Control how many top documents (by local citations) to include in the historiograph
- **Minimum citations:** Filter documents based on their local citation count
- **Network layout:** Choose the layout algorithm for positioning nodes

#### 🔎 Interpreting Results

- **Node position (x-axis):** Publication year of the document
- **Node size:** Proportional to the number of local citations received
- **Directed edges:** Arrows indicate the direction of citation (from citing to cited document)
- **Citation paths:** Following the arrows traces the intellectual lineage from foundational works to recent developments
- **Hub documents:** Nodes with many incoming or outgoing edges represent milestone papers that either built on many predecessors or inspired many successors
- **Temporal gaps:** Large horizontal gaps between connected nodes may indicate paradigm shifts or periods of dormancy

##### 📚 Key References

**Garfield, E. (2004).** *Historiographic mapping of knowledge domains literature.* **Journal of Information Science**, 30(2), 119-145. [https://doi.org/10.1177/0165551504042802](https://doi.org/10.1177/0165551504042802)

**Garfield, E., Pudovkin, A. I., & Istomin, V. S. (2003).** *Why do we need algorithmic historiography?* **Journal of the American Society for Information Science and Technology**, 54(5), 400-412. [https://doi.org/10.1002/asi.10226](https://doi.org/10.1002/asi.10226)

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Lucio-Arias, D., & Leydesdorff, L. (2008).** *Main-path analysis and path-dependent transitions in HistCite-based historiograms.* **Journal of the American Society for Information Science and Technology**, 59(12), 1948-1962. [https://doi.org/10.1002/asi.20903](https://doi.org/10.1002/asi.20903)
