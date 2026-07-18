
# Quarto-Typst-MemoriaTFEtypst

[![Quarto extension](https://img.shields.io/badge/Quarto-extension-1f77b4)](https://quarto.org/docs/extensions/)
[![Typst](https://img.shields.io/badge/Typst-239DAD?logo=typst&logoColor=white)](https://typst.app)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Quarto ≥ 1.6.0](https://img.shields.io/badge/Quarto-%E2%89%A5%201.6.0-1f77b4)](https://quarto.org)

📚 **Documentación adicional:** [web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/)

Ese sitio contiene el manual completo de la extensión más allá de estos README: una referencia detallada de opciones YAML con ejemplos de uso y enlaces a los PDFs resultantes, una sección sobre uso avanzado de Quarto-Typst (código Typst raw, bibliografía con CSL vs. Typst, cuadernos Jupyter, integración Python + R), y una colección de recursos externos seleccionados (extensiones Quarto-Typst alternativas, guías de Typst, plugins útiles para Positron). También incluye vídeos de instalación (RStudio y Positron), múltiples ejemplos resueltos con ficheros fuente descargables y una chuleta de Typst.

▶️ **Vídeos de instalación:** [RStudio](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/videoInstalacionMemoriaTFETypstRStudio.html) · [Positron](https://web.destio.synology.me/calvo/Qdescargas/memoriatfetypst/videoInstalacionMemoriaTFETypstPositron.html)

> **🇬🇧 English version: [README.md](README.md)** — Documentation in English.
>
> Un formato de [Quarto](https://quarto.org) + [Typst](https://typst.app) para
> **Trabajos Fin de Estudios (TFE)** — TFG, TFM, tesis y memorias académicas
> similares — construido sobre el motor
> [Typst](https://quarto.org/docs/output-formats/typst.html) en lugar de LaTeX.

Esta extensión envuelve Typst con un diseño tipo libro predefinido que
produce un PDF listo para impresión de una memoria académica, con
portada, prefacio, capítulos numerados, índices de figuras/tablas,
resúmenes en español e inglés, agradecimientos opcionales y apéndices
renumerados con letras (`A.1`, `A.2`, …).

Ver la demostración renderizada:

- PDF: <a href="template.pdf" target="_blank" rel="noopener">template.pdf ↗</a> · <a href="tests/ejemplo01/tfe_ejemplo01.pdf" target="_blank" rel="noopener">tfe_ejemplo01.pdf ↗</a> · <a href="https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemplo01/tfe_ejemplo01.pdf" target="_blank" rel="noopener">ver online ↗</a>
- Código fuente: [template.qmd](template.qmd) ·
  [tfe_ejemplo01.qmd](tests/ejemplo01/tfe_ejemplo01.qmd)

---

## Índice

- [¿Por qué Typst para un TFE?](#por-qué-typst-para-un-tfe)
- [Características](#características)
- [Instalación](#instalación)
- [Inicio rápido](#inicio-rápido)
- [Referencia de opciones YAML](#referencia-de-opciones-yaml)
  - [Metadatos del documento](#metadatos-del-documento)
  - [Maquetación y tipografía](#maquetación-y-tipografía)
  - [Prefacio y navegación](#prefacio-y-navegación)
  - [Portada](#portada)
  - [Estilo de cabecera de capítulo](#estilo-de-cabecera-de-capítulo)
  - [Apéndices](#apéndices)
  - [Matemáticas](#matemáticas)
  - [Bibliografía](#bibliografía)
- [Shortcodes](#shortcodes)
- [El ejemplo más completo](#el-ejemplo-más-completo)
- [Doble uso: un contenido, dos formatos](#doble-uso-un-contenido-dos-formatos)
- [Galería de características](#galería-de-características)
- [Arquitectura](#arquitectura)
- [Solución de problemas](#solución-de-problemas)
- [Hoja de ruta e ideas](#hoja-de-ruta-e-ideas)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

---

## ¿Por qué Typst para un TFE?

- **Compilación más rápida** que LaTeX (a menudo 10-50×).
- **Compilaciones reproducibles** — los paquetes de Typst están fijados
  en la extensión y se resuelven a través del registro de paquetes de Typst.
- **Valores predeterminados limpios** — no es necesario instalar una
  distribución de TeX.
- **Integración con Quarto** — mantén tu flujo de trabajo `.qmd`,
  bloques de código (R / Python / Julia), referencias cruzadas, citas,
  callouts y teoremas.

El formato fue diseñado para *Trabajo Fin de Grado* (TFG) y *Trabajo
Fin de Máster* (TFM) de universidades españolas, pero está totalmente
parametrizado y se puede adaptar a otros idiomas y convenciones a
través de las [opciones YAML](#referencia-de-opciones-yaml).

---

## Características

| Área | Qué proporciona la extensión |
|---|---|
| **Portada** | Logo de la universidad, titulación, facultad, universidad, tipo de trabajo, título, autor, tutor, fecha — todo configurable; se puede desactivar. |
| **Prefacio** | `resumen` + `palabras-clave` en español, `abstract` + `keywords` en inglés, `agradecimientos` opcionales, todo en páginas dedicadas (sin numerar). |
| **Índices** | Índice general, lista de figuras, lista de tablas, y un mini-índice *opcional* por capítulo. |
| **Cabeceras de capítulo** | Cuatro diseños diferentes (`estilo01`–`estilo04`) seleccionables por documento. |
| **Modo artículo / informe** | Usa `nombre-capitulo: "--"` para ocultar las etiquetas de capítulo y obtener un documento tipo artículo o informe (ideal para trabajos cortos, informes o papers). |
| **Apéndices** | Un shortcode `{{< appendix >}}` reinicia la numeración de figuras/tablas/encabezados a `A.1`, `A.2`, … con una página divisoria dedicada. |
| **Matemáticas** | Sintaxis LaTeX (con `$$ … $$`), más re-centrado automático de ecuaciones en bloque dentro de listas, y un filtro Lua que convierte `\boxed{}` de LaTeX a cajas de Typst. |
| **Teoremas** | `theorem-style: "modern"` opcional activa cajas coloreadas para teoremas (definition, theorem, lemma, corollary, example, exercise). Los entornos sin título ya no muestran paréntesis vacíos `()`. |
| **Bloques de código** | Cajas de colores diferenciadas para código R, Python, genérico y Markdown. |
| **Referencias cruzadas** | Sintaxis estándar de Quarto para secciones, figuras (`@fig-…`), tablas (`@tbl-…`), ecuaciones (`@eq-…`) y teoremas (`@thm-…`). Los colores de enlaces, referencias y citas son personalizables (`link-color`, `internal-link-color`, `cite-color`). |
| **Bibliografía** | BibLaTeX/BibTeX con estilos CSL `apa` y `chicago-author-date`, y opción para imprimir la bibliografía completa en una sola página. |
| **Gemelo HTML** | El mismo `.qmd` puede renderizarse a una versión HTML autónoma con código plegable. |

---

## Instalación

Elige **uno** de los tres modos de instalación.

### A) Instalar en un proyecto Quarto existente

```bash
quarto add calote/quarto-typst-memoriatfetypst
```

Para sobrescribir una instalación anterior sin avisos interactivos:

```bash
quarto add calote/quarto-typst-memoriatfetypst --no-prompt
```

Esto copia `_extensions/memoriatfetypst/` en tu proyecto.

### B) Usar la plantilla de GitHub

```bash
quarto use template calote/quarto-typst-memoriatfetypst
```

Esto clona el repositorio, te sitúa en una carpeta llamada
`quarto-typst-memoriatfetypst/`, y te da un `template.qmd` funcional
para empezar.

### C) Instalación manual

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cp -r quarto-typst-memoriatfetypst/_extensions TU_PROYECTO/
```

> **`quarto add` vs `quarto use template`:**
>
> - **`quarto add`** solo instala los archivos de la extensión en `_extensions/`.
>   Nunca toca tus documentos existentes (`.qmd`, `.bib`, imágenes, etc.).
>   Úsalo para añadir el formato a un proyecto que ya tengas.
>
> - **`quarto use template`** crea un **directorio nuevo** a partir del repositorio.
>   Si el directorio actual no está vacío, te pedirá un nombre de carpeta nueva.
>   Nunca sobrescribe archivos de un proyecto existente.
>
> Para actualizar o reinstalar la extensión en un proyecto existente, usa
> `quarto add` de nuevo (con `--no-prompt` para saltar la confirmación).
> Para fijar una versión concreta, añade `@<tag>` (ver más abajo).

### Verificar la instalación

```bash
quarto --list-extensions
# memoriatfetypst   …   TU_PROYECTO/_extensions/memoriatfetypst
```

La extensión requiere Quarto ≥ 1.6.0.

### Instalar una versión concreta

Para fijar una versión específica, añade la etiqueta (tag) a la
referencia del repositorio:

```bash
quarto add calote/quarto-typst-memoriatfetypst@v1.0.0
```

Las etiquetas disponibles se listan en la página de
[Tags de GitHub](../../tags).

---

## Inicio rápido

`.qmd` mínimo que usa todas las características del prefacio:

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

Compilar con:

```bash
quarto render mi-tfe.qmd --to memoriatfetypst-typst
quarto render mi-tfe.qmd --to html      # versión HTML
```

---

## Referencia de opciones YAML

Todas las opciones están bajo la clave `format.memoriatfetypst-typst`
a menos que se indique lo contrario. Las opciones heredadas del formato
Typst estándar de Quarto también se incluyen por completitud.

### Metadatos del documento

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `title` | string | — | Título del documento. Usa el bloque escalar YAML (`\|`) para títulos multilínea. |
| `subtitle` | string | — | Subtítulo opcional. |
| `author` | string | — | Nombre del autor. |
| `date` | string / date | `today` | Fecha del documento. |
| `date-format` | string | `full` | Formato de fecha estilo R / `format()` (`full`, `long`, `medium`, `short` o un patrón personalizado). |
| `lang` | string | `es` | Etiqueta de idioma BCP-47 (también se usa para la separación silábica). |
| `region` | string | `ES` | Región BCP-47. |
| `abstract` | string | — | Resumen en inglés (aparece en una página no numerada dedicada etiquetada *Abstract*). |
| `abstract-title` | string | `RESUMEN` | Texto del encabezado en la página de resumen en inglés. |
| `keywords` | list | — | Palabras clave en inglés que se muestran tras el abstract. |
| `resumen` | string | — | Resumen en español (aparece en su propia página). |
| `palabras-clave` | list | — | Palabras clave en español que se muestran tras el resumen. |
| `agradecimientos` | string | — | Párrafo de agradecimientos en una página no numerada dedicada. |
| `bibliography` | string | — | Ruta a un archivo `.bib` (BibTeX o BibLaTeX). |
| `csl` | string | — | Archivo CSL opcional (p.ej. `apa`, `chicago-author-date`). Cuando se omite, se usa el estilo de bibliografía nativo de Typst. |

### Maquetación y tipografía

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `papersize` | string | `a4` | Tamaño de papel. Cualquier nombre de papel de Typst (`a4`, `us-letter`, `a5`, …). |
| `margin` | dict | `{x: 2.5cm, y: 2.5cm}` | Márgenes de página. Acepta notación abreviada `{x, y}` o `{top, bottom, left, right}` en cualquier unidad de longitud. |
| `mainfont` | string | `libertinus serif` | Fuente del cuerpo. |
| `sansfont` | string | `Helvetica` | Fuente sans-serif (usada en la portada). |
| `mathfont` | string | `New Computer Modern Math` | Fuente para matemáticas. |
| `fontsize` | length | `11pt` | Tamaño base del cuerpo. |
| `link-color` | string | `"#483d8b"` | Color de enlaces externos (URLs). |
| `internal-link-color` | string | `"#5b5b9e"` | Color de enlaces internos y referencias cruzadas (`@sec-`, `@fig-`, `@tbl-`, `@thm-`, `@def-`, etc.). |
| `cite-color` | string | `"#6A1B9A"` | Color de citas bibliográficas (`@cite2020`). |
| `section-numbering` | string | `1.1.1` | Patrón de numeración de secciones (p.ej. `1.1.1.1` para cuatro niveles). |
| `page-numbering` | string | `1` | Estilo de numeración de páginas. El prefacio siempre usa números romanos (`i`, `ii`, …) independientemente. |
| `heading-style` | bool | `true` | Aplica tamaños y espaciados de sección (H2–H6) tipo LaTeX. Pon `false` para usar las proporciones predeterminadas de Typst. |

#### Orígenes de fuentes

Las fuentes pueden declararse de dos maneras:

**1. Opciones Typst simples** (vía YAML del formato):

```yaml
format:
  memoriatfetypst-typst:
    mainfont: Libertinus Serif    # Fuente del cuerpo
    sansfont: Helvetica            # Sans-serif (portada)
    mathfont: New Computer Modern Math  # Fuente matemática
```

**2. `brand.typography`** (sistema brand de Quarto, recomendado para portabilidad):

```yaml
brand:
  typography:
    fonts:
      - family: Jost
        source: google             # Descargada por Quarto automáticamente
        weight: [300, 400, 500, 600, 700]
      - family: Lato
        source: system             # Debe estar instalada en el SO
    base: Jost                     # Fuente del cuerpo
    headings: Jost                 # Fuente de títulos
```

| Origen de fuente | Funciona en | Notas |
|---|---|---|
| `source: google` | ✅ Todos los SO | Quarto la descarga automáticamente al renderizar |
| `source: system` | ⚠️ Solo si instalada | Verificar con `fc-list` (Linux/macOS) |
| `source: file` | ✅ Todos los SO | Las rutas deben existir en el repositorio |

> **Nota:** `Libertinus Sans` y `Libertinus Serif` **no están** en Google Fonts. Usar `source: system` o `source: file` con archivos OTF locales. `New Computer Modern Math` viene incluida con Typst y no necesita declaración.

Para personalizar los valores (tamaño de fuente, espaciado superior/inferior, etc.), pon `heading-style: false` y crea tu propio `mis-secciones.typ` con reglas `show` personalizadas, e inclúyelo con `include-in-header`:

```yaml
heading-style: false
include-in-header: ["mis-secciones.typ"]
```

```typst
// mis-secciones.typ — tamaños y espaciados personalizados
#show heading.where(level: 2): set text(size: 1.5em)
#show heading.where(level: 2): it => block(above: 3em, below: 2em, it)
#show heading.where(level: 3): set text(size: 1.3em)
#show heading.where(level: 3): it => block(above: 2.5em, below: 1.5em, it)
// ... repetir para niveles 4–6 según se necesite
```

> **Nota:** las reglas de `include-in-header` se colocan a nivel de documento (antes de `#show: doc => …`), por lo que `heading-style` debe estar en `false` para evitar conflictos con los valores por defecto de la extensión.

### Resaltado de secciones (heading-highlight)

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `heading-highlight` | int | `0` | Resalta las subsecciones con fondo coloreado. `0` desactiva; `2`–`6` resalta desde nivel 2 hasta ese nivel. |
| `heading-highlight-color` | string | `"#e8f0fe"` | Color de fondo para las secciones resaltadas (hex). |
| `heading-highlight-text-color` | string | `"#1a1a2e"` | Color del texto para las secciones resaltadas (hex). |

Ejemplo — resaltar niveles 2–4 con fondo `#2c3e50` y texto `#ecf0f1`:

```yaml
format:
  memoriatfetypst-typst:
    heading-highlight: 4
    heading-highlight-color: "#2c3e50"
    heading-highlight-text-color: "#ecf0f1"
```

El fondo rectangular envuelve encabezados multilínea y no interfiere con el espaciado (controlado por `heading-style`).

### Marca de agua y brand vertical

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `watermark-text` | string | — | Texto diagonal (p.ej. `"BORRADOR"`). Usa `" \| "` para varias líneas. |
| `watermark-opacity` | float | `0.12` | Opacidad (0.0–1.0). |
| `watermark-color` | string | `"#000000"` | Color del texto. |
| `watermark-fontsize` | length | `72pt` | Tamaño de fuente. |
| `watermark-angle` | angle | `35deg` | Ángulo de rotación. |
| `brand-vertical-text` | string | — | Texto vertical en margen derecho (p.ej. institución). |
| `brand-vertical-color` | string | `"#999999"` | Color del texto. |
| `brand-vertical-fontsize` | length | `0.8em` | Tamaño de fuente. |
| `brand-vertical-width` | length | `1.5cm` | Ancho del margen derecho reservado. |
| `brand-vertical-dy` | percent | `50%` | Posición vertical (`50%` = centro, `85%` = cerca del final). |
| `brand-vertical-logo` | string | — | Ruta opcional a un logo sobre el texto. |

Ejemplo:

```yaml
format:
  memoriatfetypst-typst:
    watermark-text: "BORRADOR | DOCUMENTO DE TRABAJO"
    watermark-opacity: 0.12
    brand-vertical-text: "Universidad de Sevilla"
    brand-vertical-dy: 85%
```

> **Nota:** La marca de agua se dibuja en el fondo de la página. Los callouts y otros bloques con relleno propio pueden taparla — es comportamiento esperado.

### Ejercicios (examtypst-functions)

La extensión incluye funciones Typst opcionales para crear ejercicios tipo examen dentro de un documento de memoria. Hay dos estéticas disponibles:

| Estilo | Archivo a incluir | Descripción |
|--------|------------------|-------------|
| **Clásico** (por defecto) | `examtypst-functions.typ` | Cajas con borde azul para ejercicios, cajas verdes para soluciones |
| **Moderno** | `examtypst-functions-modern.typ` | Tarjetas con barra lateral de color (paleta slate + amber + teal) |

Para usarlas, añade lo siguiente al YAML:

```yaml
format:
  memoriatfetypst-typst:
    include-in-header:
      - "_extensions/memoriatfetypst/examtypst-functions.typ"
    filters:
      - _extensions/memoriatfetypst/typst-function.lua
```

Después usa Divs de Quarto:

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

Tipos de ejercicio disponibles:

| Clase Div | Comportamiento |
|---|---|
| `.ejercicio` | Ejercicio numerado con borde azul |
| `.solucion` | Caja verde de solución |
| `.apartado` | Sub-apartado (a, b, c...) |
| `.pregunta-multiple` | Opción múltiple |
| `.verdadero-falso` | Verdadero/Falso |
| `.espacio-desarrollo` | Líneas en blanco para respuesta |
| `.respuesta-corta` | Subrayados para respuesta breve |

#### Opciones de visualización (YAML)

Opciones globales a nivel de documento:

| Opción | Tipo | Por defecto | Descripción |
|--------|------|-------------|-------------|
| `mostrar-ejercicio-cuadro` | bool | `true` | Envolver ejercicios en una caja coloreada (`true`) o texto plano (`false`). |
| `mostrar-solucion-cuadro` | bool | `true` | Envolver soluciones en una caja coloreada (`true`) o texto plano (`false`). |
| `ejercicio-salto-linea` | bool | `true` | Añadir espacio vertical tras el encabezado del ejercicio (`true`) o sin espacio (`false`). |

#### Override por instancia (argumentos Div)

Cambiar opciones de visualización para ejercicios y soluciones individuales:

```markdown
:::{.ejercicio arguments='puntos: 2, mostrar-cuadro: false'}
Ejercicio sin caja (sobrescribe la configuración YAML)
:::

:::{.solucion arguments='mostrar-cuadro: true'}
Solución con caja (sobrescribe la configuración YAML si es false)
:::
```

Argumentos disponibles:
- **`ejercicio`**: `mostrar-cuadro` (bool o none), `salto-linea` (bool o none)
- **`solucion`**: `mostrar-cuadro` (bool o none)

Si el argumento se omite o es `none`, utiliza la configuración YAML global. Si se establece explícitamente (`true`/`false`), lo sobrescribe para esa instancia específica.

#### Ejemplos completos

- Estilo clásico: [`tests/examen/test-examen.qmd`](tests/examen/test-examen.qmd)
- Estilo moderno: [`tests/examen/test-examen-moderno.qmd`](tests/examen/test-examen-moderno.qmd)
- Avanzado (examen teoría de decisión con opciones personalizadas): [`tests/examen/test-examen-teoriadecision.qmd`](tests/examen/test-examen-teoriadecision.qmd)
- **Galería con overrides por instancia**: [`tests/examen/test-examen-demografia.qmd`](tests/examen/test-examen-demografia.qmd) — demuestra todos los tipos de ejercicio y ejemplos de override

### Prefacio y navegación

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `portada` | bool | `true` | Renderizar la portada. |
| `toc` | bool | `true` | Renderizar el índice general. |
| `tofiguras` | bool | `true` | Renderizar la lista de figuras. |
| `totablas` | bool | `true` | Renderizar la lista de tablas. |
| `toccapitulos` | bool | `false` | Renderizar un pequeño recuadro "en este capítulo" al inicio de cada capítulo. |
| `bibliografia-completa` | bool | `false` | Cuando es `true`, imprime toda la bibliografía en una sola página en lugar del diseño multilínea predeterminado. |

### Portada

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `logo-file` | string | — | Ruta a un logo (PNG/SVG/JPG). Se muestra a 7 cm de ancho en la portada. |
| `titulacion` | string | `Grado en Estadística` | Nombre de la titulación. |
| `facultad` | string | — | Facultad / escuela (opcional). |
| `universidad` | string | — | Nombre de la universidad (opcional). |
| `tutor-TFG` | string | — | Línea del tutor, p.ej. `Tutor: Dr. Juan Pérez`. |
| `fecha-TFG` | string | `Sevilla, Junio de 2025` | Línea de lugar + fecha al pie de la portada. |
| `tipo-TFG` | string | `TRABAJO FIN DE GRADO` | Tipo de trabajo (`TRABAJO FIN DE MÁSTER`, `TESIS DOCTORAL`, …). |

### Estilo de cabecera de capítulo

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `cabecera-capitulo` | string | `estilo01` | Uno de `estilo01`, `estilo02`, `estilo03`, `estilo04` (ver más abajo). |
| `nombre-capitulo` | string | `CAPÍTULO` | Etiqueta impresa junto al número de capítulo. Usa `--` para modo artículo/informe (sin etiquetas de capítulo, solo títulos). |
| `numerar-secciones-nivel1` | boolean | *(auto)* | Controla si los encabezados de nivel 1 muestran su número. En modo informe (`nombre-capitulo: "--"`) se suprime automáticamente; usa `true` para restaurar la numeración completa. Fuera del modo informe, la numeración completa es siempre el comportamiento por defecto. |
| `referencias-nombre` | string | `Referencias` | Texto del encabezado de la sección de bibliografía. |
| `apendice-portada` | string | `APÉNDICE` | Texto grande en la página divisoria de apéndices. |
| `apendice-nombre` | string | `APÉNDICE` | Etiqueta impresa junto al número de apéndice. |

Los cuatro estilos de capítulo son:

- **`estilo01`** — Número gris translúcido grande en la esquina
  superior derecha de la página del capítulo, con el título del
  capítulo alineado a la derecha y una regla horizontal corta. El
  valor predeterminado, adecuado para la mayoría de los TFG.
- **`estilo02`** — Banners compacto alineado a la derecha con un
  degradado de color (`color.map.crest`) y texto blanco. Más gráfico.
- **`estilo03`** — Alineado a la izquierda, sin marca de agua de
  número. Usa `nombre-capitulo: "--"` para imprimir solo el título,
  útil para una monografía de un solo capítulo o un capítulo de
  "Bibliografía" sin número.
- **`estilo04`** — Barra lateral izquierda con un degradado de color
  vertical y el número de capítulo girado 90 grados. La barra ocupa
  toda la altura de la página y se sitúa en el margen izquierdo
  (a 0.5 cm del borde). El título del capítulo está alineado a la
  izquierda. Personalizable con:
  - `sidebar-color1` / `sidebar-color2` (hex) — colores del degradado
    (por defecto `#1a365d` / `#2c5282`).
  - `sidebar-dx` (longitud) — distancia desde el borde de página
    (por defecto `0.5cm`).
  - `sidebar-show` (cadena) — cuándo mostrar la barra lateral:
    `"all"` (todas las páginas, defecto) o `"first-page"`
    (solo en la primera página de cada capítulo y apéndice).

### Apéndices

No hay una opción YAML para los apéndices — se activan mediante el
shortcode [`{{< appendix >}}`](#shortcodes). Una vez que se encuentra
el shortcode:

- la numeración de encabezados se reinicia en `1` y se prefija con `A`
  (`A.1`, `A.1.1`, …),
- la numeración de figuras se prefija con `A` (`A.1`, `A.2`, …),
- la numeración de tablas se prefija con `A` (`A.1`, `A.2`, …),
- se inserta una página divisoria con el texto de `apendice-portada`.

### Resaltado de sintaxis / bloques de código

Desde **Quarto ≥ 1.9**, la extensión requiere la siguiente clave
**descomentada explícitamente** en el YAML del documento para usar
el estilo personalizado de bloques de código (cajas coloreadas por
lenguaje con fondos a juego):

```yaml
format:
  memoriatfetypst-typst:
    highlight-style: idiomatic   # ← debe estar activa para bloques personalizados
```

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `highlight-style` | string | — (Pandoc Skylighting) | Pon `idiomatic` para usar el resaltador nativo de Typst y la apariencia personalizada de la extensión. |

Si **omites o comentas** esta clave, el resaltador Skylighting de
Pandoc toma el control y puedes usar cualquiera de los temas estándar
de Quarto. Por ejemplo:

```yaml
format:
  memoriatfetypst-typst:
    syntax-highlighting: arrow      # Predeterminado, optimizado para accesibilidad
    # syntax-highlighting: github   # Estilo GitHub
    # syntax-highlighting: dracula  # Fondo oscuro
    # syntax-highlighting: monokai  # Fondo oscuro
    # syntax-highlighting: solarized
    # syntax-highlighting: nord
    # syntax-highlighting: gruvbox
```

Con Skylighting los colores sintácticos cambian pero se pierde el
fondo personalizado por lenguaje. Elige la opción que mejor se adapte
al aspecto de tu documento.

### Matemáticas y teoremas

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `centrar-matematicas` | bool | `true` | Vuelve a centrar las ecuaciones `$$ … $$` que aparecen dentro de entornos indentados (listas, citas en bloque, …) para que estén visualmente centradas en la columna de texto completa, no en la columna indentada. Pon `false` para desactivar. |
| `theorem-style` | string | — | Pon `"modern"` para activar cajas de teorema coloreadas (barra lateral izquierda de color por tipo). Usa [Theorion](https://github.com/OrangeX4/typst-theorion) internamente. **Corrección aplicada**: ejercicios, definiciones, teoremas o ejemplos sin un `##### Título` ya no muestran paréntesis vacíos `()` — el valor `title: none` que genera Pandoc se normaliza a cadena vacía antes de pasarlo a Theorion. |

Adicionalmente, el `boxed-filter.lua` incluido traduce las expresiones
`\boxed{…}` de LaTeX (tanto en línea como en display) a
`#box(stroke: 0.5pt, inset: 7pt, baseline: 0.55em)[$…$]` de Typst.
La función se aplica automáticamente — no se necesita ninguna opción.

#### Apariencia de teoremas (Quarto ≥ 1.9.18)

> **No es una opción de la extensión.** Es una **característica nativa de Quarto**
> disponible en **cualquier** formato Typst de Quarto (no solo esta extensión)
> desde Quarto 1.9.18.

Quarto 1.9.18+ incluye [Theorion](https://github.com/OrangeX4/typst-theorion)
y expone la clave `theorem-appearance` en el formato `typst`:

```yaml
format:
  typst:
    theorem-appearance: simple    # (predeterminado)
```

Temas disponibles:

| Tema | Descripción |
|------|-------------|
| `simple` | Prefijo negrita + número + punto, cuerpo en cursiva (estilo LaTeX clásico). |
| `fancy` | Cajas coloreadas usando colores brand (`primary` / `secondary` / `tertiary`). |
| `clouds` | Cajas redondeadas con fondo coloreado por tipo de teorema. |
| `rainbow` | Borde izquierdo coloreado con título coloreado por tipo. |

Características:
- Reinicio de contadores por capítulo.
- Colores brand desde `_brand.yml` (para `fancy`, `clouds`, `rainbow`).
- Paquetes incluidos (`theorion`, `fontawesome`, `showybox`, `octique`) para compilación sin conexión.

Cuando se usa `theorem-appearance`, la opción `theorem-style: "modern"`
de la extensión **no es necesaria** — se pueden usar independientemente o ambas.

### Bibliografía

Con salida Typst, las citas pueden procesarse de dos formas:

**1. Procesamiento nativo de Typst** (por defecto) — usa `bibliography:` + `bibliographystyle:`.

```yaml
bibliography: referencias.bib
bibliographystyle: apa          # o ieee (defecto), chicago-author-date, vancouver, harvard-cite-them-right
```

**2. Procesamiento con Pandoc (citeproc)** — activar con `citeproc: true` + `csl:`.

```yaml
citeproc: true
bibliography: referencias.bib
csl: https://www.zotero.org/styles/apa-with-abstract
```

Cuando se usa citeproc, **no debe usarse** `bibliographystyle:` — `csl:` toma el control.

| Opción | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `bibliography` | string | — | Ruta a un archivo `.bib` (BibTeX o BibLaTeX). |
| `bibliographystyle` | string | `ieee` | Nombre del estilo CSL (p.ej. `apa`, `chicago-author-date`, `vancouver`, `harvard-cite-them-right`). Solo para procesamiento nativo Typst. |
| `csl` | string | — | Archivo CSL o URL para Pandoc citeproc. Sobrescribe `bibliographystyle`. |
| `citeproc` | bool | — | Pon `true` para usar Pandoc citeproc en lugar del nativo Typst. |
| `bibliografia-completa` | bool | `false` | Cuando es `true`, imprime toda la bibliografía en una sola página en lugar de dejar que fluya. |

Los ficheros CSL pueden descargarse de:
- <https://www.zotero.org/styles>
- <https://github.com/citation-style-language/styles>

Ejemplos de sintaxis de citas:

| Tipo | Markdown | Resultado |
|------|----------|-----------|
| Parentética | `[@key]` | (Autor, año) |
| Textual | `@key` | Autor (año) |
| Múltiple | `[@key1; @key2]` | (Autor1, año; Autor2, año) |

> **Importante:** Con salida Typst **no se debe** usar `cite-method: natbib` ni `cite-method: biblatex` — son exclusivos de LaTeX.

La bibliografía se titula automáticamente con `referencias-nombre` y
su cabecera/pie de página se reemplazan con ese título (sin número de
capítulo, en mayúsculas).

---

## Shortcodes

| Shortcode | Propósito |
|---|---|
| `{{< appendix >}}` | Marca el inicio de los apéndices. Inserta una página divisoria y cambia la numeración de encabezados/figuras/tablas a `A.1`, `A.2`, … |
| `{{< pagebreak >}}` | Inserta un salto de página forzado. Útil entre secciones que no deberían compartir página (p.ej. antes de las conclusiones). |

Ambos shortcodes están definidos en `_extensions/memoriatfetypst/shortcodes.lua`.

---

## El ejemplo más completo

El ejemplo funcional más completo está en
[`tests/ejemplo01/`](tests/ejemplo01). Demuestra:

- Un proyecto **multiarchivo**: `tfe_ejemplo01.qmd` (el archivo
  principal) más dos hijos — `capitulo03.qmd` y `apendice01.qmd` —
  incluidos mediante el parámetro `child` del chunk (no con
  `{{< include … >}}`, que aparece comentado en el código). Por ejemplo:

  ````markdown
  ```{r}
  #| child: "capitulo03.qmd"
  #| echo: false
  ```
  ````
- **Prefacio bilingüe** (`resumen` + `palabras-clave` y `abstract` +
  `keywords`) y una página de `agradecimientos`.
- **Tres figuras** generadas con código R (histograma, boxplot, ggplot
  de dispersión guardado a PNG y re-incluido), más una imagen externa
  y un `logo.png` reutilizado en todo el documento.
- **Seis estilos de tabla**: `tinytable`, `knitr::kable()`, Markdown
  nativo, `layout-ncol` multipanel, paneles mixtos tabla/figura,
  tablas grid de Pandoc, y una `tinytable` larga renderizada con
  `breakable: true`.
- **Formato personalizado de tablas**: justificación por tipo de
  columna (`tbl-ejemplo-justificacion`), escalado de tablas mediante
  un helper Typst `#scale-down` inyectado con `include-in-header`
  (`tbl-scale-down`), y formato condicional con cabeceras multilínea
  y resaltado de filas (`tbl-tabla-politicas3`).
- **Una tabla de regresión** con `modelsummary::msummary()` y una
  versión alternativa cargada desde un `.rds` preguardado (útil para
  reconstrucciones más rápidas).
- **Teoremas matemáticos** (`def-`, `thm-`, `exm-`, `exr-`) usando la
  convención de que el **identificador del bloque debe comenzar con el
  prefijo** de su tipo para que las referencias cruzadas funcionen
  correctamente.
- **Una tabla larga multipágina** usando el truco de Typst
  `#show figure: set block(breakable: true)` para permitir saltos de
  página dentro de una tabla.
- **Un apéndice** generado a través del shortcode `{{< appendix >}}`,
  con numeración estilo `A.1`.

Para compilarlo localmente:

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cd quarto-typst-memoriatfetypst/tests/ejemplo01
quarto render tfe_ejemplo01.qmd --to memoriatfetypst-typst
quarto render tfe_ejemplo01.qmd --to html
open tfe_ejemplo01.pdf
```

---

## Doble uso: un contenido, dos formatos

El directorio [`tests/ejemploconslides/`](tests/ejemploconslides/) demuestra cómo generar **dos documentos distintos a partir de un único fichero de contenido**: un PDF en formato A4 para que el alumno imprima y estudie, y un PDF de transparencias para que el profesor proyecte en clase.

### Motivación

Un docente que prepara un tema para una asignatura necesita dos formatos:
- **Material para el alumno**: documento continuo, con ecuaciones, figuras, tablas y citas, para imprimir o leer en pantalla.
- **Transparencias para clase**: el mismo contenido, pero fragmentado en diapositivas, con revelado incremental, texto más grande y diseño adaptado a proyección.

Tradicionalmente esto implica mantener dos documentos paralelos que se desincronizan fácilmente. Este ejemplo resuelve el problema con un solo fichero de contenido y dos "envoltorios" que lo renderizan con distinto formato.

### Estructura

```
tests/ejemploconslides/
├── _extensions/
│   ├── memoriatfetypst/          # extensión para formato A4
│   └── qmd-ptm-ty-slides/        # extensión para formato transparencias ([repo](https://github.com/calote/qmd-ptm-ty-slides))
├── _contenido.qmd                 # ÚNICO fichero que edita el docente
├── a_ejemplo.qmd                  # envoltorio → memoria A4
├── a_ejemplo-slides.qmd           # envoltorio → transparencias
├── a_ejemplo-unificado.qmd        # envoltorio → los 3 formatos de una vez
├── eliminar-separadores.lua       # filtro: elimina --- y pausas en modo A4
├── fontsize-noop.lua              # filtro: no-op de shortcodes {{< fontsize >}} y {{< pause >}} en A4
├── color-spans-typst.lua          # filtro: colorea spans .naranja, .rosado, .verde en Typst
├── logo.png
└── referencias.bib
```

### Cómo funciona

1. El docente escribe **solo** `_contenido.qmd` con el contenido del tema.
2. El fichero `a_ejemplo.qmd` incluye ese contenido mediante `{{< include _contenido.qmd >}}` y usa el formato `memoriatfetypst-typst`.
3. El fichero `a_ejemplo-slides.qmd` incluye el mismo contenido y usa el formato `qmd-ptm-ty-slides-typst`.

Las marcas de formato condicional en `_contenido.qmd` permiten adaptar la salida a cada formato:

| Marca en `_contenido.qmd` | En A4 | En slides |
|---|---|---|
| `---` (línea horizontal) | Eliminada por `eliminar-separadores.lua` | Separa diapositivas |
| `{{< pause >}}` | No-op por `fontsize-noop.lua` | Revelado incremental (overlay) |
| `{{< fontsize 0.85em >}}` | No-op por `fontsize-noop.lua` | Reduce tamaño de texto |
| `:::{.content-visible when-meta="es-memoria"}` | Visible | Oculto |
| `:::{.content-visible when-meta="es-slides"}` | Oculto | Visible |
| `{.naranja}`, `{.rosado}`, `{.verde}` | Coloreado por `color-spans-typst.lua` | Coloreado por `color-spans-typst.lua` |

### Fichero unificado: un contenido, tres formatos

Además de los dos envoltorios dedicados, `a_ejemplo-unificado.qmd` permite renderizar **los tres formatos** (A4, transparencias y HTML) desde un solo fichero. La cabecera YAML declara cada formato bajo `format:` con su propio `output-file` y sus metadatos:

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
    keep-typ: true
    aspect-ratio: "16-9"
    font-size: "18pt"
    section-level: 3
    header-color: "#003f72"
    toc-slide: true
    slide-numbering: true
  html:
    output-file: a_ejemplo-unificado
    metadata:
      es-memoria: true
      es-slides: false
    toc: true
    embed-resources: true
```

Puntos clave:
- Cada formato define sus propias `metadata` (indicadores `es-memoria`/`es-slides`) que activan los bloques `{.content-visible when-meta=}` en `_contenido.qmd`.
- Los filtros `fontsize-noop.lua` y `eliminar-separadores.lua` solo se aplican bajo `memoriatfetypst-typst` (modo A4).
- Las opciones compartidas (`bibliography`, `filters` globales) van en la raíz.
- El formato HTML proporciona una versión web accesible con recursos embebidos.

Renderizar cada formato por separado con `--to`:

```bash
cd tests/ejemploconslides/

quarto render a_ejemplo-unificado.qmd --to memoriatfetypst-typst
quarto render a_ejemplo-unificado.qmd --to qmd-ptm-ty-slides-typst
quarto render a_ejemplo-unificado.qmd --to html
```

> **Nota:** Un solo `quarto render a_ejemplo-unificado.qmd` (multi‑formato) antes no funcionaba correctamente porque todos los formatos Typst compartían un único `.typ` intermedio. Tras la corrección con `keep-typ: true` en el formato slides, ahora funciona bien. No obstante, sigue siendo recomendable renderizar por separado con `--to` por seguridad y claridad.

Resultados:
- 📄 [a_ejemplo-unificado-a4.pdf](tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) — 641 KB, 8 páginas A4
- 📄 [a_ejemplo-unificado-slides.pdf](tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) — 721 KB, 21 diapositivas 16:9
- 🌐 [a_ejemplo-unificado.html](tests/ejemploconslides/a_ejemplo-unificado.html) — 1.4 MB

### Título de la bibliografía en slides

El formato slides usa la función `bibliography()` nativa de Typst, cuyo título predeterminado depende del idioma (`"Bibliografía"` en español). Para cambiarlo a `"Referencias"` (coincidiendo con el formato A4), se inyecta un bloque raw `{=typst}` al inicio del `.qmd` envoltorio:

````markdown
```{=typst}
#set bibliography(title: "Referencias")
```
````

Esta regla `set` está en ámbito antes de `#bibliography()` (colocada al final del body por Quarto), por lo que la sección de bibliografía aparece como `"Referencias"` en lugar de `"Bibliografía"`.

Tanto el envoltorio dedicado (`a_ejemplo-slides.qmd`) como el unificado (`a_ejemplo-unificado.qmd`) incluyen este bloque.

### Contenido del ejemplo

`_contenido.qmd` es un tema genérico de **Análisis de Datos con R** que incluye:

- Ecuaciones en línea y en bloque ($\bar{x}$, $s^2$, $r$ de Pearson).
- Bloques de código R ejecutables (`summary()`, `sd()`, `IQR()`, `ggplot2`).
- Figuras generadas con R (boxplot, histograma, scatterplot).
- Tablas de clasificación de variables.
- Citas bibliográficas [@Wickham2017; @R-ggplot2; @knuth84].
- Spans coloreados con clases `{.naranja}` y `{.rosado}`.
- Dos columnas (`layout-ncol=2`) en la sección de correlación, visible solo en slides.
- Saltos de página (`#pagebreak()`) visibles solo en el formato A4.

### Renderizar los PDFs

```bash
cd tests/ejemploconslides/

# PDF para el alumno (A4, imprimible)
quarto render a_ejemplo.qmd

# PDF para el profesor (transparencias)
quarto render a_ejemplo-slides.qmd

# Envoltorio unificado: renderizar cada formato por separado
quarto render a_ejemplo-unificado.qmd --to memoriatfetypst-typst
quarto render a_ejemplo-unificado.qmd --to qmd-ptm-ty-slides-typst
quarto render a_ejemplo-unificado.qmd --to html
```

Resultados (envoltorios separados):

- 📄 [a_ejemplo.pdf](tests/ejemploconslides/a_ejemplo.pdf) — 641 KB, 8 páginas A4
- 📄 [a_ejemplo-slides.pdf](tests/ejemploconslides/a_ejemplo-slides.pdf) — 721 KB, 21 diapositivas 16:9

Resultados (envoltorio unificado):

- 📄 [a_ejemplo-unificado-a4.pdf](tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) — 641 KB, 8 páginas A4
- 📄 [a_ejemplo-unificado-slides.pdf](tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) — 721 KB, 21 diapositivas 16:9
- 🌐 [a_ejemplo-unificado.html](tests/ejemploconslides/a_ejemplo-unificado.html) — 1.4 MB

### Descargar el ejemplo como ZIP

Puedes obtener todos los ficheros del ejemplo de dos maneras:

**Opción 1 — Clonar el repositorio** (recomendada):

```bash
git clone https://github.com/calote/quarto-typst-memoriatfetypst.git
cd quarto-typst-memoriatfetypst/tests/ejemploconslides
```

**Opción 2 — Descargar solo esta carpeta como ZIP**:

[https://download-directory.github.io/?url=https://github.com/calote/quarto-typst-memoriatfetypst/tree/main/tests/ejemploconslides](https://download-directory.github.io/?url=https://github.com/calote/quarto-typst-memoriatfetypst/tree/main/tests/ejemploconslides)

**Opción 3 — Generar el ZIP localmente** (requiere `zip` instalado):

```bash
bash tests/ejemploconslides/empaquetar-ejemplo.sh
```

---

## Galería de características

Cada característica de la plantilla tiene un test de regresión asociado que verifica que se renderiza sin errores. Los PDFs se pueden consultar online; los enlaces apuntan a **raw.githack.com** para que el PDF se abra completo en el navegador (no embebido en la vista previa de GitHub).

> **💡 Consejo:** Usa **Ctrl+clic** (o **clic derecho → Abrir en nueva pestaña**) en los enlaces PDF para verlos cómodamente sin salir de esta página.

| Característica | Descripción | Código | Vista previa |
|---|---|---|---|
| Por defecto | Estilo base de la plantilla | [`test-default.qmd`](tests/regresion/test-default.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-default.pdf) |
| Estilo 02 | Banner compacto con degradado (TeX Gyre Pagella, 10pt) | [`test-estilo02.qmd`](tests/regresion/test-estilo02.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo02.pdf) |
| Estilo 03 | Alineado a la izquierda, sin marca de agua (TeX Gyre Termes, 12pt) | [`test-estilo03.qmd`](tests/regresion/test-estilo03.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo03.pdf) |
| Estilo 04 | Cabecera de capítulo `"estilo04"` (sidebar) | [`test-estilo04.qmd`](tests/regresion/test-estilo04.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-estilo04.pdf) |
| Theorem modern | Teoremas estilo `modern` (coloreados por tipo) | [`test-theorem-modern.qmd`](tests/regresion/test-theorem-modern.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-theorem-modern.pdf) |
| Sidebar color | Barra lateral `estilo04` con colores naranja personalizados | [`test-sidebar-color.qmd`](tests/regresion/test-sidebar-color.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-sidebar-color.pdf) |
| Modo informe | Artículo/informe: una sola sección nivel 1, mini-TOC por sección, sin portada ni listados | [`test-report-mode.qmd`](tests/regresion/test-report-mode.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-report-mode.pdf) |
| Sin portada | Documento sin portada ni listados | [`test-no-portada.qmd`](tests/regresion/test-no-portada.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-no-portada.pdf) |
| Exámenes — clásico | Ejercicios de examen (cajas clásicas azul/verde) | [`test-examen.qmd`](tests/examen/test-examen.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen.pdf) |
| Exámenes — moderno | Ejercicios de examen (estilo moderno tarjetas) | [`test-examen-moderno.qmd`](tests/examen/test-examen-moderno.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-moderno.pdf) |
| Exámenes — avanzado | Márgenes personalizados, modo plano, sin salto de línea | [`test-examen-teoriadecision.qmd`](tests/examen/test-examen-teoriadecision.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-teoriadecision.pdf) |
| Exámenes — demografía | Galería de todos los tipos de ejercicio (temática demografía) | [`test-examen-demografia.qmd`](tests/examen/test-examen-demografia.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/examen/test-examen-demografia.pdf) |
| Fuentes | Configuración tipográfica vía brand | [`test-fuentes.qmd`](tests/regresion/test-fuentes.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-fuentes.pdf) |
| Bibliografía | Renderizado de citas/bibliografía | [`test-bibliografia.qmd`](tests/regresion/test-bibliografia.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-bibliografia.pdf) |
| Heading highlight | Barra destacada en encabezados de sección | [`test-heading-highlight.qmd`](tests/regresion/test-heading-highlight.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-heading-highlight.pdf) |
| Highlight styles | Resaltado sintáctico Pandoc Skylighting | [`test-highlight-styles.qmd`](tests/regresion/test-highlight-styles.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-highlight-styles.pdf) |
| Sidebar primera página | Barra lateral solo en la primera página | [`test-sidebar-first-page.qmd`](tests/regresion/test-sidebar-first-page.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-sidebar-first-page.pdf) |
| Typst raw block | Bloques de código Typst raw (numeración, fondos) | [`test-typst-raw-block.qmd`](tests/regresion/test-typst-raw-block.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-typst-raw-block.pdf) |
| Watermark brand | Marca de agua + marca vertical brand | [`test-watermark-brand.qmd`](tests/regresion/test-watermark-brand.qmd) | [📄 PDF](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/regresion/test-watermark-brand.pdf) |
| Doble uso A4 + slides + HTML | Un contenido, tres formatos: PDF A4, PDF slides y HTML — con envoltorio unificado | [`a_ejemplo-unificado.qmd`](tests/ejemploconslides/a_ejemplo-unificado.qmd) | [📄 A4](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado-a4.pdf) · [📄 Slides](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado-slides.pdf) · [🌐 HTML](https://raw.githack.com/calote/quarto-typst-memoriatfetypst/main/tests/ejemploconslides/a_ejemplo-unificado.html) |

Los tests se ejecutan con:

```bash
Rscript tests/regresion/ejecutar-tests.R
```

Si algún test falla, el script sale con código 1 e indica qué test y formato produjeron el error.

---

## Arquitectura

```
_extensions/memoriatfetypst/
├── _extension.yml                     # Manifiesto de la extensión de Quarto
├── typst-template.typ                 # Función `article` principal de Typst
├── typst-show.typ                     # Puente de parámetros Quarto → Typst
├── shortcodes.lua                     # Shortcodes `appendix` y `pagebreak`
├── normalize-exercise-titles.lua      # Normaliza title: none → title: "" para bloques teorema
└── boxed-filter.lua                   # Filtro LaTeX \boxed{} → Typst #box()
```

- **`_extension.yml`** declara el formato, requiere Quarto ≥ 1.6.0,
  incluye los dos parciales Typst, el archivo Lua de shortcodes y los
  filtros. También establece los valores predeterminados del formato
  (`portada: true`, `toc: true`, `centrar-matematicas: true`,
  `fig-format: png`).
- **`typst-template.typ`** define una única función `article()` que
  recibe todos los parámetros, configura la geometría de página,
  cabeceras/pies de página, estilos de capítulo numerados, páginas de
  prefacio y la bibliografía. La función `appendix()` al final
  reinicia la numeración e inserta una página divisoria.
- **`typst-show.typ`** es la *plantilla show* que Quarto invoca;
  reenvía cada clave YAML soportada a la función `article()` con la
  conversión de tipo Typst correcta (`$if(...)$ … $endif$`). Cuando
  se activa `theorem-style`, también sobrescribe las funciones de
  teorema de Theorion (`definition`, `theorem`, `example`, `exercise`)
  con envoltorios que normalizan `title: none` → `title: ""`,
  evitando paréntesis vacíos `()` en entornos sin título.
- **`shortcodes.lua`** proporciona los dos shortcodes. Emiten Typst
  crudo que activa el comportamiento correspondiente en
  `typst-template.typ`.
- **`normalize-exercise-titles.lua`** es un filtro Lua de Pandoc que
  detecta bloques Div con identificadores con prefijos de teorema y
  marca aquellos sin encabezado para el manejo de título vacío.
  Funciona junto con la normalización a nivel Typst en `typst-show.typ`.
- **`boxed-filter.lua`** recorre el AST después de la conversión de
  Pandoc → Typst y reescribe cualquier nodo `Math` que contenga
  `\boxed{…}` en una llamada `#box()` / `#rect()` de Typst, ya que el
  conversor nativo de Pandoc a Typst no implementa `\boxed`.

---

## Solución de problemas

| Síntoma | Causa probable | Solución |
|---|---|---|
| Ejercicio / ejemplo muestra paréntesis vacíos `()` tras el número | Pandoc pasa `title: none` para bloques sin `##### Título` | Era un bug en `get-full-title()` de Theorion. La extensión ahora normaliza `title: none` → `""` en las funciones envoltorio (`typst-show.typ`). Actualiza a la última versión. |
| `unknown variable: nombre-capitulo` | Falta `nombre-capitulo` al usar `estilo03` | Pon `nombre-capitulo: "--"` o cualquier cadena no vacía. |
| Ecuaciones en bloque quedan indentadas dentro de listas | `centrar-matematicas: false` | Ponlo a `true` (valor predeterminado). |
| La página de bibliografía está vacía | No se encuentra el archivo CSL | Asegúrate de que la ruta en `csl:` es correcta, o elimina la clave `csl:` para usar el estilo Typst predeterminado. |
| Tablas largas desbordan una sola página | Las figuras de Typst no son rompibles por defecto | Envuelve la tabla en ` ```{=typst} #show figure: set block(breakable: true) ``` ` y restablece después con `breakable: false`. Ver `apendice01.qmd` para un ejemplo. |
| La portada se imprime sin logo | La ruta de `logo-file` es relativa a la raíz del proyecto, no al archivo `.qmd` | Usa una ruta relativa al directorio desde el que ejecutas `quarto render`. |
| `quarto add` falla interactivamente | — | Vuelve a ejecutar con `--no-prompt`. |
| Los estilos CSL de BibTeX se ven mal | Quarto usa el procesador CSL, no el nativo de Typst | O mantén el flujo de trabajo CSL o elimina la clave `csl:` y deja que Typst renderice de forma nativa. |

---

## Hoja de ruta e ideas

Consulta el [archivo de propuestas](PROPOSALS.md) (o el
[rastreador de incidencias](../../issues)) para la lista completa.
Aspectos destacados:

- Aceptar `bibliografia-completa` como un booleano real en lugar de
  una cadena comparada con `"true"`.
- Añadir una opción para inyectar código Typst adicional
  (`include-in-header`) desde el YAML, p.ej. para estilos de teoremas
  personalizados tipo LaTeX.
- Documentar y distribuir un quinto estilo de cabecera de capítulo
  (`estilo05` con título centrado).
- Añadir un flujo de trabajo de GitHub Actions que renderice el
  ejemplo en cada PR.

---

## Paquetes R complementarios

Los siguientes paquetes de R **no son necesarios** para usar esta
extensión, pero resultan muy útiles porque soportan de forma nativa la
salida **Typst** y se integran perfectamente con documentos Quarto.

| Paquete | Versión instalada | Descripción |
|---|---|---|
| [`tinytable`](https://vincentarelbundock.github.io/tinytable/) | 0.16.0.14 | Renderizado flexible de tablas con salida Typst nativa (`plugin: "typst"`). Soporta multipágina, títulos, encabezados combinados y más. |
| [`modelsummary`](https://vincentarelbundock.github.io/modelsummary/) | 2.6.0.4 | Resúmenes de modelos, tablas de regresión y gráficos de coeficientes. Exporta directamente a Typst mediante `output = "typst"` o a través de `tinytable`. |

Para instalar la versión de desarrollo más reciente desde GitHub:

```r
# install.packages("remotes")
remotes::install_github("vincentarelbundock/tinytable")
remotes::install_github("vincentarelbundock/modelsummary")
```

---

## Contribuir

Las incidencias y las solicitudes de cambio son bienvenidas. Si
planeas un cambio no trivial, abre una incidencia primero para
discutir el diseño. Al enviar un PR:

1. Renderiza `tests/ejemplo01/tfe_ejemplo01.qmd` y confirma que el
   PDF sigue compilando.
2. Si cambias una opción YAML, actualiza tanto este LEEME como los
   archivos de ejemplo.
3. Si cambias la plantilla Typst, verifica que los tres estilos de
   capítulo (`estilo01/02/03`) siguen renderizando.

---

## Licencia

Publicado bajo la [Licencia MIT](LICENSE). © 2025-2026 Pedro Luque.
