# Options — Import or Load (`loadData`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 1090–1471). Ruta de menú: SEARCH › Data › Import or Load.

## Botones (encabezado)
- *(Sin botones de encabezado independientes; los botones de acción están integrados en el panel de opciones, ver más abajo.)*

## Import or Load (opción principal)
- **Please, choose what to do** (dropdown · `load`) — opciones: " " (`null`), "Import raw file(s)" (`import`), "Load bibliometrix file(s)" (`load`), "Use a sample collection" (`demo`) · default: `null`.

## Demo collection — *Condicional (`load` = "Use a sample collection" / demo)*
- **Choose a sample dataset:** (opción múltiple / radioButtons · `demoDataset`) — opciones: "Sample Collection (bibliometrix package)" (`bibliometrix_sample`), "Book Dataset (from GitHub)" (`book_dataset`) · default: `bibliometrix_sample`.
  - *Condicional (`demoDataset` = bibliometrix_sample)*: solo muestra texto descriptivo del dataset "Management" (sin control configurable).
  - *Condicional (`demoDataset` = book_dataset)*: solo muestra texto descriptivo del dataset "Book Collection" (sin control configurable).

## Database and Format — *Condicional (`load` = "Import raw file(s)" / import)*
- **Database** (dropdown · `dbsource`) — opciones: "Web of Science (WoS/WoK)" (`isi`), "Scopus" (`scopus`), "Dimensions" (`dimensions`), "Openalex" (`openalex`), "OpenAlex API (via openalexR)" (`openalex_api`), "Lens.org" (`lens`), "PubMed" (`pubmed`), "Cochrane Library" (`cochrane`) · default: `isi`.
- **Author Name Format** (dropdown · `authorName`) — opciones: "Fullname (if available)" (`AF`), "Surname and Initials" (`AU`) · default: `AU`.
  - *Condicional (`dbsource` = openalex O openalex_api)*: **Download and resolve cited references from OpenAlex** (toggle on/off / checkboxInput · `importFetchRefs`) — default: `FALSE`.
    - *Condicional (`importFetchRefs` = true)*: **(sin etiqueta)** (opción múltiple / radioButtons · `importRefsFilter`) — opciones: "Only references cited more than once (faster)" (`multiple`), "All references (complete but slower)" (`all`) · default: `multiple`.

## File upload — *Condicional (`load` ≠ null Y `load` ≠ demo, es decir import o load)*
- **Choose a file** (archivo / fileInput · `file1`) — tipos aceptados: `.csv`, `.txt`, `.ciw`, `.bib`, `.xlsx`, `.zip`, `.xls`, `.rdata`, `.rda`, `.rds` · selección múltiple: no.
  - *Condicional (`load` = load)*: solo muestra nota informativa ("Load a collection in XLSX or R format previously exported from bibliometrix").

## Start / acciones
- **Start** (botón de acción / actionBttn · `applyLoad`) — *Condicional (`load` ≠ null)*.
- **Missing Data** (botón de acción / actionBttn · `showMissingData`).

## Export
- **Save as:** (dropdown · `save_file`) — opciones: " " (`null`), "Excel" (`xlsx`), "R Data Format" (`RData`) · default: `null`.
- **Export** (EXPORT / downloadBttn · `collection.save`) — *Condicional (`save_file` ≠ null)*.
