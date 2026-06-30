# Options — Thematic Evolution (`thematicEvolution`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 8631–9256). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Evolution.

## Botones (encabezado)
- **Run / Apply** (`applyTE`) — actionBttn que ejecuta el análisis.
- **Report** (`reportTE`) — actionBttn que añade el resultado al reporte.
- **Export** (`TEplot.save`) — downloadBttn que descarga el gráfico.

## Main Configuration
- **Field** (dropdown · `TEfield`) — opciones: Keywords Plus=`ID`, Author's Keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB` · default: `KW_Merged`.
  - *Condicional (`input.TEfield == 'TI' | input.TEfield == 'AB'`)*: **N-Grams** (dropdown · `TEngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
- **Avoid Label Overlap** (toggle on/off · `noOverlapTE`) — default: on (`TRUE`).

## Text Editing (box colapsable, colapsado por defecto)

### Stop Words
- **Load a list of terms to remove** (dropdown · `TEStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TEStopFile == 'Y'`)*:
    - **Upload file** (archivo · `TEStop`) — formatos: `.csv`, `.txt` (text/csv, text/plain).
    - **File Separator** (dropdown · `TESep`) — opciones: Comma `","`=`,`, Semicolon `";"`=`;`, Tab=`\t` · default: `,`.

### Synonyms
- **Load a list of synonyms** (dropdown · `TESynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TESynFile == 'Y'`)*:
    - **Upload file** (archivo · `TESyn`) — formatos: `.csv`, `.txt` (text/csv, text/plain).
    - **File Separator** (dropdown · `TESynSep`) — opciones: Comma `","`=`,`, Semicolon `";"`=`;`, Tab=`\t` · default: `,`.

## Parameters (box colapsable, colapsado por defecto)

### Data Parameters
- **Number of Words** (entero · `nTE`) — rango: min 50, max 5000, step 1 · default: 250.
- **Min Cluster Frequency (per thousand docs)** (entero · `fTE`) — rango: min 1, max 100, step 1 · default: 5.

### Weight Parameters
- **α Parameter (Balancing Occurrence vs. Centrality)** (entero · `TEalpha`) — rango: min 0, max 1, step 0.1 · default: 0.5.
- **Min Weight Index** (entero · `minFlowTE`) — rango: min 0.02, max 1, step 0.02 · default: 0.1.

### Display Parameters
- **Label Size** (entero · `sizeTE`) — rango: min 0.0, max 1, step 0.05 · default: 0.3.
- **Number of Labels (for each cluster)** (entero · `TEn.labels`) — rango: min 1, max 5, step 1 · default: 3.

### Clustering
- **Clustering Algorithm** (dropdown · `TECluster`) — opciones: None=`none`, Edge Betweenness=`edge_betweenness`, InfoMap=`infomap`, Leading Eigenvalues=`leading_eigen`, Leiden=`leiden`, Louvain=`louvain`, Spinglass=`spinglass`, Walktrap=`walktrap` · default: `louvain`.

## Time Slices (box NO colapsable, expandido por defecto)
- **Number of Cutting Points** (entero · `numSlices`) — rango: min 1, max 4 · default: 1.
- Texto guía: "Please, write the cutting points (in year) for your collection".
- **Cutting points** (sliders dinámicos · `sliders`) — `uiOutput` que genera un control de año por cada punto de corte definido en `numSlices`.

## Export
- **Plot** (`TEplot.save`) — descarga del gráfico de evolución temática.
