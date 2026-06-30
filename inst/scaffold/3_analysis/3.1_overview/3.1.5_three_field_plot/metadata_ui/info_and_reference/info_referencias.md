# Info & References — Three-Field Plot

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `threeFieldPlot`).
> Ruta de menú: ANALYSIS › Overview › Three-Field Plot · tabName: `threeFieldPlot`

## Resumen (español)

- "Gráfico de tres campos": visualización tipo diagrama de Sankey que muestra las relaciones entre tres dimensiones bibliográficas distintas (p. ej. referencias, autores y palabras clave).
- Estructura: tres columnas verticales (campo izquierdo, medio y derecho); el ancho de cada flujo es proporcional a la frecuencia de co-ocurrencia (flujos más gruesos = asociaciones más fuertes).
- Configuración (panel Options): se eligen los campos izquierdo, medio y derecho entre los metadatos disponibles, y el número de ítems (top N) a mostrar por campo (típicamente 10-30).
- Combinaciones útiles: References→Authors→Keywords, Sources→Authors→Countries, Keywords→Authors→Cited References, entre otras, para mapear fundamentos intelectuales, distribución geográfica o evolución temporal.
- Interpretación: el grosor del flujo indica fuerza de asociación; nodos con muchas conexiones son centrales; flujos finos pueden ser nichos; el color ayuda a rastrear elementos del campo izquierdo.
- Buenas prácticas: empezar con pocos ítems para evitar saturación visual, ordenar campos en secuencia lógica, explorar de forma interactiva y combinar con análisis de redes.
- Limitaciones: muestra patrones agregados (oculta detalle por documento), solo top-N (oculta conexiones raras), no implica dirección causal y se complica con demasiados ítems. Incluye integración con Biblio AI para interpretaciones automáticas.

---

## Info & References (original, en inglés)

### 🔀 Three-Field Plot

The **Three-Field Plot** is an advanced visualization tool that reveals the relationships among three distinct bibliographic dimensions through an interactive **Sankey diagram**. This plot enables researchers to explore the complex connections between different metadata fields, making it particularly useful for understanding how research topics, authors, sources, and references are interconnected within a scientific domain.

#### 🎯 Purpose and Application

The Three-Field Plot serves multiple analytical purposes:

- **Relationship Mapping:** Visualizes how elements from three different bibliographic fields are associated with each other
- **Knowledge Flow:** Tracks the flow of ideas and citations across different dimensions (e.g., from cited references through authors to keywords)
- **Thematic Connections:** Identifies which keywords or topics are most strongly associated with specific authors or sources
- **Author-Topic Associations:** Shows which authors are working on which topics and citing which foundational works

#### 📊 How It Works

The visualization consists of three vertical columns representing different bibliographic fields:

- **Left Field:** Typically represents sources (cited references, journals) or temporal information
- **Middle Field:** Usually displays authors or intermediary elements that connect the other two fields
- **Right Field:** Often shows keywords, topics, or other thematic elements

The width of each flow (colored band) is proportional to the frequency of co-occurrence between elements. Thicker flows indicate stronger associations, while thinner ones represent weaker connections.

#### ⚙️ Configuration Options

The **Options** panel allows you to customize the plot:

- **Left Field:** Select from available metadata fields (e.g., Cited References, Sources, Authors' Countries)
- **Middle Field:** Choose the central connecting field (e.g., Authors, Sources, Keywords)
- **Right Field:** Define the destination field (e.g., Author's Keywords, Keywords Plus, Subject Categories)
- **Number of Items:** Control how many top elements to display for each field (typically 10-30 items per field)

#### 💡 Common Field Combinations

Some particularly insightful field combinations include:

- **References → Authors → Keywords:** Shows which foundational works are cited by which authors working on which topics
- **Sources → Authors → Countries:** Maps the geographical distribution of authors publishing in specific journals
- **Keywords → Authors → Cited References:** Reveals the intellectual foundations of different research themes
- **Authors' Countries → Authors → Keywords:** Identifies national research specializations and thematic focuses
- **Publication Year → Authors → Keywords:** Tracks temporal evolution of author productivity and topic emergence

#### 🔍 Interpretation Guidelines

- **Flow Thickness:** A thick flow between two elements indicates a strong association (high co-occurrence frequency)
- **Multiple Connections:** Elements with many outgoing or incoming flows are central nodes in the network
- **Isolated Flows:** Thin, isolated connections may represent niche specializations or emerging topics
- **Color Coding:** Colors help distinguish different elements in the left field, making it easier to trace specific flows
- **Cross-field Patterns:** Look for patterns where multiple elements from one field connect to the same element in another field, indicating convergence or interdisciplinarity

#### 📌 Best Practices

- **Start Simple:** Begin with a small number of items (10-15 per field) to avoid visual clutter, then increase if needed
- **Logical Sequences:** Arrange fields in a logical flow (e.g., past → present, source → output, context → content)
- **Interactive Exploration:** Hover over flows and nodes to see exact frequencies and connections
- **Export Results:** Use the plot in presentations to illustrate complex relationships in an accessible way
- **Combine with Networks:** Use Three-Field Plots alongside network analyses for complementary perspectives on your data
- **Context Matters:** Always interpret the plot in the context of your research question and domain knowledge

#### ⚠️ Limitations

- **Aggregation Effects:** The plot shows aggregate patterns and may obscure individual document-level details
- **Top-N Selection:** Only the most frequent items are displayed; rare but potentially important connections may be hidden
- **Direction Ambiguity:** While flows suggest relationships, they don't always imply causal or temporal direction
- **Visual Complexity:** With too many items, the plot can become difficult to interpret; reduce the number of items if necessary

#### 🤖 Biblio AI Integration

When **Biblio AI** is enabled, you can generate automatic interpretations of the Three-Field Plot. The AI will:

- Identify the most important flows and connections
- Highlight dominant patterns and relationships
- Provide narrative explanations suitable for research reports and presentations
- Suggest potential interpretations based on the observed patterns

#### 📚 Key References

**Aria, M., & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Chen, C. (2017).** *Science Mapping: A Systematic Review of the Literature.* **Journal of Data and Information Science**, 2(2), 1–40. [https://doi.org/10.1515/jdis-2017-0006](https://doi.org/10.1515/jdis-2017-0006)
