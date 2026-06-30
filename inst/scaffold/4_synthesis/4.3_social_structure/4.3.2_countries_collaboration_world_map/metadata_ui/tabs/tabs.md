# Tabs — Countries' Collaboration World Map (`collabWorldMap`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 10946–11110). Ruta de menú: SYNTHESIS › Social Structure › Countries' Collaboration World Map. (Se excluyen "Biblio AI" e "Info & References".)
>
> Desgloses de mapa/tabla verificados en `inst/biblioshiny/server.R` (líneas 14038–14099) y en `countrycollaboration_plotly()` de `inst/biblioshiny/utils.R`.

## Plot
- **Tipo de contenido:** mapa (`plotlyOutput` → `WMPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapamundi de colaboración científica entre países, donde las líneas que unen los países representan las coautorías internacionales y su intensidad.
- **Desglose:** `WMPlot` = `values$WMmap$g`, de `countrycollaboration_plotly(M, ...)`. Mapa coroplético `plotly::plot_geo` con proyección "natural earth". **Variable que colorea el mapa (choropleth):** la producción científica de cada país = nº de publicaciones (`Freq`, diagonal de la red de colaboración de países `biblioNetwork(analysis = "collaboration", network = "countries")`), en escala `log1p(Freq)`; escala de color blanco → bordeaux (`#FFFFFF` → `#fee5d9` → `#fcae91` → `#fb6a4a` → `#de2d26` → `#a50f15`), sin barra de escala (tooltip "Publications: Freq"). **Aristas:** arcos geodésicos (`geosphere::gcIntermediate`) trazados como `scattergeo` en azul (`#4A90E2`, opacidad 0.4) que unen pares de países que colaboran; grosor proporcional a `sqrt(count)` (nº de colaboraciones), normalizado entre `min_edgesize` y `edgesize` (tooltip "Collaborations: count"). Filtrado por `min.edges` (`input$WMedges.min`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `WMTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los pares de países colaboradores y la frecuencia (número de publicaciones conjuntas) de cada vínculo de colaboración.
- **Columnas:** `From` (país origen del vínculo), `To` (país destino del vínculo), `Frequency` (nº de publicaciones en coautoría entre ambos países). Origen: `values$WMmap$tab` (= `count.duplicates()` de los pares de países), del que se seleccionan las columnas 1, 2 y 11 y se renombran en server.R.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Collaboration_WorldMap_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
