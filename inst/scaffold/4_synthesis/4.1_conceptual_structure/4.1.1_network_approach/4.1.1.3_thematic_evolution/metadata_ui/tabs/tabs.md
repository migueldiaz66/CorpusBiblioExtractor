# Tabs — Thematic Evolution (`thematicEvolution`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 8631–9257). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Evolution. (Se excluyen "Biblio AI" e "Info & References".)

La página tiene un `tabsetPanel` de salida con dos niveles: pestañas de primer nivel ("Thematic Evolution" y "Time Slice 1"–"Time Slice 5"), cada una con su propio sub-`tabsetPanel`. Los controles de configuración están en el menú desplegable "Options" de la cabecera (no dentro de las pestañas), por lo que ninguna pestaña tiene parámetros propios.

> Detalle verificado en `inst/biblioshiny/server.R` (outputs `TEPlot`/`TETable` ~l.12427–12544; `TMPlot*`/`NetPlot*`/`TMTable*`/`TMTableCluster*`/`TMTableDocument*` ~l.12546–13069) y en las funciones `thematicEvolution()`, `thematicMap()`, `plotThematicEvolution()` (`bibliometrix/R/`) e `igraph2vis()` (`inst/biblioshiny/utils.R`).

## Thematic Evolution
- **Tipo de contenido:** mixto (sub-pestañas: figura + tabla)
- **Parámetros propios:** ninguno
- **Qué presenta:** Evolución temática global del campo a lo largo de los cortes temporales definidos. Contiene dos sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TEPlot`): diagrama de flujo/aluvial que enlaza los temas entre periodos consecutivos.
    - **Desglose:** Diagrama de Sankey/aluvial (plotly `type = "sankey"`, vía `plotThematicEvolution`). Nodos = temas (clústeres) de cada periodo, dispuestos en columnas por corte temporal (coordenada X = periodo; anotaciones superiores con el rango de años de cada corte); color del nodo = color de linaje asignado por `assignEvolutionColors`; hover del nodo = Frequency y Relative Frequency. Flujos (links) = transición de un tema de un periodo al tema del periodo siguiente; ancho del flujo ∝ `lineage_strength` (inclusión ponderada) ×100; color del flujo = color de linaje (gris claro `#D3D3D380` por defecto); hover del flujo = "origen → destino" y Lineage Strength. El control `minFlowTE` oculta (deja transparentes) los flujos por debajo del umbral.
  - **Table** — tabla (`uiOutput` `TETable`): tabla de flujos con los pesos de transición entre temas de un periodo a otro.
    - **Columnas:** `From` (tema/clúster de origen, periodo anterior), `To` (tema/clúster de destino, periodo siguiente), `Words` (términos compartidos por ambos temas, separados por ";"), `Weighted Inclusion Index` (índice de inclusión ponderado por ocurrencias), `Inclusion Index` (índice de inclusión = solapamiento de términos entre los dos clústeres), `Occurrences` (ocurrencias de los términos compartidos), `Stability Index` (índice de estabilidad del tema entre periodos), `PageRank Index` (índice de transición basado en el PageRank de los términos). (Fuente: `values$nexus$Data`, columnas renombradas en `output$TETable`.)
- **Botones:** sub-pestaña **Table** → **Excel** (`exportToExcel`), descarga la tabla filtrada a `Thematic_Evolution_<fecha>.xlsx` (button=TRUE; filtros por columna, orden por encabezado y paginación); sub-pestaña **Map** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

## Time Slice 1
- **Tipo de contenido:** mixto (sub-pestañas: figura + red + 3 tablas)
- **Parámetros propios:** ninguno
- **Qué presenta:** Análisis del primer periodo temporal. Contiene cinco sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TMPlot1`): mapa temático (diagrama estratégico de centralidad/densidad) del periodo.
    - **Desglose:** Mapa temático / diagrama estratégico (ggplot `buildTMPlot` convertido a plotly vía `plot.ly`). Eje X = "Relevance degree (Centrality)" (rango de centralidad de Callon, `rcentrality`); eje Y = "Development degree (Density)" (rango de densidad, `rdensity`). Cada tema es un punto cuyo tamaño ∝ log de la frecuencia del clúster (`freq`) y cuyo color = color del clúster; líneas discontinuas en la media de centralidad y densidad dividen el plano en cuatro cuadrantes anotados: "Motor Themes" (sup-der), "Niche Themes" (sup-izq), "Basic Themes" (inf-der) y "Emerging or Declining Themes" (inf-izq); la etiqueta de cada punto es el término representativo del clúster (`name_full`); hover = lista de términos del clúster con su score.
  - **Network** — red (`visNetworkOutput` `NetPlot1`): red de co-ocurrencia de términos del periodo.
    - **Desglose:** Red de co-ocurrencia de términos (visNetwork, vía `igraph2vis` sobre `values$nexus$Net[[1]]$graph`). Nodos = términos/keywords (etiqueta = nombre del término); color del nodo = clúster de la detección de comunidades; tamaño del nodo y de la etiqueta ∝ grado (`deg`) del nodo, escalado por `labelsize`; aristas = co-ocurrencias entre términos, grosor ∝ peso de co-ocurrencia (`width²` normalizado), con las aristas inter-clúster en gris más oscuro; opacidad según `cocAlpha`; layout, forma y curvatura según los controles `layout`, `coc.shape` y `coc.curved`.
  - **Table** — tabla (`uiOutput` `TMTable1`): términos y métricas del mapa temático.
    - **Columnas:** `Occurrences` (frecuencia/ocurrencias del término), `Words` (término), `Cluster` (id del clúster), `Cluster_Label` (término representativo/etiqueta del clúster), `Cluster_PageRank` (PageRank usado para elegir la etiqueta del clúster), `Score` (score combinado frecuencia+PageRank ×100), `Freq` (frecuencia total del clúster), `btw_centrality` (centralidad de intermediación del término), `clos_centrality` (centralidad de cercanía del término), `pagerank_centrality` (PageRank del término en la red). (Fuente: `values$nexus$TM[[1]]$words`, tras eliminar las columnas Color y Cluster_Frequency.)
  - **Clusters** — tabla (`uiOutput` `TMTableCluster1`): composición de los clústeres/temas detectados.
    - **Columnas:** `Cluster` (nombre/etiqueta del clúster), `CallonCentrality` (centralidad de Callon del clúster), `CallonDensity` (densidad de Callon), `RankCentrality` (rango de centralidad), `RankDensity` (rango de densidad), `ClusterFrequency` (frecuencia del clúster). Sobre la tabla se muestra además la modularidad de la detección de comunidades (Q). (Fuente: `values$nexus$TM[[1]]$clusters`, reordenado y renombrado en `output$TMTableCluster1`.)
  - **Documents** — tabla (`uiOutput` `TMTableDocument1`): documentos asociados a los clústeres del periodo.
    - **Columnas:** `DOI` (DOI del documento, con hipervínculo a doi.org), `Authors` (autores), `Title` (título), `Source` (fuente/revista), `Year` (año de publicación), `TotalCitation` (citas totales), `TCperYear` (citas por año), `NTC` (citas totales normalizadas), `SR` (referencia corta / identificador del documento), una columna de probabilidad por cada clúster del periodo (probabilidad de pertenencia del documento a ese clúster; el nombre de columna es la etiqueta del clúster y su número es dinámico), `Assigned_cluster` (clúster asignado al documento) y `pagerank` (PageRank total de los términos del documento). (Fuente: `values$nexus$TM[[1]]$documentToClusters`, reordenado/renombrado en `output$TMTableDocument1`.)
- **Botones:** sub-pestañas tipo tabla con **Excel** (`exportToExcel`, button=TRUE): **Table** → `Thematic_Map_Period_1_Terms_<fecha>.xlsx`, **Clusters** → `Thematic_Map_Period_1_Clusters_<fecha>.xlsx`, **Documents** → `Thematic_Map_Period_1_Documents_<fecha>.xlsx` (cada tabla: filtros por columna, orden por encabezado y paginación); **Map** y **Network** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

## Time Slice 2
- **Tipo de contenido:** mixto (sub-pestañas: figura + red + 3 tablas)
- **Parámetros propios:** ninguno
- **Qué presenta:** Análisis del segundo periodo temporal. Contiene cinco sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TMPlot2`): mapa temático del periodo.
  - **Network** — red (`visNetworkOutput` `NetPlot2`): red de co-ocurrencia de términos del periodo.
  - **Table** — tabla (`uiOutput` `TMTable2`): términos y métricas del mapa temático.
  - **Clusters** — tabla (`uiOutput` `TMTableCluster2`): composición de los clústeres/temas detectados.
  - **Documents** — tabla (`uiOutput` `TMTableDocument2`): documentos asociados a los clústeres del periodo.
  - **Desglose/Columnas:** análogos a Time Slice 1 (mismas figuras, red y tablas, idénticos `renderBibliobox` sobre `values$nexus$TM[[2]]`); solo cambia el periodo de datos.
- **Botones:** sub-pestañas tipo tabla con **Excel** (`exportToExcel`, button=TRUE): **Table** → `Thematic_Map_Period_2_Terms_<fecha>.xlsx`, **Clusters** → `Thematic_Map_Period_2_Clusters_<fecha>.xlsx`, **Documents** → `Thematic_Map_Period_2_Documents_<fecha>.xlsx` (cada tabla: filtros por columna, orden por encabezado y paginación); **Map** y **Network** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

## Time Slice 3
- **Tipo de contenido:** mixto (sub-pestañas: figura + red + 3 tablas)
- **Parámetros propios:** ninguno
- **Qué presenta:** Análisis del tercer periodo temporal. Contiene cinco sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TMPlot3`): mapa temático del periodo.
  - **Network** — red (`visNetworkOutput` `NetPlot3`): red de co-ocurrencia de términos del periodo.
  - **Table** — tabla (`uiOutput` `TMTable3`): términos y métricas del mapa temático.
  - **Clusters** — tabla (`uiOutput` `TMTableCluster3`): composición de los clústeres/temas detectados.
  - **Documents** — tabla (`uiOutput` `TMTableDocument3`): documentos asociados a los clústeres del periodo.
  - **Desglose/Columnas:** análogos a Time Slice 1 (sobre `values$nexus$TM[[3]]`); solo cambia el periodo de datos.
- **Botones:** sub-pestañas tipo tabla con **Excel** (`exportToExcel`, button=TRUE): **Table** → `Thematic_Map_Period_3_Terms_<fecha>.xlsx`, **Clusters** → `Thematic_Map_Period_3_Clusters_<fecha>.xlsx`, **Documents** → `Thematic_Map_Period_3_Documents_<fecha>.xlsx` (cada tabla: filtros por columna, orden por encabezado y paginación); **Map** y **Network** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

## Time Slice 4
- **Tipo de contenido:** mixto (sub-pestañas: figura + red + 3 tablas)
- **Parámetros propios:** ninguno
- **Qué presenta:** Análisis del cuarto periodo temporal. Contiene cinco sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TMPlot4`): mapa temático del periodo.
  - **Network** — red (`visNetworkOutput` `NetPlot4`): red de co-ocurrencia de términos del periodo.
  - **Table** — tabla (`uiOutput` `TMTable4`): términos y métricas del mapa temático.
  - **Clusters** — tabla (`uiOutput` `TMTableCluster4`): composición de los clústeres/temas detectados.
  - **Documents** — tabla (`uiOutput` `TMTableDocument4`): documentos asociados a los clústeres del periodo.
  - **Desglose/Columnas:** análogos a Time Slice 1 (sobre `values$nexus$TM[[4]]`); solo cambia el periodo de datos.
- **Botones:** sub-pestañas tipo tabla con **Excel** (`exportToExcel`, button=TRUE): **Table** → `Thematic_Map_Period_4_Terms_<fecha>.xlsx`, **Clusters** → `Thematic_Map_Period_4_Clusters_<fecha>.xlsx`, **Documents** → `Thematic_Map_Period_4_Documents_<fecha>.xlsx` (cada tabla: filtros por columna, orden por encabezado y paginación); **Map** y **Network** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

## Time Slice 5
- **Tipo de contenido:** mixto (sub-pestañas: figura + red + 3 tablas)
- **Parámetros propios:** ninguno
- **Qué presenta:** Análisis del quinto periodo temporal. Contiene cinco sub-pestañas:
  - **Map** — figura (`plotlyOutput` `TMPlot5`): mapa temático del periodo.
  - **Network** — red (`visNetworkOutput` `NetPlot5`): red de co-ocurrencia de términos del periodo.
  - **Table** — tabla (`uiOutput` `TMTable5`): términos y métricas del mapa temático.
  - **Clusters** — tabla (`uiOutput` `TMTableCluster5`): composición de los clústeres/temas detectados.
  - **Documents** — tabla (`uiOutput` `TMTableDocument5`): documentos asociados a los clústeres del periodo.
  - **Desglose/Columnas:** análogos a Time Slice 1 (sobre `values$nexus$TM[[5]]`); solo cambia el periodo de datos.
- **Botones:** sub-pestañas tipo tabla con **Excel** (`exportToExcel`, button=TRUE): **Table** → `Thematic_Map_Period_5_Terms_<fecha>.xlsx`, **Clusters** → `Thematic_Map_Period_5_Clusters_<fecha>.xlsx`, **Documents** → `Thematic_Map_Period_5_Documents_<fecha>.xlsx` (cada tabla: filtros por columna, orden por encabezado y paginación); **Map** y **Network** sin botón propio (Run/Report/Export en el encabezado — ver options.md).

> Nota: las pestañas "Time Slice 1"–"Time Slice 5" están predefinidas en la interfaz; el número de cortes (y por tanto de periodos efectivamente mostrados) depende del control "Number of Cutting Points" (`numSlices`) del menú de opciones. Las columnas/figuras son idénticas en estructura entre slices (mismo `renderBibliobox`/`plot.ly`/`igraph2vis`), variando únicamente el periodo de datos `values$nexus$TM[[k]]`.
