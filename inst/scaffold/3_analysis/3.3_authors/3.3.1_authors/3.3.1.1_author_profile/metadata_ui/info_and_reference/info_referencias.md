# Info & References — Author Profile

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `authorProfile`).
> Ruta de menú: ANALYSIS › Authors › Author Profile · tabName: `AuthorPage`

## Resumen (español)

- La sección **Author Profile** ofrece una visión bibliométrica de doble perspectiva (global y local) para cada autor de la colección.
- **Perfil Global**: producción científica completa del autor según OpenAlex (vía el paquete `openalexR`), incluyendo todas sus publicaciones aunque no estén en la colección. Métricas: total de publicaciones y citas, H-Index, i10-Index, tasa media de citación a 2 años, tendencias de publicación de los últimos 10 años y principales temas de investigación. Identificador único: OpenAlex Author ID.
- **Perfil Local**: se limita al subconjunto de publicaciones del autor incluidas en la colección bajo análisis. Métricas: número de publicaciones, citas totales, H-Index local, citas promedio por trabajo, actividad reciente (últimos 5 años), tendencias locales, palabras clave principales y listado de publicaciones con metadatos completos.
- **Interpretación**: el Perfil Global mide la influencia académica externa general del autor; el Perfil Local destaca su relevancia específica dentro del estudio actual.
- Utilidad: identificar investigadores influyentes en el área, comparar impacto local vs. global y evaluar la alineación temática de los autores con el foco de la colección.
- Fuente de datos: API de OpenAlex. Referencias clave: Priem et al. (2022), Aria et al. (2024), Hirsch (2005, índice H).

---

## Info & References (original, en inglés)

### 👤 Author Profile Overview

The Author Profile page provides a **dual-perspective bibliometric overview** of each author included in the collection:

#### 🔹 Global Profile

The **Global Profile** presents the author's complete scientific output, based on metadata retrieved from [OpenAlex](https://openalex.org) via the `openalexR` R package. This profile includes *all publications authored by the researcher*, regardless of whether they are part of the current collection.

**Main features of the Global Profile include:**

- Total Publications and Citations
- H-Index and i10-Index
- 2-Year Mean Citation Rate
- Publication Trends over the last 10 years
- Main Research Topics extracted from OpenAlex concepts

**Data Source:** OpenAlex API (via `openalexR`)
**Unique Identifier:** OpenAlex Author ID (e.g., `A5014455237`)

#### 🔸 Local Profile

The **Local Profile** focuses exclusively on the subset of the author's publications that are included in the *user-defined collection* currently under analysis in the project.

**Main features of the Local Profile include:**

- Number of Publications, Total Citations, and Local H-Index
- Average Citations per Work
- Recent Activity: Number of publications in the last 5 years
- Publication Trends (based only on local data)
- Main Keywords derived from the local collection
- List of Publications with full metadata (title, year, journal, DOI, citations)

This local profile helps contextualize the author's role and impact **within the specific research topic or dataset** under investigation.

#### 🔄 Interpretation and Use

The **Global Profile** offers a broad, external view of the author's overall scholarly influence, while the **Local Profile** highlights their specific relevance *within the current study*.

This dual visualization is particularly useful for:

- Identifying influential researchers in the topic area
- Comparing local vs. global impact
- Evaluating thematic alignment of authors with the collection's focus

#### 📚 References

**Priem, J. et al. (2022).** *OpenAlex: A fully-open index of scholarly works, authors, venues, institutions, and concepts.* Retrieved from [https://openalex.org](https://openalex.org)

**Aria, M., Le, T., Cuccurullo, C., Belfiore, A., & Choe, J. (2024).** *openalexR: An R-Tool for Collecting Bibliometric Data from OpenAlex.* **R Journal**, 15(4), 167–180. [https://doi.org/10.32614/RJ-2023-089](https://doi.org/10.32614/RJ-2023-089)

**Aria, M. et al. (2023).** *openalexR: An R package for programmatic access to OpenAlex metadata.* **CRAN**. Retrieved from [https://cran.r-project.org/package=openalexR](https://cran.r-project.org/package=openalexR)

**Hirsch, J.E. (2005).** *An index to quantify an individual's scientific research output.* **Proceedings of the National Academy of Sciences**, 102(46), 16569–16572. [https://doi.org/10.1073/pnas.0507655102](https://doi.org/10.1073/pnas.0507655102)
