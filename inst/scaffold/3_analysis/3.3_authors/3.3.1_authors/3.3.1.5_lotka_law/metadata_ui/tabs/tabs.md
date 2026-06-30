# Tabs — Lotka's Law (`lotka`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4109–4210). Ruta de menú: ANALYSIS › Authors › Lotka's Law. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle verificado en `inst/biblioshiny/server.R` (líneas 7704–7885) y en `bibliometrix::lotka()`.

## Plot
- **Tipo de contenido:** figura (plotlyOutput `lotkaPlot`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Curva de productividad de autores según la Ley de Lotka, comparando la distribución observada frente a la teórica.
- **Desglose:** tipo=gráfico de líneas (`geom_line` + `geom_point`, vía `lotka()$g_shiny` renderizado con `plot.ly`, `flip=FALSE`); eje X=`Documents Written` (n.º de documentos escritos, `N.Articles`); eje Y=`% of Authors` (porcentaje de autores, `Freq*100`); color/series=tres curvas — empírica (negra sólida `#1a1a1a` con puntos), teórica de Lotka β=2 (roja discontinua `#D6604D`), modelo ajustado con β empírico (azul punto-raya `#2171B5`).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md).

## Table
- **Tipo de contenido:** tabla (uiOutput `lotkaTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con la distribución de frecuencias: número de autores por número de documentos publicados (observado vs. esperado).
- **Columnas:** `Documents written` (n.º de documentos publicados, `N.Articles`), `N. of Authors` (n.º de autores con esa producción, `N.Authors`), `Proportion of Authors` (proporción de autores sobre el total, `Freq`). Origen: `values$lotka$AuthorProd`.
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Lotka_Law_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.

## Summary
- **Tipo de contenido:** dinámico (uiOutput `lotkaSummary`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Resumen estadístico del ajuste de la Ley de Lotka (constante beta, prueba de bondad de ajuste y parámetros asociados).
- **Desglose del resumen (HTML con `values$lotka$stat`):**
  - **Modelo Lotka (ley de potencia inversa f(n) = C / n^β):** `Estimated β (slope)` (`Beta`), `Theoretical β` (=2.0000), `Constant (C)` (`C`), `R²` (`R2`).
  - **Test KS 1 — Empírica vs Teórica (β=2):** estadístico `KS Statistic (D)` (`ks.theo.stat`), `p-value` (`ks.theo.pvalue`) e interpretación coloreada (consistente / desviación según p ≥ 0.05).
  - **Test KS 2 — Empírica vs Ajustada (β empírico):** `KS Statistic (D)` (`ks.fit.stat`), `p-value` (`ks.fit.pvalue`) e interpretación coloreada.
  - **Plot Legend:** leyenda de las tres líneas del gráfico (negra sólida=empírica; roja discontinua=teórica β=2; azul punto-raya=ajustada β).
- **Botones:** ninguno propio (resumen HTML, no tabla Bibliobox; Run/Report/Export en el encabezado — ver options.md).
