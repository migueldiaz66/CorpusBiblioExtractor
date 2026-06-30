# Unit tests for the metadata extractor: pure AST helpers (package internal) +
# structural facts of ui.R (a drift detector for biblioshiny UI changes).
# cbe_extract_ui() reads the INSTALLED biblioshiny, so this also runs it end-to-end.
test_section("metadata_extractor")

arg      <- CorpusBiblioExtractor:::arg
text_of  <- CorpusBiblioExtractor:::text_of
eval_lit <- CorpusBiblioExtractor:::eval_lit
collect  <- CorpusBiblioExtractor:::collect

test_that("arg() resolves positional and named args", {
  cl <- quote(f(1, 2, foo = 3))
  expect_equal(eval_lit(arg(cl, "x", 1)), 1, "positional #1")
  expect_equal(eval_lit(arg(cl, "foo", 9)), 3, "named")
})

test_that("text_of() strips icon()/style and pulls strong() text", {
  expect_equal(text_of(quote("Field")), "Field", "bare string")
  expect_equal(text_of(quote(strong("Network Layout"))), "Network Layout", "strong()")
  expect_equal(text_of(quote(span(icon("cogs"), strong("Method Parameters"), style = "x"))),
               "Method Parameters", "span+icon+style")
})

test_that("eval_lit() evals literal choices, NULL on non-literal", {
  v <- eval_lit(quote(c(`Keywords Plus` = "ID", `Author's Keywords` = "DE")))
  expect_equal(unname(v), c("ID", "DE"), "values")
  expect_true(is.null(eval_lit(quote(strong("z")))), "non-literal -> NULL")
})

test_that("collect() finds nested calls (regression: iterate expression objects)", {
  ex <- parse(text = "list(a(1), b(c(2), a(3)))")
  expect_equal(length(collect(ex, "a")), 2L, "two a() calls at different depths")
})

# --- structural facts of the installed ui.R (drift detector) ---------------
m <- cbe_extract_ui()
byname <- stats::setNames(m$pages, vapply(m$pages, function(p) p$tabName, ""))
mains_of <- function(tn) {
  ids <- character(0)
  for (c in byname[[tn]]$options)
    if (identical(c$type, "combo") && (is.null(c$group) || is.na(c$group))) ids <- c(ids, c$inputId)
  ids
}
test_that("ui.R structural facts hold (would break on a UI version change)", {
  expect_equal(m$summary$n_tabItems, 55L, "55 tabItems")
  expect_true(all(c("field", "cocngrams") %in% mains_of("coOccurenceNetwork")), "coOcc MAIN combos")
  expect_true(all(c("method", "CSfield") %in% mains_of("factorialAnalysis")), "factorial MAIN combos")
  expect_true(m$summary$n_help_keys >= 20L, sprintf("help keys (%d)", m$summary$n_help_keys))
})
