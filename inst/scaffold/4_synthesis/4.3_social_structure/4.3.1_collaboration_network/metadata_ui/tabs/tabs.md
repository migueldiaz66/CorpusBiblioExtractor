# Tabs — Collaboration Network (`collabNetwork`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 10323–10945). Ruta de menú: SYNTHESIS › Social Structure › Collaboration Network. (Se excluyen "Biblio AI" e "Info & References".)
>
> Desgloses de red/tabla/figura verificados en `inst/biblioshiny/server.R` (líneas 13569–13995) y en las funciones auxiliares de `inst/biblioshiny/utils.R` (`igraph2vis`, `overlayPlotly`, `degreePlot`).

## Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `colPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Grafo interactivo de colaboración entre autores, instituciones o países; los nodos son los actores y los enlaces sus coautorías, con clústeres coloreados.
- **Desglose:** `colPlot` renderiza `values$COLnetwork$VIS`, generado por `igraph2vis()` sobre el grafo de `bibliometrix::networkPlot()` de la red de `biblioNetwork(analysis = "collaboration")`. **Nodos:** autores (`COL_AU` → `AU`), instituciones/universidades (`COL_UN` → `AU_UN`) o países según el campo elegido (`colField`); cada nodo lleva el atributo `year_med` (primer año del actor). **Aristas:** coautorías; grosor proporcional al peso del vínculo. **Color de nodo:** por clúster (community detection). **Tamaño de nodo:** proporcional al grado (`deg`). Tooltip = nombre del actor.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Diachronic Network
- **Tipo de contenido:** red interactiva animada (`visNetworkOutput` → `colOverTime`)
- **Parámetros propios:**
  - Start `start_col`
  - Pause / Resume `pause_col`
  - Reset `reset_col`
  - Export `export_colUI` (control dinámico `uiOutput`)
  - Speed (ms) `speed_col` (250–2000 ms, paso 250; por defecto 500)
  - Year slider `year_slider_colUI` (control dinámico `uiOutput`)
  - Año mostrado `colYearUI` (indicador dinámico `uiOutput`)
- **Qué presenta:** Animación temporal de la red de colaboración que muestra cómo se forman y evolucionan los vínculos de coautoría año a año.
- **Desglose:** misma red base (`values$COLnetwork$VIS`) filtrada de forma acumulativa por año: muestra solo los nodos con `year_med <= año seleccionado` y las aristas entre dichos nodos; las coordenadas (`x`, `y`) de los nodos se mantienen fijas y el título de cada nodo añade su `year_med`. La animación avanza año a año (lista `values$years_col`) controlada por Start/Pause/Reset y por la velocidad `speed_col` (`invalidateLater`), sincronizada con el slider de año. Color/tamaño/aristas heredados de la red base (no determinable adicional estáticamente).
- **Botones:** controles propios de la animación dentro de la pestaña — **Start** (`start_col`), **Pause/Resume** (`pause_col`), **Reset** (`reset_col`), **Export** (`export_colUI`, exporta la red animada) y **Speed (ms)** (`speed_col`), además del slider de años. No genera tabla, por lo que no tiene botón Excel.

## Density
- **Tipo de contenido:** figura (`plotlyOutput` → `colOverlay`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa de densidad superpuesto a la red de colaboración, resaltando las regiones del grafo con mayor concentración de actores y enlaces.
- **Desglose:** `colOverlay` = `overlayPlotly(values$COLnetwork$VIS)`. Heatmap de densidad 2D (`MASS::kde2d`, 300×300) sobre las coordenadas `x`/`y` del layout, con los nodos replicados según `ceiling(log(deg))` (ponderación por grado). **Color:** escala Reds (blanco = baja densidad → rojo oscuro = alta), sin barra de escala; etiquetas de nodos superpuestas como texto; ejes ocultos.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `colTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las métricas de los nodos de la red de colaboración (clúster, grado, centralidad, etc.).
- **Columnas:** `Node` (actor: autor/institución/país), `Cluster` (clúster/comunidad asignada), `Betweenness` (centralidad de intermediación), `Closeness` (centralidad de cercanía), `PageRank` (centralidad PageRank). Origen: `values$colnet$cluster_res` con nombres reasignados en server.R; columnas 3–5 numéricas (redondeo a 3 decimales). Encima de la tabla se muestra la **Modularidad de la detección de comunidades (Q)**.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Collaboration_Network_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Degree Plot
- **Tipo de contenido:** figura (`plotlyOutput` → `colDegree`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de distribución del grado de los nodos, ordenando los actores por su número de colaboraciones en la red.
- **Desglose:** `colDegree` = `plot.ly(degreePlot(values$colnet))`. Gráfico de puntos + línea. **Eje X:** "Node" (actores ordenados por número de fila según grado). **Eje Y:** "Cumulative Degree". Título "Node Degrees"; el tooltip muestra el actor y su grado.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).
