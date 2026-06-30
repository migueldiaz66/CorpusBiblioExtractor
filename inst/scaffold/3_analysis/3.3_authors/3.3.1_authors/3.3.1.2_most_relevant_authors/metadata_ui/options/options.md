# Options — Most Relevant Authors (`mostRelAuthors`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3597–3726). Ruta de menú: ANALYSIS › Authors › Most Relevant Authors.

## Botones (encabezado)
- **Run / Apply** (`applyMRAuthors`) — `actionBttn`; ejecuta el análisis.
- **Report** (`reportMRA`) — `actionBttn`; añade el resultado al informe.

## Main Configuration
- **Frequency Measure** (dropdown · `AuFreqMeasure`) — `selectInput`; opciones: `N. of Documents` = `t`, `N. of Documents (%)` = `p`, `N. of Documents (Fractionalized)` = `f` · default: `t`.
- **Number of Authors** (entero · `MostRelAuthorsK`) — `numericInput`; rango: min `1`, step `1` (sin máximo) · default: `10`.

## Export
- **Plot (imagen)** (`MRAplot.save`) — `downloadBttn`; descarga el gráfico.
