# Tabs — Most Local Cited Documents (`mostLocalCitDoc`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5146–5292). Ruta de menú: ANALYSIS › Documents › Most Local Cited Documents. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostLocCitDocsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de los documentos más citados localmente (dentro de la colección analizada).
- **Desglose:** tipo=lollipop horizontal (`geom_segment` desde 0 + `geom_point`, vía `freqPlot()`); eje X=Local Citations (LCS); eje Y=Documents (`Document`/SR); color/tamaño=ambos codifican las citas locales (color por gradiente de `-citas`, tamaño proporcional, `scale_radius` 5–12).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostLocCitDocsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de los documentos más citados localmente con sus métricas de citación local.
- **Columnas:** `Paper` (identificador del documento — SR), `DOI` (enlace DOI clicable), `Year` (año de publicación — PY), `Local Citations` (citas dentro de la colección — LCS), `Global Citations` (citas globales — GCS), `LC/GC Ratio (%)` (proporción LCS/GCS ×100), `Normalized Local Citations` (LCS/media de LCS del año — NLCS), `Normalized Global Citations` (GCS/media de GCS del año — NGCS). Fuente: `values$TABLocDoc` (vía `localCitations()`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Local_Cited_Documents_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
