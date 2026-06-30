# Tabs — Co-occurrence Network (`coOccurenceNetwork`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 7503–8191). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Co-occurrence Network. (Se excluyen "Biblio AI" e "Info & References".)
>
> Detalle de columnas/figuras verificado en `inst/biblioshiny/server.R` (bloques `output$...`) y funciones auxiliares (`igraph2vis`, `overlayPlotly`, `degreePlot` en `inst/biblioshiny/utils.R`; `clusterAssignment` en `R/thematicMap.R`; `cluster_res` en `R/networkPlot.R`).

## Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `cocPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Red interactiva de co-ocurrencia de términos, con nodos coloreados por clúster y enlaces ponderados por la fuerza de asociación entre términos.
- **Desglose:** tipo=red interactiva visNetwork (`values$COCnetwork$VIS`, construida con `igraph2vis()` sobre `cocnet$graph`); nodos=términos/keywords del campo de co-ocurrencia (etiqueta=nombre del término); aristas=co-ocurrencia entre términos, ancho ∝ peso² normalizado (fuerza de asociación), aristas intra-clúster coloreadas por su clúster e inter-clúster en gris; color de nodo=clúster de community detection (o gradiente azul por año si la opción "by year" está activa, `coc_years`); tamaño de nodo ∝ grado del nodo (atributo `deg`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Diachronic Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `cocOverTime`)
- **Parámetros propios:**
  - Start (`start_coc`)
  - Pause / Resume (`pause_coc`)
  - Reset (`reset_coc`)
  - Export (`export_cocUI`, control dinámico)
  - Speed (ms) (`speed_coc`)
  - Slider de años (`year_slider_cocUI`, control dinámico)
  - Indicador de año actual (`cocYearUI`, control dinámico)
- **Qué presenta:** Animación de la evolución temporal de la red de co-ocurrencia, reproduciéndola año a año con controles de reproducción, velocidad y selección de rango temporal.
- **Desglose:** tipo=red interactiva visNetwork animada en el tiempo (`render_network_coc()`, derivada de `values$COCnetwork$VIS`); nodos=los mismos términos, filtrados a los que aparecen hasta el año seleccionado (`year_med <= año`, donde `year_med` es el año mediano de aparición del término); aristas=co-ocurrencias entre los nodos visibles en ese año; color/tamaño=igual que la red base (clúster / grado); codificación temporal=el año actual avanza con el slider/reproductor y el título del nodo añade su `year_med`.
- **Botones:** controles propios de la animación dentro de la pestaña — **Start** (`start_coc`), **Pause/Resume** (`pause_coc`), **Reset** (`reset_coc`), **Export** (`export_cocUI`, exporta la red animada) y **Speed (ms)** (`speed_coc`), además del slider de años. No genera tabla, por lo que no tiene botón Excel.

## Density
- **Tipo de contenido:** figura (`plotlyOutput` → `cocOverlay`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Visualización de densidad superpuesta sobre la red, mostrando las zonas de mayor concentración/agrupamiento de términos co-ocurrentes.
- **Desglose:** tipo=mapa de calor de densidad (estimación de densidad kernel 2D, `MASS::kde2d`) superpuesto al layout de la red (`overlayPlotly()`); eje X / eje Y=coordenadas del layout de la red (sin escala interpretable; ejes ocultos); densidad ponderada por el grado del nodo (cada nodo se replica `ceiling(log(deg))` veces); color=escala Reds (blanco=baja densidad → rojo oscuro=alta concentración de términos); las etiquetas de los términos se dibujan sobre sus posiciones con tamaño ∝ grado.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `cocTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos de la red y sus métricas asociadas (clúster, frecuencias y medidas de centralidad).
- **Origen de datos:** `values$cocnet$cluster_res` (de `networkPlot()`), renombrado en `server.R`. Encabezado adicional: Community Detection Modularity (Q).
- **Columnas:** `Node` (término/keyword = vértice de la red), `Cluster` (clúster asignado por community detection), `Betweenness` (centralidad de intermediación), `Closeness` (centralidad de cercanía), `PageRank` (centralidad PageRank). Las columnas 3–5 se muestran como numéricas redondeadas.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `CoWord_Network_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Documents
- **Tipo de contenido:** tabla (`uiOutput` → `cocTableDocument`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de documentos vinculados a los términos/clústeres de la red de co-ocurrencia.
- **Origen de datos:** `values$cocnet$documentToClusters` (asignación difusa de documentos a clústeres vía `clusterAssignment()`, umbral 0.5).
- **Columnas:** `DOI` (enlace clicable a doi.org), `Authors` (AU), `Title` (TI), `Source` (SO), `Year` (año de publicación, PY), `TotalCitation` (citas totales, TC), `TCperYear` (citas por año), `NTC` (citas totales normalizadas), `SR` (short reference / ID del documento), luego una columna por clúster con la probabilidad (0–1) de pertenencia del documento a ese clúster (nombre = etiqueta del clúster; nº de columnas no determinable estáticamente, depende del nº de clústeres), `Assigned_cluster` (clúster al que se asigna el documento si p ≥ 0.5), y `pagerank` (PageRank total de los términos del documento).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `CoWord_Network_Documents_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Degree Plot
- **Tipo de contenido:** figura (`plotlyOutput` → `cocDegree`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de grado de los nodos, mostrando la distribución de conexiones (centralidad de grado) de los términos en la red.
- **Desglose:** tipo=gráfico de puntos unidos por línea (`degreePlot()`, ggplot→plotly; título "Node Degrees"); eje X="Node" (índice de los nodos en orden, `row_number()`); eje Y="Cumulative Degree" (grado de cada nodo); cada punto=un término con su grado (nº de conexiones), con tooltip `nodo - Degree valor`.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).
