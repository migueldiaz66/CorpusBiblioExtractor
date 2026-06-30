# --- manifest.R -------------------------------------------------------------
# Per-(section, combination, asset) status, enabling --resume.

manifest_path <- function(run_dir) file.path(run_dir, "_manifest.json")

load_manifest <- function(run_dir) {
  p <- manifest_path(run_dir)
  if (file.exists(p)) jsonlite::fromJSON(p, simplifyVector = FALSE) else list()
}

save_manifest <- function(run_dir, manifest) {
  jsonlite::write_json(manifest, manifest_path(run_dir), auto_unbox = TRUE, pretty = TRUE)
}

asset_key <- function(section, combo, asset) paste(section, combo, asset, sep = "||")

is_done <- function(manifest, key) {
  rec <- manifest[[key]]
  !is.null(rec) && identical(rec$status, "ok")
}
