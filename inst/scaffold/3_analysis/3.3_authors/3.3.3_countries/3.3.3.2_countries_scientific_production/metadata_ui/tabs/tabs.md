# Tabs — Countries' Scientific Production (`countryScientProd`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4717–4776). Ruta de menú: ANALYSIS › Authors › Countries › Countries' Scientific Production. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura/mapa (plotlyOutput `countryProdPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa mundial coroplético que muestra la producción científica por país según la frecuencia de aparición de cada país.
- **Desglose:** tipo=mapa coroplético mundial (geom_polygon sobre `map_data("world")`, vía `mapworld()`); eje X=long (longitud), eje Y=lat (latitud); color/relleno=Freq (N. de documentos por país; escala continua de #87CEEB a dodgerblue4, países sin datos en gris #grey80). La variable que colorea el mapa es la frecuencia de documentos de cada país.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `countryProdTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con la frecuencia de producción científica por país que respalda el mapa.
- **Columnas:** `Country` (país; renombrado desde `region`), `Freq` (frecuencia/número de documentos asociados al país). Fuente: `values$mapworld$tab`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Country_Production_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
