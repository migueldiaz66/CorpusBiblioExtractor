# Options — Author Profile (`AuthorPage`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 3728–3861). Ruta de menú: ANALYSIS › Authors › Author Profile.

## Botones (encabezado)

Sin botones de encabezado (Run/Report/Export). Esta página no usa el patrón estándar `actionBttn`/`downloadBttn` del encabezado; los controles están en un panel lateral (`box`) a la derecha.

## Search Author (panel lateral · box)
- **Search Auhtor** (dropdown · `authorSearch`) — `selectizeInput`; opciones: `choices = NULL` (se rellenan dinámicamente desde el servidor con la lista de autores) · default: ninguno.
- **Apply** (botón · `authorPageApply`) — `actionButton` con icono *play*; aplica la búsqueda y genera el perfil del autor seleccionado.
- **Reset** (botón · `authorPageAReset`) — `actionButton` con icono *remove*; limpia la selección.
- **Export profile card as PNG** (botón · `exportAuthorCard`) — `actionButton` con icono *download*; exporta la tarjeta de perfil del autor como PNG.

## Export
- **Tarjeta de perfil (PNG)** (`exportAuthorCard`) — exportación mediante `actionButton` (no `downloadButton`), genera un PNG de la tarjeta del autor.

---

Notas: la vista principal se organiza en pestañas (`Global Profile` → `AuthorBioPageUI`, `Local Profile` → `AuthorLocalProfileUI`, `Info & References`), todas de solo visualización. El único control configurable es el buscador de autor (`authorSearch`).
