# Tabs — TreeMap (`treemap`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 6322–6585). Ruta de menú: ANALYSIS › Documents › Words › TreeMap. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (plotlyOutput, `treemap`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Mapa de árbol (treemap) interactivo donde cada rectángulo representa un término y su área es proporcional a la frecuencia del término en el campo seleccionado.
- **Desglose:** tipo=treemap (plot_ly, type='treemap'); cada rectángulo=un término (`labels` = columna `Terms`, W[,1]); tamaño/área del rectángulo=`Frequency` (`values` = W[,2], número de ocurrencias, medida "identity"); etiqueta mostrada=label+value+percent entry (término, ocurrencias y porcentaje); jerarquía plana (`parents` = "Tree", un solo nivel raíz).
- **Botones:** ninguno propio (Run/Report/Export en el encabezado — ver options.md)

## Table
- **Tipo de contenido:** tabla (uiOutput, `treeTable`)
- **Parámetros propios:** ninguno
- **Qué presenta:** Tabla con los términos del treemap y sus frecuencias/porcentajes de aparición.
- **Columnas:** `Terms` (término del campo seleccionado), `Frequency` (frecuencia/número de ocurrencias del término).
- **Botones:** **Excel** (`exportToExcel`) — descarga la tabla filtrada a `Most_Frequent_Words_<fecha>.xlsx`; además: filtros por columna, orden por encabezado y paginación.
