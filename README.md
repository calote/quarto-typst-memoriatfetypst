
# Quarto-Typst-MemoriaTFEtypst

[![Quarto extension](https://img.shields.io/badge/Quarto-extension-1f77b4)](https://quarto.org/docs/extensions/)
[![Typst](https://img.shields.io/badge/Typst-239DAD?logo=typst&logoColor=white)](https://typst.app)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Quarto ≥ 1.6.0](https://img.shields.io/badge/Quarto-%E2%89%A5%201.6.0-1f77b4)](https://quarto.org)

📚 **Additional documentation:** [web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/)

That site provides the complete extension manual beyond these READMEs: a detailed YAML option reference with usage examples and linked PDF outputs, a section on advanced Quarto-Typst usage (raw Typst code, bibliography with CSL vs. Typst, Jupyter notebooks, Python + R integration), and a collection of curated external resources (alternative Quarto-Typst extensions, Typst guides, useful Positron plugins). It also hosts installation videos (RStudio & Positron), multiple worked examples with downloadable source files, and a Typst cheatsheet.

▶️ **Installation videos:** [RStudio](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/videoInstalacionMemoriaTFETypstRStudio.html) · [Positron](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/videoInstalacionMemoriaTFETypstPositron.html)

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

- PDF: <a href="template.pdf" target="_blank" rel="noopener">template.pdf ↗</a> · <a href="tests/ejemplo01/tfe_ejemplo01.pdf" target="_blank" rel="noopener">tfe_ejemplo01.pdf ↗</a> · <a href="https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemplo01/tfe_ejemplo01.pdf" target="_blank" rel="noopener">ver online ↗</a>
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
- [Dual use: one source, two formats](#dual-use-one-source-two-formats)
- [Feature gallery](#feature-gallery)
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
| **Chapter headers** | Four different designs (`estilo01`–`estilo04`) selectable per document. |
| **Article / report mode** | Set `nombre-capitulo: "--"` to hide chapter labels and produce an article- or report-style document (ideal for shorter works, informes, or papers). |
| **Appendices** | A `{{< appendix >}}` shortcode resets figure/table/heading numbering to `A.1`, `A.2`, … with a dedicated divider page. |
| **Math** | LaTeX syntax (with `$$ … $$`), plus automatic re-centering of block equations inside lists, and a Lua filter that converts LaTeX `\boxed{}` to Typst boxes. |
| **Theorems** | Optional `theorem-style: "modern"` enables coloured theorem boxes (definition, theorem, lemma, corollary, example, exercise). Untitled environments no longer show empty parentheses `()`. |
| **Code blocks** | Distinct coloured boxes for R, Python, generic and Markdown code. |
| **Cross-references** | Standard Quarto syntax for sections, figures (`@fig-…`), tables (`@tbl-…`), equations (`@eq-…`) and theorems (`@thm-…`). Link, cross-reference and citation colors are customizable (`link-color`, `internal-link-color`, `cite-color`). |
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

> **`quarto add` vs `quarto use template`:**
>
> - **`quarto add`** only installs the extension files into `_extensions/`.
>   It never touches your existing documents (`.qmd`, `.bib`, images, etc.).
>   Use this to add the format to a project you already have.
>
> - **`quarto use template`** creates a **new directory** from the repository.
>   If the current directory is not empty, you will be prompted for a new folder name.
>   It never overwrites existing project files.
>
> To update or reinstall the extension in an existing project, use `quarto add`
> again (with `--no-prompt` to skip confirmation). To pin a specific version,
> append `@<tag>` (see below).

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
| `link-color` | string | `"#483d8b"` | Color of external links (URLs). |
| `internal-link-color` | string | `"#5b5b9e"` | Color of internal links & cross-references (`@sec-`, `@fig-`, `@tbl-`, `@thm-`, `@def-`, etc.). |
| `cite-color` | string | `"#6A1B9A"` | Color of bibliographic citations (`@cite2020`). |
| `section-numbering` | string | `1.1.1` | Numbering pattern for sections (e.g. `1.1.1.1` for four levels). |
| `page-numbering` | string | `1` | Page numbering style. Front matter is always roman (`i`, `ii`, …) regardless. |
| `heading-style` | bool | `true` | Apply LaTeX-style heading sizes and spacing to sub-sections (H2–H6). Set to `false` to use the default Typst heading proportions. |

#### Font sources

Fonts can be declared in two ways:

**1. Simple Typst options** (via format YAML):

```yaml
format:
  memoriatfetypst-typst:
    mainfont: Libertinus Serif    # Body font
    sansfont: Helvetica            # Sans-serif (cover page)
    mathfont: New Computer Modern Math  # Math font
```

**2. `brand.typography`** (Quarto's brand system, recommended for portability):

```yaml
brand:
  typography:
    fonts:
      - family: Jost
        source: google             # Downloaded by Quarto automatically
        weight: [300, 400, 500, 600, 700]
      - family: Lato
        source: system             # Must be installed on the OS
    base: Jost                     # Body font
    headings: Jost                 # Headings font
```

| Font source | Works on | Notes |
|---|---|---|
| `source: google` | ✅ All OS | Quarto downloads automatically during render |
| `source: system` | ⚠️ Only if installed | Use `fc-list` (Linux/macOS) to verify |
| `source: file` | ✅ All OS | Paths must exist in the repository |

> **Note:** `Libertinus Sans` and `Libertinus Serif` are **not** available on Google Fonts. Use `source: system` or `source: file` with local OTF files. `New Computer Modern Math` is bundled with Typst and does not need declaration.

To customize the values (font size, spacing above/below, etc.), set `heading-style: false` and create your own `mis-secciones.typ` file with custom show rules, then include it via `include-in-header`:

```yaml
heading-style: false
include-in-header: ["mis-secciones.typ"]
```

```typst
// mis-secciones.typ — custom heading sizes and spacing
#show heading.where(level: 2): set text(size: 1.5em)
#show heading.where(level: 2): it => block(above: 3em, below: 2em, it)
#show heading.where(level: 3): set text(size: 1.3em)
#show heading.where(level: 3): it => block(above: 2.5em, below: 1.5em, it)
// ... repeat for levels 4–6 as needed
```

> **Note:** the rules from `include-in-header` are placed at document level (before `#show: doc => …`), so `heading-style` must be `false` to avoid conflicts with the extension's defaults.

### Section highlight (heading-highlight)

| Option | Type | Default | Description |
|---|---|---|---|
| `heading-highlight` | int | `0` | Highlight sub-sections with a coloured background. `0` disables; `2`–`6` highlights from level 2 up to that level. |
| `heading-highlight-color` | string | `"#e8f0fe"` | Background colour for highlighted sections (hex). |
| `heading-highlight-text-color` | string | `"#1a1a2e"` | Text colour for highlighted sections (hex). |

Example — highlight levels 2–4 with `#2c3e50` background and `#ecf0f1` text:

```yaml
format:
  memoriatfetypst-typst:
    heading-highlight: 4
    heading-highlight-color: "#2c3e50"
    heading-highlight-text-color: "#ecf0f1"
```

The rectangular background wraps multi-line headings and does not affect spacing (controlled by `heading-style`).

### Watermark & vertical brand

| Option | Type | Default | Description |
|---|---|---|---|
| `watermark-text` | string | — | Diagonal watermark text (e.g. `"BORRADOR"`). Use `" \| "` for multiple lines. |
| `watermark-opacity` | float | `0.12` | Opacity (0.0–1.0). |
| `watermark-color` | string | `"#000000"` | Text colour. |
| `watermark-fontsize` | length | `72pt` | Font size. |
| `watermark-angle` | angle | `35deg` | Rotation angle. |
| `brand-vertical-text` | string | — | Vertical text on the right margin (e.g. institution name). |
| `brand-vertical-color` | string | `"#999999"` | Text colour. |
| `brand-vertical-fontsize` | length | `0.8em` | Font size. |
| `brand-vertical-width` | length | `1.5cm` | Right margin width reserved for the brand. |
| `brand-vertical-dy` | percent | `50%` | Vertical position (`50%` = centre, `85%` = near bottom). |
| `brand-vertical-logo` | string | — | Optional logo image path above the text. |

Example:

```yaml
format:
  memoriatfetypst-typst:
    watermark-text: "BORRADOR | DOCUMENTO DE TRABAJO"
    watermark-opacity: 0.12
    brand-vertical-text: "Universidad de Sevilla"
    brand-vertical-dy: 85%
```

> **Note:** The watermark is drawn on the page background. Callouts and other blocks with their own fill may cover it — this is expected behaviour.

### Exercises (examtypst-functions)

The extension ships optional Typst functions to create exam-style exercises inside a memoir document. Two aesthetics are available:

| Style | Include file | Description |
|-------|-------------|-------------|
| **Classic** (default) | `examtypst-functions.typ` | Blue-bordered boxes for exercises, green boxes for solutions |
| **Modern** | `examtypst-functions-modern.typ` | Cards with coloured left border (slate + amber + teal palette) |

To use them, add the following to your YAML:

```yaml
format:
  memoriatfetypst-typst:
    include-in-header:
      - "_extensions/memoriatfetypst/examtypst-functions.typ"
    filters:
      - _extensions/memoriatfetypst/typst-function.lua
```

Then use Quarto Divs:

```markdown
:::{.ejercicio arguments='title: "Ecuación", puntos: 2.5'}
Resuelve: $3x + 5 = 20$
:::

:::{.solucion}
$x = 5$
:::

:::{.pregunta-multiple arguments='opciones: ("Madrid", "Londres", "París", "Berlín"), correcta: 3, columnas: 2'}
¿Cuál es la capital de Francia?
:::

:::{.verdadero-falso arguments='correcta: true'}
La suma de los ángulos de un triángulo es 180°.
:::

:::{.espacio-desarrollo arguments='lineas: 6, puntos: true'}
:::
```

Available function types:

| Div class | Behaviour |
|---|---|
| `.ejercicio` | Numbered exercise with blue border |
| `.solucion` | Green solution box |
| `.apartado` | Sub-section (a, b, c...) |
| `.pregunta-multiple` | Multiple choice |
| `.verdadero-falso` | True/False |
| `.espacio-desarrollo` | Blank lines for answers |
| `.respuesta-corta` | Underlines for short answer |

#### Display options (YAML)

Global document-level options:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `mostrar-ejercicio-cuadro` | bool | `true` | Wrap exercises in a coloured box (`true`) or plain text (`false`). |
| `mostrar-solucion-cuadro` | bool | `true` | Wrap solutions in a coloured box (`true`) or plain text (`false`). |
| `ejercicio-salto-linea` | bool | `true` | Add a vertical gap after the exercise header (`true`) or no gap (`false`). |

#### Per-instance override (Div arguments)

Override display options for individual exercises and solutions:

```markdown
:::{.ejercicio arguments='puntos: 2, mostrar-cuadro: false'}
Exercise without box (overrides global YAML)
:::

:::{.solucion arguments='mostrar-cuadro: true'}
Solution with box (overrides global YAML if false)
:::
```

Available arguments:
- **`ejercicio`**: `mostrar-cuadro` (bool or none), `salto-linea` (bool or none)
- **`solucion`**: `mostrar-cuadro` (bool or none)

If argument is omitted or `none`, uses the global YAML setting. If set explicitly (`true`/`false`), overrides it for that specific instance.

#### Complete examples

- Classic style: [`tests/examen/test-examen.qmd`](tests/examen/test-examen.qmd)
- Modern style: [`tests/examen/test-examen-moderno.qmd`](tests/examen/test-examen-moderno.qmd)
- Advanced (decision theory exam with custom options): [`tests/examen/test-examen-teoriadecision.qmd`](tests/examen/test-examen-teoriadecision.qmd)
- **Gallery with per-instance overrides**: [`tests/examen/test-examen-demografia.qmd`](tests/examen/test-examen-demografia.qmd) — demonstrates all exercise types and override examples

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
| `cabecera-capitulo` | string | `estilo01` | One of `estilo01`, `estilo02`, `estilo03`, `estilo04` (see below). |
| `nombre-capitulo` | string | `CAPÍTULO` | Label printed next to the chapter number. Use `--` to switch to article/report mode (no chapter labels, titles only). |
| `numerar-secciones-nivel1` | boolean | *(auto)* | Controls whether level-1 headings show their number. In report mode (`nombre-capitulo: "--"`) it is suppressed automatically; set to `true` to restore full numbering. Outside report mode, full numbering is always the default. |
| `referencias-nombre` | string | `Referencias` | Heading text of the bibliography section. |
| `apendice-portada` | string | `APÉNDICE` | Large text on the appendix divider page. |
| `apendice-nombre` | string | `APÉNDICE` | Label printed next to the appendix number. |

The four chapter styles are:

- **`estilo01`** — Large translucent grey number on the top-right of
  the chapter page, with the chapter title right-aligned and a short
  horizontal rule. The default, suitable for most TFGs.
- **`estilo02`** — Compact right-aligned banner with a colour
  gradient (`color.map.crest`) and white text. More graphical.
- **`estilo03`** — Left-aligned, no number watermark. Use
  `nombre-capitulo: "--"` to print only the title, useful for a
  one-chapter monograph or a "Bibliografía" chapter with no number.
- **`estilo04`** — Left sidebar with a vertical colour gradient and
  the chapter number rotated 90 degrees. The sidebar spans the full
  page height and sits in the left margin (0.5 cm from the page edge).
  The chapter title is left-aligned. Customisable with:
  - `sidebar-color1` / `sidebar-color2` (hex strings) — gradient
    endpoints (default `#1a365d` / `#2c5282`).
  - `sidebar-dx` (length) — distance from the page edge (default
    `0.5cm`).
  - `sidebar-show` (string) — when to show the sidebar: `"all"`
    (every page, default) or `"first-page"` (only on the first page
    of each chapter and appendix).

### Appendices

There is no YAML option for appendices — they are triggered by the
[`{{< appendix >}}` shortcode](#shortcodes). Once the shortcode is
encountered:

- heading numbering restarts at `1` and is prefixed with `A`
  (`A.1`, `A.1.1`, …),
- figure numbering is prefixed with `A` (`A.1`, `A.2`, …),
- table numbering is prefixed with `A` (`A.1`, `A.2`, …),
- a divider page is inserted with the text from `apendice-portada`.

### Syntax highlighting / code blocks

Since **Quarto ≥ 1.9**, the extension requires the following key to
be **explicitly uncommented** in your document YAML in order to use
the extension's custom code block styling (coloured boxes per
language with matching background tints):

```yaml
format:
  memoriatfetypst-typst:
    highlight-style: idiomatic   # ← must be active for custom code blocks
```

| Option | Type | Default | Description |
|---|---|---|---|
| `highlight-style` | string | — (Pandoc Skylighting) | Set to `idiomatic` to use the Typst native highlighter and the extension's custom code block appearance. |

If you **omit or comment out** this key, Pandoc's Skylighting
highlighter takes over and you can use any of the standard Quarto
themes instead. For example:

```yaml
format:
  memoriatfetypst-typst:
    syntax-highlighting: arrow      # Default, accessibility-optimised
    # syntax-highlighting: github   # GitHub style
    # syntax-highlighting: dracula  # Dark background
    # syntax-highlighting: monokai  # Dark background
    # syntax-highlighting: solarized
    # syntax-highlighting: nord
    # syntax-highlighting: gruvbox
```

With Skylighting the syntax colours change but the custom per-language
block background is lost. Choose whichever best fits your document's
look.

### Math & theorems

| Option | Type | Default | Description |
|---|---|---|---|
| `centrar-matematicas` | bool | `true` | Re-centre `$$ … $$` equations that appear inside indented environments (lists, blockquotes, …) so they are visually centred on the full text column, not on the indented column. Set to `false` to disable. |
| `theorem-style` | string | — | Set to `"modern"` to enable coloured theorem boxes (bar-left coloured stroke per type). Uses [Theorion](https://github.com/OrangeX4/typst-theorion) under the hood. **Fix applied**: exercises, definitions, theorems, or examples without a `##### Title` no longer show empty parentheses `()` — the `title: none` value from Pandoc is normalised to an empty string before being passed to Theorion. |

Additionally, the bundled `boxed-filter.lua` translates LaTeX
`\boxed{…}` expressions (both inline and display) into Typst
`#box(stroke: 0.5pt, inset: 7pt, baseline: 0.55em)[$…$]`. The
function is applied automatically — no option needed.

#### Theorem appearance (Quarto ≥ 1.9.18)

> **Not an extension option.** This is a **Quarto-native feature** available in
> **any** Quarto Typst format (not just this extension) since Quarto 1.9.18.

Quarto 1.9.18+ bundles [Theorion](https://github.com/OrangeX4/typst-theorion)
and exposes a built-in `theorem-appearance` key on the `typst` format:

```yaml
format:
  typst:
    theorem-appearance: simple    # (default)
```

Available themes:

| Theme | Description |
|-------|-------------|
| `simple` | Bold prefix + number + period, body in italics (classic LaTeX style). |
| `fancy` | Coloured boxes using brand colours (`primary` / `secondary` / `tertiary`). |
| `clouds` | Rounded boxes with a coloured background per theorem type. |
| `rainbow` | Coloured left border with coloured title per theorem type. |

Uses:
- Chapter-level counter reset.
- Brand colours from `_brand.yml` (for `fancy`, `clouds`, `rainbow`).
- Bundled packages (`theorion`, `fontawesome`, `showybox`, `octique`) for offline builds.

When `theorem-appearance` is set, the extension's own `theorem-style: "modern"`
is **not required** — you can use either independently or both.

### Bibliography

When using Typst output, citations can be processed in two ways:

**1. Typst native processing** (default) — uses `bibliography:` + `bibliographystyle:`.

```yaml
bibliography: referencias.bib
bibliographystyle: apa          # or ieee (default), chicago-author-date, vancouver, harvard-cite-them-right
```

**2. Pandoc citeproc** — activate with `citeproc: true` + `csl:`.

```yaml
citeproc: true
bibliography: referencias.bib
csl: https://www.zotero.org/styles/apa-with-abstract
```

When using citeproc, `bibliographystyle:` **must not** be used — `csl:` takes control.

| Option | Type | Default | Description |
|---|---|---|---|
| `bibliography` | string | — | Path to a `.bib` file (BibTeX or BibLaTeX). |
| `bibliographystyle` | string | `ieee` | CSL style name (e.g. `apa`, `chicago-author-date`, `vancouver`, `harvard-cite-them-right`). Only for Typst native processing. |
| `csl` | string | — | CSL file or URL for Pandoc citeproc. Overrides `bibliographystyle`. |
| `citeproc` | bool | — | Set to `true` to use Pandoc citeproc instead of Typst native. |
| `bibliografia-completa` | bool | `false` | When `true`, prints the whole bibliography on a single page instead of letting it flow. |

CSL files can be downloaded from:
- <https://www.zotero.org/styles>
- <https://github.com/citation-style-language/styles>

Citation syntax examples:

| Type | Markdown | Result |
|------|----------|--------|
| Parenthetical | `[@key]` | (Author, year) |
| Textual | `@key` | Author (year) |
| Multiple | `[@key1; @key2]` | (Author1, year; Author2, year) |

> **Important:** With Typst output, **do not** use `cite-method: natbib` or `cite-method: biblatex` — these are LaTeX-only.

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
  via the `child` chunk parameter (not with `{{< include … >}}`,
  which is commented out in the source). For example:

  ````markdown
  ```{r}
  #| child: "capitulo03.qmd"
  #| echo: false
  ```
  ````
- **Dual-language front matter** (`resumen` + `palabras-clave` and
  `abstract` + `keywords`) and an `agradecimientos` page.
- **Three figures** generated from R code (histogram, boxplot, ggplot
  scatter saved to PNG and re-included), plus an external image and
  a `logo.png` re-used throughout.
- **Six table styles**: `tinytable`, `knitr::kable()`, native
  Markdown, multi-panel `layout-ncol`, mixed table/figure panels,
  Pandoc grid tables, and a long `tinytable` rendered with
  `breakable: true`.
- **Custom table formatting**: justification by column type
  (`tbl-ejemplo-justificacion`), table scaling via a `#scale-down`
  Typst helper injected through `include-in-header`
  (`tbl-scale-down`), and conditional formatting with multi-line
  headers and row highlighting (`tbl-tabla-politicas3`).
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

## Dual use: one source, two formats (print + slides)

The [`tests/ejemploconslides/`](tests/ejemploconslides/) directory demonstrates how to produce **two different documents from a single content file**: an A4 PDF for students to print and study from, and a slides PDF for the lecturer to project in class.

### Motivation

A teacher preparing a topic for a course needs two formats:
- **Student material**: continuous text with equations, figures, tables, citations — suitable for printing or on-screen reading.
- **Classroom slides**: the same content broken into slides, with incremental reveals, larger text, and a projection-friendly layout.

Traditionally this means maintaining two separate files that easily drift out of sync. This example solves the problem with a single content file and two thin "wrapper" files that render it with different formats.

### Layout

```
tests/ejemploconslides/
├── _extensions/
│   ├── memoriatfetypst/          # A4 format extension
│   └── qmd-ptm-ty-slides/        # slides format extension
├── _contenido.qmd                 # ONE file the teacher edits
├── a_ejemplo.qmd                  # wrapper → A4 print document
├── a_ejemplo-slides.qmd           # wrapper → slides presentation
├── a_ejemplo-unificado.qmd        # wrapper → all three formats at once
├── eliminar-separadores.lua       # filter: removes --- and pauses in A4 mode
├── fontsize-noop.lua              # filter: no-op for {{< fontsize >}} and {{< pause >}} in A4
├── color-spans-typst.lua          # filter: colours .naranja, .rosado, .verde spans in Typst
├── logo.png
└── referencias.bib
```

### How it works

1. The teacher writes **only** `_contenido.qmd` with the topic content.
2. `a_ejemplo.qmd` includes that content via `{{< include _contenido.qmd >}}` using the `memoriatfetypst-typst` format.
3. `a_ejemplo-slides.qmd` includes the same content using the `qmd-ptm-ty-slides-typst` format.

Conditional formatting marks in `_contenido.qmd` adapt the output to each format:

| Mark in `_contenido.qmd` | In A4 (print) | In slides |
|---|---|---|
| `---` (horizontal rule) | Removed by `eliminar-separadores.lua` | Breaks into a new slide |
| `{{< pause >}}` | No-op by `fontsize-noop.lua` | Incremental reveal (overlay) |
| `{{< fontsize 0.85em >}}` | No-op by `fontsize-noop.lua` | Reduces text size |
| `:::{.content-visible when-meta="es-memoria"}` | Visible | Hidden |
| `:::{.content-visible when-meta="es-slides"}` | Hidden | Visible |
| `{.naranja}`, `{.rosado}`, `{.verde}` | Coloured by `color-spans-typst.lua` | Coloured by `color-spans-typst.lua` |

### Unified file: one source, three formats

Besides the two dedicated wrappers, `a_ejemplo-unificado.qmd` bundles **all three formats** (A4, slides, HTML) in a single file. The YAML header declares each format under `format:` with its own `output-file` and `metadata` flags (render each with `--to`, see below):

```yaml
format:
  memoriatfetypst-typst:
    output-file: a_ejemplo-unificado-a4
    metadata:
      es-memoria: true
      es-slides: false
    portada: false
    centrar-matematicas: true
    cabecera-capitulo: "estilo03"
    nombre-capitulo: "--"
    papersize: a4
    margin: {x: 1.5cm, y: 1.5cm}
    filters:
      - fontsize-noop.lua
      - eliminar-separadores.lua
  qmd-ptm-ty-slides-typst:
    output-file: a_ejemplo-unificado-slides
    metadata:
      es-memoria: false
      es-slides: true
      subtitle: "Asignatura: Estadística Aplicada"
    aspect-ratio: "16-9"
    font-size: "18pt"
    section-level: 3
    header-color: "#003f72"
    toc-slide: true
    slide-numbering: true
  html:
    output-file: a_ejemplo-unificado
    metadata:
      es-memoria: false
      es-slides: false
    toc: true
    embed-resources: true
```

Key points:
- Each format sets `metadata` flags (`es-memoria`/`es-slides`) that drive the `{.content-visible when-meta=}` blocks in `_contenido.qmd`.
- The `fontsize-noop.lua` and `eliminar-separadores.lua` filters are only applied under `memoriatfetypst-typst` (A4 mode).
- Shared settings (`bibliography`, top-level `filters`) live at the root.
- The HTML format provides an accessible web version with embedded resources.

Render each format separately with `--to`:

```bash
cd tests/ejemploconslides/

quarto render a_ejemplo-unificado.qmd --to memoriatfetypst-typst
quarto render a_ejemplo-unificado.qmd --to qmd-ptm-ty-slides-typst
quarto render a_ejemplo-unificado.qmd --to html
```

> **Note:** A single `quarto render a_ejemplo-unificado.qmd` (multi‑format) does **not** work reliably: Pandoc processes all formats sharing a single intermediate `.typ` file, so the last Pandoc pass overwrites it and corrupts earlier formats. Use the `--to` flag per format instead.

Results:
- 📄 [a_ejemplo-unificado-a4.pdf](tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) — 641 KB, 8 A4 pages
- 📄 [a_ejemplo-unificado-slides.pdf](tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) — 721 KB, 21 slides 16:9
- 🌐 [a_ejemplo-unificado.html](tests/ejemploconslides/a_ejemplo-unificado.html) — 1.4 MB

### Bibliography title in slides

The slides format uses Typst's native `bibliography()` function, whose default title is language‑sensitive (`"Bibliografía"` for Spanish). To override it to `"Referencias"` (matching the A4 format), inject a `{=typst}` raw block at the top of the wrapper `.qmd`:

```markdown
```{=typst}
#set bibliography(title: "Referencias")
```
```

This `set` rule enters scope before `#bibliography()` (placed at the end of the body by Quarto), so the bibliography section reads `"Referencias"` instead of `"Bibliografía"`.

Both dedicated (`a_ejemplo-slides.qmd`) and unified (`a_ejemplo-unificado.qmd`) wrappers include this block.

### Example content

`_contenido.qmd` is a generic topic on **Data Analysis with R** that includes:

- Inline and display equations ($\bar{x}$, $s^2$, Pearson's $r$).
- Executable R code chunks (`summary()`, `sd()`, `IQR()`, `ggplot2`).
- R-generated figures (boxplot, histogram, scatterplot).
- Variable classification tables.
- Bibliographic citations [@Wickham2017; @R-ggplot2; @knuth84].
- Coloured spans using `{.naranja}` and `{.rosado}` classes.
- Two-column layout (`.cols`) in the correlation section, visible only in slides.
- Page breaks (`#pagebreak()`) visible only in the A4 format.

### Render the PDFs

```bash
cd tests/ejemploconslides/

# PDF for students (A4, printable)
quarto render a_ejemplo.qmd

# PDF for the lecturer (slides)
quarto render a_ejemplo-slides.qmd

# Unified wrapper: render each format separately
quarto render a_ejemplo-unificado.qmd --to memoriatfetypst-typst
quarto render a_ejemplo-unificado.qmd --to qmd-ptm-ty-slides-typst
quarto render a_ejemplo-unificado.qmd --to html
```

Results (separate wrappers):

- 📄 [a_ejemplo.pdf](tests/ejemploconslides/a_ejemplo.pdf) — 641 KB, 8 A4 pages
- 📄 [a_ejemplo-slides.pdf](tests/ejemploconslides/a_ejemplo-slides.pdf) — 721 KB, 21 slides 16:9

Results (unified wrapper):

- 📄 [a_ejemplo-unificado-a4.pdf](tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) — 641 KB, 8 A4 pages
- 📄 [a_ejemplo-unificado-slides.pdf](tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) — 721 KB, 21 slides 16:9
- 🌐 [a_ejemplo-unificado.html](tests/ejemploconslides/a_ejemplo-unificado.html) — 1.4 MB

### Download the example as ZIP

You can get all the example files in two ways:

**Option 1 — Clone the repository** (recommended):

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cd quarto-typst-memoriatfetypst/tests/ejemploconslides
```

**Option 2 — Download only this folder as ZIP**:

[https://download-directory.github.io/?url=https://github.com/calote/quarto-typst-memoriatfetypst/tree/main/tests/ejemploconslides](https://download-directory.github.io/?url=https://github.com/calote/quarto-typst-memoriatfetypst/tree/main/tests/ejemploconslides)

**Option 3 — Generate the ZIP locally** (requires `zip` installed):

```bash
bash tests/ejemploconslides/empaquetar-ejemplo.sh
```

---

## Feature gallery

Each feature has an associated regression test that verifies it renders without errors. PDFs are hosted on **raw.githack.com** so they open fully in the browser (not embedded in GitHub's preview).

> **💡 Tip:** Use **Ctrl+click** (or **right-click → Open in new tab**) on the PDF links to view them comfortably without leaving this page.

| Feature | Description | Source | Preview |
|---|---|---|---|
| Default | Base template style | [`test-default.qmd`](tests/regresion/test-default.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-default.pdf) |
| Style 02 | Compact gradient banner (TeX Gyre Pagella, 10pt) | [`test-estilo02.qmd`](tests/regresion/test-estilo02.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo02.pdf) |
| Style 03 | Left-aligned, no watermark (TeX Gyre Termes, 12pt) | [`test-estilo03.qmd`](tests/regresion/test-estilo03.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo03.pdf) |
| Style 04 | Chapter header `"estilo04"` (sidebar) | [`test-estilo04.qmd`](tests/regresion/test-estilo04.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo04.pdf) |
| Theorem modern | `theorem-style: modern` (coloured by type) | [`test-theorem-modern.qmd`](tests/regresion/test-theorem-modern.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-theorem-modern.pdf) |
| Sidebar colour | `estilo04` sidebar with custom orange colours | [`test-sidebar-color.qmd`](tests/regresion/test-sidebar-color.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-sidebar-color.pdf) |
| Report mode | Article/report: single level-1 section, mini-TOC per section, no cover or lists | [`test-report-mode.qmd`](tests/regresion/test-report-mode.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-report-mode.pdf) |
| No cover | Document without cover page or lists | [`test-no-portada.qmd`](tests/regresion/test-no-portada.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-no-portada.pdf) |
| Exams — classic | Exam exercises (classic blue/green boxes) | [`test-examen.qmd`](tests/examen/test-examen.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen.pdf) |
| Exams — modern | Exam exercises (modern card style) | [`test-examen-moderno.qmd`](tests/examen/test-examen-moderno.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-moderno.pdf) |
| Exams — advanced | Custom margins, plain mode, no line break | [`test-examen-teoriadecision.qmd`](tests/examen/test-examen-teoriadecision.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-teoriadecision.pdf) |
| Exams — demography | Gallery of all exercise types (demography-themed) | [`test-examen-demografia.qmd`](tests/examen/test-examen-demografia.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-demografia.pdf) |
| Fonts | Brand typography font settings | [`test-fuentes.qmd`](tests/regresion/test-fuentes.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-fuentes.pdf) |
| Bibliography | Citation/bibliography rendering | [`test-bibliografia.qmd`](tests/regresion/test-bibliografia.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-bibliografia.pdf) |
| Heading highlight | Section heading highlight bar | [`test-heading-highlight.qmd`](tests/regresion/test-heading-highlight.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-heading-highlight.pdf) |
| Highlight styles | Pandoc Skylighting syntax highlighting | [`test-highlight-styles.qmd`](tests/regresion/test-highlight-styles.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-highlight-styles.pdf) |
| Sidebar first page | Sidebar restricted to first page only | [`test-sidebar-first-page.qmd`](tests/regresion/test-sidebar-first-page.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-sidebar-first-page.pdf) |
| Typst raw block | Typst raw code blocks (line numbering, backgrounds) | [`test-typst-raw-block.qmd`](tests/regresion/test-typst-raw-block.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-typst-raw-block.pdf) |
| Watermark brand | Watermark text overlay + vertical brand mark | [`test-watermark-brand.qmd`](tests/regresion/test-watermark-brand.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-watermark-brand.pdf) |
| Dual use A4 + slides + HTML | One source, three formats: A4 PDF, slides PDF, HTML — with a unified wrapper | [`a_ejemplo-unificado.qmd`](tests/ejemploconslides/a_ejemplo-unificado.qmd) | [📄 A4](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) · [📄 Slides](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) · [🌐 HTML](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado.html) |

Run the tests with:

```bash
Rscript tests/regresion/ejecutar-tests.R
```

If any test fails, the script exits with code 1 and reports which test and format produced the error.

---

## Architecture

```
_extensions/memoriatfetypst/
├── _extension.yml                     # Quarto extension manifest
├── typst-template.typ                 # Main Typst `article` function
├── typst-show.typ                     # Quarto → Typst parameter bridge
├── shortcodes.lua                     # `appendix` and `pagebreak` shortcodes
├── normalize-exercise-titles.lua      # Normalises title: none → title: "" for theorem blocks
└── boxed-filter.lua                   # LaTeX \boxed{} → Typst #box() filter
```

- **`_extension.yml`** declares the format, requires Quarto ≥ 1.6.0,
  pulls the two Typst partials, the shortcode Lua file, and the
  filters. It also sets the format defaults (`portada: true`,
  `toc: true`, `centrar-matematicas: true`, `fig-format: png`).
- **`typst-template.typ`** defines a single `article()` function that
  receives all parameters, sets up page geometry, headers/footers,
  numbered chapter styles, front-matter pages, and the bibliography.
  The `appendix()` function at the bottom resets numbering and
  inserts a divider page.
- **`typst-show.typ`** is the *show template* that Quarto invokes; it
  forwards every supported YAML key to the `article()` function with
  the right Typst type conversion (`$if(...)$ … $endif$`). When
  `theorem-style` is set, it also overrides Theorion's theorem
  functions (`definition`, `theorem`, `example`, `exercise`) with
  wrappers that normalise `title: none` → `title: ""`, preventing
  empty parentheses `()` in untitled environments.
- **`shortcodes.lua`** provides the two shortcodes. They emit
  raw Typst that triggers the corresponding behaviour in
  `typst-template.typ`.
- **`normalize-exercise-titles.lua`** is a Pandoc Lua filter that
  detects Div blocks with theorem-prefixed identifiers and marks
  those without a heading for empty-title handling. It works
  alongside the Typst-level normalisation in `typst-show.typ`.
- **`boxed-filter.lua`** walks the AST after Pandoc → Typst
  conversion and rewrites any `Math` node that contains `\boxed{…}`
  into a Typst `#box()` / `#rect()` call, since Typst's native
  pandoc converter does not implement `\boxed`.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Exercise / example shows empty parentheses `()` after the number | `title: none` passed by Pandoc for blocks without a `#####` heading | This was a bug in Theorion's `get-full-title()`. The extension now normalises `title: none` → `""` in the wrapper functions (`typst-show.typ`). Update to the latest version. |
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

- Accept `bibliografia-completa` as a real boolean instead of a
  string compared to `"true"`.
- Add an option to inject additional Typst code (`include-in-header`)
  from the YAML, e.g. for custom LaTeX-like theorem styles.
- Document and ship a fifth chapter header style (`estilo05` with a
  centred title).
- Add a GitHub Actions workflow that renders the example on every PR.

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
