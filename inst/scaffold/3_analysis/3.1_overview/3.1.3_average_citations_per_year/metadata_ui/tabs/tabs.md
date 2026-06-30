# Tabs — Average Citations per Year (`averageCitPerYear`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2557–2620). Ruta de menú: ANALYSIS › Overview › Average Citations per Year. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (`plotlyOutput` con outputId `AnnualTotCitperYearPlot`).
- **Parámetros propios:** ninguno.
- **Qué presenta:** gráfico interactivo de la media de citas por año, mostrando la evolución del impacto de las publicaciones a lo largo del tiempo.
- **Desglose:** tipo=gráfico de líneas (ggplot `geom_line` renderizado a plotly vía `plot.ly`); eje X=`Year` (año de publicación, PY); eje Y=`MeanTCperYear` (media de citas por año = `MeanTCperArt` / (año_actual+1 − PY)); color/tamaño=serie única (línea negra, sin codificación por color ni tamaño). Título "Average Citations per Year". Datos: `values$AnnualTotCitperYear`.
- **Botones:** ninguno propio (Run/Report/Export están en el encabezado de la página — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` con outputId `AnnualTotCitperYearTable`).
- **Parámetros propios:** ninguno.
- **Qué presenta:** tabla con los valores de citas medias por año (citas medias por artículo y por año), datos de soporte del gráfico.
- **Columnas:** `Year` (año de publicación, PY), `MeanTCperArt` (media de citas totales por artículo en ese año), `N` (nº de documentos publicados ese año), `MeanTCperYear` (media de citas por año = `MeanTCperArt` dividido por los años citables), `CitableYears` (años transcurridos desde la publicación = año_actual+1 − PY). Fuente: `values$AnnualTotCitperYear` (`group_by(PY) %>% summarize(MeanTCperArt, N) %>% mutate(MeanTCperYear, CitableYears) %>% rename(Year=PY)`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Annual_Total_Citation_per_Year_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
