# Tabs — Filters (`filters`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 1999–2220). Ruta de menú: APPRAISAL › Filters. (Se excluyen "Biblio AI" e "Info & References".)

## Filter List
- **Tipo de contenido:** dinámico (htmlOutput). El único output de la pestaña es `htmlOutput("textDim")`, un texto que reporta la dimensión de la colección (número de documentos resultante tras aplicar los filtros). El `outputId` "textDim" no contiene 'Table'/'Plot'/'fig', por lo que se clasifica como dinámico/texto.
- **Parámetros propios:**
  - "Apply" (`applyFilter`) — actionBttn que aplica los filtros seleccionados.
  - "Reset" (`resetFilter`) — actionBttn que restablece los filtros.
  - "Data" (`viewDataFilter`) — actionBttn para ver la tabla de datos filtrados.
  - Bloque 1. General: "Document Type" (`selectType`, selectizeInput multiple), "Language" (`selectLA`, selectizeInput multiple), "Publication Year" (`sliderPY`, sliderInput rango de años), "Subject Category" (`subject_category`, multiInput).
  - Bloque 2. (J) Journal: "Upload a List of Journals" (`journal_list_upload`, fileInput), `journal_list_ui` (uiOutput), "Upload a Journal Ranking List" (`journal_ranking_upload`, fileInput), `journal_ranking_ui` y `journal_ranking_ui_view` (uiOutput), "Source by Bradford Law Zones" (`bradfordSources`, selectInput: Core / Core+Zone 2 / All).
  - Bloque 3. (AU) Author's Country: "Region" (`region`, selectInput multiple), "Country" (`country`, multiInput).
  - Bloque 4. (DOC) Documents: "Total Citations" (`sliderTC`, sliderInput), "Total Citations per Year" (`sliderTCpY`, sliderInput).
- **Qué presenta:** Panel para acotar la colección mediante filtros (tipo de documento, idioma, año, categoría temática, revistas y rankings, zonas de Bradford, región y país de autores, y umbrales de citas). El output muestra en texto la dimensión actualizada de la colección filtrada, que se confirma con "Apply".
- **Desglose de outputs (verificado en server.R):**
  - `textDim` (server.R L4810–4863) — **Texto/recuadro** (`renderUI` + HTML). Tabla resumen de 3 filas que compara la colección filtrada (`values$M`) contra la original (`values$Morig`), mostrando para cada métrica "actual of total": **Documents** = `dim(values$M)[1]` of `dim(values$Morig)[1]`; **Sources** = nº de `SO` únicos actuales of totales; **Authors** = nº de autores únicos (`unlist(strsplit(AU, ";"))`) actuales of totales. No es gráfico ni datatable.
  - `dataFiltered` (modal lanzado por `viewDataFilter`, server.R L5326–5368) — **Tabla** (`renderBibliobox`, 3 filas por página, scroll X, filtro superior) titulada "Filtered Data". Renderiza `values$M` seleccionando un conjunto **fijo** de 10 columnas; si la colección queda vacía muestra el mensaje "Empty collection".
- **Columnas (tabla `dataFiltered`, `select(SR, AU, TI, SO, PY, LA, DT, TC, TCpY, DI)`):** `SR` (short reference: primer autor, año, revista), `AU` (autores), `TI` (título del documento), `SO` (fuente/nombre de la revista), `PY` (año de publicación), `LA` (idioma), `DT` (tipo de documento), `TC` (total de citas), `TCpY` (citas totales por año = TC/(año actual − PY + 1)), `DI` (DOI).
- **Botones:** propios de la pestaña — **Apply** (`applyFilter`) aplica los filtros seleccionados, **Reset** (`resetFilter`) los restablece y **Data** (`viewDataFilter`) abre el modal "Filtered Data". La tabla `dataFiltered` de ese modal no lleva botón Excel (button=FALSE): solo permite filtrar/ordenar/paginar. (Run/Report/Export globales están en el encabezado de la página — ver options.md).
