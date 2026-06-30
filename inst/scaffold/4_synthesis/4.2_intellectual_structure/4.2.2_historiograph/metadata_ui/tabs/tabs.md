# Tabs — Historiograph (`historiograph`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 10116–10322). Ruta de menú: SYNTHESIS › Intellectual Structure › Historiograph. (Se excluyen "Biblio AI" e "Info & References".)
>
> Desgloses de red/tabla verificados en `inst/biblioshiny/server.R` (líneas 13440–13530), en `hist2vis()` de `inst/biblioshiny/utils.R` y en las columnas de `histData` de `R/histNetwork.R`.

## Network
- **Tipo de contenido:** red interactiva (`visNetworkOutput` → `histPlotVis`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa historiográfico (red de citación directa) que ordena los documentos clave a lo largo del tiempo y muestra la genealogía cronológica de las citas entre ellos.
- **Desglose:** `histPlotVis` = `hist2vis(values$histPlot, ...)$VIS`, sobre el grafo de `bibliometrix::histPlot(histResults, ...)`. **Nodos:** documentos; etiqueta corta o "año: etiqueta" según el parámetro `titlelabel` (`labeltype`); forma `dot`. **Color de nodo:** por clúster (color del layout del historiograph). **Tamaño de nodo:** fijo según el parámetro `histsize` (`nodesize * 2`), no por grado. **Aristas:** citas directas locales entre documentos, color gris; discontinuas si `lty == 2`. Disposición cronológica (eje x del layout según el año del documento). **Tooltip:** Título, DOI (enlace), LCS y GCS.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` → `histTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los documentos incluidos en el historiograph y sus atributos (etiqueta, año, citas locales, etc.).
- **Columnas:** `SR` (identificador de fila del documento, añadido vía `rownames_to_column`), `Paper` (etiqueta del documento), `Title` (título), `Author_Keywords` (palabras clave del autor, campo `DE`), `KeywordsPlus` (Keywords Plus, campo `ID`), `DOI` (enlace DOI), `Year` (año de publicación), `LCS` (Local Citation Score: citas dentro de la colección), `GCS` (Global Citation Score: citas totales), `cluster` (clúster asignado por el color del historiograph). Origen: `values$histResults$histData` (de `histNetwork()`), con `SR` y `cluster` añadidos y `DOI` convertido en hipervínculo en server.R; filas ordenadas por `cluster` y `Year`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Historiograph_Network_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
