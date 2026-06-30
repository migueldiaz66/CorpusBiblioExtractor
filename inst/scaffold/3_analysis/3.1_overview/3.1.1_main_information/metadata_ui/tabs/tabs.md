# Tabs — Main Information (`mainInfo`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2387–2494). Ruta de menú: ANALYSIS › Overview › Main Information. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** indicadores dinámicos (varios `valueBoxOutput`: Timespan, au, kw, so, auS1, cr, doc, col, agePerDoc, cagr, coAuPerDoc, tc).
- **Parámetros propios:** ninguno.
- **Qué presenta:** panel de cuadros-resumen (value boxes) con las métricas principales del dataset: periodo temporal, número de autores, palabras clave, fuentes, documentos, colaboraciones, citas totales, CAGR, antigüedad media por documento, etc.
- **Desglose:** tipo=value boxes (KPIs) calculados por `ValueBoxes(values$M)`; indicadores mostrados=`Timespan` (rango de años PY), `Authors` (nº de autores únicos), `Author's Keywords (DE)` (nº de keywords de autor), `Sources (Journals, Books, etc)` (nº de fuentes únicas), `Authors of single-authored docs` (autores de documentos de un solo autor), `References` (nº de referencias citadas únicas), `Documents` (nº de documentos), `International co-authorships %` (% de coautorías internacionales), `Document Average Age` (antigüedad media por documento en años), `Annual Growth Rate %` (tasa de crecimiento anual compuesta), `Co-Authors per Doc` (coautores por documento), `Average citations per doc` (media de citas por documento).
- **Botones:** ninguno propio (Run/Report/Export están en el encabezado de la página — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` con outputId `MainInfo`).
- **Parámetros propios:** ninguno.
- **Qué presenta:** tabla con la información principal de la colección (descripción detallada del dataset, autores, contenido del documento, colaboración, etc.) presentada en formato tabular.
- **Columnas:** `Description` (nombre del indicador o encabezado de sección: MAIN INFORMATION ABOUT DATA, DOCUMENT CONTENTS, AUTHORS, AUTHORS COLLABORATION, DOCUMENT TYPES), `Results` (valor del indicador). Fuente: `values$TABvb <- ValueBoxes(values$M)`; incluye las métricas de los value boxes más `Keywords Plus (ID)`, `Single-authored docs` y el recuento por tipo de documento (DT).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Main_Information_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
