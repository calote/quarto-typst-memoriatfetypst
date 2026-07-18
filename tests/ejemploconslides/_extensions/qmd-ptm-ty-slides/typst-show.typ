// typst-show.typ
// Conecta las variables del YAML de Quarto con la función slides()
// de typst-template.typ

// Redefinición de Skylighting: el fondo hardcodeado (#f1f3f5) se sustituye por
// fill: none (transparente). Los bloques coloreados los inserta slides-headings.lua
// ANTES de #show: slides.with(...) para no generar un slide implícito en blanco.
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
  let blocks = []
  let lnum = start - 1
  for ln in sourcelines {
    if number {
      lnum = lnum + 1
      blocks = blocks + box(
        width: if start + sourcelines.len() > 999 { 30pt } else { 24pt },
        text(fill: rgb("#aaaaaa"), [ #lnum ])
      )
    }
    blocks = blocks + ln + EndLine()
  }
  block(fill: fill, width: 100%, inset: 8pt, radius: 2pt, blocks)
}
$if(lang)$
  #set text(lang: "$lang$")
$endif$

$-- Sobrescribe #alert de Touying con una función simple basada en text().          --$
$-- Touying define alert() con touying-fn-wrapper, lo que hace que siempre          --$
$-- "escape" la zona de pausa y aparezca en todas las subdiapositivas.              --$
$-- text() es contenido normal: Touying lo oculta correctamente con cover().        --$
$if(accent-color)$
#let alert(body) = text(fill: rgb("$accent-color$"), body)
$else$
#let alert(body) = text(fill: rgb("#eb811b"), body)
$endif$

$-- center-equations: centra las ecuaciones en bloque ($$...$$) corrigiendo la    --$
$-- sangría acumulada de las listas. Se aplica ANTES de #show: slides.with(...)   --$
$-- para que Touying no lo vea como contenido entre slides (lo que generaría un   --$
$-- slide implícito en blanco). El contexto se evalúa en tiempo de renderizado,   --$
$-- por lo que page.margin/width corresponden a las dimensiones reales del slide. --$
$if(center-equations)$
#show math.equation.where(block: true): it => context {
  let ml      = page.margin.left
  let mr      = page.margin.right
  let sangria = here().position().x - ml
  let ancho   = page.width - ml - mr
  move(
    dx: -sangria,
    block(width: ancho, align(center, it))
  )
}
$endif$

#show: slides.with(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(author)$
$-- Puede ser string simple o lista de autores --$
$if(author/allbutlast)$
  author: [$for(author)$$it$$sep$, $endfor$],
$else$
  author: [$for(author)$$it$$endfor$],
$endif$
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(institute)$
  institution: [$institute$],
$endif$
$if(header-color)$
  header-color: rgb("$header-color$"),
$endif$
$if(section-color)$
  section-color: rgb("$section-color$"),
$endif$
$if(accent-color)$
  accent-color: rgb("$accent-color$"),
$endif$
$if(aspect-ratio)$
  aspect-ratio: "$aspect-ratio$",
$endif$
$if(handout-mode)$
  handout: true,
$endif$
$-- font-size se pasa como parámetro (no como body content) para que slides()    --$
$-- lo aplique via set text() en su scope, evitando slides implícitos en blanco. --$
$if(font-size)$
  font-size: $font-size$,
$endif$
)
