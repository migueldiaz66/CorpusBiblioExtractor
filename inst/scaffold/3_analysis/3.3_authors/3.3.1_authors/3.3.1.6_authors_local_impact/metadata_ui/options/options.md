# Options — Authors' Local Impact (`authorImpact`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 4211–4339). Ruta de menú: ANALYSIS › Authors › Authors' Local Impact.

## Botones (encabezado)
- **Run / Apply** (`applyHAuthors`) — `actionBttn`; ejecuta el análisis.
- **Report** (`reportAI`) — `actionBttn`; añade el resultado al informe.

## Main Configuration
- **Impact Measure** (dropdown · `HmeasureAuthors`) — `selectInput`; opciones: `H-Index` = `h`, `G-Index` = `g`, `M-Index` = `m`, `Total Citation` = `tc` · default: `h`.
- **Number of Authors** (entero · `Hkauthor`) — `numericInput`; sin min/max/step definidos en `ui.R` · default: `10`.

## Export
- **Plot (imagen)** (`AIplot.save`) — `downloadBttn`; descarga el gráfico.
