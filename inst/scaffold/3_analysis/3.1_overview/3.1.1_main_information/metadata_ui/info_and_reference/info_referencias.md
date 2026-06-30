# Info & References — Main Information

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `mainInformation`).
> Ruta de menú: ANALYSIS › Overview › Main Information · tabName: `mainInfo`

## Resumen (español)

- Sección de "Información principal": panel resumen con 12 métricas clave que dan una visión rápida del alcance, composición y características de la colección bibliográfica.
- Es el punto de partida ideal para entender el dataset antes de análisis más detallados (tamaño, cobertura temporal, nivel de colaboración e impacto).
- Métricas de alcance temporal y volumen: Timespan (rango de años), Sources (revistas/venues distintos), Documents (registros), Annual Growth Rate (tasa de crecimiento anual compuesta, CAGR) y References (referencias citadas totales).
- Métricas de autoría y colaboración: Authors (autores únicos), Authors of Single-Authored Docs (autores con trabajos de un solo autor), International Co-Authorship (% de docs con autores de varios países) y Co-Authors per Document (promedio de autores por documento).
- Métricas temáticas y de impacto: Author's Keywords (DE) (palabras clave únicas de autor), Document Average Age (antigüedad media de los documentos) y Average Citations per Document (citas promedio por documento).
- Interpretación: más fuentes sugiere campo multidisciplinar/disperso; mayor colaboración e internacionalidad suele asociarse a más impacto; las citas dependen de antigüedad, disciplina y base de datos.
- Ofrece tres vistas (Plot, Table, Biblio AI) e incluye buenas prácticas y advertencias: sesgo de base de datos, retraso de citas, metadatos incompletos y sensibilidad de la tasa de crecimiento.

---

## Info & References (original, en inglés)

### 📊 Main Information: Overview of Your Bibliometric Collection

The **Main Information** page provides a comprehensive, at-a-glance summary of the key bibliometric indicators for your collection. This dashboard-style interface displays **12 core metrics** organized into visual cards, allowing you to quickly assess the scope, composition, and characteristics of your dataset.

This section is the ideal starting point for understanding your collection before diving into more detailed analyses. It answers fundamental questions such as: *How large is my dataset? What is the temporal coverage? How collaborative is the research? How impactful are the documents?*

#### 📈 Core Metrics Explained

The Main Information dashboard displays the following indicators:

#### 1. Timespan

- **Definition:** The temporal range covered by the collection, from the earliest to the most recent publication year.
- **Example:** `1985-2020` indicates documents published between 1985 and 2020.
- **Interpretation:** A wider timespan enables longitudinal trend analysis and historical perspectives. Collections spanning decades are suitable for studying research evolution and paradigm shifts.

#### 2. Sources

- **Definition:** The total number of distinct publication venues (journals, conferences, books) represented in the collection.
- **Interpretation:** A higher number of sources suggests a *multidisciplinary* or *dispersed research field*, while a lower number indicates concentration in a few core journals. This metric is useful for identifying dominant publication venues via Bradford's Law analysis.

#### 3. Documents

- **Definition:** The total number of bibliographic records (articles, reviews, proceedings, etc.) in the collection.
- **Interpretation:** This is the fundamental sample size for all subsequent analyses. Larger collections (>1,000 documents) provide more robust insights, especially for network and clustering analyses.

#### 4. Annual Growth Rate

- **Definition:** The average percentage increase in the number of publications per year over the collection's timespan.
- **Formula:** Compound Annual Growth Rate (CAGR) calculated as: `[(N_final / N_initial)^(1/years) - 1] × 100`
- **Interpretation:** A positive growth rate indicates an *expanding research field*, while negative or near-zero values suggest maturity or decline. High growth rates (>10%) often signal **emerging topics** attracting increasing scholarly attention.

#### 5. Authors

- **Definition:** The total number of unique authors who contributed to the documents in the collection.
- **Interpretation:** This metric reflects the size of the research community. A high author-to-document ratio suggests *collaborative research*, while a low ratio may indicate a field dominated by a few prolific researchers.

#### 6. Authors of Single-Authored Docs

- **Definition:** The number of authors who published at least one single-authored document in the collection.
- **Interpretation:** Single-authored papers are more common in humanities and theoretical disciplines. A low proportion suggests *high collaboration intensity*, typical of experimental sciences and interdisciplinary fields.

#### 7. International Co-Authorship

- **Definition:** The percentage of documents authored by researchers from multiple countries.
- **Interpretation:** High international collaboration (>30%) indicates *global research networks* and is often associated with higher citation impact. This metric is a proxy for research globalization and cross-border knowledge exchange.

#### 8. Co-Authors per Document

- **Definition:** The average number of authors per document in the collection.
- **Interpretation:** Values typically range from 2 (social sciences, humanities) to 5+ (biomedical sciences, physics). Increasing values over time reflect the trend toward **team science** and large-scale collaborative projects.

#### 9. Author's Keywords (DE)

- **Definition:** The total number of unique keywords provided by authors (`DE` = *Descriptors*) across all documents.
- **Interpretation:** A rich keyword set (>1,000 unique terms) enables robust thematic analysis and topic modeling. The diversity of keywords reflects the *conceptual breadth* of the research field.

#### 10. References

- **Definition:** The total number of cited references listed in the bibliographies of all documents in the collection.
- **Interpretation:** This metric is essential for citation-based analyses (co-citation, bibliographic coupling, reference publication year spectroscopy). Larger reference pools enable more comprehensive intellectual structure mapping.

#### 11. Document Average Age

- **Definition:** The average number of years elapsed since publication, calculated relative to the current year.
- **Formula:** `Current Year - Mean(Publication Years)`
- **Interpretation:** Lower values (<5 years) indicate a focus on *recent research*, while higher values suggest inclusion of foundational or historical literature. This metric helps assess whether the collection is **contemporary** or **retrospective**.

#### 12. Average Citations per Document

- **Definition:** The mean number of citations received by documents in the collection (based on database citation counts).
- **Interpretation:** Higher values indicate *high-impact research*. Average citation rates vary widely by discipline (e.g., biomedical sciences >20, social sciences ~10). This metric is influenced by document age, field norms, and database coverage.

#### 🧠 Biblio AI Integration

If **Biblio AI** is enabled, you can click the **Biblio AI** tab to receive an *automated narrative summary* of these indicators. The AI-generated text provides contextualized interpretations, highlights notable patterns, and offers insights suitable for inclusion in research reports or presentations.

**Example AI-generated insights:**

- 'The collection exhibits a strong annual growth rate of 14.05%, suggesting an emerging and rapidly expanding research domain.'
- 'With 36.41% international co-authorship, the field demonstrates moderate global collaboration, indicating opportunities for further cross-border partnerships.'
- 'The average of 37.12 citations per document reflects high scholarly impact, placing this collection above typical citation rates for the social sciences.'

#### 📋 Viewing Options

The Main Information page offers three viewing modes via tabs at the top:

- **Plot:** Visual card-based dashboard (default view) with color-coded metrics
- **Table:** Tabular representation of all indicators for easy export to reports
- **Biblio AI:** AI-generated narrative summary and interpretation (requires Gemini API key)

#### 💡 How to Use Main Information

This section is designed for multiple purposes:

- **Initial Data Assessment:** Quickly validate that your collection has been imported correctly and contains the expected number of documents and metadata fields.
- **Research Reporting:** Extract summary statistics for the 'Methods' or 'Data' section of a systematic review or bibliometric study.
- **Comparative Analysis:** Compare indicators across different datasets (e.g., two time periods, competing research streams) to identify differences in growth, collaboration, or impact.
- **Presentation Material:** Export the dashboard or AI-generated text for use in slides, posters, or grant proposals.

#### 📌 Best Practices

- **Always review Main Information first** before proceeding to advanced analyses—it helps identify potential data quality issues (e.g., missing years, incomplete author data).
- **Compare with field benchmarks:** Contextualize your indicators by comparing them with known norms for your discipline (e.g., citation rates, collaboration patterns).
- **Document your collection:** Use the 'Brief Description' text box (visible in the Import/Load section) to record search queries, inclusion criteria, and data sources for reproducibility.
- **Export summary statistics:** Save the table view as a reference for your research documentation or supplementary materials.

#### ⚠️ Important Considerations

- **Database Bias:** Indicators reflect the coverage and indexing policies of the source database(s). Web of Science and Scopus have different journal lists, which affects metrics like citation counts and international co-authorship.
- **Citation Lag:** Recent documents (<2 years old) typically have lower citation counts due to insufficient time for accumulation. Average citations per document may be biased downward if your collection includes many recent papers.
- **Incomplete Metadata:** Some databases (e.g., PubMed, Dimensions) provide limited metadata, which may result in missing or incomplete values for certain indicators (e.g., author affiliations for international co-authorship calculation).
- **Growth Rate Sensitivity:** Annual growth rate calculations are sensitive to the start and end years of the collection. Unusual spikes or drops in specific years can distort the overall trend.

#### 🔍 Next Steps

After reviewing the Main Information dashboard, proceed to more detailed analyses:

- **Filters:** Refine your collection by applying metadata filters (e.g., document type, time range, subject category)
- **Sources:** Identify the most productive journals and analyze publication patterns
- **Authors:** Examine author productivity, collaboration networks, and impact metrics
- **Conceptual Structure:** Explore thematic evolution and topic clustering via keyword co-occurrence and thematic maps
- **Intellectual Structure:** Investigate citation networks through co-citation analysis and historiography

#### 📚 References

**Aria, M., & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Zupic, I., & Čater, T. (2015).** *Bibliometric methods in management and organization.* **Organizational Research Methods**, 18(3), 429–472. [https://doi.org/10.1177/1094428114562629](https://doi.org/10.1177/1094428114562629)
