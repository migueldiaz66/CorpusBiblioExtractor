#' Parity spot-check: saved tables vs. an independent bibliometrix recompute
#'
#' Loads the exact filtered corpus a run used and compares a few of its saved
#' tables against an independent recomputation with the `bibliometrix` engine
#' (the same engine biblioshiny runs). Checks tabular sections only.
#'
#' @param run_dir A run directory produced by [cbe_run()]
#'   (default: the latest run under `file.path(getwd(), "runs")`).
#' @return (invisibly) a data.frame of checks with a `pass` column.
#' @export
cbe_verify_parity <- function(run_dir = NULL) {
  if (is.null(run_dir)) {
    rr <- file.path(getwd(), "runs")
    rd <- sort(list.dirs(rr, recursive = FALSE, full.names = FALSE)); rd <- rd[grepl("Z$", rd)]
    if (!length(rd)) stop("no runs under ", rr)
    run_dir <- file.path(rr, utils::tail(rd, 1))
  }
  info <- jsonlite::read_json(file.path(run_dir, "_corpus_info.json"))
  M <- load_corpus(info$bib)

  read_saved <- function(frag) {
    d <- list.dirs(run_dir, recursive = FALSE, full.names = TRUE)
    d <- d[grepl(frag, basename(d))][1]
    if (is.na(d)) return(NULL)
    f <- list.files(d, pattern = "__table\\.xlsx$", recursive = TRUE, full.names = TRUE)
    if (length(f)) openxlsx::read.xlsx(f[1]) else NULL
  }
  res <- list()
  add <- function(name, ok) {
    res[[length(res) + 1L]] <<- data.frame(check = name, pass = isTRUE(ok), stringsAsFactors = FALSE)
    cat(sprintf("  [%s] %s\n", if (isTRUE(ok)) "PASS" else "FAIL", name))
  }

  sav <- read_saved("main_information")
  if (!is.null(sav)) { names(sav)[1:2] <- c("d", "r")
    pick <- function(rx) { i <- grep(rx, sav$d, ignore.case = TRUE)[1]; if (is.na(i)) NA else sav$r[i] }
    add("Main Information", as.numeric(gsub("\\D", "", pick("^Documents"))) == nrow(M)) }

  sav <- read_saved("most_relevant_sources")
  if (!is.null(sav)) { tt <- sort(table(M$SO), decreasing = TRUE)
    ref <- data.frame(Sources = names(tt), Articles = as.integer(tt), stringsAsFactors = FALSE)
    ref <- ref[!is.na(ref$Sources) & ref$Sources != "", ]
    mg  <- merge(sav, ref, by = "Sources")
    add("Most Relevant Sources", nrow(mg) == nrow(sav) && all(mg$Articles.x == mg$Articles.y)) }

  sav <- read_saved("bradford")
  if (!is.null(sav)) { bt <- bibliometrix::bradford(M)$table
    add("Bradford", nrow(sav) == nrow(bt) && identical(as.integer(table(sav$Zone)), as.integer(table(bt$Zone)))) }

  sav <- read_saved("lotka")
  if (!is.null(sav)) { L <- as.data.frame(bibliometrix::lotka(M)$AuthorProd)
    add("Lotka", all(dim(sav) == dim(L))) }

  out <- do.call(rbind, res)
  cat(sprintf("\nParity: %d/%d PASS\n", sum(out$pass), nrow(out)))
  invisible(out)
}
