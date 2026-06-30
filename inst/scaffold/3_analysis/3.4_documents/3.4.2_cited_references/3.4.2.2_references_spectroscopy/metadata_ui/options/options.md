# Options — References Spectroscopy (RPYS) (`ReferenceSpect`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5403–5638). Ruta de menú: ANALYSIS › Documents › Cited References › References Spectroscopy.

## Botones (encabezado)
- **Run / Apply** (`applyRPYS`)
- **Report** (`reportRPYS`)
- **Export** (`RSplot.save`)

## Main Configuration
- **Median Window** (dropdown · `rpysMedianWindow`) — opciones: Centered (Marx et al., 2014) = `centered`, Backward (bibliometrix) = `backward` · default: `backward`.
- **Field Separator Character** (dropdown · `rpysSep`) — opciones: `;`, `.  ` (punto + espacios), `,` · default: `;`.

## Time Slice
- **Starting Year** (entero · `rpysMinYear`) — opciones: paso (step) = 1, sin min/max definidos · default: NA (vacío).
- **End Year** (entero · `rpysMaxYear`) — opciones: paso (step) = 1, sin min/max definidos · default: NA (vacío).

## Controles en pestañas (no en el panel Options)
- **Type** (dropdown · `rpysInfluential`) — ubicado dentro de la pestaña *Table - Influential References*. Opciones: Constant Performer, Hot Paper, Life Cycle, Sleeping Beauty, Not Influent · default: `Hot Paper`.

## Export
- **Plot (descarga de imagen)** (`RSplot.save`)
