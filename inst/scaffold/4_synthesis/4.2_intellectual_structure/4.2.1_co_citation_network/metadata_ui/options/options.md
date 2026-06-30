# Options — Co-citation Network (`coCitationNetwork`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 9631–10115). Ruta de menú: SYNTHESIS › Intellectual Structure › Co-citation Network.

## Botones (encabezado)
- **Run / Apply** (`applyCocit`)
- **Report** (`reportCOCIT`)
- **Export / Screenshot** (`screenCOCIT`)

## Main Configuration
- **Field** (dropdown · `citField`) — opciones: Papers=`CR`, Authors=`CR_AU`, Sources=`CR_SO` · default: `CR` (Papers).
- **Field separator character** (dropdown · `citSep`) — opciones: `";"` (Semicolon), `".   "` (Dot and 3 or more spaces), `","` (Comma) · default: `;` (Semicolon).
- **Avoid Label Overlap** (toggle on/off · `citNoOverlap`) — default: on (`TRUE`).

## Method Parameters (box colapsable, `collapsed = TRUE`)
- **Network Layout** (dropdown · `citlayout`) — opciones: Automatic layout=`auto`, Circle=`circle`, Fruchterman & Reingold=`fruchterman`, Kamada & Kawai=`kamada`, MultiDimensional Scaling=`mds`, Sphere=`sphere`, Star=`star` · default: `auto`.
- **Clustering Algorithm** (dropdown · `cocitCluster`) — opciones: None=`none`, Edge Betweenness=`edge_betweenness`, InfoMap=`infomap`, Leading Eigenvalues=`leading_eigen`, Leiden=`leiden`, Louvain=`louvain`, Spinglass=`spinglass`, Walktrap=`walktrap` · default: `louvain`.

### Network Size (subgrupo)
- **Number of Nodes** (entero · `citNodes`) — min: 5, max: 1000, step: 1 · default: 50.
- **Repulsion Force** (entero · `cocit.repulsion`) — min: 0, max: 1, step: 0.1 · default: 0.5.

### Filtering Options (subgrupo)
- **Remove Isolated Nodes** (dropdown · `cit.isolates`) — opciones: Yes=`yes`, No=`no` · default: `yes`.
- **Minimum Number of Edges** (entero · `citedges.min`) — min: 0, step: 1 · default: 2.

## Graphical Parameters (box colapsable, `collapsed = TRUE`)

### Visual Appearance (subgrupo)
- **Short Label** (dropdown · `citShortlabel`) — opciones: Yes, No · default: Yes.
- **Number of Labels** (entero · `citLabels`) — min: 0, max: 1000, step: 1 · default: 1000.

### Label Settings (subgrupo)
- **Label Scaling (cex)** (dropdown · `citlabel.cex`) — opciones: Yes, No · default: Yes.
- **Label Size** (entero · `citlabelsize`) — min: 0.0, max: 20, step: 0.10 · default: 2.

### Node & Edge Settings (subgrupo)
- **Node Shape** (dropdown · `cocit.shape`) — opciones: Box=`box`, Circle=`circle`, Dot=`dot`, Ellipse=`ellipse`, Square=`square`, Text=`text` · default: `dot`.
- **Edge Size** (entero · `citedgesize`) — min: 0.5, max: 20, step: 0.5 · default: 2.
- **Node Shadow** (dropdown · `cocit.shadow`) — opciones: Yes, No · default: Yes.
- **Edit Nodes** (dropdown · `cocit.curved`) — opciones: Yes, No · default: No.

## Export
- **Pajek** (`network.cocit`)
- **HTML** (`networkCocit.fig`)
