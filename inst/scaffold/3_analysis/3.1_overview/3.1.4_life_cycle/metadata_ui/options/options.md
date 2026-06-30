# Options — Life Cycle (`lifeCycle`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2621–2750). Ruta de menú: ANALYSIS › Overview › Life Cycle.

## Botones (encabezado)
- **Run** — Run the Analysis (`applyDLC`)
- **Report** — Add Results to the Report (`reportDLC`)

## Controles
Sin controles configurables en `ui.R` (solo visualización/tabla).

El cuerpo se compone de pestañas: **Summary** (`lifeCycleSummaryUIid`, renderizado en servidor), **Plot** (`DLCPlotYear`, `DLCPlotCum`), **Biblio AI** (`DLCGeminiUI`) e **Info & References**. Hay botón **Run** en el encabezado, pero en `ui.R` no se declaran controles de entrada (selectInput, numericInput, etc.) dentro de esta `tabItem`; cualquier parámetro se gestiona en el servidor.

## Export
- **Export Plot as PNG** (download · `DLCplot.save`)
