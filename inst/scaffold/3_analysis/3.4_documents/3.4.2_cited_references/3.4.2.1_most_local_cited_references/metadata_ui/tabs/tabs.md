# Tabs — Most Local Cited References (`mostLocalCitRef`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5293–5402). Ruta de menú: ANALYSIS › Documents › Cited References › Most Local Cited References. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `MostCitRefsPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico interactivo de las referencias citadas con mayor frecuencia dentro de la colección analizada.
- **Desglose:** tipo=lollipop horizontal (`geom_segment` desde 0 + `geom_point`, vía `freqPlot()`); eje X=Local Citations (`Citations`); eje Y=References (`Cited References`); color/tamaño=ambos codifican el número de citas (color por gradiente de `-citas`, tamaño proporcional, `scale_radius` 5–12).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `MostCitRefsTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de las referencias más citadas localmente con su número de citas.
- **Columnas:** `Google Scholar` (enlace de búsqueda en Google Scholar para la referencia), `Cited References` (cadena de la referencia citada), `Citations` (número de citas locales / frecuencia). Fuente: `values$TABCitRef` (vía `citations()`; se excluye "ANONYMOUS, NO TITLE CAPTURED").
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Local_Cited_References_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
