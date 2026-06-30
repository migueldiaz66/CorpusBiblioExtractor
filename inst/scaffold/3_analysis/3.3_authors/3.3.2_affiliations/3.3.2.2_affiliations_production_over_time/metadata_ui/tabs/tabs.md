# Tabs — Affiliations' Production over Time (`AffOverTime`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4469–4582). Ruta de menú: ANALYSIS › Authors › Affiliations › Affiliations' Production over Time. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `AffOverTimePlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de la evolución temporal de la producción de las principales afiliaciones a lo largo de los años.
- **Desglose:** tipo=gráfico de líneas (geom_line); eje X=Year (año); eje Y=Articles (conteo acumulado de documentos); color=Affiliation (una línea por afiliación, etiquetas truncadas a 35 caracteres en la leyenda).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `AffOverTimeTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con la producción anual acumulada por afiliación que respalda el gráfico de evolución.
- **Columnas:** `Affiliation` (nombre de la afiliación), `Year` (año), `Articles` (número de documentos acumulado hasta ese año). Fuente: `values$AffOverTime` (vía `AffiliationOverTime()`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Affiliation_over_Time_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
