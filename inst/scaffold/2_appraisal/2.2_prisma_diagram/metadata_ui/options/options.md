# Options — PRISMA Diagram (`prisma`)

> Opciones extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2221–2386). Ruta de menú: APPRAISAL › PRISMA Diagram.

## Botones (encabezado)
- **Export** (EXPORT / downloadBttn · `prismaPlot.save`) — descarga el diagrama PRISMA (configurado vía `do.call("downloadBttn", export_bttn)`).
- **Report** (botón de acción / actionBttn · `reportPrisma`) — añade el resultado al Report (configurado vía `do.call("actionBttn", report_bttn)`).

## Identification (box)
- **Database Name** (texto / textInput · `prisma_db_name`) — default: `"Web of Science"` · placeholder: "e.g. Web of Science, Scopus".
- **Search Query / Topic** (texto / textInput · `prisma_query`) — default: `""` · placeholder: "e.g. TS=(bibliometrics)".
- **Total Records Retrieved** (entero / numericInput · `prisma_n_total`) — min: 0, value: 0.
- **Other Source Description** (texto / textInput · `prisma_other_source`) — default: `""` · placeholder: "e.g. Records from Scopus" · subgrupo "Additional Source (optional)".
- **Records from Other Source** (entero / numericInput · `prisma_n_other`) — min: 0, value: 0 · subgrupo "Additional Source (optional)".

## Screening & Eligibility Steps (box)
- *(Pasos de filtrado añadidos dinámicamente en `prisma_steps_container`; cada paso se crea en servidor.)*
- **Add Step** (botón de acción / actionBttn · `prisma_add_step`).
- **Remove Last Step** (botón de acción / actionBttn · `prisma_remove_step`).

## Acciones
- **Generate PRISMA Diagram** (botón de acción / actionBttn · `prisma_generate`).
