# Tabs — Countries' Production over Time (`COOverTime`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4777–4890). Ruta de menú: ANALYSIS › Authors › Countries › Countries' Production over Time. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `CountryOverTimePlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de la evolución temporal de la producción de los principales países a lo largo de los años.
- **Desglose:** tipo=gráfico de líneas (geom_line); eje X=Year (año); eje Y=Articles (conteo acumulado de documentos); color=Country (una línea por país).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `CountryOverTimeTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con la producción anual acumulada por país que respalda el gráfico de evolución.
- **Columnas:** `Country` (país), `Year` (año), `Articles` (número de documentos acumulado hasta ese año). Fuente: `values$CountryOverTime` (vía `CountryOverTime()`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Countries_Production_Over_Time_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
