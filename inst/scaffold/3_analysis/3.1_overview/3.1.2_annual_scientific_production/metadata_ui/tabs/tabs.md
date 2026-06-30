# Tabs — Annual Scientific Production (`annualScPr`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2495–2556). Ruta de menú: ANALYSIS › Overview › Annual Scientific Production. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (`plotlyOutput` con outputId `AnnualProdPlot`).
- **Parámetros propios:** ninguno.
- **Qué presenta:** gráfico interactivo de la producción científica anual (número de documentos publicados por año).
- **Desglose:** tipo=gráfico de líneas (ggplot `geom_line` renderizado a plotly vía `plot.ly`); eje X=`Year` (año de publicación, PY); eje Y=`Articles`/`Freq` (nº de documentos publicados ese año); color/tamaño=serie única (línea negra, sin codificación por color ni tamaño). Título "Annual Scientific Production". Datos: `descriptive(values, type="tab2")`.
- **Botones:** ninguno propio (Run/Report/Export están en el encabezado de la página — ver options.md).

## Table
- **Tipo de contenido:** tabla (`uiOutput` con outputId `AnnualProdTable`).
- **Parámetros propios:** ninguno.
- **Qué presenta:** tabla con el número de artículos publicados por cada año, base de los datos del gráfico.
- **Columnas:** `Year` (año de publicación), `Articles` (nº de documentos publicados ese año; los años sin producción se rellenan con 0). Fuente: `values$TAB` de `descriptive(values, type="tab2")` (`group_by(PY) %>% count() %>% rename(Year=PY, Articles=n)`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Annual_Production_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
