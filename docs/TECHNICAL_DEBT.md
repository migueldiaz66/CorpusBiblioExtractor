# Deuda técnica — extractor + pipeline de barrido exhaustivo

> Registro **consolidado** de la deuda técnica del proyecto de tooling (Fase 1 metadata-extractor +
> Fase 2/3 plan/runner) al cierre de la **sesión 3 (2026-06-30)**. Complementa la retrospectiva de
> madurez y la verificación de paridad del proyecto. Cada ítem documenta:
> **deuda · problema · impacto · por qué atacarla · propuesta(s) de solución**. Nada de esto bloquea
> el uso actual; es el mapa para endurecer de *alfa-tardío/beta-temprano* hacia *beta sólido*.

## Actualización 2026-06-30 (sesión 4) — deuda atendida
Se implementó la suite de pruebas (`tests/`, harness propio sin dependencias). Cambia el estado de:
- **B4 (tests/smoke) → ✅ ATENDIDA.** 47 unit (spec/manifest/savers/extractor) + 29 pipeline
  (smoke/regression/determinism en 49 docs) + e2e(473) opt-in. `Rscript tests/run_tests.R`.
- **T4 (determinismo) → ✅ ATENDIDA.** Test que corre `co_occurrence` 2× y compara el md5 del `.net`.
- **T1 (drift) → PARCIAL.** El snapshot de regresión (`tests/fixtures/snapshots_49.json`) detecta si
  una salida cambia tras actualizar bibliometrix o tocar un runner. **Falta aún** el lock de versión
  (`renv`) y abortar/avisar si `packageVersion("bibliometrix")` difiere de la esperada.
- **B3 (corpus chico)** sigue pendiente, pero los tests lo **aíslan**: `thematic_evolution` se excluye
  del subset de 49 docs (degenera) en vez de tratarse como verde.

Ver `tests/README.md`. El resto del documento queda como mapa de la deuda restante.

**Nueva (beta.1, repo GitHub) — alcance de entrada:** el loader es **solo Web of Science BibTeX**
(`convert2df(dbsource="wos", format="bibtex")`). OpenAlex/Scopus/etc. NO se soportan (OpenAlex ni
siquiera emite `.bib` formato WoS). **Deuda: ingestión multi-fuente** (parametrizar `dbsource`/`format`
en `load_corpus`/`cbe_run`). Además, **no se envían corpus ni salidas de ejemplo** en el repo (serían
datos derivados de WoS, redistribución prohibida): bring-your-own en `assetsbib/`, `runs/` gitignored.

## Cómo leer este documento
- **Severidad** = qué tan mal afecta hoy (Alta/Media/Baja).
- **Esfuerzo** = costo estimado de saldarla (S/M/L ≈ horas / día / varios días).
- **Categorías:** **A. Extractor de metadata** (Fase 1, automatización), **B. Runner** (Fase 3),
  **C. Análisis/decisiones**, **T. Transversal**.

## Matriz de prioridad

| ID | Deuda | Sev. | Esf. | Ataca primero si… |
|---|---|:--:|:--:|---|
| T1 | Sin *version pinning* ni test de regresión vs salida buena conocida | **Alta** | M | vas a actualizar bibliometrix o confiar en el runner a ciegas |
| B3 | Degeneración en corpus chico (errores duros, no "datos insuficientes") | Media | S–M | vas a correr corpus de tamaños variados |
| B2 | Paridad verificada solo en tablas (no figuras/redes ni secciones con cap) | Media | M | necesitas defender fidelidad de figuras en la tesis |
| A4 | Sin enriquecimiento `server.R` (columnas/figuras) en el extractor | Media | L | quieres regenerar `tabs.md` completo automáticamente |
| C1 | Caps `n=50`/`max_terms=50` pragmáticos, no justificados analíticamente | Media | S | vas a reportar resultados de redes/factorial en la tesis |
| A5 | Extractor no emite `.md`/`plan.json` (solo JSON estructural) | Media | M | quieres cerrar el loop metadata→spec automático |
| B4 | Sin tests automáticos / smoke test | Media | M | el proyecto va a crecer o pasar a otra máquina |
| B5 | Rutas *hardcoded* (R lib, `.bib`, `BASE`) | Baja | S | vas a mover el proyecto de máquina |
| A1 | `tabsetPanel` anidados se sobre-cuentan | Baja | S | te molesta el ruido en `ui_metadata.json` |
| A2 | Regla `*Sep` no aplicada en código | Baja | S | un consumidor del JSON no filtra separadores |
| A3 | Mapeo `helpContent()$clave → página` pendiente | Baja | S | quieres regenerar `info_and_reference/` |
| A6 | Cosméticos (choices sin nombre; clasificación de las 42) | Baja | S | pulido final |
| C2 | Three-Field Plot reducido a `default` por explosión combinatoria | Baja | S–M | quieres cobertura de ese análisis |
| T2 | Doble fuente de metadata (manual vs auto) sin plan de reconciliación | Media | M | cuando el extractor empiece a emitir |

---

# A. Extractor de metadata (Fase 1 — `metadata_extractor/`)

## A1 — `tabsetPanel` anidados se sobre-cuentan
- **Deuda:** el extractor cuenta TODOS los `tabPanel` a cualquier profundidad del `tabItem`.
- **Problema:** páginas con sub-pestañas (p. ej. `thematicEvolution`) tienen `tabsetPanel` dentro de
  `tabPanel`; el recorrido los aplana. Resultado: `thematicEvolution` reporta **35 "tabs"** cuando el
  cuerpo real tiene ~3.
- **Impacto:** `ui_metadata.json` exagera el nº de pestañas en ~3 páginas. **No afecta** Fase 2/3 (que
  hoy usan la `metadata_ui` manual), solo la fidelidad del JSON auto-generado.
- **Por qué atacarla:** sin esto, una futura emisión de `tabs.md` (A5) saldría inflada y poco fiable.
- **Propuesta:** tomar **solo el primer `tabsetPanel` descendiente directo del cuerpo** del `tabItem`
  (no los anidados): recorrer hasta el primer `tabsetPanel` y extraer únicamente sus `tabPanel` hijos
  inmediatos; marcar sub-tabs como `nested=true` aparte. Esf. S.

## A2 — Regla `*Sep` (File Separator) no aplicada en código
- **Deuda:** los selectores de separador de archivo (`citSep`, `rpysSep`, `LocCitSep`, `COCSep`…)
  salen como controles `combo` normales, algunos con `group=null` (parecen *Main Configuration*).
- **Problema:** los separadores de archivo son **parseo técnico, no dimensión analítica**; la regla
  vive en la documentación, no en el extractor.
- **Impacto:** un consumidor ingenuo del JSON que tome "todo `combo` con `group=null`" como dimensión
  barrible incluiría separadores → combinaciones espurias. Hoy **no pasa** porque Fase 2 usa el plan
  manual (que ya los excluyó a mano).
- **Por qué atacarla:** es la diferencia entre que el `plan.json` se pueda derivar automático y bien (A5)
  o con basura.
- **Propuesta:** marcar en el extractor `analytic=false` cuando `inputId` casa `/Sep$/i` o el `label`
  contiene "Separator"; documentar la heurística. Esf. S.

## A3 — Mapeo `helpContent()$clave → página` pendiente
- **Deuda:** se extraen las 25 claves de `helpContent()`, pero no a qué página pertenece cada una.
- **Problema:** el vínculo está en `ui.R` como `HTML(helpContent()$<clave>)` dentro del `tabItem`; aún
  no se rastrea.
- **Impacto:** no se puede regenerar `info_and_reference/` automáticamente ni separar las 17 claves de
  resultados de las 8 generales. Hoy se tiene a mano.
- **Por qué atacarla:** completa la cobertura de la Fase 1 (es la tercera pata junto a options y tabs).
- **Propuesta:** durante el recorrido del `tabItem`, `collect(ti, "$")` o buscar llamadas `helpContent`
  y leer el nombre del campo (`x[[3]]`); asociar clave↔`tabName`. Esf. S.

## A4 — Sin enriquecimiento desde `server.R` (columnas de tablas, desglose de figuras)
- **Deuda:** el extractor saca la **estructura** (qué outputs hay, de qué tipo) pero no el **contenido
  semántico**: las columnas reales de cada tabla ni los ejes/codificación de color-tamaño de cada figura.
- **Problema:** eso no está en `ui.R`; vive en `server.R` como flujo reactivo
  `output$X <- renderBibliobox(values$Y …)` y `values$Y <- f(M) %>% rename()/select()`, más funciones de
  `bibliometrix` (`freqPlot`, `igraph2vis`, `degreePlot`…). Requiere **seguir el dataflow**, no parsear
  una llamada aislada.
- **Impacto:** el `tabs.md` rico (columnas + desglose) **no** es regenerable automáticamente; esa parte
  de la `metadata_ui` seguiría siendo manual ante un cambio de versión.
- **Por qué atacarla:** es lo único que falta para automatizar el 100% de la metadata y, por tanto, para
  que un cambio de versión de biblioshiny se absorba sin trabajo manual.
- **Propuesta (incremental, best-effort):**
  1. Para cada `outputId`, `grep 'output\$<id>'` en `server.R` → identificar la **función de render**.
  2. Resolver 1 nivel de indirección: hallar `values$Y <- …` y capturar `rename()/select()/colnames()`
     literales → columnas.
  3. Lo no resoluble estáticamente se marca `"no determinable estáticamente; vía f()"` (regla de
     fidelidad §7). Aceptar cobertura parcial + verificación humana puntual.
  Esf. L; alto riesgo/heurístico — candidato a apoyarse en un agente.

## A5 — El extractor no emite `.md` ni `plan.json` (solo el JSON estructural)
- **Deuda:** la salida es `ui_metadata.json`; no regenera ni la `metadata_ui` legible ni el spec de Fase 2.
- **Problema:** falta la capa de **emisión** (render JSON→Markdown; y derivación JSON→combinaciones).
- **Impacto:** el flujo "crear metadata → JSON → extractor → resultados" está **a medias**: el extractor
  produce el JSON pero alguien (humano) sigue manteniendo `metadata_ui/` y `plan.json`.
- **Por qué atacarla:** cierra el loop y hace el sistema verdaderamente reproducible ante versiones.
- **Propuesta:** (a) `emit_md.R`: plantillas que rinden `options.md`/`tabs.md` desde el JSON; (b)
  `emit_plan.R`: producto cartesiano de los combos `analytic & group=null`, expandiendo condicionales y
  aplicando el cap de explosión (>100→`default`) → `plan.json`. Requiere A1–A3 sólidos. Esf. M.

## A6 — Cosméticos
- **Deuda:** `choices` sin nombre se muestran con label vacío (`{=Yes,=No}`); no se etiqueta qué páginas
  son "de resultados" (las 42) vs herramientas.
- **Impacto:** mínimo; ruido cosmético en el JSON.
- **Propuesta:** si `label==""` usar el `value` como label; añadir `is_result_page` por intersección con
  la lista curada (o por estar bajo los super-niveles SEARCH/APPRAISAL/ANALYSIS/SYNTHESIS del menú). Esf. S.

---

# B. Runner (Fase 3 — `scripts/`)

## B1 — Validado en un solo corpus
- **Deuda:** todas las validaciones (42/42, paridad, escalamiento) son sobre el corpus de **473 docs**
  (`savedrecs (2)`=`(5)`, 1997-2021). El corpus "real" reciente (~512 docs, 2024-2025) **no está en mano**.
- **Problema:** un corpus distinto puede traer campos faltantes, codificaciones nuevas, años fuera de
  rango, etc., que ningún caso de prueba cubre.
- **Impacto:** confianza acotada a ese corpus; sorpresas posibles con el real.
- **Por qué atacarla:** es el uso final del sistema; conviene que el primer contacto con el corpus real
  no destape fallos.
- **Propuesta:** al llegar el `.bib` nuevo, correr el sweep + revisar `_run_log.txt` por errores y el
  visor; además correr el de 727 docs (`Reporte de Actividades SS/datasets/savedrecs.bib`) como prueba
  de estrés. Esf. S (ya hay infraestructura).

## B2 — Paridad verificada solo en tablas
- **Deuda:** `verify_parity.R` confirma 4/4 **tablas** (Main Information, Most Relevant Sources, Bradford,
  Lotka). Figuras, redes y secciones con cap **no** están verificadas contra biblioshiny.
- **Problema:** comparar figuras requiere referencia (export manual de la GUI) o métricas estructurales
  (nº nodos/aristas, métricas de red), no pixel-a-pixel; las secciones con cap difieren a propósito del
  default de la GUI.
- **Impacto:** no se puede afirmar fidelidad de las figuras/redes que irán a la tesis con la misma
  solidez que las tablas.
- **Por qué atacarla:** Resultados/Discusión se apoyará fuertemente en redes y mapas temáticos.
- **Propuesta:** (a) para redes, comparar **invariantes** (nº de nodos/aristas, densidad, top-N por grado)
  contra `biblioNetwork`/`networkPlot` directos con el mismo cap; (b) para 2–3 figuras clave, export
  manual desde la GUI y diff cualitativo; (c) documentar los resultados de paridad. Esf. M.

## B3 — Degeneración en corpus chico (errores duros)
- **Deuda:** a 49 docs fallan **9 escenarios** (`thematic_evolution`: *"filter applied to NULL"*).
- **Problema:** `thematicEvolution()` (y potencialmente otras) asume densidad mínima de términos/periodos;
  con pocos docs produce estructuras vacías que revientan aguas abajo. El runner lo captura como error
  genérico y sigue, pero no **degrada con gracia**.
- **Impacto:** con corpus chicos o subconjuntos filtrados, parte del banco de evidencia no se genera y el
  log muestra errores en vez de un "datos insuficientes" claro.
- **Por qué atacarla:** robustez; además distingue "bug" de "corpus insuficiente", que hoy se ven igual.
- **Propuesta:** *guards* previos por sección (nº de docs/términos/periodos mínimos) que, si no se
  cumplen, **omiten** el escenario con estado `skipped:insufficient_data` (no `error`) y una nota en el
  manifest/log. Esf. S–M.

## B4 — Sin tests automáticos / smoke test
- **Deuda:** "validado" = "corrió sin error" + paridad manual puntual; no hay suite que detecte
  regresiones.
- **Problema:** cualquier cambio (runner, versión de paquete) puede romper o alterar salidas sin que nada
  lo señale.
- **Impacto:** frágil ante edición futura; las regresiones se descubren tarde (o nunca).
- **Por qué atacarla:** habilita iterar con confianza y detectar drift de versión (ver T1).
- **Propuesta:** un `smoke_test.R` sobre un corpus mínimo fijo (incluido en el repo) que corra N
  secciones y compare contra *snapshots* (hashes de tablas / nº de assets / invariantes de red). Correr
  antes de cada cambio. Esf. M.

## B5 — Rutas *hardcoded*
- **Deuda:** `BASE`, la ruta de `R_LIBS_USER`, las rutas de `.bib` y del clon están fijas a esta máquina/
  usuario.
- **Problema:** no hay configuración central; mover el proyecto exige editar varios archivos.
- **Impacto:** no portátil; cualquiera que lo reabra en otra máquina tropieza.
- **Por qué atacarla:** reproducibilidad fuera de esta laptop (y a prueba de futuro-tú con otra ruta).
- **Propuesta:** un `config.R`/`.Renviron` único con `BASE`, `SRC` (clon), `RLIB`; derivar rutas relativas
  donde se pueda; los scripts leen de ahí. Esf. S.

---

# C. Análisis / decisiones

## C1 — Caps `n=50` / `max_terms=50` pragmáticos, no justificados analíticamente
- **Deuda:** los caps de cómputo (redes a 50 nodos, factorial a 50 términos) se eligieron para que
  corriera, no por criterio del dominio.
- **Problema:** cambian el resultado respecto al default de la GUI (que no acota igual); el valor 50 es
  arbitrario.
- **Impacto:** las figuras de redes/factorial que entren a la tesis dependen de un parámetro no defendido;
  un revisor podría cuestionarlo.
- **Por qué atacarla:** es contenido de Resultados que hay que poder justificar metodológicamente.
- **Propuesta:** (a) documentar el cap como decisión metodológica explícita (criterio: legibilidad de la
  red / términos más frecuentes); (b) sensibilidad rápida: correr 1–2 secciones con `n∈{30,50,100}` y
  mostrar que la estructura principal no cambia; (c) dejarlo *tunable* en `plan.json` (ya lo es). Esf. S.

## C2 — Three-Field Plot reducido a `default`
- **Deuda:** la página Three-Field tiene 3 selectores de campo (~11 opciones c/u → 11³≈1331 escenarios);
  por la regla de explosión se dejó en `default` (1 escenario).
- **Problema:** cobertura incompleta de ese análisis (decisión consciente, documentada en el plan §2.5).
- **Impacto:** bajo — Three-Field es exploratorio/dinámico; rara vez se necesitan todas las combinaciones.
- **Propuesta:** si se requiere, definir a mano un **subconjunto curado** (p. ej. AU–DE–SO y CR_AU–AU–DE)
  en `plan.json` en vez del cartesiano completo. Esf. S–M.

---

# T. Transversal (lo que agrego)

## T1 — Sin *version pinning* ni detección de drift de biblioshiny/bibliometrix
- **Deuda:** los runners replican a mano la lógica de `server.R` de **bibliometrix 5.4.1**; no hay lock
  de versión ni prueba que detecte si una actualización del paquete cambia las salidas.
- **Problema:** `install.packages` puede actualizar bibliometrix; los runners quedarían replicando una
  versión vieja mientras el motor cambió → **divergencia silenciosa**. Es justo el riesgo que el
  extractor de metadata busca mitigar… pero solo para la metadata, no para los runners.
- **Impacto:** potencialmente **alto y silencioso**: resultados que ya no corresponden a la versión
  instalada, sin aviso.
- **Por qué atacarla:** es el riesgo de fondo que conecta todo; sin esto, "reproducible" tiene asterisco.
- **Propuesta:** (a) registrar `packageVersion("bibliometrix")` en `_corpus_info.json` (ya se hace) y
  **abortar/avisar** si difiere de la esperada; (b) lock con `renv`; (c) el `smoke_test` (B4) como detector
  de drift: si los snapshots cambian tras actualizar, salta. Esf. M.

## T2 — Doble fuente de metadata (manual vs auto) sin reconciliación
- **Deuda:** existirá la `metadata_ui/` hecha a mano (fuente de verdad actual) y el `ui_metadata.json`
  auto-extraído; sin plan, divergen.
- **Problema:** cuando el extractor emita `.md` (A5), habrá dos verdades.
- **Impacto:** confusión sobre cuál manda; riesgo de editar una y no la otra.
- **Por qué atacarla:** evita drift documental cuando se cierre la automatización.
- **Propuesta:** decidir explícitamente que **el auto-generado reemplaza** al manual una vez validado por
  diff (la `metadata_ui` manual pasa a *snapshot* histórico); hasta entonces, el manual manda y el auto es
  solo verificación. Esf. M (sobre todo decisión + un diff).

## T3 — Clasificación de errores pobre en el runner
- **Deuda:** `tryCatch` por escenario marca `error` sin distinguir *bug* de *corpus insuficiente* (ver B3)
  de *dependencia faltante*.
- **Impacto:** diagnosticar un run requiere leer el log a mano; el `_manifest.json` no ayuda a triage.
- **Propuesta:** clasificar el error (regex sobre el mensaje → categoría) y guardarlo en el manifest;
  estados `error|skipped:insufficient|skipped:unsupported`. Esf. S.

## T4 — Determinismo no auditado de punta a punta
- **Deuda:** `set.seed(42)` corre antes de cada escenario, pero no se auditó que **todas** las etapas
  estocásticas (layouts, Louvain, MCA, muestreos internos) queden realmente fijadas.
- **Impacto:** posible variación no detectada entre corridas idénticas en alguna figura.
- **Por qué atacarla:** "reproducible" debe ser verificable.
- **Propuesta:** correr 2× el mismo escenario de red y diff de los assets (hashes); si difieren, rastrear
  la fuente de aleatoriedad no seedeada. Esf. S.

---

## Secuencia recomendada al retomar
1. **B1** — correr el corpus real cuando llegue (es el objetivo) + revisar errores.
2. **T1 + B4** — version pinning + smoke test (protege todo lo demás; barato relativo al riesgo).
3. **B3 / T3** — *guards* de corpus chico y clasificación de errores (robustez visible).
4. **C1** — justificar/sensibilizar los caps (necesario para escribir Resultados).
5. **A1→A3→A5** — cerrar la emisión del extractor (loop metadata→spec) ; **A4** al final (lo más difícil).
6. **T2** — reconciliar manual vs auto cuando A5 esté listo.

> Filosofía: nada aquí impide **usar** el sistema hoy ni **empezar a redactar** Resultados/Discusión con
> la evidencia ya generada. Es el plan para que, cuando vuelvas, endurezcas con orden en vez de improvisar.
