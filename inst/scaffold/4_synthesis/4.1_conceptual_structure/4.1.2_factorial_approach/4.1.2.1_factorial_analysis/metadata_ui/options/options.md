# Options — Factorial Analysis (`factorialAnalysis`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 9258–9628). Ruta de menú: SYNTHESIS › Conceptual Structure › Factorial Approach › Factorial Analysis.

## Botones (encabezado)
- **Run / Apply** (`applyCA`) — actionBttn que ejecuta el análisis.
- **Report** (`reportFA`) — actionBttn que añade el resultado al reporte.
- **Export** (`FAplot.save`) — downloadBttn que descarga el gráfico.

## Main Configuration
- **Method** (dropdown · `method`) — opciones: Correspondence Analysis=`CA`, Multiple Correspondence Analysis=`MCA`, Multidimensional Scaling=`MDS` · default: `MCA`.
- **Field** (dropdown · `CSfield`) — opciones: Keywords Plus=`ID`, Author's Keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB` · default: `KW_Merged`.
  - *Condicional (`input.CSfield == 'TI' | input.CSfield == 'AB'`)*: **N-Grams** (dropdown · `CSngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.

## Text Editing (box colapsable, colapsado por defecto)

### Stop Words
- **Load a list of terms to remove** (dropdown · `CSStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.CSStopFile == 'Y'`)*:
    - **Upload file** (archivo · `CSStop`) — formatos: `.csv`, `.txt` (text/csv, text/plain).
    - **File Separator** (dropdown · `CSSep`) — opciones: Comma `","`=`,`, Semicolon `";"`=`;`, Tab=`\t` · default: `,`.

### Synonyms
- **Load a list of synonyms** (dropdown · `FASynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.FASynFile == 'Y'`)*:
    - **Upload file** (archivo · `FASyn`) — formatos: `.csv`, `.txt` (text/csv, text/plain).
    - **File Separator** (dropdown · `FASynSep`) — opciones: Comma `","`=`,`, Semicolon `";"`=`;`, Tab=`\t` · default: `,`.

## Method Parameters (box colapsable, colapsado por defecto)
- **Number of Terms** (entero · `CSn`) — step 1 (sin min/max definidos) · default: 50.
- **N. of Clusters** (dropdown · `nClustersCS`) — opciones: `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8` · default: `1`.

## Graphical Parameters (box colapsable, colapsado por defecto)
- **Label Size** (entero · `CSlabelsize`) — rango: min 5, max 30 · default: 10.
- **Num. of Documents** (entero · `CSdoc`) — sin min/max/step definidos · default: 5.

## Export
- **Plot** (`FAplot.save`) — descarga del gráfico de análisis factorial.
