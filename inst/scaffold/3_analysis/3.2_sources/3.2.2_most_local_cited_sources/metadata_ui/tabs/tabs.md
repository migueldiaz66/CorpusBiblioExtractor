# Tabs — Most Local Cited Sources (`localCitedSources`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3124–3235). Ruta de menú: ANALYSIS › Sources › Most Local Cited Sources. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostRelCitSourcesPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de barras interactivo con las fuentes más citadas localmente (citas dentro de la colección analizada).
- **Desglose:** tipo=lollipop/dot horizontal (`freqPlot()`: `geom_segment` desde 0 + `geom_point`, renderizado con `plot.ly`); eje X=`N. of Local Citations` (columna `Articles`); eje Y=`Cited Sources` (nombre de fuente citada, truncado a 50 caracteres); color/tamaño=gradiente por magnitud (`color = -Articles`, `size = Articles`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostRelCitSourcesTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las fuentes más citadas localmente y su número de citas locales.
- **Columnas:** `Sources` (nombre de la fuente citada; `names()` de `tableTag(values$M, "CR_SO")`), `Articles` (número de citas locales recibidas por la fuente; `as.numeric()` del conteo). Origen: `values$TABSoCit` en `MLCSources()` (previo `metaTagExtraction(M, "CR_SO")`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Cited_Sources_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
