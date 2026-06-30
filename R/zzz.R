# Package-level setup. The runner registry (.RUNNERS in registry.R) is populated
# by the top-level register_runner() calls in R/runners_*.R at load time.

# Silence R CMD check NOTEs for non-standard-evaluation column names used inside
# dplyr/ggplot pipelines in the runners.
utils::globalVariables(c(
  ".data", "SO", "n", "PY", "DT",
  "seconds", "section", "runner",
  "Articles", "Sources", "Zone",
  "Inc_Weighted", "freq2", "x", "y", "xend", "yend", "name"
))
