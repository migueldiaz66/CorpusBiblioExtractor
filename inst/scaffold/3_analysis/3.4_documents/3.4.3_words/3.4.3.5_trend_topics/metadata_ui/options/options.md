# Options — Trend Topics (`trendTopic`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6876–7235). Ruta de menú: ANALYSIS › Documents › Words › Trend Topics.

## Botones (encabezado)
- **Run / Apply** (`applyTrendTopics`)
- **Report** (`reportTT`)
- **Export (descarga del gráfico)** (`TTplot.save`)

## Main Configuration
- **Field** (dropdown · `trendTerms`) — opciones: Keywords Plus=`ID`, Author's keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB` · default: `KW_Merged`.
- **N-Grams** (dropdown · `trendTermsngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.trendTerms == 'TI' | input.trendTerms == 'AB'`)*: solo visible cuando el campo es Titles o Abstracts.
- **Word Stemming** (dropdown · `trendStemming`) — opciones: Yes=`TRUE`, No=`FALSE` · default: `FALSE`.
  - *Condicional (`input.trendTerms == 'TI' | input.trendTerms == 'AB'`)*: solo visible cuando el campo es Titles o Abstracts.
- **Timespan (slider de años)** (slider dinámico · `trendSliderPY`) — generado por servidor vía `uiOutput("trendSliderPY")`; rango/valores dependen de los años del dataset (no definidos en `ui.R`).

## Text Editing (box colapsable, colapsado por defecto)
### Stop Words
- **Load a list of terms to remove** (dropdown · `TTStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TTStopFile == 'Y'`)*:
    - **Upload file** (archivo · `TTStop`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `TTSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `TTSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.TTSynFile == 'Y'`)*:
    - **Upload file** (archivo · `TTSyn`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `TTSynSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.

## Parameters (box colapsable, colapsado por defecto)
- **Word Minimum Frequency** (entero · `trendMinFreq`) — rango: min 0, max 100, step 1 · default: 5.
- **Number of Words per Year** (entero · `trendNItems`) — rango: min 1, max 20, step 1 · default: 3.

## Export
- **Plot (descarga)** (`TTplot.save`)

## Notas
- La pestaña de resultados incluye además **Biblio AI** (`trendTopicsGeminiUI`, salida generada por IA) e **Info & References** (contenido de ayuda), que no son controles configurables.
