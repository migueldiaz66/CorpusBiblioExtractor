# NOTICE — attribution

**CorpusBiblioExtractor** is built on top of, requires, and is interoperable with
**bibliometrix** and its Shiny interface **biblioshiny**:

> Aria, M. & Cuccurullo, C. (2017). *bibliometrix: An R-tool for comprehensive
> science mapping analysis.* Journal of Informetrics, 11(4), 959–975.
> https://doi.org/10.1016/j.joi.2017.08.007

`bibliometrix` is licensed under **GPL-3**, © Massimo Aria & Corrado Cuccurullo.

This package, accordingly, is also licensed under **GPL-3** (see `COPYING` /
<https://www.gnu.org/licenses/gpl-3.0.html>). In particular it:

- **requires and calls** `bibliometrix` at runtime (it is a hard dependency);
- **reads biblioshiny's source** (`ui.R`, `helpContent.R`) from the *installed*
  `bibliometrix` package to extract the UI metadata — nothing of bibliometrix is
  needed in this repository to do so;
- **bundles**, under `inst/scaffold/`, documentation pages whose *Info & References*
  sections are **derived from (and in part verbatim of)** biblioshiny's
  `helpContent()`. Those portions remain © Aria & Cuccurullo under GPL-3.

CorpusBiblioExtractor is an **independent personal / portfolio project — a personal tool
built to ease a bibliometrics thesis development process** and is
**not affiliated with, nor endorsed by**, the bibliometrix authors. It is **beta,
unsupported, and accepts no pull requests** — fork it under GPL-3 and improve it.
