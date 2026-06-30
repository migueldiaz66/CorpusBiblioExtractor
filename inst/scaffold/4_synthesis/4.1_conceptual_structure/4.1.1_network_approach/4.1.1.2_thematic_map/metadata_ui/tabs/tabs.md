# Tabs — Thematic Map (`thematicMap`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 8192–8630). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Map. (Se excluyen "Biblio AI" e "Info & References".)
>
> Detalle de columnas/figuras verificado en `inst/biblioshiny/server.R` (bloques `output$...`) y en `R/thematicMap.R` (`thematicMap()`, `clusterAssignment()`), `R/networkPlot.R` (`cluster_res`) y `inst/biblioshiny/utils.R` (`igraph2vis`).

## Map
- **Tipo de contenido:** figura (`plotlyOutput` → `TMPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa temático (diagrama estratégico) que posiciona los clústeres de términos según centralidad (relevancia) y densidad (desarrollo) en los cuadrantes motor, básico, emergente/decadente y nicho.
- **Desglose:** tipo=diagrama estratégico / mapa temático (scatter de burbujas, `TM$map` ggplot → `plot.ly`); eje X=`rcentrality` (centralidad de Callon normalizada por rango = grado de relevancia); eje Y=`rdensity` (densidad de Callon normalizada por rango = grado de desarrollo); cada burbuja=un clúster temático, tamaño ∝ `freq` (frecuencia del tema), color=clúster, etiqueta=términos representativos; cuadrantes divididos en la media de centralidad (X) y de densidad (Y): superior-derecha=temas motor (alta centralidad/alta densidad), superior-izquierda=temas nicho (baja centralidad/alta densidad), inferior-derecha=temas básicos (alta centralidad/baja densidad), inferior-izquierda=temas emergentes/decadentes (baja centralidad/baja densidad). Al hacer clic en una burbuja se abre la subred del clúster (`cocPlotClust`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `NetPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Red interactiva subyacente al mapa temático, con los términos agrupados en clústeres y sus enlaces de co-ocurrencia.
- **Desglose:** tipo=red interactiva visNetwork (`igraph2vis()` sobre `TM$net$graph`); nodos=términos del análisis (etiqueta=nombre del término); aristas=co-ocurrencia entre términos, ancho ∝ peso² normalizado (fuerza de asociación), intra-clúster coloreadas por su clúster e inter-clúster en gris; color de nodo=clúster temático (community detection); tamaño de nodo ∝ grado del nodo (atributo `deg`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `TMTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos del análisis y sus métricas (clúster asignado, frecuencia, centralidad y densidad).
- **Origen de datos:** `values$TM$words` (de `thematicMap()`, sin las columnas Color y Cluster_Frequency).
- **Columnas:** `Occurrences` (nº de ocurrencias del término), `Words` (término), `Cluster` (clúster asignado), `Cluster_Label` (etiqueta representativa del clúster), `Cluster_PageRank` (PageRank del término), `Score` (puntuación usada para elegir la etiqueta del clúster), `Freq` (frecuencia), y luego las medidas de centralidad del término en la red (`btw_centrality` = intermediación, `clos_centrality` = cercanía, `pagerank_centrality` = PageRank). Las columnas 5–7 (Cluster_PageRank, Score, Freq) se muestran como numéricas redondeadas.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Thematic_Map_Terms_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Clusters
- **Tipo de contenido:** tabla (`uiOutput` → `TMTableCluster`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla resumen por clúster temático, con sus indicadores agregados (centralidad, densidad, frecuencia y etiquetas representativas).
- **Origen de datos:** `values$TM$clusters` (de `thematicMap()`, reordenado y renombrado en `server.R`). Encabezado adicional: Community Detection Modularity (Q).
- **Columnas:** `Cluster` (etiqueta/nombre del clúster con sus términos representativos), `CallonCentrality` (centralidad de Callon), `CallonDensity` (densidad de Callon), `RankCentrality` (centralidad normalizada por rango = eje X del mapa), `RankDensity` (densidad normalizada por rango = eje Y del mapa), `ClusterFrequency` (frecuencia total del clúster). Las columnas 2–3 (CallonCentrality, CallonDensity) se muestran como numéricas redondeadas.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Thematic_Map_Clusters_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Documents
- **Tipo de contenido:** tabla (`uiOutput` → `TMTableDocument`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de documentos asociados a los clústeres temáticos identificados en el mapa.
- **Origen de datos:** `values$TM$documentToClusters` (asignación difusa de documentos a clústeres vía `clusterAssignment()`, umbral 0.5).
- **Columnas:** `DOI` (enlace clicable a doi.org), `Authors` (AU), `Title` (TI), `Source` (SO), `Year` (año de publicación, PY), `TotalCitation` (citas totales, TC), `TCperYear` (citas por año), `NTC` (citas totales normalizadas), `SR` (short reference / ID del documento), luego una columna por clúster con la probabilidad (0–1) de pertenencia del documento a ese clúster (nombre = etiqueta del clúster; nº de columnas no determinable estáticamente, depende del nº de clústeres), `Assigned_cluster` (clúster al que se asigna el documento si p ≥ 0.5), y `pagerank` (PageRank total de los términos del documento).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Thematic_Map_Documents_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
