# Info & References — Factorial Analysis

> Metadata de biblioshiny 5.4.1, extraída de `inst/biblioshiny/helpContent.R` (clave `factorialAnalysis`).
> Ruta de menú: SYNTHESIS › Conceptual Structure › Factorial Approach › Factorial Analysis · tabName: `factorialAnalysis`

## Resumen (español)

- **Qué es:** el Análisis Factorial aplica técnicas de reducción de dimensionalidad a datos bibliométricos, proyectando relaciones documento-término de alta dimensión en un espacio reducido. El método principal es el Análisis de Correspondencias (CA).
- **Fundamento:** el CA descompone una matriz documento-término y representa simultáneamente documentos (filas) y términos (columnas) en el mismo espacio factorial, revelando la *estructura intelectual* del campo.
- **Conceptos clave:** *inercia* (varianza total, repartida por cada eje), *distancia chi-cuadrado* (apropiada para datos de frecuencia) y *representación dual* (filas y columnas en los mismos ejes).
- **Cómo funciona:** construcción de la matriz documento/autor-término → descomposición en ejes factoriales → proyección sobre los primeros 2-3 ejes → clustering jerárquico opcional sobre las coordenadas factoriales.
- **Parámetros:** campo a analizar, método (CA, MCA), número de términos, número de clústeres y ejes a mostrar.
- **Interpretación:** proximidad = perfiles similares; oposición (lados opuestos del eje) = perfiles contrastantes; puntos cerca del origen = perfiles promedio; los colores indican clústeres jerárquicos; revisar la inercia explicada por cada eje para evaluar la calidad de la representación 2D.
- **Referencias:** Greenacre (2007), Benzecri (1973), Aria & Cuccurullo (2017, 2026), Cuccurullo et al. (2016).

---

## Info & References (original, en inglés)

### 📊 Factorial Analysis

**Factorial Analysis** applies dimensionality reduction techniques to bibliometric data, projecting high-dimensional document-term relationships onto a low-dimensional space for visualization and interpretation. The primary method used is **Correspondence Analysis (CA)**, a multivariate statistical technique particularly suited to analyzing contingency tables and categorical data.

#### 🎓 Theoretical Foundations

**Correspondence Analysis (CA)** decomposes a document-term matrix to identify the principal dimensions of variation in the data. It simultaneously represents both documents (rows) and terms (columns) in the same factorial space, revealing the associations between them.

Key concepts include:

- **Inertia:** The total variance in the data. Each factorial dimension (axis) explains a portion of this inertia.
- **Chi-square distance:** CA uses chi-square distances rather than Euclidean distances, making it particularly appropriate for frequency data.
- **Dual representation:** Both rows (documents/authors) and columns (terms) are projected onto the same axes, enabling direct comparison.

When applied to bibliometric data, CA reveals the **intellectual structure** of a field by identifying the main dimensions along which research topics and authors are organized.

#### 📈 How It Works

1. **Matrix construction:** A document-term (or author-term) co-occurrence matrix is built from the bibliographic data
2. **Decomposition:** Correspondence Analysis decomposes this matrix into factorial axes that capture the most important dimensions of variation
3. **Projection:** Documents and terms are projected onto the first two or three factorial axes
4. **Clustering:** Hierarchical clustering can be applied to the factorial coordinates to group similar documents or terms

#### ⚙️ Parameters and Options

- **Field:** Choose the bibliographic field to analyze (Keywords, Title words, Abstract terms, etc.)
- **Method:** Select from Correspondence Analysis (CA), Multiple Correspondence Analysis (MCA), or related techniques
- **Number of terms:** Control how many terms to include in the analysis
- **Number of clusters:** Define the number of groups for hierarchical clustering on factorial coordinates
- **Axes:** Choose which factorial dimensions to display on the x and y axes

#### 🔍 Interpreting Results

- **Proximity:** Points that are close together in the factorial space have similar profiles (they tend to co-occur with the same terms)
- **Opposition:** Points on opposite sides of an axis represent contrasting profiles or research themes
- **Origin:** Points near the origin have average profiles and are not strongly associated with any particular dimension
- **Axis interpretation:** Each axis represents a dimension of variation; examine which terms are most strongly associated with each axis to interpret its meaning
- **Cluster colors:** Terms grouped by the same color belong to the same hierarchical cluster, representing a coherent thematic group
- **Explained inertia:** Check the percentage of inertia explained by each axis to assess how well the 2D representation captures the overall structure

##### 📚 Key References

**Greenacre, M. J. (2007).** *Correspondence Analysis in Practice* (2nd ed.). London: Chapman and Hall/CRC. [https://doi.org/10.1201/9781420011234](https://doi.org/10.1201/9781420011234)

**Benzecri, J.-P. (1973).** *L'Analyse des Donnees. Volume II: L'Analyse des Correspondances.* Paris: Dunod.

**Aria, M. & Cuccurullo, C. (2017).** *bibliometrix: An R-tool for comprehensive science mapping analysis.* **Journal of Informetrics**, 11(4), 959-975. [https://doi.org/10.1016/j.joi.2017.08.007](https://doi.org/10.1016/j.joi.2017.08.007)

**Aria, M., & Cuccurullo, C. (2026).** *Science Mapping Analysis: A Primer with Biblioshiny.* McGraw-Hill, New York, NY, USA. ISBN: 978-88-386-2297-7.

**Cuccurullo, C., Aria, M., & Sarto, F. (2016).** *Foundations and trends in performance management. A twenty-five years bibliometric analysis in business and public administration domains.* **Scientometrics**, 108(2), 595-611. [https://doi.org/10.1007/s11192-016-1948-8](https://doi.org/10.1007/s11192-016-1948-8)
