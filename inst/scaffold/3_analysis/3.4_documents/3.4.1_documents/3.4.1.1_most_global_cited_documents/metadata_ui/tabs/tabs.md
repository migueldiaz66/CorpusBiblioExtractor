# Tabs — Most Global Cited Documents (`mostGlobalCitDoc`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5020–5145). Ruta de menú: ANALYSIS › Documents › Most Global Cited Documents. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostCitDocsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de los documentos más citados globalmente, ordenados según la medida seleccionada (citas totales o citas totales por año).
- **Desglose:** tipo=lollipop horizontal (`geom_segment` desde 0 + `geom_point`, vía `freqPlot()`); eje X=Global Citations (`Total Citations`) o Global Citations per Year (`TC per Year`) según `input$CitDocsMeasure`; eje Y=Documents (`Paper`/SR); color/tamaño=ambos codifican el valor de citas (color por gradiente de `-citas`, tamaño proporcional a las citas, `scale_radius` 5–12).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostCitDocsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de los documentos más citados globalmente con sus métricas de citación.
- **Columnas:** `Paper` (identificador del documento: primer autor, año y fuente — SR), `DOI` (enlace DOI clicable), `Total Citations` (citas globales totales — TC), `TC per Year` (citas totales por año = TC/(año actual+1−PY)), `Normalized TC` (TC normalizadas = TC/media de TC del mismo año de publicación). Fuente: `values$TABGlobDoc`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Global_Cited_Documents_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
