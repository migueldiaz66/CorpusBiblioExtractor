# Tabs — Authors' Production over Time (`authorsProdOverTime`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3973–4108). Ruta de menú: ANALYSIS › Authors › Authors' Production over Time. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle verificado en `inst/biblioshiny/server.R` (líneas 7583–7684) y en `bibliometrix::authorProdOverTime()`.

## Plot
- **Tipo de contenido:** figura (plotlyOutput `TopAuthorsProdPlot`)
- **Parámetros propios:** ninguno (la opción `TopAuthorsProdK` —número de autores— está en el desplegable de la cabecera de la página)
- **Qué presenta:** Gráfico temporal de la producción de los autores top: tamaño/intensidad de los puntos por año según número de artículos y citas.
- **Desglose:** tipo=gráfico de dispersión/burbujas temporal (`geom_point` + `geom_line` por autor, con `coord_flip` y renderizado con `plot.ly`, `flip=TRUE`); eje X=`Year` (año de publicación); eje Y=`Author` (top `TopAuthorsProdK` autores, líneas que unen su trayectoria); tamaño=`freq` (n.º de artículos del autor ese año, leyenda "N.Articles"); color/intensidad=transparencia (`alpha`) por `TCpY` (citas totales por año, leyenda "TC per Year"), color base fijo `dodgerblue4` y líneas de trayectoria en `firebrick4`.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table - Production per Year
- **Tipo de contenido:** tabla (uiOutput `TopAuthorsProdTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con la producción anual de cada autor (artículos y citas por año).
- **Columnas:** `Author` (autor), `year` (año), `freq` (n.º de artículos del autor en ese año), `TC` (citas totales de esos artículos), `TCpY` (citas totales por año). Origen: `values$AUProdOverTime$dfAU`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Author_Prod_over_Time_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Table - Documents
- **Tipo de contenido:** tabla (uiOutput `TopAuthorsProdTablePapers`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con el detalle de los documentos asociados a los autores del análisis.
- **Columnas:** `Author` (autor), `year` (año, `PY`), `TI` (título del documento), `SO` (fuente/revista), `DOI` (DOI, renderizado como enlace a doi.org), `TC` (citas totales), `TCpY` (citas por año). Origen: `values$AUProdOverTime$dfPapersAU`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Author_Prod_over_Time_Docs_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
