# --- logging.R --------------------------------------------------------------
# Minimal logger: prints to console and appends to a run log file.

.LOG <- new.env(parent = emptyenv())

init_log <- function(path) {
  .LOG$path <- path
  cat("", file = path)            # truncate / create
  invisible(path)
}

log_line <- function(level, msg) {
  ts   <- format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  line <- sprintf("[%s] %-5s %s", ts, level, msg)
  cat(line, "\n", sep = "")
  if (!is.null(.LOG$path)) cat(line, "\n", sep = "", file = .LOG$path, append = TRUE)
  invisible(line)
}

log_info  <- function(msg) log_line("INFO",  msg)
log_warn  <- function(msg) log_line("WARN",  msg)
log_error <- function(msg) log_line("ERROR", msg)
