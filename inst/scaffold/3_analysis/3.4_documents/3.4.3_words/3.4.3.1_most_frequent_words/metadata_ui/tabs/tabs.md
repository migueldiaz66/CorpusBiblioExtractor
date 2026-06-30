# Tabs — Most Frequent Words (`mostFreqWords`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5639–5903). Ruta de menú: ANALYSIS › Documents › Words › Most Frequent Words. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput, `MostRelWordsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de barras interactivo con los términos más frecuentes del campo seleccionado, ordenados por número de ocurrencias.
- **Desglose:** tipo=gráfico de barras horizontal tipo "lollipop" (geom_segment + geom_point, vía `freqPlot()`); eje X=`Occurrences` (número de ocurrencias del término); eje Y=términos del campo seleccionado (`Words`; la etiqueta del eje es el campo: Keywords Plus / Author's Keywords / All Keywords / Title's Words / Abstract's Words / Subject Categories); color/tamaño=magnitud de ocurrencias del término (a mayor ocurrencia, punto mayor).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput, `MostRelWordsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos más frecuentes y su frecuencia de aparición en la colección.
- **Columnas:** `Words` (término del campo seleccionado), `Occurrences` (número de ocurrencias/frecuencia del término en la colección).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Frequent_Words_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
