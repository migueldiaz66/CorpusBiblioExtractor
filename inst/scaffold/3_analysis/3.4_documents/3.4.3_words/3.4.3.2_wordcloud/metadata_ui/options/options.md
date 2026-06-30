# Options — WordCloud (`wcloud`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 5904–6321). Ruta de menú: ANALYSIS › Documents › Words › WordCloud.

## Botones (encabezado)
- **Run / Apply** (`applyWordCloud`)
- **Report** (`reportWC`)
- **Screenshot / Export** (`screenWC`)

## Main Configuration
- **Field** (dropdown · `summaryTerms`) — opciones: Keywords Plus=`ID`, Author's keywords=`DE`, All Keywords=`KW_Merged`, Titles=`TI`, Abstracts=`AB`, Subject Categories (WoS)=`WC` · default: `KW_Merged`.
- **N-Grams** (dropdown · `summaryTermsngrams`) — opciones: Unigrams=`1`, Bigrams=`2`, Trigrams=`3` · default: `1`.
  - *Condicional (`input.summaryTerms == 'AB' | input.summaryTerms == 'TI'`)*: solo visible cuando el campo es Abstracts o Titles.
- **Number of Words** (entero · `n_words`) — rango: min 10, max 500, step 1 · default: 50.

## Text Editing (box colapsable, colapsado por defecto)
### Stop Words
- **Load a list of terms to remove** (dropdown · `WCStopFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.WCStopFile == 'Y'`)*:
    - **Upload file** (archivo · `WCStop`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `WCSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.
### Synonyms
- **Load a list of synonyms** (dropdown · `WCSynFile`) — opciones: Yes=`Y`, No=`N` · default: `N`.
  - *Condicional (`input.WCSynFile == 'Y'`)*:
    - **Upload file** (archivo · `WCSyn`) — acepta: .csv, .txt · default: ninguno.
    - **File Separator** (dropdown · `WCSynSep`) — opciones: Comma `","`, Semicolon `";"`, Tab `"\t"` · default: `,`.

## Parameters (box colapsable, colapsado por defecto)
- **Word occurrence by** (dropdown · `measure`) — opciones: Frequency=`freq`, Square root=`sqrt`, Log=`log`, Log10=`log10` · default: `freq`.
- **Shape** (dropdown · `wcShape`) — opciones: Circle=`circle`, Cardiod=`cardioid`, Diamond=`diamond`, Pentagon=`pentagon`, Star=`star`, Triangle-forward=`triangle-forward`, Triangle=`triangle` · default: `circle`.
- **Font type** (dropdown · `font`) — opciones: Impact, Comic Sans MS, Arial, Arial Black, Tahoma, Verdana, Courier New, Georgia, Times New Roman, Andale Mono · default: Impact (primera opción).
- **Text colors** (dropdown · `wcCol`) — opciones: Random Dark=`random-dark`, Random Light=`random-light` · default: `random-dark`.
- **Font size** (entero/decimal · `scale`) — rango: min 0.1, max 5, step 0.1 · default: 0.5.
- **Ellipticity** (entero/decimal · `ellipticity`) — rango: min 0, max 1, step 0.05 · default: 0.65.
- **Padding** (entero · `padding`) — rango: min 0, max 5, step 1 · default: 1.
- **Rotate** (entero · `rotate`) — rango: min 0, max 20, step 1 · default: 0.

## Export
- Sin `downloadButton`/`downloadBttn`. La exportación es por captura de pantalla mediante el botón **Screenshot / Export** (`screenWC`).
