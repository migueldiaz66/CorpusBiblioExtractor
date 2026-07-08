# Package-level setup. The runner registry (.RUNNERS in registry.R) is populated
# by the top-level register_runner() calls in R/runners_*.R at load time.

# Populate the private `.BSHINY` env (biblioshiny's real helper functions, sourced from
# the installed bibliometrix) at LOAD time — see .load_bshiny() in runners_networks.R.
# Must run at runtime (not build time), hence .onLoad, so it uses the runtime bibliometrix.
.onLoad <- function(libname, pkgname) {
  .load_bshiny()
}

# Silence R CMD check NOTEs for non-standard-evaluation column names used inside the
# dplyr / ggplot2 pipelines in the runners (bare symbols not seen by the static checker).
utils::globalVariables(c(
  ".data",
  # overview / documents
  "SO", "n", "PY", "DT", "TC", "SR", "DI", "TI", "TCperYear", "NTC",
  "LCS", "GCS", "Year", "Ratio", "NLCS", "NGCS", "diffMedian", "is_peak",
  "Reference", "Citations", "CR", "Freq", "freq", "item",
  "year_q1", "year_med", "year_q3", "Term", "Words", "Occurrences",
  # geo / affiliations / countries
  "AU", "AU1_CO", "AU_UN", "AU_CO", "AU_CO1", "TotalCitation", "Country",
  "Region", "SCP", "MCP", "MCP_Ratio", "Collaboration", "Frequency", "AFF",
  # ranking / networks / misc
  "seconds", "section", "runner", "Articles", "Sources", "Source", "Zone",
  "Inc_Weighted", "freq2", "x", "y", "xend", "yend", "name", "value",
  "LocalCitations", "Author", "Element", "Paper", "id"
))
