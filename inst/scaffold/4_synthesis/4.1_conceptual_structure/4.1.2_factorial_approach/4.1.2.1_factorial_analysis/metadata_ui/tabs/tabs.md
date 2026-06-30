# Tabs — Factorial Analysis (`factorialAnalysis`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 9258–9630). Ruta de menú: SYNTHESIS › Conceptual Structure › Factorial Approach › Factorial Analysis. (Se excluyen "Biblio AI" e "Info & References".)

Los controles de configuración (método, campo, parámetros gráficos, etc.) están en el menú desplegable "Options" de la cabecera, no dentro de las pestañas; por ello ninguna pestaña de salida tiene parámetros propios.

> Detalle verificado en `inst/biblioshiny/server.R` (outputs `CSPlot1`/`CSPlot4`/`CSTableW`/`CSTableD` ~l.11721–11781; construcción de `WData`/`CSData` ~l.11614–11669) y en `conceptualStructure()` (`bibliometrix/R/`), `ca2plotly()` y `dend2vis()` (`inst/biblioshiny/utils.R`). Los datos provienen de `values$CS` (resultado de `conceptualStructure`).

## Word Map
- **Tipo de contenido:** figura (`plotlyOutput` `CSPlot1`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa conceptual de los términos sobre el plano factorial (resultado del CA/MCA/MDS), con los términos coloreados por clúster temático.
- **Desglose:** Diagrama de dispersión plotly (`type = "scatter"`, `mode = "markers"`, vía `ca2plotly` sobre `values$plotCS`). Eje X = "Dim 1 (xx%)" y eje Y = "Dim 2 (yy%)", donde xx/yy son el porcentaje de varianza explicada en CA/MCA (en MDS los ejes son simplemente "Dim 1"/"Dim 2"). Cada punto es un término, posicionado por sus coordenadas (`Dim1`, `Dim2`); el tamaño del marcador ∝ contribución del término a los ejes (`dotSize` = contribución + tamaño base); el color del marcador = clúster del término (`km.res$cluster`, paleta `colorlist()`); las etiquetas de texto son los términos (solo se muestran los que superan el umbral de contribución; se ocultan los solapamientos); se dibuja un polígono de envolvente convexa (convex hull) por clúster cuando hay más de un clúster; hover = término + valor de "Contribute".
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Topic Dendrogram
- **Tipo de contenido:** red (`visNetworkOutput` `CSPlot4`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Dendrograma del agrupamiento jerárquico de los términos, mostrando cómo se combinan los temas en clústeres.
- **Desglose:** Dendrograma de clustering jerárquico (`hclust`, `CS$km.res`) renderizado como visNetwork horizontal/jerárquico (vía `dend2vis` sobre `values$dendCS`). Nodos hoja del grupo "word" = términos (cajas etiquetadas con el término); nodos internos del grupo "group" = uniones de clúster (puntos grises; el tooltip muestra la inercia/altura de fusión). Aristas = ramas del dendrograma, coloreadas por clúster según el corte `cutree = nclusters` (paleta `colorlist()`); la altura/inercia codifica la distancia de fusión entre temas (eje horizontal de la jerarquía).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Words by Cluster
- **Tipo de contenido:** tabla (`uiOutput` `CSTableW`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Lista de los términos asignados a cada clúster del análisis factorial, con sus coordenadas/contribuciones.
- **Columnas:** `word` (término/keyword), `Dim1` (coordenada del término en la dimensión 1 del plano factorial, redondeada a 2 decimales), `Dim2` (coordenada en la dimensión 2), `cluster` (clúster asignado al término). (Fuente: `values$CS$WData`, construido a partir de `CS$km.res$data.clust`; en `method = "MDS"` la estructura es análoga: `word`, `Dim1`, `Dim2`, `cluster`.)
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `CoWord_Factorial_Analysis_Words_By_Cluster_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Articles by Cluster
- **Tipo de contenido:** tabla (`uiOutput` `CSTableD`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Documentos más representativos de cada clúster, según su proximidad al centroide en el plano factorial.
- **Columnas:** `Documents` (identificador / referencia corta del documento), `dim1` (coordenada del documento en la dimensión 1, redondeada a 2 decimales), `dim2` (coordenada en la dimensión 2), `contrib` (contribución del documento a los ejes factoriales). (Fuente: `values$CS$CSData` = `CS$docCoord` con la fila de nombres como columna `Documents`; con `method = "MDS"` esta tabla no se calcula y queda vacía.)
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `CoWord_Factorial_Analysis_Articles_By_Cluster_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
