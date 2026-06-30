# Tabs — PRISMA Diagram (`prisma`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2221–2386). Ruta de menú: APPRAISAL › PRISMA Diagram. (Se excluyen "Biblio AI" e "Info & References".)

## PRISMA Diagram
- **Tipo de contenido:** gráfico/figura (estático, `plotOutput("prismaPlotOutput")`, altura 750px, con spinner).
- **Parámetros propios:**
  - "Export" (`prismaPlot.save`) — downloadBttn para descargar el diagrama.
  - "Report" (`reportPrisma`) — actionBttn para añadir al reporte.
  - Identificación: "Database Name" (`prisma_db_name`, textInput), "Search Query / Topic" (`prisma_query`, textInput), "Total Records Retrieved" (`prisma_n_total`, numericInput).
  - Fuente adicional (opcional): "Other Source Description" (`prisma_other_source`, textInput), "Records from Other Source" (`prisma_n_other`, numericInput).
  - Pasos de cribado y elegibilidad: contenedor dinámico `prisma_steps_container`, "Add Step" (`prisma_add_step`, actionBttn), "Remove Last Step" (`prisma_remove_step`, actionBttn).
  - "Generate PRISMA Diagram" (`prisma_generate`) — actionBttn que genera el diagrama.
- **Qué presenta:** Construye y muestra el diagrama de flujo PRISMA (adaptado para estudios bibliométricos), reflejando el número de registros identificados, cribados, evaluados por elegibilidad y finalmente incluidos según los pasos de filtrado definidos por el usuario.
- **Desglose de outputs (verificado en server.R + utils.R):**
  - `prismaPlotOutput` (server.R L5507–5510) — **Figura** (`renderPlot`). Llama `do.call(drawPrismaFlowDiagram, values$prismaParams)`; la función generadora está en `inst/biblioshiny/utils.R` L6857+ (dibujada con el paquete `grid`, no es ggplot/plotly).
- **Desglose:** tipo = diagrama de flujo PRISMA vertical (cajas redondeadas unidas por flechas, dibujado con `grid::grid.roundrect`/`grid.arrow`); título "PRISMA Flow Diagram (adapted for bibliometric studies)".
  - eje Y (flujo de arriba hacia abajo, columna central x≈0.42): fila **Identification** = "Records identified from {db_name} (n = n_total)" con la query en fuente menor (y, si hay fuente adicional, "Records from {other_source} (n = n_other)" y "Total records retrieved (n = n_total + n_other)"); seguidas de una caja por cada **paso** "After {criterion} filter / {values} (n = n_remaining)"; fila final **Included** = "Studies included in the analysis (n = n_included)".
  - eje X / cajas laterales (derecha, x≈0.81): por cada paso una caja de exclusión "Excluded by {criterion} (n = n_excluded)" conectada con línea horizontal.
  - etiquetas de fase a la izquierda (x≈0.09): "Identification", "Screening" y "Eligibility" (la fase de cada paso se asigna por tipo de criterio: duplicate removal / time span / document type → Screening; subject category / language / journal / country / other → Eligibility).
  - color/tamaño = paleta fija (sin codificar variables): cajas de flujo azul claro (relleno `#D6E8F5`, borde `#2B5C8A`), etiquetas de fase azul oscuro (`#1B3A5C`, texto blanco), texto de la query en gris itálica; la altura de cada caja se calcula según el nº de líneas de su etiqueta (no representa una variable). Los valores numéricos (n) provienen de `values$prismaParams` (db_name, query, n_total, other_source, n_other, steps[criterion, values, n_remaining, n_excluded, phase], n_included), generados en server.R a partir de los inputs del usuario.
- **Botones:** propios de la pestaña — **Generate PRISMA Diagram** (`prisma_generate`) construye el diagrama, **Add Step** (`prisma_add_step`) y **Remove Last Step** (`prisma_remove_step`) gestionan los pasos de cribado/elegibilidad, **Export** (`prismaPlot.save`) descarga la figura y **Report** (`reportPrisma`) la añade al reporte. (Run/Report/Export globales también están en el encabezado de la página — ver options.md).
