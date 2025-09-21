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
$if(logo)$
  logo: "$logo$",
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
