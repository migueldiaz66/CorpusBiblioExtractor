# Options — Filters (`filters`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 1999–2220). Ruta de menú: APPRAISAL › Filters.

## Botones (encabezado)
- **Apply** (botón de acción / actionBttn · `applyFilter`)
- **Reset** (botón de acción / actionBttn · `resetFilter`)
- **Data** (botón de acción / actionBttn · `viewDataFilter`)

## 1. General (box)
- **Document Type** (dropdown / selectizeInput · `selectType`) — opciones: dinámicas (`choices = NULL`, se rellenan en servidor) · selección múltiple: sí · default: ninguno.
- **Language** (dropdown / selectizeInput · `selectLA`) — opciones: dinámicas (`choices = NULL`) · selección múltiple: sí · default: ninguno.
- **Publication Year** (slider · `sliderPY`) — min: 1900, max: 2025, value: `c(2000, 2025)` (rango).
- **Subject Category** (multi-select / multiInput · `subject_category`) — opciones: dinámicas (`choices = character(0)`) · default: `NULL`.

## 2. (J) Journal (box)
- **Upload a List of Journals** (archivo / fileInput · `journal_list_upload`) — tipos aceptados: `.txt`, `.csv`, `.xlsx`.
- **Upload a Journal Ranking List** (archivo / fileInput · `journal_ranking_upload`) — tipos aceptados: `.csv`, `.xlsx`.
- **Source by Bradford Law Zones** (dropdown / selectInput · `bradfordSources`) — opciones: "Core Sources" (`core`), "Core + Zone 2 Sources" (`zone2`), "All Sources" (`all`) · default: `all`.

## 3. (AU) Author's Country (box)
- **Region** (dropdown / selectInput · `region`) — opciones: "Africa" (`AFRICA`), "Asia" (`ASIA`), "Europe" (`EUROPE`), "North America" (`NORTH AMERICA`), "South America" (`SOUTH AMERICA`), "Seven Seas" (`SEVEN SEAS (OPEN OCEAN)`), "Oceania" (`OCEANIA`), "Unknown" (`Unknown`) · selección múltiple: sí · default: todas las regiones seleccionadas.
- **Country** (multi-select / multiInput · `country`) — opciones: dinámicas (`choices = character(0)`) · default: `NULL`.

## 4. (DOC) Documents (box)
- **Total Citations** (slider · `sliderTC`) — min: 0, max: 500, value: `c(0, 500)` (rango).
- **Total Citations per Year** (slider · `sliderTCpY`) — min: 0, max: 100, value: `c(0, 100)` (rango).
