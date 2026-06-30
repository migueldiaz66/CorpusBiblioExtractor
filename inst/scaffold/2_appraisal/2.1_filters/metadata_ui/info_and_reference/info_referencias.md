# Info & References — Filters

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `filters`).
> Ruta de menú: APPRAISAL › Filters · tabName: `filters`

## Resumen (español)

- **Qué es:** El módulo Filtros permite refinar y crear subconjuntos de la colección bibliográfica según múltiples criterios de metadatos (tipo de documento, periodo, región, revista, umbrales de citación) para análisis más específicos.
- **Resumen en tiempo real:** en la parte superior se muestran de forma dinámica los Documentos, Fuentes y Autores que quedan tras aplicar los filtros, ayudando a valorar su impacto antes de confirmarlos.
- **Cuatro paneles temáticos:** (1) **General** (tipo de documento, idioma, año de publicación); (2) **Revista (J)** (lista de revistas, ranking/cuartiles, zonas de la Ley de Bradford); (3) **País del autor (AU)** (región y país); (4) **Documentos (DOC)** (total de citas y citas por año, con histogramas interactivos).
- **Definiciones útiles:** Ley de Bradford divide las fuentes en zonas Core/Zona 2/Zona 3 (cada una ~1/3 de la producción); citas por año = Total de citas / (Año actual − Año de publicación), que normaliza por antigüedad para comparar de forma justa.
- **Flujo de trabajo:** revisar la colección inicial → seleccionar criterios → monitorear el resumen → **Apply** → verificar → analizar → **Reset** para restaurar.
- **Buenas prácticas y avisos:** evitar el sobre-filtrado (apuntar a 200-300+ documentos), documentar los filtros, recordar que se aplican simultáneamente (independiente del orden) y que las zonas de Bradford se recalculan según la colección actual; la disponibilidad de citas y afiliaciones depende de la base de datos.
- **Referencias clave:** Bradford (1934), Aria & Cuccurullo (2017, 2026) y Garfield (2009).

---

## Info & References (original, en inglés)

### 🔍 Filters: Refining Your Bibliometric Collection

The **Filters** module provides a comprehensive set of tools to refine and subset your bibliographic collection based on multiple metadata criteria. By applying filters, you can focus your analysis on specific document types, time periods, geographic regions, journals, or citation thresholds—enabling more targeted and meaningful bibliometric insights.

Filters are organized into **four thematic panels**, each addressing different aspects of bibliographic metadata. At the top of the page, a **real-time summary** displays how many documents, sources, and authors remain after applying your filter selections.

#### 📊 Real-Time Filter Summary

Located at the top of the Filters page, this summary updates dynamically as you adjust filter settings:

- **Documents:** Shows the number of documents currently selected (e.g., '898 of 898' means all documents are included; '450 of 898' means 450 documents match your filter criteria).
- **Sources:** The number of distinct journals, books, or conferences represented in the filtered subset.
- **Authors:** The total number of unique authors contributing to the filtered documents.

These indicators help you assess the impact of your filters *before* applying them, ensuring your subset maintains sufficient size for robust analysis.

#### 1️⃣ General Filters

The **General** panel provides fundamental filters applicable to most bibliometric collections:

#### Document Type

- **Function:** Filters documents by publication type (e.g., Article, Book Chapter, Proceedings Paper, Review, Editorial, Letter, Note).
- **How to Use:**
  - By default, all document types are selected (shown in the filter box).
  - To **exclude** a document type, click on its name in the filter box—it will be removed.
  - To **include** a previously excluded type, click on it in the list below the filter box.
- **Use Cases:**
  - Focus on **peer-reviewed articles** by excluding editorials, letters, and notes.
  - Analyze **conference proceedings** separately from journal articles.
  - Include only **review articles** for systematic literature reviews.

#### Language

- **Function:** Filters documents by publication language (e.g., English, Spanish, French, German, Chinese).
- **Interaction:** Similar to Document Type—click to select/deselect languages.
- **Note:** Most bibliometric databases predominantly index English-language publications. Non-English documents may represent a small fraction (<5%) of typical collections.

#### Publication Year

- **Function:** Restricts the collection to documents published within a specific time range.
- **How to Use:**
  - Use the **slider** to adjust the start and end years.
  - The selected range is displayed below the slider (e.g., '1985 - 2020').
  - The histogram shows the distribution of publications across years, helping you identify periods of high activity.
- **Use Cases:**
  - **Temporal segmentation:** Analyze different decades separately (e.g., 1990-2000 vs. 2010-2020).
  - **Exclude recent publications:** Remove documents <2 years old to avoid citation lag bias.
  - **Focus on historical literature:** Study foundational works from earlier periods.

#### 2️⃣ Journal (J) Filters

The **Journal** panel enables filtering based on publication venues, journal rankings, or Bradford's Law zones:

#### Upload a List of Journals

- **Function:** Restricts the collection to documents published in a user-defined list of journals.
- **How to Use:**
  1. Prepare a file (`.csv`, `.txt`, or `.xlsx`) with journal titles listed in the **first column**.
  2. Click **Browse...** and select your file.
  3. Only documents from journals matching the uploaded list (case-insensitive, partial matching) will be retained.
- **Use Cases:**
  - Focus on **core journals** in your field (e.g., top 10 management journals).
  - Analyze publications from **open-access journals** only.
  - Exclude predatory or low-quality journals identified via external blacklists.
- **Example File Format:**

```
Journal of Informetrics
Scientometrics
Journal of the Association for Information Science and Technology
Research Policy
```

#### Upload a Journal Ranking List

- **Function:** Filters journals based on quality rankings (e.g., Q1, Q2, Q3, Q4 quartiles; A*, A, B, C grades).
- **How to Use:**
  1. Prepare a file (`.csv` or `.xlsx`) with **two columns and headers**:
     - **Column 1:** Journal titles (must match exactly or closely)
     - **Column 2:** Ranking categories (e.g., Q1, Q2, A*, B)
  2. Upload the file via **Browse...**
  3. Select which ranking categories to include in your filtered collection.
- **Use Cases:**
  - Focus on **top-tier journals** (e.g., Q1 only) for high-impact analysis.
  - Compare publication patterns across journal tiers (e.g., Q1 vs. Q2-Q4).
  - Filter by national rankings (e.g., Italian VQR, Australian ABDC, UK ABS).
- **Example File Format:**

```
Journal,Quartile
Journal of Informetrics,Q1
Scientometrics,Q1
Library Quarterly,Q2
Online Information Review,Q3
```

#### Source by Bradford Law Zones

- **Function:** Filters journals based on **Bradford's Law**, which divides sources into three productivity zones: **Core**, **Zone 2**, and **Zone 3**.
- **Theory:** Bradford's Law states that:
  - **Core journals (Zone 1):** A small number of highly productive sources publishing ~1/3 of all documents.
  - **Zone 2:** A moderate number of sources contributing another ~1/3.
  - **Zone 3:** A large number of peripheral sources producing the final ~1/3.
- **How to Use:**
  - Select **'All Sources'** to include everything (default).
  - Select **'Core'** to focus on the most productive journals.
  - Select **'Zone 2'** or **'Zone 3'** to analyze mid-tier or peripheral journals.
- **Use Cases:**
  - Identify the **core journals** dominating a research field.
  - Compare citation impact between core and peripheral sources.
  - Exclude low-productivity journals (Zone 3) to streamline analysis.

#### 3️⃣ Author's Country (AU) Filters

The **Author's Country** panel enables geographic filtering based on author affiliations:

#### Region

- **Function:** Filters documents by broad geographic regions (e.g., Africa, Asia, Europe, North America, South America, Oceania, Seven Seas, Unknown).
- **How to Use:** Click on region buttons to toggle selection. Selected regions are highlighted in blue.
- **Note:** 'Seven Seas' represents international waters or unclassified regions; 'Unknown' indicates missing affiliation data.

#### Country

- **Function:** Filters documents by specific author countries (e.g., USA, China, UK, Germany, Italy).
- **How to Use:**
  - Use the **search box** to quickly find countries.
  - Countries are displayed in two columns: **left** (available), **right** (selected).
  - Click a country in the left column to **add** it; click in the right column to **remove**.
- **Use Cases:**
  - Analyze **national research outputs** (e.g., Italian contributions to bibliometrics).
  - Study **international collaboration** by including multiple countries.
  - Compare **regional trends** (e.g., Europe vs. Asia vs. North America).
  - Identify **emerging research nations** in a field.
- **Important:** Multi-country documents (with authors from different countries) are included if *any* selected country is represented among the authors.

#### 4️⃣ Documents (DOC) Filters

The **Documents** panel provides citation-based filters with interactive histograms:

#### Total Citations

- **Function:** Filters documents by their cumulative citation count (from database records).
- **How to Use:**
  - Use the **slider** below the histogram to set minimum and maximum citation thresholds.
  - The histogram shows the distribution of citation counts across documents, helping you identify highly-cited outliers.
  - Example: Set minimum = 50 to include only documents with ≥50 citations.
- **Use Cases:**
  - Focus on **high-impact documents** (e.g., citations >100) for influence analysis.
  - Exclude **uncited documents** (citations = 0) for citation network studies.
  - Identify the **citation elite** (top 1% most-cited papers).

#### Total Citations per Year

- **Function:** Filters documents by their **average annual citation rate**, calculated as: `Total Citations / (Current Year - Publication Year)`.
- **Why Use This?** Raw citation counts are biased toward older publications. Citations per year normalizes for document age, enabling fairer comparison between recent and historical works.
- **How to Use:** Adjust the slider to set citation-per-year thresholds (e.g., ≥5 citations/year).
- **Use Cases:**
  - Identify **rapidly accumulating citations** (indicators of emerging influence).
  - Compare **citation velocity** across time periods.
  - Find **recent high-impact papers** that haven't yet accumulated large total citation counts but show strong annual growth.

#### 🎛️ Filter Workflow

Follow these steps to apply filters effectively:

1. **Review the initial collection:** Check the summary counts (Documents, Sources, Authors) before applying filters.
2. **Select filter criteria:** Adjust settings across the four panels based on your research objectives.
3. **Monitor real-time updates:** The summary at the top updates dynamically as you change selections, showing how many documents remain.
4. **Click 'Apply':** Once satisfied with your selections, click the blue **Apply** button to activate the filters.
5. **Verify results:** Check the updated summary to ensure your filters produced the expected subset size.
6. **Proceed to analysis:** Navigate to other modules (Overview, Sources, Authors, etc.) to analyze the filtered collection.
7. **Reset if needed:** Click the **Reset** button to clear all filters and restore the original dataset.

#### 💡 Best Practices

- **Avoid over-filtering:** Very small subsets (<100 documents) may not provide robust results for network or clustering analyses. Aim for at least 200-300 documents when possible.
- **Document your filters:** Record which filters you applied for reproducibility and transparency in research reporting (e.g., 'Filtered to Q1 journals, 2010-2020, English-language articles only').
- **Iterative refinement:** Start with broad filters and gradually narrow your criteria while monitoring the summary counts.
- **Combine filters strategically:** Use multiple filter types together (e.g., specific countries + high citations + recent years) for highly targeted analyses.
- **Save filtered collections:** After applying filters, export your refined collection using the **Data** button (top right) to preserve your work.
- **Compare filtered vs. unfiltered:** Run key analyses on both the full and filtered collections to assess how filters impact results.

#### ⚠️ Important Considerations

- **Citation Data Availability:** Citation counts depend on database indexing. Web of Science and Scopus provide citation data; PubMed and some other databases do not. Missing citation data will result in empty histograms in the Documents panel.
- **Affiliation Data Quality:** Author country filters rely on affiliation metadata, which may be incomplete or inconsistent, especially in older publications or non-WoS/Scopus databases.
- **Subject Category Coverage:** Subject categories are database-specific. Scopus categories differ from Web of Science categories; merged collections may have inconsistent classification.
- **Filter Order Independence:** Filters are applied simultaneously, not sequentially. The order in which you select filters does not affect the final result.
- **Bradford Zone Recalculation:** Bradford's Law zones are calculated based on the *current* collection. If you merge collections or upload new data, zones may shift.

#### 🔍 Use Case Examples

**Example 1: Analyzing Top-Tier Recent Research**

- **Goal:** Focus on high-impact, recent publications in core journals.
- **Filters Applied:**
  - Document Type: Article, Review
  - Publication Year: 2015-2020
  - Source by Bradford Law Zones: Core
  - Total Citations per Year: ≥10
- **Outcome:** A curated subset of influential papers from leading journals, suitable for identifying emerging research fronts.

**Example 2: National Research Assessment**

- **Goal:** Evaluate research output from Italian universities in Computer Science.
- **Filters Applied:**
  - Author's Country: Italy
  - Subject Category: Computer Science, Information Systems
  - Document Type: Article
- **Outcome:** A collection focused on Italian contributions to CS, enabling analysis of national productivity, collaboration patterns, and impact.

**Example 3: Historical Foundational Literature**

- **Goal:** Study the intellectual foundations of a field by examining seminal works.
- **Filters Applied:**
  - Publication Year: 1970-1990
  - Total Citations: ≥100
  - Document Type: Article
- **Outcome:** A set of highly-cited historical documents representing foundational contributions.

#### 📚 References

**Bradford, S. C. (1934).** *Sources of information on specific subjects.* **Engineering**, 137, 85–86.

**Aria, M., & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Garfield, E. (2009).** *From the science of science to Scientometrics: visualizing the history of science with HistCite software.* **Journal of Informetrics**, 3(3), 173–179. [https://doi.org/10.1016/j.joi.2009.03.009](https://doi.org/10.1016/j.joi.2009.03.009)
