# --- spec.R -----------------------------------------------------------------
# Read plan.json and expand each section's Main-Configuration selectors into the
# full list of scenarios (cartesian product, honoring conditional selectors).

read_spec <- function(path) {
  jsonlite::fromJSON(path, simplifyVector = FALSE)
}

# Returns a list of scenarios; each scenario = list(name = "<combo>", values = named list of codes).
# - No params           -> single scenario named "default".
# - Conditional selector -> only included when its `applies_when` holds.
expand_combinations <- function(section) {
  params <- section$params
  if (is.null(params) || length(params) == 0) {
    return(list(list(name = "default", values = list())))
  }

  results <- list()
  recurse <- function(i, acc_names, acc_codes) {
    if (i > length(params)) {
      nm <- if (length(acc_names) == 0) "default" else paste(acc_names, collapse = "__")
      results[[length(results) + 1L]] <<- list(name = nm, values = acc_codes)
      return(invisible())
    }
    sel <- params[[i]]
    key <- sel$key

    # Conditional selector: include only if the referenced param's chosen NAME is in the set.
    if (!is.null(sel$applies_when)) {
      ref   <- sel$applies_when$param
      inset <- unlist(sel$applies_when$`in`)
      ref_name <- NA_character_
      for (an in acc_names) {
        if (startsWith(an, paste0(ref, "-"))) ref_name <- sub(paste0(ref, "-"), "", an)
      }
      if (is.na(ref_name) || !(ref_name %in% inset)) {
        recurse(i + 1L, acc_names, acc_codes)   # skip this selector entirely
        return(invisible())
      }
    }

    for (v in sel$values) {
      codes <- acc_codes
      codes[[key]] <- v$code
      recurse(i + 1L, c(acc_names, paste0(key, "-", v$name)), codes)
    }
  }
  recurse(1L, character(0), list())
  results
}
