# --- registry.R -------------------------------------------------------------
# Runner registry. Each R/runners_*.R file registers its runners here, so
# families can live in separate files. Sourced before runners*.R (alphabetical).

.RUNNERS <- new.env(parent = emptyenv())

register_runner <- function(name, fn) assign(name, fn, envir = .RUNNERS)

get_runner <- function(name) {
  if (!exists(name, envir = .RUNNERS, inherits = FALSE))
    stop(sprintf("Runner not implemented: %s", name))
  get(name, envir = .RUNNERS)
}

# Runner contract:
#   fn(M, params) -> list of assets, each:
#     list(id=, type=, filename=, object=[, object2=])
#   types: table_xlsx | figure_png | network_html | network_net
#   params: named list of value CODES for the scenario (e.g. list(field="ID", ngrams=2))
run_section <- function(section, M, params, seed) {
  set.seed(seed)                       # reproducibility for stochastic steps
  get_runner(section$runner)(M, params)
}
