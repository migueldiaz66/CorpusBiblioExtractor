# Options — Collaboration Network (`collabNetwork`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 10323–10945). Ruta de menú: SYNTHESIS › Social Structure › Collaboration Network.

## Botones (encabezado)
- **Run / Apply** (`applyCol`)
- **Report** (`reportCOL`)
- **Export / Screenshot** (`screenCOL`)

## Main Configuration
- **Field** (dropdown · `colField`) — opciones: Authors=`COL_AU`, Institutions=`COL_UN`, Countries=`COL_CO` · default: `COL_AU` (Authors).
- **Avoid Label Overlap** (toggle on/off · `colNoOverlap`) — default: on (`TRUE`).

## Method Parameters (box colapsable, `collapsed = TRUE`)
- **Network Layout** (dropdown · `collayout`) — opciones: Automatic layout=`auto`, Circle=`circle`, Fruchterman & Reingold=`fruchterman`, Kamada & Kawai=`kamada`, MultiDimensional Scaling=`mds`, Sphere=`sphere`, Star=`star` · default: `auto`.
- **Clustering Algorithm** (dropdown · `colCluster`) — opciones: None=`none`, Edge Betweenness=`edge_betweenness`, InfoMap=`infomap`, Leading Eigenvalues=`leading_eigen`, Leiden=`leiden`, Louvain=`louvain`, Spinglass=`spinglass`, Walktrap=`walktrap` · default: `louvain`.
- **Normalization Method** (dropdown · `colnormalize`) — opciones: None=`none`, Association=`association`, Jaccard=`jaccard`, Salton=`salton`, Inclusion=`inclusion`, Equivalence=`equivalence` · default: `association`.

### Network Size (subgrupo)
- **Number of Nodes** (entero · `colNodes`) — min: 5, max: 1000, step: 1 · default: 50.
- **Repulsion Force** (entero · `col.repulsion`) — min: 0, max: 1, step: 0.1 · default: 0.5.

### Filtering Options (subgrupo)
- **Remove Isolated Nodes** (dropdown · `col.isolates`) — opciones: Yes=`yes`, No=`no` · default: `yes`.
- **Minimum Number of Edges** (entero · `coledges.min`) — min: 0, step: 1 · default: 1.
- **Exclude articles with > 20 authors** (toggle on/off · `col.filterMaxAuthors`) — default: off (`FALSE`). Filtra los artículos hiperautorados (>20 autores) del análisis.

## Graphical Parameters (box colapsable, `collapsed = TRUE`)

### Visual Appearance (subgrupo)
- **Opacity** (entero · `colAlpha`) — min: 0, max: 1, step: 0.05 · default: 0.7.
- **Number of Labels** (entero · `colLabels`) — min: 0, max: 1000, step: 1 · default: 1000.

### Label Settings (subgrupo)
- **Label Scaling (cex)** (dropdown · `collabel.cex`) — opciones: Yes, No · default: Yes.
- **Label Size** (entero · `collabelsize`) — min: 0.0, max: 20, step: 0.10 · default: 2.

### Node & Edge Settings (subgrupo)
- **Node Shape** (dropdown · `col.shape`) — opciones: Box=`box`, Circle=`circle`, Dot=`dot`, Ellipse=`ellipse`, Square=`square`, Text=`text` · default: `dot`.
- **Edge Size** (entero · `coledgesize`) — min: 0.5, max: 20, step: 0.5 · default: 5.
- **Node Shadow** (dropdown · `col.shadow`) — opciones: Yes, No · default: Yes.
- **Edit Nodes** (dropdown · `soc.curved`) — opciones: Yes, No · default: No.

## Export
- **Pajek** (`network.col`)
- **HTML** (`networkCol.fig`)

## Controles adicionales (pestaña «Diachronic Network»)
> Estos controles están en el área de contenido (no en el panel Options), dentro de la pestaña Diachronic Network.
- **Start** (botón · `start_col`)
- **Pause / Resume** (botón · `pause_col`)
- **Reset** (botón · `reset_col`)
- **Export** (UI dinámica · `export_colUI`)
- **Speed (ms)** (dropdown · `speed_col`) — opciones: 250 … 2000 (paso 250) · default: 500.
