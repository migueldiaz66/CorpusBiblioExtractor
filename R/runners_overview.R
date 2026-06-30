# --- runners_overview.R -----------------------------------------------------
# ANALYSIS > Overview family. Registers five runners. Sourced after
# registry.R (register_runner) and runners.R (helpers .tbl/.fig/.hbar), so all
# of those are available here.
#
# Contract: register_runner("<name>", function(M, params){ ... ; list(<assets>) })
#   asset = list(id=, type=, filename=, object=)
#   helpers: .tbl(df, file, id)  -> table_xlsx ; .fig(ggplot, file, id) -> figure_png
#            .hbar(df, value_col, label_col, title, xlab, n=20) -> ggplot (top-n h-bars)
#   Loaded libs: bibliometrix, dplyr, ggplot2. No plotly. The driver handles the
#   per-scenario seed + error capture, so no set.seed here; tryCatch is used ONLY
#   where the section spec asks for graceful degradation (logistic fit in
#   life_cycle; the plotly-only three-field plot, which must never fail).
# All five Overview pages take an empty `params` (single "default" scenario).
#
# Notes on data sources (verified against bibliometrix 5.4.1 source + server.R):
# - main_information: summary.bibliometrix() returns $MainInformationDF
#   (cols Description, Results) and biblioAnalysis()$Documents is a table of DT
#   counts (names padded)                              [summary.bibliometrix.R,
#   biblioAnalysis.R].
# - annual_scientific_production: descriptive(type="tab2") = group_by(PY) |>
#   count() |> rename(Year=PY, Articles=n)             [server.R AnnualProdPlot].
# - average_citations_per_year: server groups by PY -> MeanTCperArt=mean(TC),
#   N=n(), MeanTCperYear=MeanTCperArt/(currentYear+1-PY). The section spec for
#   this runner instead divides by (maxYear-Year+1), which is what we use below
#   [server.R AnnualTotCitperYearPlot].
# - life_cycle: bibliometrix::lifeCycle() fits the logistic via optim() on ANNUAL
#   counts and is plotly-rendered. The section spec asks for a simpler stand-in:
#   fit the CUMULATIVE curve with stats::nls(SSlogis), fall back to the raw
#   cumulative if it does not converge                 [lifeCycle.R].
# - three_field_plot: threeFieldsPlot() returns a plotly Sankey (cannot be a
#   ggplot/PNG); we emit a static faceted-bars stand-in built from the same
#   per-field top-n items via cocMatrix()              [threeFieldsPlot.R].

# === Overview family ========================================================

# 1) Main Information -------------------------------------------------------
# 3.1.1 · plot.png + table.xlsx · no params
# table = summary()$MainInformationDF (Description / Results).
# plot  = document-type bar chart (falls back to numeric main-info indicators
#         when the corpus has no DT column).
register_runner("main_information", function(M, params) {
  res <- bibliometrix::biblioAnalysis(M)
  s   <- summary(res, k = 10, verbose = FALSE)

  TAB <- s$MainInformationDF
  if (is.null(TAB)) {
    TAB <- data.frame(
      Description = c("Timespan", "Sources", "Documents", "Authors",
                      "Annual Growth Rate %", "Average citations per doc",
                      "References", "Author's Keywords (DE)", "Keywords Plus (ID)"),
      Results = c(paste(min(res$Years, na.rm = TRUE), max(res$Years, na.rm = TRUE), sep = ":"),
                  length(res$Sources), res$Articles, res$nAuthors[1],
                  NA, round(mean(as.numeric(res$TotalCitation), na.rm = TRUE), 3),
                  res$nReferences, length(res$DE), length(res$ID)),
      stringsAsFactors = FALSE)
  }

  docs    <- res$Documents
  have_dt <- !(length(docs) == 1 && is.na(docs[1]))
  if (have_dt) {
    DT <- data.frame(Type = trimws(names(docs)), N = as.numeric(docs),
                     stringsAsFactors = FALSE)
    p <- .hbar(DT, "N", "Type", "Document Types", "N. of Documents", n = nrow(DT))
  } else {
    num <- suppressWarnings(as.numeric(TAB$Results))
    ND  <- data.frame(Metric = trimws(TAB$Description), Value = num,
                      stringsAsFactors = FALSE)
    ND  <- ND[is.finite(ND$Value) & nzchar(ND$Metric), , drop = FALSE]
    p <- .hbar(ND, "Value", "Metric", "Main Information (numeric indicators)",
               "Value", n = 12)
  }

  list(.fig(p), .tbl(TAB))
})

# 2) Annual Scientific Production -------------------------------------------
# 3.1.2 · plot.png + table.xlsx · no params
# table = documents per publication year (Year / Articles); plot = line of it.
register_runner("annual_scientific_production", function(M, params) {
  TAB <- M |>
    dplyr::group_by(PY) |>
    dplyr::count() |>
    dplyr::rename(Year = PY, Articles = n) |>
    as.data.frame()
  TAB      <- TAB[!is.na(TAB$Year), , drop = FALSE]
  TAB$Year <- as.numeric(TAB$Year)
  TAB      <- TAB[order(TAB$Year), , drop = FALSE]

  p <- ggplot2::ggplot(TAB, ggplot2::aes(x = Year, y = Articles)) +
    ggplot2::geom_line(color = "black", linewidth = 0.8) +
    ggplot2::geom_point(color = "#4477AA", size = 1.8) +
    ggplot2::labs(title = "Annual Scientific Production", x = "Year", y = "Articles") +
    ggplot2::theme_minimal(base_size = 12)

  list(.fig(p), .tbl(TAB))
})

# 3) Average Citations per Year ---------------------------------------------
# 3.1.3 · plot.png + table.xlsx · no params
# Per spec: MeanTCperArt = mean(TC) of the year ; N = docs of the year ;
#           MeanTCperYear = MeanTCperArt / (maxYear - Year + 1).
# plot = line of Year x MeanTCperYear.
register_runner("average_citations_per_year", function(M, params) {
  df <- data.frame(Year = as.numeric(M$PY), TC = as.numeric(M$TC))
  df <- df[is.finite(df$Year), , drop = FALSE]
  maxYear <- max(df$Year)

  TAB <- df |>
    dplyr::group_by(Year) |>
    dplyr::summarize(MeanTCperArt = round(mean(TC, na.rm = TRUE), 2),
                     N = dplyr::n(), .groups = "drop") |>
    dplyr::mutate(MeanTCperYear = round(MeanTCperArt / (maxYear - Year + 1), 2)) |>
    dplyr::arrange(Year) |>
    as.data.frame()
  TAB <- TAB[is.finite(TAB$MeanTCperArt), , drop = FALSE]
  TAB <- TAB[, c("Year", "MeanTCperArt", "N", "MeanTCperYear")]

  p <- ggplot2::ggplot(TAB, ggplot2::aes(x = Year, y = MeanTCperYear)) +
    ggplot2::geom_line(color = "black", linewidth = 0.8) +
    ggplot2::geom_point(color = "#4477AA", size = 1.8) +
    ggplot2::labs(title = "Average Citations per Year", x = "Year", y = "MeanTCperYear") +
    ggplot2::theme_minimal(base_size = 12)

  list(.fig(p), .tbl(TAB))
})

# 4) Life Cycle -------------------------------------------------------------
# 3.1.4 · plot.png + table.xlsx · no params
# Logistic growth on the CUMULATIVE production: nls(Cumulative ~ SSlogis(Year)).
# tryCatch -> NULL if it does not converge, then fall back to the raw cumulative.
# table = Year / Articles / Cumulative ; plot = observed cumulative vs fit.
register_runner("life_cycle", function(M, params) {
  TAB <- M |>
    dplyr::group_by(PY) |>
    dplyr::count() |>
    dplyr::rename(Year = PY, Articles = n) |>
    as.data.frame()
  TAB$Year       <- as.numeric(TAB$Year)
  TAB            <- TAB[is.finite(TAB$Year), , drop = FALSE]
  TAB            <- TAB[order(TAB$Year), , drop = FALSE]
  TAB$Cumulative <- cumsum(TAB$Articles)

  fit <- tryCatch(
    stats::nls(Cumulative ~ stats::SSlogis(Year, Asym, xmid, scal), data = TAB),
    error = function(e) NULL)
  TAB$Fitted <- if (!is.null(fit)) as.numeric(stats::predict(fit)) else as.numeric(TAB$Cumulative)

  title <- if (!is.null(fit))
    "Life Cycle - Cumulative Production (logistic fit)" else
    "Life Cycle - Cumulative Production (logistic fit did not converge; raw curve)"

  p <- ggplot2::ggplot(TAB, ggplot2::aes(x = Year)) +
    ggplot2::geom_point(ggplot2::aes(y = Cumulative), color = "#2ca02c", size = 2) +
    ggplot2::geom_line(ggplot2::aes(y = Fitted), color = "#1f77b4", linewidth = 1) +
    ggplot2::labs(title = title, x = "Year", y = "Cumulative Publications") +
    ggplot2::theme_minimal(base_size = 12)

  list(.fig(p), .tbl(TAB[, c("Year", "Articles", "Cumulative")]))
})

# 5) Three-Field Plot -------------------------------------------------------
# 3.1.5 · plot.html (interactive Sankey) · no params
# Native threeFieldsPlot() returns a plotly Sankey; saved as interactive HTML
# (its natural form) instead of an approximation. Left = cited authors,
# middle = authors, right = author keywords (CR_AU -> AU -> DE).
register_runner("three_field_plot", function(M, params) {
  if (!"CR_AU" %in% names(M)) M <- bibliometrix::metaTagExtraction(M, Field = "CR_AU")
  sk <- bibliometrix::threeFieldsPlot(M, fields = c("CR_AU", "AU", "DE"), n = c(20, 20, 20))
  list(list(id = "plot", type = "plot_html", filename = "plot.html", object = sk))
})
