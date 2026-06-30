
# Quarto-Typst-MemoriaTFEtypst

[![Quarto extension](https://img.shields.io/badge/Quarto-extension-1f77b4)](https://quarto.org/docs/extensions/)
[![Typst](https://img.shields.io/badge/Typst-239DAD?logo=typst&logoColor=white)](https://typst.app)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Quarto ≥ 1.6.0](https://img.shields.io/badge/Quarto-%E2%89%A5%201.6.0-1f77b4)](https://quarto.org)

📚 **Additional documentation:** [web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/)

▶️ **Installation video:** [videoInstalacionMemoriaTFETypstRStudio.html](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/videoInstalacionMemoriaTFETypstRStudio.html)

> **🇪🇸 Spanish version: [LEEME.md](LEEME.md)** — Documentación en español.
>
> A [Quarto](https://quarto.org) + [Typst](https://typst.app) format for
> **Trabajos Fin de Estudios (TFE)** — final degree projects, master's
> theses and similar academic memoirs — built on top of the
> [Typst](https://quarto.org/docs/output-formats/typst.html) engine
> instead of LaTeX.

This extension wraps Typst with a pre-designed book-like layout that
produces a print-ready PDF for an academic memoir, complete with cover
page, front matter, numbered chapters, figures/tables indexes, Spanish
& English abstracts, optional acknowledgements, and appendices
renumbered with letters (`A.1`, `A.2`, …).

See the rendered demo:

- PDF: [template.pdf](template.pdf) · [tfe_ejemplo01.pdf](tests/ejemplo01/tfe_ejemplo01.pdf)
- Source: [template.qmd](template.qmd) ·
  [tfe_ejemplo01.qmd](tests/ejemplo01/tfe_ejemplo01.qmd)

---

## Table of contents

- [Why Typst for a TFE?](#why-typst-for-a-tfe)
- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [YAML options reference](#yaml-options-reference)
  - [Document metadata](#document-metadata)
  - [Layout & typography](#layout--typography)
  - [Front matter & navigation](#front-matter--navigation)
  - [Cover page](#cover-page)
  - [Chapter header style](#chapter-header-style)
  - [Appendices](#appendices)
  - [Math](#math)
  - [Bibliography](#bibliography)
- [Shortcodes](#shortcodes)
- [The most complete example](#the-most-complete-example)
- [Architecture](#architecture)
- [Troubleshooting](#troubleshooting)
- [Roadmap &amp; ideas](#roadmap--ideas)
- [Contributing](#contributing)
- [License](#license)

---

## Why Typst for a TFE?

- **Faster compilation** than LaTeX (often 10-50×).
- **Reproducible builds** — Typst packages are pinned in the
  extension and resolved via the Typst package registry.
- **Clean defaults** — no need to install a TeX distribution.
- **Quarto integration** — keep your `.qmd` workflow, code chunks
  (R / Python / Julia), cross-references, citations, callouts, and
  theorems.

The format was designed for Spanish universities' *Trabajo Fin de
Grado* (TFG) and *Trabajo Fin de Máster* (TFM), but it is fully
parameterised and can be adapted to other languages and conventions
via the [YAML options](#yaml-options-reference).

---

## Features

| Area | What the extension provides |
|---|---|
| **Cover page** | University logo, degree, faculty, university, work type, title, author, tutor, date — all configurable; can be disabled. |
| **Front matter** | Spanish `resumen` + `palabras-clave`, English `abstract` + `keywords`, optional `agradecimientos`, all with dedicated (unnumbered) pages. |
| **Tables of contents** | Master TOC, list of figures, list of tables, and an *optional* per-chapter mini-TOC. |
| **Chapter headers** | Three different designs (`estilo01`, `estilo02`, `estilo03`) selectable per document. |
| **Appendices** | A `{{< appendix >}}` shortcode resets figure/table/heading numbering to `A.1`, `A.2`, … with a dedicated divider page. |
| **Math** | LaTeX syntax (with `$$ … $$`), plus automatic re-centering of block equations inside lists, and a Lua filter that converts LaTeX `\boxed{}` to Typst boxes. |
| **Code blocks** | Distinct coloured boxes for R, Python, generic and Markdown code. |
| **Cross-references** | Standard Quarto syntax for sections, figures (`@fig-…`), tables (`@tbl-…`), equations (`@eq-…`) and theorems (`@thm-…`). |
| **Bibliography** | BibLaTeX/BibTeX with `apa` and `chicago-author-date` CSL styles, and an option to print the full bibliography on a single page. |
| **HTML twin** | The same `.qmd` can render to a self-contained HTML version with collapsible code. |

---

## Installation

Pick **one** of the three install modes.

### A) Install into an existing Quarto project

```bash
quarto add calote/quarto-typst-memoriatfetypst
```

To overwrite a previous install without interactive prompts:

```bash
quarto add calote/quarto-typst-memoriatfetypst --no-prompt
```

This copies `_extensions/memoriatfetypst/` into your project.

### B) Use the GitHub template

```bash
quarto use template calote/quarto-typst-memoriatfetypst
```

This clones the repo, drops you in a folder named
`quarto-typst-memoriatfetypst/`, and gives you a working `template.qmd`
to start from.

### C) Manual install

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cp -r quarto-typst-memoriatfetypst/_extensions YOUR_PROJECT/
```

### Verify the install

```bash
quarto --list-extensions
# memoriatfetypst   …   YOUR_PROJECT/_extensions/memoriatfetypst
```

The extension requires Quarto ≥ 1.6.0.

### Install a specific version

To pin a particular release, append the tag to the repository reference:

```bash
quarto add calote/quarto-typst-memoriatfetypst@v1.0.0
```

Available tags are listed in the [GitHub Tags](../../tags) page.

---

## Quick start

Minimal `.qmd` that uses every front-matter feature:

```yaml
---
title: |
  Análisis Estadístico
  
  con Quarto-Typst
author: Marta García González
resumen: |
  Este trabajo presenta una metodología de optimización para la toma
  de decisiones en problemas de clasificación binaria …
palabras-clave: [Quarto, Typst, formato]
abstract: |
  This work presents an optimisation methodology for decision-making
  in binary classification problems …
keywords: [Quarto, Typst, format]
agradecimientos: |
  A mi tutor, por sus comentarios y sugerencias …
lang: es
date: today
bibliography: referencias.bib
format:
  memoriatfetypst-typst:
    portada: true
    toc: true
    tofiguras: true
    totablas: true
    logo-file: "logo.png"
    titulacion: "Grado en Estadística"
    facultad: "Facultad de Matemáticas"
    universidad: "Universidad de Sevilla"
    tutor-TFG: "Tutor: Pedro L. Luque"
    fecha-TFG: "Sevilla, Junio de 2026"
    cabecera-capitulo: "estilo01"
    nombre-capitulo: "CAPÍTULO"
    toccapitulos: false
  html:
    embed-resources: true
execute:
  warning: false
  message: false
---

# Introducción

Texto del primer capítulo …

# Metodología

Texto del segundo capítulo …

{{< appendix >}}

# Código fuente

Apéndice con el código R completo …
```

Compile with:

```bash
quarto render mi-tfe.qmd --to memoriatfetypst-typst
quarto render mi-tfe.qmd --to html      # twin HTML version
```

---

## YAML options reference

All options live under the `format.memoriatfetypst-typst` key unless
stated otherwise. Options that are inherited from Quarto's standard
Typst format are also listed for completeness.

### Document metadata

| Option | Type | Default | Description |
|---|---|---|---|
| `title` | string | — | Document title. Use the YAML block scalar (`\|`) for multi-line titles. |
| `subtitle` | string | — | Optional subtitle. |
| `author` | string | — | Author name. |
| `date` | string / date | `today` | Date of the document. |
| `date-format` | string | `full` | R / `format()` style date format (`full`, `long`, `medium`, `short`, or a custom pattern). |
| `lang` | string | `es` | BCP-47 language tag (also used for hyphenation). |
| `region` | string | `ES` | BCP-47 region. |
| `abstract` | string | — | English abstract (appears on a dedicated unnumbered page labelled *Abstract*). |
| `abstract-title` | string | `RESUMEN` | Heading text used on the English abstract page. |
| `keywords` | list | — | English keywords shown after the abstract. |
| `resumen` | string | — | Spanish abstract (appears on its own page). |
| `palabras-clave` | list | — | Spanish keywords shown after the resumen. |
| `agradecimientos` | string | — | Acknowledgements paragraph on a dedicated unnumbered page. |
| `bibliography` | string | — | Path to a `.bib` file (BibTeX or BibLaTeX). |
| `csl` | string | — | Optional CSL file (e.g. `apa`, `chicago-author-date`). When omitted, Typst's native bibliography style is used. |

### Layout & typography

| Option | Type | Default | Description |
|---|---|---|---|
| `papersize` | string | `a4` | Paper size. Any Typst paper name (`a4`, `us-letter`, `a5`, …). |
| `margin` | dict | `{x: 2.5cm, y: 2.5cm}` | Page margins. Accepts `{x, y}` shorthand or `{top, bottom, left, right}` in any length unit. |
| `mainfont` | string | `libertinus serif` | Body font. |
| `sansfont` | string | `Helvetica` | Sans-serif font (used in cover page). |
| `mathfont` | string | `New Computer Modern Math` | Math font. |
| `fontsize` | length | `11pt` | Base body size. |
| `link-color` | colour | `rgb("#483d8b")` | Colour of internal & external links. |
| `section-numbering` | string | `1.1.1` | Numbering pattern for sections (e.g. `1.1.1.1` for four levels). |
| `page-numbering` | string | `1` | Page numbering style. Front matter is always roman (`i`, `ii`, …) regardless. |

### Front matter & navigation

| Option | Type | Default | Description |
|---|---|---|---|
| `portada` | bool | `true` | Render the cover page. |
| `toc` | bool | `true` | Render the main table of contents. |
| `tofiguras` | bool | `true` | Render the list of figures. |
| `totablas` | bool | `true` | Render the list of tables. |
| `toccapitulos` | bool | `false` | Render a small "in this chapter" TOC box at the start of every chapter. |
| `bibliografia-completa` | bool | `false` | Print every bibliography entry on a single page (`true`) vs. the default multi-page layout. |

### Cover page

| Option | Type | Default | Description |
|---|---|---|---|
| `logo-file` | string | — | Path to a logo (PNG/SVG/JPG). Shown at 7 cm width on the cover. |
| `titulacion` | string | `Grado en Estadística` | Degree name. |
| `facultad` | string | — | Faculty / school (optional). |
| `universidad` | string | — | University name (optional). |
| `tutor-TFG` | string | — | Supervisor line, e.g. `Tutor: Dr. Juan Pérez`. |
| `fecha-TFG` | string | `Sevilla, Junio de 2025` | Place + date line at the bottom of the cover. |
| `tipo-TFG` | string | `TRABAJO FIN DE GRADO` | Work type (`TRABAJO FIN DE MÁSTER`, `TESIS DOCTORAL`, …). |

### Chapter header style

| Option | Type | Default | Description |
|---|---|---|---|
| `cabecera-capitulo` | string | `estilo01` | One of `estilo01`, `estilo02`, `estilo03` (see below). |
| `nombre-capitulo` | string | `CAPÍTULO` | Label printed next to the chapter number (use `--` to hide the label entirely in `estilo03`). |
| `referencias-nombre` | string | `Referencias` | Heading text of the bibliography section. |
| `apendice-portada` | string | `APÉNDICE` | Large text on the appendix divider page. |
| `apendice-nombre` | string | `APÉNDICE` | Label printed next to the appendix number. |

The three chapter styles are:

- **`estilo01`** — Large translucent grey number on the top-right of
  the chapter page, with the chapter title right-aligned and a short
  horizontal rule. The default, suitable for most TFGs.
- **`estilo02`** — Compact right-aligned banner with a colour
  gradient (`color.map.crest`) and white text. More graphical.
- **`estilo03`** — Left-aligned, no number watermark. Use
  `nombre-capitulo: "--"` to print only the title, useful for a
  one-chapter monograph or a "Bibliografía" chapter with no number.

### Appendices

There is no YAML option for appendices — they are triggered by the
[`{{< appendix >}}` shortcode](#shortcodes). Once the shortcode is
encountered:

- heading numbering restarts at `1` and is prefixed with `A`
  (`A.1`, `A.1.1`, …),
- figure numbering is prefixed with `A` (`A.1`, `A.2`, …),
- table numbering is prefixed with `A` (`A.1`, `A.2`, …),
- a divider page is inserted with the text from `apendice-portada`.

### Math

| Option | Type | Default | Description |
|---|---|---|---|
| `centrar-matematicas` | bool | `true` | Re-centre `$$ … $$` equations that appear inside indented environments (lists, blockquotes, …) so they are visually centred on the full text column, not on the indented column. Set to `false` to disable. |

Additionally, the bundled `boxed-filter.lua` translates LaTeX
`\boxed{…}` expressions (both inline and display) into Typst
`#box(stroke: 0.5pt, inset: 7pt, baseline: 0.55em)[$…$]`. The
function is applied automatically — no option needed.

### Bibliography

| Option | Type | Default | Description |
|---|---|---|---|
| `bibliography` | string | — | Path to a `.bib` file. |
| `csl` | string | — | Optional CSL file. Examples used in the project: `apa.csl`, `chicago-author-date.csl`. |
| `bibliografia-completa` | bool | `false` | When `true`, prints the whole bibliography on a single page instead of letting it flow. |

The bibliography is automatically titled with `referencias-nombre` and
its header/footer are replaced with that title (no chapter number,
upper-cased).

---

## Shortcodes

| Shortcode | Purpose |
|---|---|
| `{{< appendix >}}` | Marks the start of the appendices. Inserts a divider page and switches heading / figure / table numbering to `A.1`, `A.2`, … |
| `{{< pagebreak >}}` | Inserts a hard page break. Useful between sections that should not share a page (e.g. before the conclusions). |

Both shortcodes are defined in `_extensions/memoriatfetypst/shortcodes.lua`.

---

## The most complete example

The richest working example is in
[`tests/ejemplo01/`](tests/ejemplo01). It demonstrates:

- A **multi-file** project: `tfe_ejemplo01.qmd` (the main file) plus
  two children — `capitulo03.qmd` and `apendice01.qmd` — pulled in
  with `{{< include … >}}` and the `child` chunk parameter.
- **Dual-language front matter** (`resumen` + `palabras-clave` and
  `abstract` + `keywords`) and an `agradecimientos` page.
- **Three figures** generated from R code (histogram, boxplot, ggplot
  scatter saved to PNG and re-included), plus an external image and
  a `logo.png` re-used throughout.
- **Six table styles**: `tinytable`, `knitr::kable()`, native
  Markdown, multi-panel `layout-ncol`, mixed table/figure panels,
  Pandoc grid tables, and a long `tinytable` rendered with
  `breakable: true`.
- **A regression table** with `modelsummary::msummary()` and an
  alternative version loaded from a pre-saved `.rds` (useful for
  faster rebuilds).
- **Mathematical theorems** (`def-`, `thm-`, `exm-`, `exr-`) using
  the convention that the **block identifier must start with the
  prefix** of its kind for cross-references to work cleanly.
- **A long, multi-page table** using the Typst trick
  `#show figure: set block(breakable: true)` to allow page breaks
  inside a table.
- **An appendix** generated through the `{{< appendix >}}` shortcode,
  with `A.1`-style numbering.

To compile it locally:

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cd quarto-typst-memoriatfetypst/tests/ejemplo01
quarto render tfe_ejemplo01.qmd --to memoriatfetypst-typst
quarto render tfe_ejemplo01.qmd --to html
open tfe_ejemplo01.pdf
```

---

## Architecture

```
_extensions/memoriatfetypst/
├── _extension.yml          # Quarto extension manifest
├── typst-template.typ      # Main Typst `article` function
├── typst-show.typ          # Quarto → Typst parameter bridge
├── shortcodes.lua          # `appendix` and `pagebreak` shortcodes
└── boxed-filter.lua        # LaTeX \boxed{} → Typst #box() filter
```

- **`_extension.yml`** declares the format, requires Quarto ≥ 1.6.0,
  pulls the two Typst partials, the shortcode Lua file, and the
  filter. It also sets the format defaults (`portada: true`,
  `toc: true`, `centrar-matematicas: true`, `fig-format: png`).
- **`typst-template.typ`** defines a single `article()` function that
  receives all parameters, sets up page geometry, headers/footers,
  numbered chapter styles, front-matter pages, and the bibliography.
  The `appendix()` function at the bottom resets numbering and
  inserts a divider page.
- **`typst-show.typ`** is the *show template* that Quarto invokes; it
  forwards every supported YAML key to the `article()` function with
  the right Typst type conversion (`$if(...)$ … $endif$`).
- **`shortcodes.lua`** provides the two shortcodes. They emit
  raw Typst that triggers the corresponding behaviour in
  `typst-template.typ`.
- **`boxed-filter.lua`** walks the AST after Pandoc → Typst
  conversion and rewrites any `Math` node that contains `\boxed{…}`
  into a Typst `#box()` / `#rect()` call, since Typst's native
  pandoc converter does not implement `\boxed`.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `unknown variable: nombre-capitulo` | Missing `nombre-capitulo` while using `estilo03` | Set `nombre-capitulo: "--"` or any non-empty string. |
| Block equations stay indented inside lists | `centrar-matematicas: false` | Set to `true` (default). |
| Bibliography page is empty | CSL file not found | Make sure the path in `csl:` is correct, or remove the `csl:` key to use the default Typst style. |
| Long tables overflow a single page | Typst figures are not breakable by default | Wrap the table in ` ```{=typst} #show figure: set block(breakable: true) ``` ` and reset after with `breakable: false`. See `apendice01.qmd` for an example. |
| Cover page prints without logo | `logo-file` path is relative to the project root, not the `.qmd` file | Use a path relative to the directory where you run `quarto render`. |
| `quarto add` fails interactively | — | Re-run with `--no-prompt`. |
| BibTeX `csl` styles look off | Quarto uses the CSL processor, not Typst's native one | Either keep the CSL workflow or remove the `csl:` key and let Typst render natively. |

---

## Roadmap & ideas

See the [proposals file](PROPOSALS.md) (or the [issue tracker](../../issues))
for the full list. Highlights:

- Allow `margin` to be a single length (e.g. `margin: 2cm`) in
  addition to the dictionary form.
- Accept `bibliografia-completa` as a real boolean instead of a
  string compared to `"true"`.
- Add an option to inject additional Typst code (`include-in-header`)
  from the YAML, e.g. for custom LaTeX-like theorem styles.
- Document and ship a third (and fourth) chapter header style
  (`estilo04` with a sidebar, `estilo05` with a centred title).
- Provide a `_metadata.yml` example for multi-document book projects.
- Add a GitHub Actions workflow that renders the example on every PR.
- Add a Spanish translation of the README.
- Remove the leftover `print("DEBUG: …")` in `boxed-filter.lua`.

---

## Complementary R packages

The following R packages are **not required** to use this extension,
but they are particularly useful because they natively support
**Typst** output and integrate seamlessly with Quarto documents.

| Package | Version installed | Description |
|---|---|---|
| [`tinytable`](https://vincentarelbundock.github.io/tinytable/) | 0.16.0.14 | Flexible table rendering with native Typst output (`plugin: "typst"`). Supports multi-page, captions, spanning headers, and more. |
| [`modelsummary`](https://vincentarelbundock.github.io/modelsummary/) | 2.6.0.4 | Model summaries, regression tables, and coefficient plots. Exports directly to Typst via `output = "typst"` or through `tinytable`. |

To install the latest development version of either package from GitHub:

```r
# install.packages("remotes")
remotes::install_github("vincentarelbundock/tinytable")
remotes::install_github("vincentarelbundock/modelsummary")
```

---

## Contributing

Issues and pull requests are welcome. If you plan a non-trivial
change, please open an issue first to discuss the design. When
submitting a PR, please:

1. Render `tests/ejemplo01/tfe_ejemplo01.qmd` and confirm the PDF
   still compiles.
2. If you change a YAML option, update both this README *and* the
   example files.
3. If you change the Typst template, verify the three chapter styles
   (`estilo01/02/03`) still render.

---

## License

Released under the [MIT License](LICENSE). © 2025-2026 Pedro Luque.
