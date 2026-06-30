# Options — Most Local Cited Authors (`mostLocalCitedAuthors`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3863–3971). Ruta de menú: ANALYSIS › Authors › Most Local Cited Authors.

## Botones (encabezado)
- **Run / Apply** (`applyMLCAuthors`) — `actionBttn`; ejecuta el análisis.
- **Report** (`reportMLCA`) — `actionBttn`; añade el resultado al informe.

## Main Configuration
- **Number of Authors** (entero · `MostCitAuthorsK`) — `numericInput`; sin min/max/step definidos en `ui.R` · default: `10`.

## Export
- **Plot (imagen)** (`MLCAplot.save`) — `downloadBttn`; descarga el gráfico.
