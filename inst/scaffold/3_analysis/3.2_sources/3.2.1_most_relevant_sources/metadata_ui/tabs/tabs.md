# Tabs — Most Relevant Sources (`relevantSources`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3014–3123). Ruta de menú: ANALYSIS › Sources › Most Relevant Sources. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostRelSourcesPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de barras interactivo con las fuentes (revistas) más relevantes por número de documentos publicados.
- **Desglose:** tipo=lollipop/dot horizontal (`freqPlot()`: `geom_segment` desde 0 + `geom_point`, renderizado con `plot.ly`); eje X=`N. of Documents` (columna `Articles`); eje Y=`Sources` (nombre de fuente, truncado a 50 caracteres); color/tamaño=gradiente por magnitud (`color = -Articles`, `size = Articles`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostRelSourcesTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las fuentes más relevantes y su recuento de artículos.
- **Columnas:** `Sources` (nombre de la fuente/revista; renombrada de `SO`), `Articles` (número de documentos publicados en la fuente; conteo `group_by(SO) %>% count()` ordenado descendente). Origen: `values$TABSo` en `MRSourcesResult()`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Relevant_Sources_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
