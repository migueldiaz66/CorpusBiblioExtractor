# --- runners_geo.R ----------------------------------------------------------
# Geographic / affiliation / country family of Phase-3 runners.
# Sources, Affiliations, Countries (ANALYSIS) + Countries' Collaboration World
# Map (SYNTHESIS). Registers itself via register_runner(); sourced after
# runners.R so the shared helpers (.tbl/.fig/.hbar) are available.
#
# Loaded by run_exhaustive.R: bibliometrix, dplyr, ggplot2 (+ openxlsx/jsonlite).
# Contract: register_runner("<name>", function(M, params){ list(<assets>) }).
# No plotly, no tryCatch, no set.seed here.

# --- local helpers ----------------------------------------------------------

# Normalize country names to match ggplot2::map_data("world") regions
# (replicates inst/biblioshiny/utils.R::mapworld()). Input already partly
# normalized by metaTagExtraction()'s AU_CO(); we finish the job (notably
# UNITED KINGDOM -> UK and KOREA -> SOUTH KOREA, which AU_CO does not do).
.norm_country <- function(x) {
  x <- toupper(trimws(as.character(x)))
  x <- gsub("[[:digit:]]", "", x)
  x <- gsub(".", "", x, fixed = TRUE)
  x <- gsub(";;", ";", x, fixed = TRUE)
  x <- gsub("UNITED STATES", "USA", x)
  x <- gsub("RUSSIAN FEDERATION", "RUSSIA", x)
  x <- gsub("TAIWAN", "CHINA", x)
  x <- gsub("ENGLAND", "UNITED KINGDOM", x)
  x <- gsub("SCOTLAND", "UNITED KINGDOM", x)
  x <- gsub("WALES", "UNITED KINGDOM", x)
  x <- gsub("NORTH IRELAND", "UNITED KINGDOM", x)
  x <- gsub("UNITED KINGDOM", "UK", x)
  x <- gsub("KOREA", "SOUTH KOREA", x)
  trimws(x)
}

# Cumulative production-over-time table for a ";"-separated multivalue field
# (e.g. AU_UN, AU_CO) crossed with PY. Returns long df: <label>, Year, Articles
# (cumulative document count up to each year) for the top-K elements.
.over_time <- function(M, field, label, top = 5L) {
  PY    <- suppressWarnings(as.numeric(M$PY))
  years <- seq.int(min(PY, na.rm = TRUE), max(PY, na.rm = TRUE))
  sv    <- strsplit(as.character(M[[field]]), ";")
  sv    <- lapply(sv, function(z) { z <- trimws(z); unique(z[!is.na(z) & nchar(z) > 0]) })

  freq <- sort(table(unlist(sv)), decreasing = TRUE)
  topn <- names(freq)[seq_len(min(top, length(freq)))]

  rows <- lapply(topn, function(el) {
    yr  <- PY[vapply(sv, function(z) el %in% z, logical(1))]
    cnt <- vapply(years, function(y) sum(yr == y, na.rm = TRUE), integer(1))
    data.frame(El = el, Year = years, Articles = cumsum(cnt), stringsAsFactors = FALSE)
  })
  df <- do.call(rbind, rows)
  names(df)[1] <- label
  df
}

# Multi-series line chart (production over time). `group` = colour/legend column.
.lines <- function(df, group, title, ylab) {
  ggplot2::ggplot(df, ggplot2::aes(x = .data$Year, y = .data$Articles,
                                   colour = .data[[group]], group = .data[[group]])) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::labs(title = title, x = "Year", y = ylab, colour = group) +
    ggplot2::theme_minimal(base_size = 12)
}

# ===========================================================================
# 1) Most Local Cited Sources  (3.2.2)
#    Cited sources within the collection: metaTagExtraction(CR_SO) + tableTag,
#    exactly as biblioshiny's values$TABSoCit. (citations(field="source") does
#    not exist in bibliometrix; CR_SO/tableTag is the real source of truth.)
# ===========================================================================
register_runner("most_local_cited_sources", function(M, params) {
  MM  <- bibliometrix::metaTagExtraction(M, "CR_SO")
  tab <- bibliometrix::tableTag(MM, "CR_SO")
  TAB <- data.frame(Sources  = names(tab),
                    Articles = as.integer(tab),
                    stringsAsFactors = FALSE)
  TAB <- TAB[!is.na(TAB$Sources) & nchar(TAB$Sources) > 0, , drop = FALSE]
  list(.fig(.hbar(TAB, "Articles", "Sources",
                  "Most Local Cited Sources", "N. of Local Citations")),
       .tbl(TAB))
})

# ===========================================================================
# 2) Sources' Production over Time  (3.2.5)  ·  params$occurrences {cumulate, per_year}
# ===========================================================================
register_runner("sources_production_over_time", function(M, params) {
  occ <- if (is.null(params$occurrences)) "cumulate" else params$occurrences
  cdf <- identical(occ, "cumulate")
  sg  <- bibliometrix::sourceGrowth(M, top = 10, cdf = cdf)   # wide: Year x sources

  sonames <- names(sg)[-1]
  long <- do.call(rbind, lapply(sonames, function(s)
    data.frame(Year = sg$Year, Source = s, Articles = sg[[s]], stringsAsFactors = FALSE)))
  ylab <- if (cdf) "Cumulate occurrences" else "Annual occurrences"

  list(.fig(.lines(long, "Source", "Sources' Production over Time", ylab)),
       .tbl(sg))
})

# ===========================================================================
# 3) Most Relevant Affiliations  (3.3.2.1)  ·  params$disambiguation {yes, no}
#    Affiliations from AU_UN. yes -> count every appearance (per author);
#    no  -> count once per document (unique affiliation per doc).
# ===========================================================================
register_runner("most_relevant_affiliations", function(M, params) {
  disamb <- if (is.null(params$disambiguation)) "yes" else params$disambiguation
  MM <- bibliometrix::metaTagExtraction(M, "AU_UN")
  sv <- strsplit(as.character(MM$AU_UN), ";")

  if (identical(disamb, "no")) {
    vals <- unlist(lapply(sv, function(z) { z <- trimws(z); unique(z[nchar(z) > 0]) }))
  } else {
    vals <- trimws(unlist(sv)); vals <- vals[nchar(vals) > 0]
  }
  tab <- sort(table(vals), decreasing = TRUE)
  TAB <- data.frame(Affiliation = names(tab),
                    Articles    = as.integer(tab),
                    stringsAsFactors = FALSE)

  list(.fig(.hbar(TAB, "Articles", "Affiliation",
                  "Most Relevant Affiliations", "N. of Documents")),
       .tbl(TAB))
})

# ===========================================================================
# 4) Affiliations' Production over Time  (3.3.2.2)
# ===========================================================================
register_runner("affiliations_production_over_time", function(M, params) {
  MM <- bibliometrix::metaTagExtraction(M, "AU_UN")
  df <- .over_time(MM, "AU_UN", "Affiliation", top = 5L)
  list(.fig(.lines(df, "Affiliation", "Affiliations' Production over Time", "Articles")),
       .tbl(df))
})

# ===========================================================================
# 5) Corresponding Author's Countries  (3.3.3.1)
#    Country = AU1_CO (corresponding/first author). SCP if the document has a
#    single country across all authors (AU_CO), MCP otherwise.
# ===========================================================================
register_runner("corresponding_author_countries", function(M, params) {
  MM <- bibliometrix::metaTagExtraction(M, "AU_CO")
  MM <- bibliometrix::metaTagExtraction(MM, "AU1_CO")

  multi <- vapply(strsplit(as.character(MM$AU_CO), ";"), function(z) {
    z <- trimws(z); length(unique(z[nchar(z) > 0])) > 1
  }, logical(1))

  df <- data.frame(Country = trimws(toupper(MM$AU1_CO)), multi = multi,
                   stringsAsFactors = FALSE)
  df <- df[!is.na(df$Country) & nchar(df$Country) > 0, , drop = FALSE]

  agg <- df |>
    dplyr::group_by(Country) |>
    dplyr::summarise(Articles = dplyr::n(),
                     SCP = sum(!multi),
                     MCP = sum(multi), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(Articles)) |>
    as.data.frame()

  d    <- utils::head(agg, 20L)
  long <- rbind(
    data.frame(Country = d$Country, Articles = d$Articles, Collaboration = "SCP", Freq = d$SCP),
    data.frame(Country = d$Country, Articles = d$Articles, Collaboration = "MCP", Freq = d$MCP)
  )
  g <- ggplot2::ggplot(long, ggplot2::aes(x = stats::reorder(Country, Articles),
                                          y = Freq, fill = Collaboration)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_manual(values = c(SCP = "#4477AA", MCP = "#EE6677")) +
    ggplot2::labs(title = "Corresponding Author's Countries", x = NULL, y = "N. of Documents") +
    ggplot2::theme_minimal(base_size = 12)

  list(.fig(g), .tbl(agg))
})

# ===========================================================================
# 6) Countries' Scientific Production  (3.3.3.2)
#    Choropleth world map coloured by country document frequency (AU_CO).
#    Replicates inst/biblioshiny/utils.R::mapworld(). Falls back to a top-20
#    bar chart (no error) if no country name matches the world map.
# ===========================================================================
register_runner("countries_scientific_production", function(M, params) {
  MM <- bibliometrix::metaTagExtraction(M, "AU_CO")
  CO <- as.data.frame(bibliometrix::tableTag(MM, "AU_CO"))
  names(CO) <- c("Tab", "Freq")
  CO$Tab  <- .norm_country(CO$Tab)
  CO$Freq <- as.numeric(CO$Freq)
  CO <- CO[nchar(CO$Tab) > 0, , drop = FALSE]

  tab_out <- CO[order(-CO$Freq), ]
  names(tab_out) <- c("Country", "Freq")

  map.world <- ggplot2::map_data("world")
  map.world$region <- toupper(map.world$region)
  country.prod <- dplyr::left_join(map.world, CO, by = c("region" = "Tab"))

  if (sum(!is.na(country.prod$Freq)) == 0) {            # name merge failed -> fallback
    return(list(.fig(.hbar(tab_out, "Freq", "Country",
                           "Countries' Scientific Production", "N. of Documents")),
                .tbl(tab_out)))
  }

  g <- ggplot2::ggplot(country.prod,
                       ggplot2::aes(x = long, y = lat, group = group)) +
    ggplot2::geom_polygon(ggplot2::aes(fill = Freq)) +
    ggplot2::scale_fill_continuous(low = "#87CEEB", high = "dodgerblue4",
                                   na.value = "grey80") +
    ggplot2::labs(fill = "N.Documents", title = "Country Scientific Production",
                  x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   panel.grid = ggplot2::element_blank())

  list(.fig(g), .tbl(tab_out))
})

# ===========================================================================
# 7) Countries' Production over Time  (3.3.3.3)
# ===========================================================================
register_runner("countries_production_over_time", function(M, params) {
  MM <- bibliometrix::metaTagExtraction(M, "AU_CO")
  df <- .over_time(MM, "AU_CO", "Country", top = 5L)
  list(.fig(.lines(df, "Country", "Countries' Production over Time", "Articles")),
       .tbl(df))
})

# ===========================================================================
# 8) Most Cited Countries  (3.3.3.4)  ·  params$measure {total_citations, average_article_citations}
#    Country = AU1_CO (first author). TC = sum of document citations;
#    Average Article Citations = TC / n. of articles.
# ===========================================================================
register_runner("most_cited_countries", function(M, params) {
  measure <- if (is.null(params$measure)) "total_citations" else params$measure
  MM <- bibliometrix::metaTagExtraction(M, "AU1_CO")

  df <- data.frame(Country = trimws(toupper(MM$AU1_CO)),
                   TC = suppressWarnings(as.numeric(MM$TC)),
                   stringsAsFactors = FALSE)
  df <- df[!is.na(df$Country) & nchar(df$Country) > 0, , drop = FALSE]

  agg <- df |>
    dplyr::group_by(Country) |>
    dplyr::summarise(TC = sum(TC, na.rm = TRUE), Articles = dplyr::n(), .groups = "drop") |>
    as.data.frame()
  agg[["Average Article Citations"]] <- round(agg$TC / agg$Articles, 2)

  if (identical(measure, "average_article_citations")) {
    val <- "Average Article Citations"; ttl <- "Most Cited Countries (avg. article citations)"; xlab <- "Average Article Citations"
  } else {
    val <- "TC"; ttl <- "Most Cited Countries (total citations)"; xlab <- "N. of Citations"
  }
  out <- agg[order(-agg[[val]]), c("Country", "TC", "Average Article Citations")]

  list(.fig(.hbar(out, val, "Country", ttl, xlab)),
       .tbl(out))
})

# ===========================================================================
# 9) Countries' Collaboration World Map  (4.3.2)
#    Country-country collaboration matrix via biblioNetwork(collaboration,
#    countries). Edges table = From/To/Frequency. Map = collaboration segments
#    between country centroids over the world map; falls back (no error) to a
#    bar chart of the top collaborating pairs if no centroid matches.
# ===========================================================================
register_runner("countries_collaboration_world_map", function(M, params) {
  MM  <- bibliometrix::metaTagExtraction(M, "AU_CO")
  Net <- as.matrix(bibliometrix::biblioNetwork(MM, analysis = "collaboration",
                                               network = "countries", sep = ";"))
  cn <- colnames(Net)

  ut    <- which(upper.tri(Net) & Net > 0, arr.ind = TRUE)
  edges <- data.frame(From = cn[ut[, 1]], To = cn[ut[, 2]],
                      Frequency = Net[ut], stringsAsFactors = FALSE)
  edges <- edges[order(-edges$Frequency), , drop = FALSE]

  # centroids of world-map regions
  base <- ggplot2::map_data("world")
  base$region <- toupper(base$region)
  cent <- base |>
    dplyr::group_by(region) |>
    dplyr::summarise(long = mean(long), lat = mean(lat), .groups = "drop") |>
    as.data.frame()

  ef <- edges
  ef$From <- .norm_country(ef$From)
  ef$To   <- .norm_country(ef$To)
  fromc <- cent; names(fromc) <- c("From", "x", "y")
  toc   <- cent; names(toc)   <- c("To", "xend", "yend")
  ef <- merge(ef, fromc, by = "From")
  ef <- merge(ef, toc,   by = "To")
  ef <- ef[!is.na(ef$x) & !is.na(ef$xend), , drop = FALSE]

  if (nrow(ef) == 0) {                                   # no centroid match -> fallback
    bars <- edges
    bars$Pair <- paste(bars$From, bars$To, sep = " - ")
    return(list(.fig(.hbar(bars, "Frequency", "Pair",
                           "Top Country Collaboration Pairs", "N. of Co-Publications")),
                .tbl(edges)))
  }

  nodes <- cent[cent$region %in% unique(c(ef$From, ef$To)), , drop = FALSE]
  g <- ggplot2::ggplot() +
    ggplot2::geom_polygon(data = base, ggplot2::aes(x = long, y = lat, group = group),
                          fill = "grey92", colour = "grey75", linewidth = 0.1) +
    ggplot2::geom_segment(data = ef,
                          ggplot2::aes(x = x, y = y, xend = xend, yend = yend,
                                       linewidth = Frequency),
                          colour = "#4A90E2", alpha = 0.4) +
    ggplot2::geom_point(data = nodes, ggplot2::aes(x = long, y = lat),
                        colour = "#B22222", size = 1.2) +
    ggplot2::scale_linewidth_continuous(range = c(0.2, 2.2)) +
    ggplot2::labs(title = "Countries' Collaboration World Map", x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   panel.grid = ggplot2::element_blank())

  list(.fig(g), .tbl(edges))
})
