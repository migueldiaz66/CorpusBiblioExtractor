# Tabs — Import or Load (`loadData`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 1090–1471). Ruta de menú: SEARCH › Data › Import or Load. (Se excluyen "Biblio AI" e "Info & References".)

## Import or Load
- **Tipo de contenido:** dinámico (uiOutput). El cuerpo de la pestaña muestra `uiOutput("collection_descriptionUI")` (descripción de la colección) y, con spinner de conversión, `uiOutput("contents")` (la colección importada/cargada renderizada como tabla de registros). El `outputId` "contents" no contiene 'Table'/'Plot'/'fig', por lo que se clasifica como dinámico (uiOutput), aunque en la práctica presenta la colección en formato tabular.
- **Parámetros propios:**
  - "Please, choose what to do" (`load`) — selectInput: Importar archivo(s) crudo(s) / Cargar archivo(s) bibliometrix / Usar colección de muestra.
  - "Choose a sample dataset" (`demoDataset`) — radioButtons (Sample Collection / Book Dataset), visible si `load == 'demo'`.
  - "Database" (`dbsource`) — selectInput (WoS, Scopus, Dimensions, OpenAlex, OpenAlex API, Lens.org, PubMed, Cochrane), visible si `load == 'import'`.
  - "Author Name Format" (`authorName`) — selectInput (Fullname / Surname and Initials).
  - "Download and resolve cited references from OpenAlex" (`importFetchRefs`) — checkboxInput (solo OpenAlex).
  - References filter (`importRefsFilter`) — radioButtons (Only references cited more than once / All references).
  - "Choose a file" (`file1`) — fileInput (.csv, .txt, .ciw, .bib, .xlsx, .zip, .xls, .rdata, .rda, .rds).
  - "Start" (`applyLoad`) — actionBttn que ejecuta la importación/carga.
  - "Missing Data" (`showMissingData`) — actionBttn para inspeccionar datos faltantes.
  - Log de proceso: `uiOutput("textLog2")`.
  - "Save as" (`save_file`) — selectInput (Excel / R Data Format) para exportar la colección.
  - "Export" (`collection.save`) — downloadBttn de descarga de la colección.
- **Qué presenta:** Es la pantalla de entrada de datos: permite importar archivos crudos de bases bibliográficas, cargar una colección previamente exportada o usar una colección de ejemplo, y tras pulsar "Start" muestra la descripción y la tabla de los documentos de la colección convertida al formato bibliometrix, además de permitir exportarla.
- **Desglose de outputs (verificado en server.R):**
  - `contents` (server.R L2320–2355) — **Tabla** (`renderBibliobox`, 3 filas por página, scroll X/Y, filtro superior). Renderiza el data.frame `values$M` (la colección convertida por `convert2df`), truncando cada celda a 150 caracteres. Antepone una columna `DOI` con hipervínculo a doi.org y muestra **todas** las columnas de `values$M`. El conjunto exacto de columnas es dinámico y depende de la base de datos de origen (lo genera `convert2df` en server.R); las columnas/etiquetas (Field Tags) bibliométricas canónicas son las siguientes.
  - `collection_descriptionUI` (server.R L1291–1300) — no es tabla ni figura: renderiza un `textAreaInput` (`collection_description_merge`) para que el usuario escriba una breve descripción de la colección (insumo para el asistente BIBLIO AI).
  - `textLog2` (server.R L3453–3471) — texto/recuadro informativo "Conversion results" que muestra el número de documentos: `Number of Documents = dim(values$M)[1]`.
- **Columnas (tabla `contents`, Field Tags de `values$M`):** `DOI` (DOI como hipervínculo a doi.org; columna añadida al frente), `AU` (autores), `TI` (título del documento), `SO` (fuente/nombre de la revista), `JI`/`J9` (abreviatura de la fuente), `PY` (año de publicación), `DT` (tipo de documento), `DE` (palabras clave del autor), `ID` (Keywords Plus / palabras clave indexadas), `AB` (resumen/abstract), `C1` (afiliaciones/direcciones de autores), `RP` (autor de correspondencia/reprint), `CR` (referencias citadas), `TC` (total de citas), `LA` (idioma), `SC` (categorías temáticas / Science Categories), `DB` (base de datos de origen), `SR` (short reference: primer autor, año, revista); además campos derivados como `AU_UN`/`AU_CO` (universidades/países de autores). (El listado completo y su presencia dependen de la base de datos; se genera dinámicamente en server.R vía `convert2df()`/`metaTagExtraction()`, no es una lista fija.)
- **Botones:** propios de la pestaña — **Start** (`applyLoad`) importa/carga la colección, **Missing Data** (`showMissingData`) abre la inspección de datos faltantes y **Export** (`collection.save`) descarga la colección en el formato elegido en **Save as** (`save_file`: Excel / R Data). La tabla `contents` no lleva botón Excel (button=FALSE): solo permite filtrar/ordenar/paginar. (Run/Report/Export globales están en el encabezado de la página — ver options.md).
