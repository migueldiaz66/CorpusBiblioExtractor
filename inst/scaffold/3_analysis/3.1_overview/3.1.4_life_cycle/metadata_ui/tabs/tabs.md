# Tabs — Life Cycle (`lifeCycle`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2621–2750). Ruta de menú: ANALYSIS › Overview › Life Cycle. (Se excluyen "Biblio AI" e "Info & References".)

## Summary
- **Tipo de contenido:** contenido dinámico (`uiOutput` con outputId `lifeCycleSummaryUIid`); la pestaña lleva icono de tabla, por lo que presenta un resumen tabular.
- **Parámetros propios:** ninguno.
- **Qué presenta:** resumen del análisis del ciclo de vida de la producción científica (fases/etapas detectadas y métricas asociadas) en formato de tabla/resumen.
- **Desglose:** no es una tabla de columnas sino tarjetas de métricas generadas por `lifeCycleSummaryUI(values$DLC)` a partir del modelo logístico `lifeCycle()`. Indicadores mostrados — Card "Model Overview": `Saturation (K)` (nº de publicaciones de saturación), `Peak Year (tₘ)` (año pico), `Peak Annual` (publicaciones/año en el pico), `Growth Duration (Δₜ)` (años de duración del crecimiento); Card "Model Fit Quality": `R²`, `RMSE`, `AIC`, `BIC`; Card "Current Status": `Last Observed Year`, `Annual Publications`, `Cumulative Total`, `Progress to Saturation` (% de K); además hitos `years_to_50` / `years_to_90` / `years_to_99` (años hasta alcanzar el 50/90/99 % de K).
- **Botones:** ninguno propio; `lifeCycleSummaryUIid` son tarjetas de métricas (no una tabla Bibliobox), por lo que no tiene botón Excel (Run/Report/Export están en el encabezado de la página — ver options.md).

## Plot
- **Tipo de contenido:** figura (dos `plotlyOutput`: `DLCPlotYear` y `DLCPlotCum`), mostrados en dos columnas.
- **Parámetros propios:** ninguno.
- **Qué presenta:** dos gráficos interactivos del ciclo de vida — producción por año (DLCPlotYear) y producción acumulada (DLCPlotCum) — para visualizar las fases del ciclo de vida del campo.
- **Desglose:** generados por `plotLifeCycle(values$DLC, plot_type=...)` (plotly `scatter`).
  - `DLCPlotYear` (plot_type="annual"): tipo=líneas + puntos; eje X=`Year` (año); eje Y=`Publications (Annual)` (publicaciones por año); color/tamaño por serie=ajuste logístico (línea azul `#1f77b4`), pronóstico (línea azul discontinua), observados (marcadores azules tamaño 8) y línea vertical roja discontinua del año pico (`Peak year`). Título "Life Cycle - Annual Publications" (con R² y pico).
  - `DLCPlotCum` (plot_type="cumulative"): tipo=líneas + puntos; eje X=`Year` (año); eje Y=`Cumulative Publications` (publicaciones acumuladas); color/tamaño por serie=ajuste logístico (línea verde `#2ca02c`), pronóstico (línea verde discontinua), observados (marcadores verdes tamaño 8) y líneas de referencia gris punteadas al 50/90/99 % de la saturación K. Título "Cumulative Growth Curve" (con K).
- **Botones:** ninguno propio (Run/Report/Export están en el encabezado de la página — ver options.md).
