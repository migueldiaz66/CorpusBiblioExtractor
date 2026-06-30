# Options — Thematic Map (`thematicMap`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 8192–8630). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Thematic Map.

## Botones (encabezado)
- **Run / Apply** (`applyTM`) — actionBttn.
- **Report** (`reportTM`) — actionBttn.
- **Export** (`TMplot.save`) — downloadBttn (descarga del gráfico).

## Main Configuration
- **Field** (dropdown · `TMfield`) — opciones: Keywords Plus=`ID`, Author's Keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB` · default: `KW_Merged`.
  - *Condicional (`input.TMfield == 'TI' | input.TMfield == 'AB'`)*: **N-Grams** (dropdown · `TMngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.TMfield == 'TI' | input.TMfield == 'AB'`)*: **Word Stemming** (dropdown · `TMstemming`) — opciones: Yes=`TRUE`, No=`FALSE` · default: `FALSE`.
- **Avoid Label Overlap** (toggle on/off · `noOverlapTM`) — default: `TRUE` (on).

## Text Editing (box colapsable, colapsado)
### Stop Words
- **Load a list of terms to remove** (dropdown · `TMStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TMStopFile == 'Y'`)*:
    - **Upload de archivo** (archivo · `TMStop`) — acepta: `.csv`, `.txt` (single file).
    - **File Separator** (dropdown · `TMSep`) — opciones: Comma `,`, Semicolon `;`, Tab `\t` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `TMapSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TMapSynFile == 'Y'`)*:
    - **Upload de archivo** (archivo · `TMapSyn`) — acepta: `.csv`, `.txt` (single file).
    - **File Separator** (dropdown · `TMapSynSep`) — opciones: Comma `,`, Semicolon `;`, Tab `\t` · default: `,`.

## Parameters (box colapsable, colapsado)
### Data Parameters
- **Number of Words** (entero · `TMn`) — min: 50, max: 5000, default: 250, step: 1.
- **Min Cluster Frequency (per thousand docs)** (entero · `TMfreq`) — min: 1, max: 100, default: 5, step: 1.
- **α Parameter (Balancing Occurrence vs. Centrality)** (entero/decimal · `TMalpha`) — min: 0, max: 1, default: 0.5, step: 0.1.
### Display Parameters
- **Number of Labels** (entero · `TMn.labels`) — min: 0, max: 10, default: 3, step: 1.
- **Label Size** (entero/decimal · `sizeTM`) — min: 0.0, max: 1, default: 0.3, step: 0.05.
### Network Parameters
- **Community Repulsion** (entero/decimal · `TMrepulsion`) — min: 0, max: 1, default: 0.5, step: 0.1.
- **Clustering Algorithm** (dropdown · `TMCluster`) — opciones: None=`none`, Edge Betweenness=`edge_betweenness`, InfoMap=`infomap`, Leading Eigenvalues=`leading_eigen`, Leiden=`leiden`, Louvain=`louvain`, Spinglass=`spinglass`, Walktrap=`walktrap` · default: `louvain`.

## Export
- (Sin caja Export en el panel de opciones; la exportación del gráfico se realiza con el botón de encabezado **Export** `TMplot.save`.)
