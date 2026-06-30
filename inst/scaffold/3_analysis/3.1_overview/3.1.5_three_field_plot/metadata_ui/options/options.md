# Options — Three-Field Plot (`threeFieldPlot`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2751–3013). Ruta de menú: ANALYSIS › Overview › Three-Field Plot.

## Botones (encabezado)
- **Run** — Run the Analysis (`apply3F`)
- **Report** — Add Results to the Report (`reportTFP`)
- **Export Plot as PNG** — botón de captura/screenshot (`screenTFP`)
- **Options** — panel desplegable (icono *sliders*) que agrupa los controles de abajo.

## Main Configuration
- **Middle Field** (dropdown · `CentralField`) — opciones: Authors (`AU`), Affiliations (`AU_UN`), Countries (`AU_CO`), Keywords (`DE`), Keywords Plus (`ID`), All Keywords (`KW_Merged`), Titles (`TI_TM`), Abstract (`AB_TM`), Sources (`SO`), References (`CR`), Cited Sources (`CR_SO`) · default: Authors (`AU`).
- **Number of Items** (entero · `CentralFieldn`) — rango: min 1, max 50, step 1 · default: 20. *(número de ítems del Middle Field)*
- **Left Field** (dropdown · `LeftField`) — opciones: Authors (`AU`), Affiliations (`AU_UN`), Countries (`AU_CO`), Keywords (`DE`), Keywords Plus (`ID`), All Keywords (`KW_Merged`), Titles (`TI_TM`), Abstract (`AB_TM`), Sources (`SO`), References (`CR`), Cited Sources (`CR_SO`) · default: References (`CR`).
- **Number of Items** (entero · `LeftFieldn`) — rango: min 1, max 50, step 1 · default: 20. *(número de ítems del Left Field)*
- **Right Field** (dropdown · `RightField`) — opciones: Authors (`AU`), Affiliations (`AU_UN`), Countries (`AU_CO`), Keywords (`DE`), Keywords Plus (`ID`), All Keywords (`KW_Merged`), Titles (`TI_TM`), Abstract (`AB_TM`), Sources (`SO`), References (`CR`), Cited Sources (`CR_SO`) · default: All Keywords (`KW_Merged`).
- **Number of Items** (entero · `RightFieldn`) — rango: min 1, max 50, step 1 · default: 20. *(número de ítems del Right Field)*

## Export
El botón de exportación es una captura de imagen (`screenTFP`, listado en Botones del encabezado); esta página no usa `downloadBttn`.
