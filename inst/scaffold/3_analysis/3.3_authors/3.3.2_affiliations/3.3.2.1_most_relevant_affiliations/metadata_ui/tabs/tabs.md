# Tabs — Most Relevant Affiliations (`mostRelAffiliations`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4341–4468). Ruta de menú: ANALYSIS › Authors › Affiliations › Most Relevant Affiliations. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostRelAffiliationsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo con las afiliaciones más relevantes según el número de documentos producidos.
- **Desglose:** tipo=gráfico de puntos/lollipop horizontal (`freqPlot`: geom_segment + geom_point); eje X=Articles (número de documentos); eje Y=Affiliations (nombre de la afiliación, ordenadas de mayor a menor); color=gradiente según el valor (`-Articles`); tamaño=Articles.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostRelAffiliationsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con las afiliaciones más relevantes y su conteo de artículos asociado.
- **Columnas:** `Affiliation`/`Affiliations` (nombre de la afiliación; el encabezado es `Affiliation` cuando se desambigua vía AU_UN con `disAff="Y"`, y `Affiliations` cuando se usa el campo C1 directo), `Articles` (número de documentos de esa afiliación). Fuente: `values$TABAff`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Relevant_Affiliations_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
