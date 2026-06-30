# Tabs — Trend Topics (`trendTopic`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6876–7235). Ruta de menú: ANALYSIS › Documents › Words › Trend Topics. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput, `trendTopicsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de temas tendencia que ubica cada término en su año mediano de aparición, con barras de cuartiles y tamaño según frecuencia, para identificar la evolución de los tópicos.
- **Desglose:** tipo=gráfico de dispersión de puntos con segmentos de cuartiles (ggplot, geom_point + geom_segment, con `coord_flip`, vía `fieldByYear()`); ejes (tras coord_flip): términos (`item`) en un eje y año (`year`) en el otro; cada punto se ubica en el año mediano del término (`year_med`); segmento=rango intercuartílico del año, de Q1 a Q3 (`year_q1`–`year_q3`); tamaño del punto=`freq` (frecuencia del término); color=fijo (dodgerblue4).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput, `trendTopicsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos tendencia y sus años de referencia (frecuencia, año mediano y cuartiles) que respaldan el gráfico.
- **Columnas:** `Term` (término, =item), `Frequency` (frecuencia del término, =freq), `Year (Q1)` (primer cuartil del año, =year_q1), `Year (Median)` (año mediano de aparición, =year_med), `Year (Q3)` (tercer cuartil del año, =year_q3).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `TrendTopic_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
