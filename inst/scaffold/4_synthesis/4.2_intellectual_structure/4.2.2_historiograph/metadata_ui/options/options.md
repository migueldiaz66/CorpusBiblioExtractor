# Options — Historiograph (`historiograph`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 10116–10322). Ruta de menú: SYNTHESIS › Intellectual Structure › Historiograph.

## Botones (encabezado)
- **Run / Apply** (`applyHist`)
- **Report** (`reportHIST`)
- **Export / Screenshot** (`screenHIST`)

## Main Configuration
- **Number of Nodes** (entero · `histNodes`) — min: 5, max: 100, step: 1 · default: 20.

## Graphical Parameters (box colapsable, `collapsed = FALSE`)

### Label Configuration (subgrupo)
- **Node Label** (dropdown · `titlelabel`) — opciones: Short id (1st Author, Year)=`short`, Document Title=`title`, Authors' Keywords=`keywords`, Keywords Plus=`keywordsplus` · default: `short`.

### Filtering Options (subgrupo)
- **Remove Isolated Nodes** (dropdown · `hist.isolates`) — opciones: Yes=`yes`, No=`no` · default: `yes`.

### Visual Settings (subgrupo)
- **Label Size** (entero · `histlabelsize`) — min: 0.0, max: 20, step: 1 · default: 3.
- **Node Size** (entero · `histsize`) — min: 0, max: 20, step: 1 · default: 2.

## Export
Sin botones de exportación (download) en `ui.R`. La exportación se realiza desde el botón de encabezado **Export / Screenshot** (`screenHIST`).
