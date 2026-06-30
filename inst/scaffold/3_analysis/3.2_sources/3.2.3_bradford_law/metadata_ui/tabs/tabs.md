# Tabs — Bradford's Law (`bradford`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3236–3335). Ruta de menú: ANALYSIS › Sources › Bradford's Law. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput `bradfordPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Gráfico de la Ley de Bradford que muestra la dispersión de artículos entre fuentes y delimita la zona de fuentes núcleo (core sources).
- **Desglose:** tipo=curva acumulada (línea+puntos) con bandas de zona (`bradford()$graph_shiny`, ggplot vía `plot.ly`); eje X=`Source log(Rank)` (logaritmo del rango de la fuente); eje Y=`Cumulative N. of Articles` (`cumFreq`); color=fondo sombreado por `Zone` (Zone 1=#2171B5, Zone 2=#6BAED6, Zone 3=#BDD7E7) con líneas divisorias punteadas; además curva empírica negra y línea teórica ajustada (`Theoretical`, discontinua roja). Subtítulo: `C(r) = a + b·log(r)`, R2, multiplicador de Bradford k y p-valor KS.
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput `bradfordTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla de fuentes ordenadas con su frecuencia, frecuencia acumulada y zona de Bradford asignada.
- **Columnas:** `SO` (nombre de la fuente), `Rank` (rango por productividad decreciente), `Freq` (n.º de artículos en la fuente), `cumFreq` (n.º acumulado de artículos), `Zone` (zona de Bradford asignada: Zone 1/Zone 2/Zone 3, cada una ~1/3 de los artículos). Origen: `values$bradford$table` (función `bradford(values$M)`, subconjunto `df[, c("SO","Rank","Freq","cumFreq","Zone")]`).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Bradford_Law_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Summary
- **Tipo de contenido:** dinámico (uiOutput `bradfordSummary`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Resumen de las fuentes núcleo identificadas según la Ley de Bradford.
- **Desglose:** bloque HTML generado a partir de `values$bradford$stat` y `values$bradford$zoneSummary`: modelo de distribución `C(r) = a + b·log(r)` (coeficientes `a`, `b`), R2, multiplicador de Bradford `k`, e interpretación del test de bondad de ajuste Kolmogorov-Smirnov (`ks.pvalue`; verde si p≥0.05, rojo si p<0.05). La tabla `zoneSummary` resume por zona las columnas `Zone`, `N. Sources`, `% Sources`, `N. Articles`, `% Articles` (más fila `Total`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)
