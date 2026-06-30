# Tabs — Three-Field Plot (`threeFieldPlot`)

> Pestañas de salida extraídas de biblioshiny 5.4.1 (`inst/biblioshiny/ui.R`, líneas 2751–3013). Ruta de menú: ANALYSIS › Overview › Three-Field Plot. (Se excluyen "Biblio AI" e "Info & References".)

## Plot
- **Tipo de contenido:** figura (`plotlyOutput` con outputId `ThreeFieldsPlot`).
- **Parámetros propios:** ninguno (los controles de configuración de campos están en la cabecera de la página, dentro de un `dropdown`, fuera de la pestaña: "Middle Field" `CentralField` + "Number of Items" `CentralFieldn`; "Left Field" `LeftField` + `LeftFieldn`; "Right Field" `RightField` + `RightFieldn`).
- **Qué presenta:** diagrama de Sankey de tres campos que relaciona tres dimensiones bibliométricas (p. ej. autores, referencias citadas y palabras clave) mediante flujos, mostrando las conexiones entre los elementos más relevantes de cada campo.
- **Desglose:** tipo=diagrama de Sankey (plotly `type="sankey"`), generado por `threeFieldsPlot(values$M, fields=c(LeftField, CentralField, RightField), n=c(LeftFieldn, CentralFieldn, RightFieldn))`; nodos=los `n` elementos más frecuentes de cada uno de los tres campos, dispuestos por columnas (izquierda=`LeftField`, centro=`CentralField`, derecha=`RightField`); aristas/enlaces=co-ocurrencia entre Left–Middle y Middle–Right, con grosor (`value`/`weight`) = nº de documentos compartidos (peso de co-ocurrencia ≥ 1); color de nodos=paleta tipo Spectral interpolada (`colorRampPalette(c("#9E0142", ..., "#5E4FA2"))` sobre todos los nodos) y agrupados/etiquetados por campo; posición X de cada nodo según su campo/nivel (1=izq, 2=centro, 3=der). No se codifica color/tamaño por una variable de datos más allá del peso del enlace.
- **Botones:** ninguno propio (los controles de campos están en el `dropdown` del encabezado, fuera de la pestaña; Run/Report/Export están en el encabezado de la página — ver options.md).
