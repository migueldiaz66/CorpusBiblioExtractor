# Tabs — Most Local Cited Authors (`mostLocalCitedAuthors`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3863–3972). Ruta de menú: ANALYSIS › Authors › Most Local Cited Authors. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle verificado en `inst/biblioshiny/server.R` (líneas 7388–7479) y en `bibliometrix::localCitations()`.

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostCitAuthorsPlot`)
- **Parámetros propios:** ninguno (la opción `MostCitAuthorsK` —número de autores— está en el desplegable de la cabecera de la página)
- **Qué presenta:** Gráfico de barras con los autores más citados localmente (citas recibidas desde otros documentos de la propia colección).
- **Desglose:** tipo=gráfico tipo lollipop horizontal (segmento + punto, vía `freqPlot()` renderizado con `plot.ly`, `flip=FALSE`); eje X=`Local Citations` (citas locales recibidas, columna `LocalCitations`); eje Y=`Authors` (top `MostCitAuthorsK`, orden descendente por citas); color/tamaño=magnitud de las citas locales (gradiente de color por `-valor` y radio del punto proporcional).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (uiOutput `MostCitAuthorsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los autores ordenados por número de citas locales.
- **Columnas:** `Author` (nombre del autor), `LocalCitations` (suma de citas locales —LCS— recibidas por el autor desde documentos de la colección). Origen: `values$TABAuCit` = `localCitations(M)$Authors`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Local_Cited_Authors_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
