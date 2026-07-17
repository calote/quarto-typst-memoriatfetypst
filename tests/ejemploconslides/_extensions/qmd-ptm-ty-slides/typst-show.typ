// typst-show.typ
// Conecta las variables del YAML de Quarto con la función slides()
// de typst-template.typ

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
$if(handout)$
  handout: true,
$endif$
)

$-- font-size se aplica dentro del body procesado por slides()/metropolis-theme,  --$
$-- con mayor especificidad que el `set text(size: 20pt)` interno del tema.       --$
$if(font-size)$
#set text(size: $font-size$)
$endif$
// Redefinición de Skylighting: el fondo hardcodeado (#f1f3f5) se sustituye por
// fill: none (transparente). Los bloques coloreados los inserta slides-headings.lua
// envolviendo cada CodeBlock con #block(fill: rgb("..."), width: 100%)[...].
// Así, código fuente y salidas pueden tener colores independientes.
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