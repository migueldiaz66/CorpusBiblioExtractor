# `assetsbib/` — bring your own corpus

This project **ships no bibliographic data**. Web of Science / Scopus and similar
proprietary databases license their exports for the subscriber's own use and
**prohibit redistribution**, so committing a real `.bib` to a public repository
would violate those terms. Instead, **you provide your own corpora here** and the
tests read them from this folder. The `.bib` files in this directory are
git-ignored and never leave your machine.

## The convention (dogmatic on purpose)

Drop exactly these two files (any source — WoS, Scopus, OpenAlex, …) exported as
BibTeX:

| File | Required document count | Used by |
|---|---|---|
| `assetsbib/short.bib` | **10 – 40** documents | fast pipeline tests (smoke / regression / determinism) |
| `assetsbib/large.bib` | **400 – 500** documents | the opt-in end-to-end test |

**If a file is missing or its document count is out of range, the tests that need
it are SKIPPED — not failed.** That is the whole rule; there is no further
configuration.

> **Format: Web of Science BibTeX only.** The runner loads corpora with
> `bibliometrix::convert2df(dbsource = "wos", format = "bibtex")`. A generic `.bib`
> (e.g. an OpenAlex export) lacks the WoS-specific fields the runners depend on
> (Keywords-Plus, Cited-References, Times-Cited, Affiliations, …) and will **not**
> work in this version. Export your records from Web of Science as **BibTeX**.
> (Multi-source ingestion is noted as future work in `docs/TECHNICAL_DEBT.md`.)
>
> No example run outputs are shipped either: they would be derived from licensed
> WoS data. Generate your own locally — `runs/` is git-ignored.

## Why two sizes
The pipeline is validated at two corpus scales (~10× apart) to exercise both the
fast path and the heavier network/structure runners, and to check that runtime
scales sub-linearly. See `docs/` for the methodology.
