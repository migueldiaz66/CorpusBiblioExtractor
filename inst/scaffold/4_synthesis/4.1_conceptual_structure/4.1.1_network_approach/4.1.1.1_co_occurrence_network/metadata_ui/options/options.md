# Options — Co-occurrence Network (`coOccurenceNetwork`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 7503–8191). Ruta de menú: SYNTHESIS › Conceptual Structure › Network Approach › Co-occurrence Network.

## Botones (encabezado)
- **Run / Apply** (`applyCoc`) — actionBttn.
- **Report** (`reportCOC`) — actionBttn.
- **Screenshot / Export** (`screenCOC`) — actionBttn.

## Main Configuration
- **Field** (dropdown · `field`) — opciones: Keywords Plus=`ID`, Author's Keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB`, Subject Categories (WoS)=`WC` · default: `KW_Merged`.
  - *Condicional (`input.field == 'TI' | input.field == 'AB'`)*: **N-Grams** (dropdown · `cocngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
- **Avoid Label Overlap** (toggle on/off · `noOverlap`) — default: `TRUE` (on).

## Text Editing (box colapsable, colapsado)
### Stop Words
- **Load a list of terms to remove** (dropdown · `COCStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.COCStopFile == 'Y'`)*:
    - **Upload de archivo** (archivo · `COCStop`) — acepta: `.csv`, `.txt` (single file).
    - **File Separator** (dropdown · `COCSep`) — opciones: Comma `,`, Semicolon `;`, Tab `\t` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `COCSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.COCSynFile == 'Y'`)*:
    - **Upload de archivo** (archivo · `COCSyn`) — acepta: `.csv`, `.txt` (single file).
    - **File Separator** (dropdown · `COCSynSep`) — opciones: Comma `,`, Semicolon `;`, Tab `\t` · default: `,`.

## Method Parameters (box colapsable, colapsado)
- **Network Layout** (dropdown · `layout`) — opciones: Automatic layout=`auto`, Circle=`circle`, Fruchterman & Reingold=`fruchterman`, Kamada & Kawai=`kamada`, MultiDimensional Scaling=`mds`, Sphere=`sphere`, Star=`star` · default: `auto`.
- **Clustering Algorithm** (dropdown · `cocCluster`) — opciones: None=`none`, Edge Betweenness=`edge_betweenness`, InfoMap=`infomap`, Leading Eigenvalues=`leading_eigen`, Leiden=`leiden`, Louvain=`louvain`, Spinglass=`spinglass`, Walktrap=`walktrap` · default: `louvain`.
- **Normalization Method** (dropdown · `normalize`) — opciones: None=`none`, Association=`association`, Jaccard=`jaccard`, Salton=`salton`, Inclusion=`inclusion`, Equivalence=`equivalence` · default: `association`.
- **Node Color by Year** (dropdown · `cocyears`) — opciones: No=`No`, Yes=`Yes` · default: `No`.

### Network Size
- **Number of Nodes** (entero · `Nodes`) — min: 5, max: 1000, default: 50, step: 1.
- **Repulsion Force** (entero/decimal · `coc.repulsion`) — min: 0, max: 1, default: 0.5, step: 0.1.

### Filtering Options
- **Remove Isolated Nodes** (dropdown · `coc.isolates`) — opciones: Yes=`yes`, No=`no` · default: `yes`.
- **Minimum Number of Edges** (entero · `edges.min`) — min: 0, default: 2, step: 1.

## Graphical Parameters (box colapsable, colapsado)
### Visual Appearance
- **Opacity** (entero/decimal · `cocAlpha`) — min: 0, max: 1, default: 0.7, step: 0.05.
- **Number of Labels** (entero · `Labels`) — min: 0, max: 1000, default: 1000, step: 1.
### Label Settings
- **Label Scaling (cex)** (dropdown · `label.cex`) — opciones: Yes, No · default: `Yes`.
- **Label Size** (entero/decimal · `labelsize`) — min: 0.0, max: 20, default: 3, step: 0.10.
### Node & Edge Settings
- **Node Shape** (dropdown · `coc.shape`) — opciones: Box=`box`, Circle=`circle`, Dot=`dot`, Ellipse=`ellipse`, Square=`square`, Text=`text` · default: `dot`.
- **Edge Size** (entero/decimal · `edgesize`) — min: 0.0, max: 20, default: 5, step: 0.5.
- **Node Shadow** (dropdown · `coc.shadow`) — opciones: Yes, No · default: `Yes`.
- **Edit Nodes** (dropdown · `coc.curved`) — opciones: Yes, No · default: `No`.

## Export
- **Pajek** (`network.coc`) — downloadBttn (formato Pajek `.net`).
- **HTML** (`networkCoc.fig`) — downloadBttn (red interactiva HTML).
