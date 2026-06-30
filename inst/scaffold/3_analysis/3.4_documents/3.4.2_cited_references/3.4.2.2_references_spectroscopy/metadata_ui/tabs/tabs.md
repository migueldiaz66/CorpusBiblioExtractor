# Tabs — References Spectroscopy (RPYS) (`ReferenceSpect`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5403–5638). Ruta de menú: ANALYSIS › Documents › Cited References › References Spectroscopy. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `rpysPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Espectrograma RPYS (Reference Publication Year Spectroscopy): número de referencias citadas por año de publicación y su desviación respecto de la mediana móvil, identificando picos históricos.
- **Desglose:** tipo=gráfico de líneas (dos `geom_line`) con puntos y etiquetas de picos (`geom_point` + `geom_text_repel`, vía `rpys()`); eje X=Year (año de publicación de la referencia); eje Y=Cited References (`Citations`, línea negra) y la desviación respecto de la mediana de 5 años (`diffMedian`, línea roja firebrick); color/tamaño=línea negra=Citations, línea roja=diffMedian, puntos rojos (#D6604D) en los 10 picos principales (tamaño fijo=3) con etiqueta del año.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table - RPYS
- **Tipo de contenido:** tabla (uiOutput `rpysTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los valores RPYS por año (número de citas y desviación respecto de la mediana).
- **Columnas:** `Year` (año de publicación de las referencias), `Citations` (número de referencias citadas de ese año), `diffMedian5` (desviación respecto de la mediana móvil de 5 años / backward), `diffMedian2` (desviación respecto de la mediana centrada), `diffMedian` (desviación efectiva seleccionada según `input$rpysMedianWindow`). Fuente: `values$res$rpysTable`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `RPYS_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Table - Cited References
- **Tipo de contenido:** tabla (uiOutput `crTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de las referencias citadas que sustentan el análisis RPYS.
- **Columnas:** `Year` (año de publicación de la referencia), `Google link` (enlace de búsqueda en Google Scholar), `Reference` (referencia citada), `Local Citations` (frecuencia de citación — Freq). Fuente: `values$res$CR` (reordenada a Year, Google link, Reference, Local Citations).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `RPYS_Documents_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Table - Influential References
- **Tipo de contenido:** tabla (uiOutput `rpysSequence`)
- **Parámetros propios:** Type (`rpysInfluential`)
- **Qué presenta:** Tabla de referencias influyentes clasificadas por patrón temporal de citación, filtrable por tipo (Constant Performer, Hot Paper, Life Cycle, Sleeping Beauty, Not Influent).
- **Columnas:** `Year` (año de publicación de la referencia — RPY), `Reference` (referencia citada — CR), `Local Citations` (frecuencia de citación — Freq), `Google link` (enlace de búsqueda en Google Scholar), `Citation Sequence` (secuencia temporal de citación — `sequence`), `Sequence Type` (clasificación del patrón — `Class`: Constant Performer, Hot Paper, Life Cycle, Sleeping Beauty). Fuente: `values$res$Sequences` (vía `sequenceTypes()`), filtrada por `input$rpysInfluential`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `RPYS_InfluentialReferences_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Table - Top 10 Peaks
- **Tipo de contenido:** tabla (uiOutput `rpysPeaks`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los 10 picos más destacados del espectrograma RPYS (años con mayor desviación positiva).
- **Columnas:** `Year` (año del pico), `Reference` (referencia citada más frecuente de ese año), `Local Citations` (frecuencia de citación — Freq). Fuente: `values$res$peaks` (función `rpysPeaks()`: top-10 años por `diffMedian` × top-3 referencias por Freq de cada año).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `RPYS_Top10Peaks_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
