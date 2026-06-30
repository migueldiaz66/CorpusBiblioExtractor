# Options — TreeMap (`treemap`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6322–6585). Ruta de menú: ANALYSIS › Documents › Words › TreeMap.

## Botones (encabezado)
- **Run / Apply** (`applyTreeMap`)
- **Report** (`reportTREEMAP`)
- **Screenshot / Export** (`screenTREEMAP`)

## Main Configuration
- **Field** (dropdown · `treeTerms`) — opciones: Keywords Plus=`ID`, Author's keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB`, Subject Categories (WoS)=`WC` · default: `KW_Merged`.
- **N-Grams** (dropdown · `treeTermsngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.treeTerms == 'AB' | input.treeTerms == 'TI'`)*: solo visible cuando el campo es Abstracts o Titles.
- **Number of Words** (entero · `treen_words`) — rango: min 10, max 200, step 5 · default: 50.

## Text Editing (box colapsable, colapsado por defecto)
### Stop Words
- **Load a list of terms to remove** (dropdown · `TreeMapStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TreeMapStopFile == 'Y'`)*:
    - **Upload file** (archivo · `TreeMapStop`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `TreeMapSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `TreeMapSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TreeMapSynFile == 'Y'`)*:
    - **Upload file** (archivo · `TreeMapSyn`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `TreeMapSynSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.

## Export
- Sin `downloadButton`/`downloadBttn`. La exportación es por captura de pantalla mediante el botón **Screenshot / Export** (`screenTREEMAP`).
