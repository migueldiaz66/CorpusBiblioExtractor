# Unit tests for save_asset (package internal): each asset type writes a valid file.
save_asset <- CorpusBiblioExtractor:::save_asset
suppressMessages({ library(openxlsx); library(ggplot2); library(igraph) })
test_section("save_asset")

tmp <- function(ext) file.path(tempdir(), sprintf("savetest_%d.%s", as.integer(runif(1, 1, 1e6)), ext))

test_that("table_xlsx writes a readable workbook", {
  p <- tmp("xlsx")
  save_asset(list(type = "table_xlsx", object = data.frame(x = 1:3, y = c("a", "b", "c"))), p)
  expect_file(p, "exists")
  back <- openxlsx::read.xlsx(p)
  expect_equal(nrow(back), 3L, "rows")
  expect_equal(names(back), c("x", "y"), "cols")
})

test_that("figure_png writes a non-empty PNG from a ggplot", {
  p <- tmp("png")
  g <- ggplot(data.frame(x = 1:5, y = (1:5)^2), aes(x, y)) + geom_point()
  save_asset(list(type = "figure_png", object = g), p)
  expect_file(p, "exists")
})

test_that("network_net writes a Pajek .net from an igraph", {
  p <- tmp("net")
  save_asset(list(type = "network_net", object = igraph::make_ring(6)), p)
  expect_file(p, "exists")
  expect_match(readLines(p, n = 1, warn = FALSE), "Vertices", "pajek header")
})

test_that("unknown asset type errors", {
  expect_error(save_asset(list(type = "bogus", object = 1), tmp("x")))
})
