# --- assert.R — minimal test harness (no external deps) ---------------------
# Global tally in an env; expect_* increment it; test_summary() prints + returns
# the failure count (driver uses it for the process exit code).

.TS <- new.env(parent = emptyenv())
.TS$pass <- 0L; .TS$fail <- 0L; .TS$ctx <- ""; .TS$failures <- character(0)

test_section <- function(name) cat(sprintf("\n== %s ==\n", name))

# code is lazy: evaluated inside tryCatch so a thrown error becomes a failure.
test_that <- function(desc, code) {
  .TS$ctx <- desc
  tryCatch(force(code),
           error = function(e) .fail(sprintf("%s :: unexpected ERROR: %s", desc, conditionMessage(e))))
  invisible(NULL)
}

.pass <- function(msg) { .TS$pass <- .TS$pass + 1L; cat(sprintf("  [PASS] %s\n", msg)) }
.fail <- function(msg) { .TS$fail <- .TS$fail + 1L; .TS$failures <- c(.TS$failures, msg); cat(sprintf("  [FAIL] %s\n", msg)) }

expect_true <- function(x, info = "") if (isTRUE(x)) .pass(paste(.TS$ctx, info)) else .fail(paste(.TS$ctx, info, "(expected TRUE)"))
expect_false <- function(x, info = "") expect_true(!isTRUE(x), info)

expect_equal <- function(actual, expected, info = "") {
  if (isTRUE(all.equal(actual, expected)))
    .pass(paste(.TS$ctx, info))
  else
    .fail(sprintf("%s %s (got=%s want=%s)", .TS$ctx, info,
                  paste(deparse(actual), collapse = ""), paste(deparse(expected), collapse = "")))
}

expect_error <- function(expr, info = "") {
  threw <- tryCatch({ force(expr); FALSE }, error = function(e) TRUE)
  if (threw) .pass(paste(.TS$ctx, info, "(threw as expected)")) else .fail(paste(.TS$ctx, info, "(expected an error)"))
}

expect_file <- function(path, info = "") {
  ok <- file.exists(path) && isTRUE(file.info(path)$size > 0)
  if (ok) .pass(paste(.TS$ctx, info, basename(path))) else .fail(sprintf("%s %s (missing/empty: %s)", .TS$ctx, info, path))
}

expect_match <- function(x, pattern, info = "") {
  if (length(x) == 1 && grepl(pattern, x)) .pass(paste(.TS$ctx, info))
  else .fail(sprintf("%s %s (no match /%s/ in '%s')", .TS$ctx, info, pattern, paste(x, collapse = "|")))
}

# near-equality for numeric snapshots
expect_close <- function(actual, expected, tol = 1e-6, info = "") {
  if (is.numeric(actual) && is.numeric(expected) && length(actual) == length(expected) &&
      all(abs(actual - expected) <= tol)) .pass(paste(.TS$ctx, info))
  else .fail(sprintf("%s %s (got=%s want=%s tol=%g)", .TS$ctx, info,
                     paste(actual, collapse = ","), paste(expected, collapse = ","), tol))
}

test_summary <- function() {
  cat(sprintf("\n──── %d passed, %d failed ────\n", .TS$pass, .TS$fail))
  if (.TS$fail > 0) { cat("FAILURES:\n"); for (f in .TS$failures) cat("  -", f, "\n") }
  invisible(.TS$fail)
}
