# Options — Most Frequent Words (`mostFreqWords`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5639–5903). Ruta de menú: ANALYSIS › Documents › Words › Most Frequent Words.

## Botones (encabezado)
- **Run / Apply** (`applyMFWords`)
- **Report** (`reportMFW`)
- **Export (descarga del gráfico)** (`MRWplot.save`)

## Main Configuration
- **Field** (dropdown · `MostRelWords`) — opciones: Keywords Plus=`ID`, Author's keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB`, Subject Categories (WoS)=`WC` · default: `KW_Merged`.
- **N-Grams** (dropdown · `MRWngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.MostRelWords == 'AB' | input.MostRelWords == 'TI'`)*: solo visible cuando el campo es Abstracts o Titles.
- **Number of Words** (entero · `MostRelWordsN`) — rango: min 2, max 100, step 1 · default: 10.

## Text Editing (box colapsable, colapsado por defecto)
### Stop Words
- **Load a list of terms to remove** (dropdown · `MostRelWordsStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.MostRelWordsStopFile == 'Y'`)*:
    - **Upload file** (archivo · `MostRelWordsStop`) — acepta: .csv, .txt (text/csv, text/plain) · default: ninguno.
    - **File Separator** (dropdown · `MostRelWordsSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `MRWSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.MRWSynFile == 'Y'`)*:
    - **Upload file** (archivo · `MRWSyn`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `MRWSynSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.

## Export
- **Plot (descarga)** (`MRWplot.save`)
