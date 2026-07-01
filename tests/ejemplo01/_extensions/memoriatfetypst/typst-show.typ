$if(heading-style)$
// heading-style.typ — estilo de subsecciones H2..H6
#show heading.where(level: 2): set text(size: 1.35em)
#show heading.where(level: 3): set text(size: 1.2em)
#show heading.where(level: 4): set text(size: 1.1em)
#show heading.where(level: 5): set text(size: 1.0em)
#show heading.where(level: 6): set text(size: 0.95em)
#show heading.where(level: 2): it => block(above: 2.5em, below: 1.5em, it)
#show heading.where(level: 3): it => block(above: 2.5em, below: 1.5em, it)
#show heading.where(level: 4): it => block(above: 2em, below: 1.2em, it)
#show heading.where(level: 5): it => block(above: 1.5em, below: 1em, it)
#show heading.where(level: 6): it => block(above: 1.5em, below: 1em, it)
$endif$
$if(theorem-style)$
// Colores para cada tipo de teorema
#let thm-col-def   = rgb("#1565C0")
#let thm-col-thm   = rgb("#C62828")
#let thm-col-exm   = rgb("#2E7D32")
#let thm-col-exr   = rgb("#E65100")
#let thm-col-proof = rgb("#6A1B9A")
#let thm-col-sol   = rgb("#00695C")

// Show rules para suprimir el número del figure envolvente
// (el contador sigue activo para #ref(), pero no se muestra visualmente)
#show figure.where(kind: "def-wrap"): it => it.body
#show figure.where(kind: "thm-wrap"): it => it.body
#show figure.where(kind: "exm-wrap"): it => it.body
#show figure.where(kind: "exc-wrap"): it => it.body

// Auxiliar: envuelve en figure para que #ref() funcione.
// Cada tipo de teorema tiene su propio kind de figure para que
// los contadores sean independientes y coincidan 1 a 1 con los
// contadores de theorion.
#let thm-style(body, col, kind) = figure(
  kind: kind, supplement: [], caption: [], numbering: "1",
  block(
    width: 100%, stroke: (left: 4pt + col), fill: col.lighten(90%),
    inset: (x: 0.8em, y: 0.6em), radius: 2pt, breakable: true,
  )[
    #set align(left)
    #set par(justify: true)
    #body
  ],
)
// Helper: normaliza title (none → "") para evitar paréntesis vacíos en Theorion
#let _normalize-title(t) = if t == none or t == "" { "" } else { t }

// Sobreescribir funciones de teoremas
#let _thm-old-def = definition
#let definition(title: none, body) = thm-style(_thm-old-def(title: _normalize-title(title), body), thm-col-def, "def-wrap")
#let _thm-old-thm = theorem
#let theorem(title: none, body) = thm-style(_thm-old-thm(title: _normalize-title(title), body), thm-col-thm, "thm-wrap")
#let _thm-old-exm = example
#let example(title: none, body) = thm-style(_thm-old-exm(title: _normalize-title(title), body), thm-col-exm, "exm-wrap")
#let _thm-old-exc = exercise
#let exercise(title: none, body) = thm-style(_thm-old-exc(title: _normalize-title(title), body), thm-col-exr, "exc-wrap")
$endif$

// Show rules para colores personalizados
// Quarto escapa # → \# al interpolar strings, así que quitamos el \ antes de pasar a rgb()
#let _fixhex(s) = s.replace("\\", "")
$if(link-color)$
#let _link-col = rgb(_fixhex("$link-color$"))
$else$
#let _link-col = rgb("#483d8b")
$endif$
$if(internal-link-color)$
#let _internal-col = rgb(_fixhex("$internal-link-color$"))
$else$
#let _internal-col = rgb("#5b5b9e")
$endif$
$if(cite-color)$
#let _cite-col = rgb(_fixhex("$cite-color$"))
$else$
#let _cite-col = rgb("#6A1B9A")
$endif$

// show link discrimina: enlaces externos (URL string) vs internos (location)
#show link: it => {
  if type(it.dest) == str {
    text(fill: _link-col, weight: "bold", it)
  } else {
    text(fill: _internal-col, weight: "bold", it)
  }
}
#show ref: set text(fill: _internal-col, weight: "bold")
#show cite: set text(fill: _cite-col, weight: "bold")

#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(author)$
  author: [$author$],
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(abstract-title)$
  abstract-title: [$abstract-title$],
$endif$
$if(keywords)$
  keywords: [$for(keywords)$$keywords$$sep$, $endfor$],
$endif$
$if(agradecimientos)$
  agradecimientos: [$agradecimientos$],
$endif$
$if(resumen)$
  resumen: [$resumen$],
$endif$
$if(palabras-clave)$
  palabras-clave: [$for(palabras-clave)$$palabras-clave$$sep$, $endfor$],
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(sansfont)$
  sansfont: ("$sansfont$",),
$elseif(brand.typography.headings.family)$
  sansfont: $brand.typography.headings.family$,
$endif$
$if(mathfont)$
  mathfont: ("$mathfont$",),
$elseif(brand.defaults.academic-typst.mathfont)$
  mathfont: ("$brand.defaults.academic-typst.mathfont$"),
$endif$
$if(brand.typography.link.color)$
  link-color: $brand.typography.link.color$,
$endif$
$if(internal-link-color)$
  internal-link-color: "$internal-link-color$",
$endif$
$if(cite-color)$
  cite-color: "$cite-color$",
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
  toc: $if(toc)$$toc$$else$false$endif$,
  totablas: $if(totablas)$$totablas$$else$false$endif$,
  tofiguras: $if(tofiguras)$$tofiguras$$else$false$endif$,
  portada: $if(portada)$$portada$$else$false$endif$,
$if(toccapitulos)$
  toccapitulos: $toccapitulos$,
$endif$
  centrar-matematicas: $if(centrar-matematicas)$$centrar-matematicas$$else$false$endif$,
$if(tipo-TFG)$
  tipo-TFG: "$tipo-TFG$",
$endif$
$if(titulacion)$
  titulacion: "$titulacion$",
$endif$
$if(tutor-TFG)$
  tutor-TFG: "$tutor-TFG$",
$endif$
$if(facultad)$
  facultad: "$facultad$",
$endif$
$if(universidad)$
  universidad: "$universidad$",
$endif$
$if(logo-file)$
  logo: "$logo-file$",
$endif$
$if(fecha-TFG)$
  fecha-TFG: "$fecha-TFG$",
$endif$
$if(cabecera-capitulo)$
  cabecera-capitulo: "$cabecera-capitulo$",
$endif$
$if(nombre-capitulo)$
  nombre-capitulo: "$nombre-capitulo$",
$endif$
$if(sidebar-color1)$
  sidebar-first-color: "$sidebar-color1$",
$endif$
$if(sidebar-color2)$
  sidebar-second-color: "$sidebar-color2$",
$endif$
$if(sidebar-dx)$
  sidebar-dx: $sidebar-dx$,
$endif$
$if(theorem-style)$
  theorem-style: "$theorem-style$",
$endif$
$if(referencias-nombre)$
  referencias-nombre: "$referencias-nombre$",
$endif$
$if(apendice-portada)$
  apendice-portada: "$apendice-portada$",
$endif$
$if(apendice-nombre)$
  apendice-nombre: "$apendice-nombre$",
$endif$
$if(bibliografia-completa)$
  bibliografia-completa: "$bibliografia-completa$",
$endif$
  doc,
)
