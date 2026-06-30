# Info & References — PRISMA Diagram

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `prisma`).
> Ruta de menú: APPRAISAL › PRISMA Diagram · tabName: `prisma`

## Resumen (español)

- **Qué es:** El diagrama de flujo PRISMA (Preferred Reporting Items for Systematic Reviews and Meta-Analyses) documenta el proceso de selección de estudios; en bibliometría rastrea cómo el conjunto inicial de registros se refina progresivamente mediante criterios de filtrado.
- **Cuatro fases:** *Identification* (registros recuperados de bases de datos y otras fuentes), *Screening* (filtros formales: duplicados, periodo, tipo de documento), *Eligibility* (filtros de contenido: categoría temática, idioma, revista, país) e *Inclusion* (conjunto final incluido en el análisis).
- **Cómo se usa:** se introduce la base, la consulta y el total de registros en Identification; opcionalmente una fuente secundaria; se añaden pasos (**Add Step**) indicando el criterio y los registros restantes.
- **Automatización:** la fase PRISMA (Screening o Eligibility) y el número de registros excluidos se calculan automáticamente.
- **Salida:** **Generate PRISMA Diagram** produce el diagrama; se puede descargar como PNG de alta resolución o añadir al informe (workbook).
- **Referencias clave:** Page et al. (2021), Aria & Cuccurullo (2017, 2026).

---

## Info & References (original, en inglés)

### PRISMA Flow Diagram for Bibliometric Studies

The PRISMA (Preferred Reporting Items for Systematic Reviews and Meta-Analyses) flow diagram documents the process of selecting studies for analysis. In bibliometric research, the PRISMA diagram tracks how the initial set of records retrieved from databases is progressively refined through filtering criteria.

#### Phases

- **Identification**: Records retrieved from database queries and other sources.
- **Screening**: Filters based on formal criteria such as duplicate removal, time span, and document type.
- **Eligibility**: Filters based on content-related criteria such as subject category, language, journal, and country.
- **Inclusion**: Final set of studies included in the bibliometric analysis.

#### How to use

1. In the **Identification** box, enter the database name, your search query, and the total number of records retrieved.
2. Optionally, add a secondary source (e.g. records added via DOI or from another database).
3. Click **Add Step** to define each filtering stage. For each step, select the criterion type, optionally describe the filter values (e.g. "Article, Review" or "1985–2025"), and enter the number of records remaining after applying that filter.
4. The PRISMA phase (Screening or Eligibility) and the number of excluded records are computed automatically.
5. Click **Generate PRISMA Diagram** to produce the flow chart.
6. Use the download button to export the diagram as a high-resolution PNG, or the report button to add it to the workbook.

#### References

**Page, M. J., et al. (2021).** *The PRISMA 2020 statement: an updated guideline for reporting systematic reviews.* **BMJ**, 372, n71. [https://doi.org/10.1136/bmj.n71](https://doi.org/10.1136/bmj.n71)

**Aria, M., & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959–975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.
