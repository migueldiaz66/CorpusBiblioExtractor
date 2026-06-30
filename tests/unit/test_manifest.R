# Unit tests for the manifest helpers (package internal).
asset_key     <- CorpusBiblioExtractor:::asset_key
is_done       <- CorpusBiblioExtractor:::is_done
load_manifest <- CorpusBiblioExtractor:::load_manifest
save_manifest <- CorpusBiblioExtractor:::save_manifest
test_section("manifest")

test_that("asset_key joins with ||", {
  expect_equal(asset_key("sec", "combo", "asset"), "sec||combo||asset")
})

test_that("is_done true only for status == ok", {
  m <- list(`s||c||a` = list(status = "ok"), `s||c||b` = list(status = "error"))
  expect_true(is_done(m, "s||c||a"), "ok")
  expect_false(is_done(m, "s||c||b"), "error")
  expect_false(is_done(m, "missing"), "absent")
})

test_that("manifest save/load round-trips", {
  td <- file.path(tempdir(), paste0("mtest_", as.integer(runif(1, 1, 1e6))))
  dir.create(td, showWarnings = FALSE, recursive = TRUE)
  m <- list(`s||c||a` = list(status = "ok", path = "x.png"))
  save_manifest(td, m)
  expect_file(file.path(td, "_manifest.json"), "written")
  m2 <- load_manifest(td)
  expect_equal(m2[["s||c||a"]]$status, "ok", "status survives")
  expect_true(is_done(m2, "s||c||a"), "is_done after reload")
})

test_that("load_manifest on empty dir -> empty list", {
  td <- file.path(tempdir(), paste0("empty_", as.integer(runif(1, 1, 1e6))))
  dir.create(td, showWarnings = FALSE, recursive = TRUE)
  expect_equal(length(load_manifest(td)), 0L)
})
