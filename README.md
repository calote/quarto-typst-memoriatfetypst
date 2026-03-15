

# Quarto-Typst-MemoriaTFEtypst Format

A Quarto + Typst format for TFE documents.

Click the image below to see a [demo
pdf](https://github.com/calote/quarto-typst-memoriatfetypst/blob/main/template.pdf).
Code is available
[here](https://github.com/calote/quarto-typst-memoriatfetypst/blob/main/template.qmd).

## Install

If you would like to add the extension to an existing directory:

``` bash
quarto add calote/quarto-typst-memoriatfetypst
```

To overwrite an existing installation without interactive prompts:

``` bash
quarto add calote/quarto-typst-memoriatfetypst --no-prompt
```

Or use a Quarto template that bundles a `.qmd` starter file:

``` bash
quarto use template calote/quarto-typst-memoriatfetypst
```

## Features

### Centered block equations in lists (`centrar-matematicas`)

Block equations (`$$ ... $$`) inside indented environments (numbered
lists, bullet lists, etc.) are automatically re-centered relative to the
full text column width, compensating for the list indentation. This is
enabled by default.

To disable it:

``` yaml
format:
  memoriatfetypst-typst:
    centrar-matematicas: false
```
