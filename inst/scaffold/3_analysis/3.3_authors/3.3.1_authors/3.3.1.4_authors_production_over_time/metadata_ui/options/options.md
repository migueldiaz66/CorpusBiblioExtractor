# Options — Authors' Production over Time (`authorsProdOverTime`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3973–4107). Ruta de menú: ANALYSIS › Authors › Authors' Production over Time.

## Botones (encabezado)
- **Run / Apply** (`applyAUoverTime`) — `actionBttn`; ejecuta el análisis.
- **Report** (`reportAPOT`) — `actionBttn`; añade el resultado al informe.

## Main Configuration
- **Number of Authors** (entero · `TopAuthorsProdK`) — `numericInput`; sin min/max/step definidos en `ui.R` · default: `10`.

## Export
- **Plot (imagen)** (`APOTplot.save`) — `downloadBttn`; descarga el gráfico.

---

Notas: la vista incluye pestañas de solo visualización (`Plot` → `TopAuthorsProdPlot`, `Table - Production per Year`, `Table - Documents`, y una pestaña **Biblio AI** → `ApotGeminiUI`). Ningún control configurable adicional.
