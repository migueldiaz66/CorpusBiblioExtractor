# Tabs — Author Profile (`AuthorPage`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3728–3862). Ruta de menú: ANALYSIS › Authors › Author Profile. (Se excluyen "Biblio AI" e "Info & References".)
> Detalle de contenido verificado en `inst/biblioshiny/server.R` (líneas 7018–7107) y en las funciones de tarjeta de `inst/biblioshiny/utils.R` (`authorCard`, `create_author_bio_card`, `create_local_author_bio_card`).

## Global Profile
- **Tipo de contenido:** dinámico (uiOutput `AuthorBioPageUI`)
- **Parámetros propios:** ninguno (la búsqueda y los botones —`authorSearch`, `authorPageApply`, `authorPageAReset`, `exportAuthorCard`— están en el panel lateral de la página, fuera de las pestañas)
- **Qué presenta:** Ficha de perfil global del autor seleccionado (datos de carrera completa traídos de OpenAlex vía `authorCard()` → `create_author_bio_card()`).
- **Desglose del perfil (tarjeta global):** fuente = OpenAlex (`authorBio`/openalexR).
  - **Cabecera:** nombre (`display_name`), institución (`primary_affiliation` con enlace ROR), país (`primary_affiliation_country`), enlaces a perfil ORCID y OpenAlex.
  - **Bibliometric Indicators** (4 tarjetas): `Publications` (`works_count`), `Citations` (`cited_by_count`), `H-Index` (`h_index`), `2yr Mean Cit.` (`2yr_mean_citedness`).
  - **Métricas adicionales:** `i10-Index` (`i10_index`) y `OpenAlex ID`.
  - **Publication Trends (Last 10 Years):** mini-gráfico de barras del nº de publicaciones por año (`counts_by_year$works_count`, últimos 10 años).
  - **Main Research Topics:** etiquetas (badges) de temas de investigación dimensionadas por frecuencia (`topics$display_name (count)`).
  - **Pie:** fecha de extracción desde OpenAlex (`query_timestamp`).
  - (Requiere conexión a internet; sin trabajos/datos OpenAlex muestra tarjeta vacía vía `create_empty_author_bio_card()`.)
- **Botones:** ninguno en la pestaña; es una tarjeta de perfil (uiOutput, no tabla Bibliobox). Los botones (búsqueda `authorSearch`, `authorPageApply` (Apply), `authorPageAReset` (Reset) y `exportAuthorCard` (Export PNG)) están en el panel lateral, no en la pestaña.

## Local Profile
- **Tipo de contenido:** dinámico (uiOutput `AuthorLocalProfileUI`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Ficha de perfil del autor restringida a la colección local (calculada sobre `values$M` vía `create_local_author_bio_card()`).
- **Desglose del perfil (tarjeta local):** fuente = corpus local (documentos del autor en `values$M`).
  - **Cabecera:** nombre del autor + leyenda "Local Collection Profile".
  - **Local Bibliometric Indicators** (4 tarjetas): `Publications` (nº de documentos locales), `Total Citations` (suma de `TC`), `H-Index (Local)` (h calculado sobre las `TC` locales), `Cit./Year` (media de citas por antigüedad de publicación).
  - **Métricas adicionales:** `Years Active` (rango de `PY`), `Avg Cit./Work` (citas medias por documento), `Recent Activity (5yr)` (nº de docs en los últimos 5 años).
  - **Publication Trends (Last 10 Years):** barras del nº de publicaciones por año (`table(PY)`, últimos 10 años, rellenando años sin producción con 0).
  - **Main Keywords:** etiquetas (badges) de palabras clave del autor (`DE`) dimensionadas por frecuencia.
  - **Publications (N total):** lista desplazable de los trabajos del autor (título `TI`, revista `SO`, año `PY`, citas `TC` y enlace DOI `DI`), ordenados por año descendente.
  - **Pie:** fecha de análisis de la colección local.
- **Botones:** ninguno en la pestaña; es una tarjeta de perfil (uiOutput, no tabla Bibliobox). Los botones (búsqueda `authorSearch`, `authorPageApply` (Apply), `authorPageAReset` (Reset) y `exportAuthorCard` (Export PNG)) están en el panel lateral, no en la pestaña.
