# tests/ — suite de pruebas del proyecto

Cubre la deuda **B4** (smoke/regresión), **T4** (determinismo) y parte de **T1** (detección de drift)
de `../TECHNICAL_DEBT.md`. **Harness propio, sin dependencias nuevas** (solo base R + `jsonlite`/
`openxlsx`/`ggplot2`/`igraph`, ya instalados). Corre con `Rscript`; sale con **código 0 = todo pasó,
1 = hubo fallos** (apto para gate pre-cambio).

## Uso
```powershell
$env:R_LIBS_USER = "C:\Users\migue.LAPTOP-7RVI23O5\AppData\Local\R\win-library\4.6"
$R = "C:\Program Files\R\R-4.6.1\bin\Rscript.exe"

& $R tests/run_tests.R                    # default: unit + pipeline(49 docs)  (~2 min)
& $R tests/run_tests.R --unit             # solo unit (rápido, sin corpus)     (~15 s)
& $R tests/run_tests.R --pipeline         # solo pipeline(49)                  (~1.5 min)
& $R tests/run_tests.R --e2e473           # + sweep completo en 473 docs       (~12 min)
& $R tests/run_tests.R --all              # unit + pipeline(49) + e2e(473)
& $R tests/run_tests.R --pipeline --update-snapshots   # re-graba el snapshot de regresión
```

## Estructura
```
tests/
├─ run_tests.R              # driver/CLI; orquesta capas y fija el exit code
├─ helpers/assert.R         # harness mínimo: test_that + expect_{true,false,equal,error,file,match,close}
├─ unit/                    # rápidos, deterministas, SIN corpus
│   ├─ test_spec.R          # expand_combinations (producto cartesiano + condicionales applies_when)
│   ├─ test_manifest.R      # asset_key / is_done / save·load round-trip
│   ├─ test_savers.R        # save_asset por tipo (table_xlsx/figure_png/network_net) + tipo desconocido
│   └─ test_extractor.R     # helpers AST (arg/text_of/eval_lit/collect) + hechos estructurales de ui.R
├─ pipeline/
│   ├─ pipeline49.R         # SMOKE + REGRESSION + DETERMINISM sobre 49 docs (1 corrida real del CLI)
│   └─ e2e473.R             # opt-in: sweep completo 473 docs (159/159 ok, 0 errores, index)
└─ fixtures/snapshots_49.json   # valores esperados (detector de drift); commiteado
```

## Qué valida cada capa

### Unit (47 asserts, ~15 s, sin corpus)
- **`expand_combinations`** (corazón de Fase 2): sin params→`default`; producto cartesiano; **selector
  condicional** incluido solo cuando el ref casa (N-Grams solo si field∈{TI,AB}); nomenclatura; y que el
  **`plan.json` real** expanda a **42 secciones / 159 escenarios**.
- **`manifest`**: `asset_key`, `is_done` (solo `ok`), round-trip save/load.
- **`savers`**: cada tipo escribe un archivo válido; tipo desconocido lanza error.
- **Extractor**: helpers AST puros (incl. regresión del bug de iterar `expression`) y **hechos
  estables de `ui.R`** (55 tabItems; MAIN combos de coOccurence=`field,cocngrams`, factorial=`method,
  CSfield`; 25 claves de help) → **un cambio de versión en la UI rompe estos tests** (señal temprana).

### Pipeline(49) (29 asserts, ~1.5 min, corpus `savedrecs.bib`)
Una **corrida real del CLI** (`run_exhaustive.R --only <1 sección por familia> --runs-root <temp>`),
luego tres bloques:
- **SMOKE** — se generó el run dir; existen `index.html`/`_timing.csv`/`_manifest.json`/`_corpus_info.json`;
  corpus=49 docs; `ok>0` y **0 errores** en el subset; cada familia produjo carpeta con activos.
- **REGRESSION (snapshot)** — compara contra `fixtures/snapshots_49.json`: docs/sources/timespan,
  Most Relevant Sources (top-1 fuente + top-5 conteos), zonas de Bradford, distribución de Lotka.
  **Si cambian tras actualizar bibliometrix o tocar un runner → falla = drift detectado.** Primera
  corrida (o `--update-snapshots`) **bootstrapea** el snapshot; las siguientes **comparan**.
- **DETERMINISM** — corre `co_occurrence` dos veces y compara el **md5 del `.net`**; idéntico ⇒
  `set.seed(42)` fija el camino estocástico.

### e2e(473) (opt-in, ~12 min, corpus `savedrecs (2).bib`)
Sweep **completo** de las 42 secciones: asegura `ok=159 err=0`, 0 errores en el manifest e `index.html`.
No entra en la suite rápida.

## Notas
- **Las corridas de prueba van a un directorio temporal** (`--runs-root <tempdir>`), nunca a `../runs/`;
  se limpian al terminar. Por eso se agregó el flag `--runs-root` (retrocompatible) al driver.
- **`thematic_evolution` a 49 docs** se **excluye** del subset porque degenera (deuda B3); su fallo
  esperado se documenta en `TECHNICAL_DEBT.md`, no se testea como "verde" aquí.
- **Actualizar snapshots a propósito** (tras un cambio validado): `--update-snapshots`. Revisa el diff
  del JSON antes de aceptarlo.
- **Gate sugerido:** correr `run_tests.R` (default) antes de cada cambio en `scripts/` o
  `metadata_extractor/`; correr `--e2e473` antes de congelar una versión o tras actualizar paquetes.
