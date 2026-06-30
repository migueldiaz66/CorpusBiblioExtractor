# Tabs — WordCloud (`wcloud`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5904–6321). Ruta de menú: ANALYSIS › Documents › Words › WordCloud. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** nube de palabras (wordcloud2Output, `wordcloud`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Nube de palabras interactiva donde el tamaño de cada término refleja su frecuencia (o la medida de ocurrencia elegida) en el campo seleccionado.
- **Desglose:** tipo=nube de palabras (wordcloud2, vía `wordlist()`); palabras=términos del campo seleccionado (`Terms`); tamaño=valor de la columna `Frequency` transformada según la medida elegida (`input$measure`: identity, sqrt, log o log10); color=color único seleccionado por el usuario (`input$wcCol`); forma, fuente y rotación configurables por el usuario.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput, `wordTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos representados en la nube y sus valores de ocurrencia/frecuencia.
- **Columnas:** `Terms` (término del campo seleccionado), `Frequency` (frecuencia/número de ocurrencias del término, sin transformar).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Frequent_Words_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
