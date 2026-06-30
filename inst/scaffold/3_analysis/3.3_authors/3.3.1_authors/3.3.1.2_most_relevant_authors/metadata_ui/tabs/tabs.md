# Tabs — Most Relevant Authors (`mostRelAuthors`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3597–3727). Ruta de menú: ANALYSIS › Authors › Most Relevant Authors. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle verificado en `inst/biblioshiny/server.R` (líneas 7170–7285).

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostRelAuthorsPlot`)
- **Parámetros propios:** ninguno (las opciones —`AuFreqMeasure`, `MostRelAuthorsK`— están en el desplegable de la cabecera de la página)
- **Qué presenta:** Gráfico de barras con los autores más relevantes según la medida de frecuencia elegida (n.º de documentos, %, o fraccionalizado).
- **Desglose:** tipo=gráfico tipo lollipop horizontal (segmento + punto, vía `freqPlot()` renderizado con `plot.ly`, `flip=FALSE`); eje X=medida de frecuencia seleccionada en `AuFreqMeasure` (`t`="N. of Documents", `p`="N. of Documents (in %)", `f`="N. of Documents (Fractionalized)"); eje Y=`Authors` (top `MostRelAuthorsK`, orden descendente por valor); color/tamaño=magnitud del valor (gradiente de color por `-valor` y radio del punto proporcional al valor).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (uiOutput `MostRelAuthorsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los autores más relevantes y su recuento de artículos según la medida seleccionada.
- **Columnas:** `Author` (nombre del autor; renombrado desde `Authors`), `Articles` (n.º de documentos del autor), `Articles Fractionalized` (n.º de documentos fraccionalizado por nº de coautores). Origen: data.frame `values$TABAu` (agregación de `M$AU` por autor con `summarize(Articles = n(), AuthorFrac = sum(fracAU))`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Relevant_Authors_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
