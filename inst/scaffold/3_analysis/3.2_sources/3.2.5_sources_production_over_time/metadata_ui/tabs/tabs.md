# Tabs — Sources' Production over Time (`sourceDynamics`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3466–3596). Ruta de menú: ANALYSIS › Sources › Sources' Production over Time. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `soGrowthPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de líneas interactivo con la evolución temporal de la producción de las fuentes principales (acumulada o por año).
- **Desglose:** tipo=gráfico de líneas (`ggplot` + `geom_line`, vía `plot.ly`); eje X=`Year` (año); eje Y=`Cumulate occurrences` si `input$cumSO == "Cum"`, o `Annual occurrences` en caso contrario (columna `Freq`); color=`Source` (una línea por fuente; leyenda ordenada por valor máximo descendente y etiquetas truncadas a 35 caracteres). Datos: `values$SODF` (Year, Source, Freq); fuentes seleccionadas por el rango `input$topSO`.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `soGrowthtable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con el número de artículos por fuente y año a lo largo del periodo analizado.
- **Columnas:** `Year` (año) y una columna por cada fuente top seleccionada (nombre de la fuente como cabecera; conteo anual de documentos, acumulado si `cdf = TRUE`). Formato ancho. Origen: `values$PYSO` (`sourceGrowth(values$M, top = input$topSO[2], cdf = ...)`; nombres de columna = `c("Year", sonames)`, no determinables estáticamente al depender de las fuentes del corpus).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Source_Prod_over_Time_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
