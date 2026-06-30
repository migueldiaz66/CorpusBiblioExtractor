# Tabs — Corresponding Author's Countries (`correspAuthorCountry`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4583–4716). Ruta de menú: ANALYSIS › Authors › Countries › Corresponding Author's Countries. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostRelCountriesPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de los países del autor de correspondencia, distinguiendo publicaciones de un solo país (SCP) y de colaboración multinacional (MCP).
- **Desglose:** tipo=gráfico de barras apiladas horizontal (geom_bar stat="identity" + coord_flip); eje X=Country (país, eje categórico que queda en vertical tras el flip); eje Y=Freq (N. de documentos); color/relleno=Collaboration (categorías SCP y MCP).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostRelCountriesTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los países del autor de correspondencia y sus conteos de artículos SCP/MCP.
- **Columnas:** `Country` (país del autor de correspondencia), `Articles` (total de documentos), `Articles %` (porcentaje sobre el total), `SCP` (Single Country Publications), `MCP` (Multiple Country Publications), `MCP %` (porcentaje de MCP sobre los artículos del país). Fuente: `values$TABCo`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Relevant_Countries_By_Corresponding_Author_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
