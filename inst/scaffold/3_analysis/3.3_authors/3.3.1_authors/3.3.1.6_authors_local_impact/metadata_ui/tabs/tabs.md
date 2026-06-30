# Tabs — Authors' Local Impact (`authorImpact`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4211–4340). Ruta de menú: ANALYSIS › Authors › Authors' Local Impact. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle verificado en `inst/biblioshiny/server.R` (líneas 7499–7563), `Hindex_plot()` (utils.R) y `bibliometrix::Hindex()`.

## Plot
- **Tipo de contenido:** figura (plotlyOutput `AuthorHindexPlot`)
- **Parámetros propios:** ninguno (las opciones —`HmeasureAuthors`, `Hkauthor`— están en el desplegable de la cabecera de la página)
- **Qué presenta:** Gráfico de barras con el impacto de los autores según la medida elegida (H-Index, G-Index, M-Index o citas totales).
- **Desglose:** tipo=gráfico tipo lollipop horizontal (segmento + punto, vía `freqPlot()` renderizado con `plot.ly`, `flip=FALSE`); eje X=medida de impacto seleccionada en `HmeasureAuthors` (`h`=h_index, `g`=g_index, `m`=m_index, `tc`=TC; etiqueta "Impact Measure: H/G/M/TC"); eje Y=`Authors` (top `Hkauthor`, orden descendente por la medida); color/tamaño=magnitud de la medida (gradiente de color por `-valor` y radio del punto proporcional).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (uiOutput `AuthorHindexTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los índices de impacto de cada autor (h, g, m, citas totales, n.º de artículos, año de inicio).
- **Columnas:** `Author` (nombre del autor; renombrado desde `Element`), `h_index` (índice h), `g_index` (índice g), `m_index` (índice m = h / años activo), `TC` (citas totales), `NP` (n.º de documentos/publicaciones), `PY_start` (año de la primera publicación). Origen: `values$H` = `Hindex(M, field="author")$H`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Author_Impact_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
