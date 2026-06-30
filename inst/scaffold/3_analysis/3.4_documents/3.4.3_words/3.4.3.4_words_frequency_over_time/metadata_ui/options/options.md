# Options — Words' Frequency over Time (`wordDynamics`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6586–6875). Ruta de menú: ANALYSIS › Documents › Words › Words' Frequency over Time.

## Botones (encabezado)
- **Run / Apply** (`applyWD`)
- **Report** (`reportWD`)
- **Export (descarga del gráfico)** (`WDplot.save`)

## Main Configuration
- **Field** (dropdown · `growthTerms`) — opciones: Keywords Plus=`ID`, Author's keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB` · default: `KW_Merged`.
- **N-Grams** (dropdown · `growthTermsngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.growthTerms == 'AB' | input.growthTerms == 'TI'`)*: solo visible cuando el campo es Abstracts o Titles.

## Text Editing (box colapsable, colapsado por defecto)
### Stop Words
- **Load a list of terms to remove** (dropdown · `WDStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.WDStopFile == 'Y'`)*:
    - **Upload file** (archivo · `WDStop`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `WDSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `WDSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.WDSynFile == 'Y'`)*:
    - **Upload file** (archivo · `WDSyn`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `WDSynSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.

## Parameters (box colapsable, colapsado por defecto)
- **Occurrences** (dropdown · `cumTerms`) — opciones: Cumulate=`Cum`, Per year=`noCum` · default: `Cum`.
- **Number of words** (slider de rango · `topkw`) — rango: min 1, max 100, step 1 · default: `c(1, 10)` (rango 1–10).

## Export
- **Plot (descarga)** (`WDplot.save`)
