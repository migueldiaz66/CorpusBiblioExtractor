# Tabs — Most Cited Countries (`mostCitedCountries`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4891–5019). Ruta de menú: ANALYSIS › Authors › Countries › Most Cited Countries. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostCitCountriesPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de los países más citados, según la medida seleccionada (total de citas o promedio de citas por artículo).
- **Desglose:** tipo=gráfico de puntos/lollipop horizontal (`freqPlot`: geom_segment + geom_point); eje X=N. of Citations (si `measure="TC"`) o Average Article Citations (si se elige el promedio); eje Y=Countries (país, ordenado de mayor a menor); color=gradiente según el valor; tamaño=valor del eje X.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostCitCountriesTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los países más citados y sus valores de citación que respaldan el gráfico.
- **Columnas:** `Country` (país, derivado de AU1_CO), `TC` (Total Citations: suma de citas de los documentos del país), `Average Article Citations` (promedio de citas por artículo = TC / nº de artículos). Fuente: `values$TABCitCo`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Cited_Countries_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
