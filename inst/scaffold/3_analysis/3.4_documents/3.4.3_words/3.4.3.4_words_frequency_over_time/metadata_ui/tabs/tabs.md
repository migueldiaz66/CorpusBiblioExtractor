# Tabs — Words' Frequency over Time (`wordDynamics`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6586–6875). Ruta de menú: ANALYSIS › Documents › Words › Words' Frequency over Time. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput, `kwGrowthPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de líneas interactivo con la evolución temporal de la frecuencia (acumulada o anual) de los términos seleccionados a lo largo de los años.
- **Desglose:** tipo=gráfico de líneas (ggplot, geom_line); eje X=`Year` (año); eje Y=`Freq`, ocurrencias anuales o acumuladas según `input$cumTerms` (etiqueta "Annual occurrences" o "Cumulate occurrences"); color=`Term` (un trazo/línea por cada término seleccionado).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput, `kwGrowthtable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las ocurrencias de cada término por año, que sustenta la curva de crecimiento mostrada en el gráfico.
- **Columnas:** `Year` (año) y una columna por cada término seleccionado, cuyo nombre es el propio término y cuyos valores son sus ocurrencias anuales o acumuladas en ese año. (Los nombres de las columnas de términos no son determinables estáticamente; dependen de los datos, vía `KeywordGrowth()`.)
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Word_Dynamics_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
