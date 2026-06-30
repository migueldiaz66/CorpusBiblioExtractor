# Unit tests for expand_combinations (the heart of Phase 2) — package internal.
expand_combinations <- CorpusBiblioExtractor:::expand_combinations
read_spec           <- CorpusBiblioExtractor:::read_spec
test_section("expand_combinations")

test_that("no params -> single 'default' scenario", {
  r <- expand_combinations(list(params = NULL))
  expect_equal(length(r), 1L, "length")
  expect_equal(r[[1]]$name, "default", "name")
  expect_equal(length(r[[1]]$values), 0L, "no values")
})

test_that("empty params list -> default", {
  r <- expand_combinations(list(params = list()))
  expect_equal(length(r), 1L)
  expect_equal(r[[1]]$name, "default")
})

test_that("one selector x3 -> 3 named scenarios with codes", {
  s <- list(params = list(list(key = "field", values = list(
    list(name = "keywords_plus", code = "ID"),
    list(name = "authors_keywords", code = "DE"),
    list(name = "all_keywords", code = "KW_Merged")))))
  r <- expand_combinations(s)
  expect_equal(length(r), 3L, "length")
  expect_equal(r[[1]]$name, "field-keywords_plus", "name")
  expect_equal(r[[1]]$values$field, "ID", "code")
  expect_equal(r[[3]]$values$field, "KW_Merged", "last code")
})

test_that("two selectors -> cartesian product (2x2=4), nested naming", {
  s <- list(params = list(
    list(key = "method", values = list(list(name = "ca", code = "CA"), list(name = "mca", code = "MCA"))),
    list(key = "field",  values = list(list(name = "kw", code = "ID"),  list(name = "ab", code = "AB")))))
  r <- expand_combinations(s)
  expect_equal(length(r), 4L, "count")
  expect_equal(r[[1]]$name, "method-ca__field-kw", "naming")
  expect_equal(r[[4]]$values$method, "MCA", "code a")
  expect_equal(r[[4]]$values$field, "AB", "code b")
})

test_that("conditional selector included only when ref NAME in set", {
  s <- list(params = list(
    list(key = "field", values = list(
      list(name = "keywords_plus", code = "ID"),
      list(name = "titles", code = "TI"))),
    list(key = "ngrams", applies_when = list(param = "field", `in` = list("titles", "abstracts")),
         values = list(list(name = "unigrams", code = "1"), list(name = "bigrams", code = "2")))))
  r   <- expand_combinations(s)
  nms <- vapply(r, function(x) x$name, "")
  expect_equal(length(r), 3L, "1 (kw, no ngrams) + 2 (titles x ngrams)")
  expect_true("field-keywords_plus" %in% nms, "kw branch drops ngrams")
  expect_true("field-titles__ngrams-unigrams" %in% nms, "titles branch keeps ngrams")
  expect_true("field-titles__ngrams-bigrams" %in% nms, "titles branch keeps ngrams 2")
  expect_false(any(grepl("keywords_plus__ngrams", nms)), "no ngrams under kw")
})

test_that("real plan.json: every section expands without error", {
  spec <- read_spec(system.file("spec", "plan.json", package = "CorpusBiblioExtractor"))
  n <- 0L
  for (sec in spec$sections) { r <- expand_combinations(sec); n <- n + length(r) }
  expect_equal(length(spec$sections), 42L, "42 sections")
  expect_true(n >= 150 && n <= 170, sprintf("~159 scenarios total (got %d)", n))
})
