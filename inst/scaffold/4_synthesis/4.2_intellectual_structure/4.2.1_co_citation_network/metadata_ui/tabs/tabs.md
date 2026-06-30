# Tabs — Co-citation Network (`coCitationNetwork`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 9631–10115). Ruta de menú: SYNTHESIS › Intellectual Structure › Co-citation Network. (Se excluyen "Biblio AI" e "Info & References".)
>
> Desgloses de tabla/red/figura verificados en `inst/biblioshiny/server.R` (líneas 13266–13361) y en las funciones auxiliares de `inst/biblioshiny/utils.R` (`igraph2vis`, `overlayPlotly`, `degreePlot`).

## Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `cocitPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Grafo interactivo de co-citación donde los nodos son referencias (papers, autores o fuentes citadas) y los enlaces representan que dos ítems son citados conjuntamente; los clústeres detectados se colorean.
- **Desglose:** `cocitPlot` renderiza `values$COCITnetwork$VIS`, generado por `igraph2vis()` a partir del grafo de `bibliometrix::networkPlot(NetRefs, ...)` (red de `biblioNetwork(analysis = "co-citation")`). **Nodos:** referencias citadas (`CR`), autores citados (`CR_AU`) o fuentes citadas (`CR_SO`) según el campo elegido; el título/tooltip del nodo es su nombre (`id`). **Aristas:** co-citación (dos ítems citados juntos); el grosor es proporcional al peso del vínculo (`width^2` reescalado); las aristas intra-clúster heredan el color del clúster y las inter-clúster se grisan. **Color de nodo:** por clúster (community detection). **Tamaño de nodo:** proporcional al grado (`deg`); `size.cex = TRUE`, `size = 5`. Layout configurable (`cit_layout`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Density
- **Tipo de contenido:** figura (`plotlyOutput` → `cocitOverlay`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa de densidad superpuesto a la red de co-citación, que destaca las zonas de mayor concentración de nodos y enlaces.
- **Desglose:** `cocitOverlay` = `overlayPlotly(values$COCITnetwork$VIS)`. Heatmap de densidad 2D (estimación kernel `MASS::kde2d`, 300×300) calculado sobre las coordenadas `x`/`y` del layout de la red, con los nodos replicados según `ceiling(log(deg))` (mayor peso a nodos de alto grado). **Color:** escala Reds (blanco = baja densidad → rojo oscuro `rgb(103,0,13)` = alta densidad), sin barra de escala. Las etiquetas de los nodos se superponen como anotaciones de texto. Ejes ocultos (sin títulos ni ticks).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `cocitTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las métricas de los nodos de la red (clúster, grado, centralidad, etc.) para los ítems co-citados.
- **Columnas:** `Node` (etiqueta del ítem co-citado), `Cluster` (clúster/comunidad asignada), `Betweenness` (centralidad de intermediación), `Closeness` (centralidad de cercanía), `PageRank` (centralidad PageRank). Origen: `values$cocitnet$cluster_res` con nombres reasignados en server.R; columnas 3–5 numéricas (redondeo a 3 decimales). Encima de la tabla se muestra la **Modularidad de la detección de comunidades (Q)**.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `CoCitation_Network_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Degree Plot
- **Tipo de contenido:** figura (`plotlyOutput` → `cocitDegree`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de distribución del grado de los nodos, ordenando los ítems por su número de conexiones en la red de co-citación.
- **Desglose:** `cocitDegree` = `plot.ly(degreePlot(cocitnet))`. Gráfico de puntos + línea (`geom_point` + `geom_line` color `#002F80`). **Eje X:** "Node" (nodos ordenados por número de fila según grado). **Eje Y:** "Cumulative Degree". Título "Node Degrees"; el tooltip muestra el nodo y su grado redondeado.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).
