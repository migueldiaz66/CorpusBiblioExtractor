# Tabs — Sources' Local Impact (`sourceImpact`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3336–3465). Ruta de menú: ANALYSIS › Sources › Sources' Local Impact. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `SourceHindexPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de barras interactivo con el impacto local de las fuentes según la medida seleccionada (H-Index, G-Index, M-Index o Total Citation).
- **Desglose:** tipo=lollipop/dot horizontal (`Hindex_plot()` → `freqPlot()`: `geom_segment` + `geom_point`, vía `plot.ly`); eje X=`Impact Measure: <H/G/M/TC>` (valor de la medida elegida en `input$HmeasureSources`: `h_index`, `g_index`, `m_index` o `TC`); eje Y=`Sources` (nombre de la fuente, columna `Element`); color/tamaño=gradiente por magnitud (`color = -valor`, `size = valor`). Ordenado descendente por la medida y recortado a `input$Hksource` fuentes.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `SourceHindexTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las fuentes y sus métricas de impacto (índices y citas totales).
- **Columnas:** `Source` (nombre de la fuente; renombrada de `Element`), `h_index` (índice h), `g_index` (índice g), `m_index` (índice m = h / años desde el primer año), `TC` (Total Citations, suma de citas), `NP` (n.º de documentos / Number of Papers), `PY_start` (año de la primera publicación). Origen: `values$H` (`Hindex(values$M, field = "source")$H`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Source_Impact_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
