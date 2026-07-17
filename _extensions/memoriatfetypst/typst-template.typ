#import "@preview/fontawesome:0.5.0": *
#import "@preview/hydra:0.6.1": hydra
//#import "@preview/hydra:0.5.2": hydra

// DEBUG: Mostrar valor y tipo
#let debug(label, value) = [
  *DEBUG [#label]:* #repr(value) (tipo: #type(value)) \
]
#let debug2(label, value) = [
  *DEBUG [#label]:* value (tipo: #type(value)) \
]
// 
// #debug("mi diccionario", my-dict)



#let cabecera-capitulo-estilo01(it,nums,nombre-capitulo) = {

    // Número del capítulo grande en gris claro
    place(
      top + right,
      dx: 0cm,
      dy: -0.5cm,
      [
      #align(center)[
        #text(size: 72pt, fill: gray.lighten(70%), weight: "bold")[#nums.at(0)]
        #linebreak()
        #text(size: 14pt, fill: gray.lighten(70%), weight: "bold", tracking: 2pt)[#nombre-capitulo]
        ]
      ]
    )
    
    // Título alineado a la derecha
    v(5em)
    align(right)[
        #text(size: 24pt, weight: "bold")[#it.body]
        #v(0.3em)
        #line(length: 50%, stroke: 2pt + gray)
    ]
    v(3em)

}

#let cabecera-apendice-estilo01(it, nums, apendice-nombre) = {

    place(
      top + right,
      dx: 0cm,
      dy: -0.5cm,
      [
      #align(center)[
        #text(size: 72pt, fill: gray.lighten(70%), weight: "bold")[#numbering("A", nums.at(0))]
        #linebreak()
        #text(size: 14pt, fill: gray.lighten(70%), weight: "bold", tracking: 2pt)[#apendice-nombre]
        ]
      ]

    )
    
    // Título alineado a la derecha
    v(5em)
    align(right)[
      #block[
        #text(size: 24pt, weight: "bold")[#it.body]
        #v(0.3em)
        #line(length: 50%, stroke: 2pt + gray)
      ]
    ]
    v(3em)



}

#let cabecera-capitulo-estilo02(it, number, nombre-capitulo) = {

   align(right)[
      #rect(
        fill: gradient.linear(..color.map.crest),
        stroke: none,
        radius: (left: 10pt, right: 0pt),
        inset: (x: 20pt, y: 15pt)
      )[
        #text(size: 16pt, weight: "bold", fill: white)[#nombre-capitulo #number.at(0)]
        #linebreak()
        #text(size: 20pt, weight: "bold", fill: white)[#it.body]
      ]
    
    
   ]


}

#let cabecera-apendice-estilo02(it, number, apendice-nombre) = {
     align(right)[
      #rect(
        fill: gradient.linear(..color.map.crest),
        stroke: none,
        radius: (left: 10pt, right: 0pt),
        inset: (x: 20pt, y: 15pt)
      )[
        #text(size: 16pt, weight: "bold", fill: white)[#apendice-nombre #numbering("A", number.at(0))]
        #linebreak()
        #text(size: 20pt, weight: "bold", fill: white)[#it.body]
      ]
    
    
   ]
}

#let cabecera-capitulo-estilo03(it,nums,nombre-capitulo,author) = {
    
    if nombre-capitulo == "--" {
      // Modo report: mostrar solo título y autor sin número
      // El heading se crea sin renderizar visualmente
      align(left)[
          #text(size: 26pt, weight: "bold")[#it.body]
          #v(1em)
          #text(size: 16pt, weight: "bold", tracking: -1pt, style: "italic")[#author]
          #v(1em)
          #line(length: 50%, stroke: 2pt + gray)
      ]
      v(3em)

    } else {
      align(left)[
          #text(size: 25pt, weight: "bold", tracking: 2pt)[#nombre-capitulo #nums.at(0)]
          #v(1.5em)
          #text(size: 26pt, weight: "bold")[#it.body]
          #v(1em)
          #line(length: 50%, stroke: 2pt + gray)
      ]
      v(3em)

    }

}

#let cabecera-apendice-estilo03(it,nums,apendice-nombre) = {
    
    align(left)[
        #text(size: 25pt, weight: "bold", tracking: 2pt)[#apendice-nombre #numbering("A", nums.at(0))]
        #v(1.5em)
        #text(size: 26pt, weight: "bold")[#it.body]
        #v(1em)
        #line(length: 50%, stroke: 2pt + gray)
    ]
    v(3em)

}



#let appendix-count-state = state("appendix-count", 1)
#let cabecera-capitulo-state = state("cabecera-capitulo", "estilo01")
#let nombre-capitulo = state("nombre-capitulo", "CAPÍTULO")
#let referencias-nombre = "Referencias"

#let apendice-portada-state = state("apendice-portada", "APÉNDICE")
#let apendice-nombre-state = state("apendice-nombre", "APÉNDICE")

#let toccapitulos-state = state("toccapitulos", false)


// Estado para controlar si mostrar TOC por capítulo
#let show-chapter-toc = state("show-chapter-toc", true)

// Estados para estilo04 (sidebar)
#let num-capitulo = state("num-capitulo", 1)
#let sidebar-activo-state = state("sidebar-activo", false)
#let sidebar-c1-state = state("sidebar-c1", rgb("#1a365d"))
#let sidebar-c2-state = state("sidebar-c2", rgb("#2c5282"))
#let sidebar-dx-state = state("sidebar-dx", 0.5cm)
#let sidebar-show-state = state("sidebar-show", "all")
#let apendice-activo-state = state("apendice-activo", false)

// Estado para el estilo de teoremas/definiciones (default = sin modificar)
#let theorem-style-state = state("theorem-style", "default")

// Estados para resaltado de secciones (heading-highlight)
#let heading-highlight-state = state("heading-highlight", 0)
#let heading-highlight-color-state = state("heading-highlight-color", none)
#let heading-highlight-text-color-state = state("heading-highlight-text-color", none)

// Estados para watermark
#let watermark-text-state = state("watermark-text", none)
#let watermark-opacity-state = state("watermark-opacity", 0.12)
#let watermark-color-state = state("watermark-color", "#000000")
#let watermark-fontsize-state = state("watermark-fontsize", 72pt)
#let watermark-angle-state = state("watermark-angle", 35deg)

// Estados para brand vertical
#let brand-vertical-text-state = state("brand-vertical-text", none)
#let brand-vertical-color-state = state("brand-vertical-color", "#999999")
#let brand-vertical-fontsize-state = state("brand-vertical-fontsize", 0.8em)
#let brand-vertical-width-state = state("brand-vertical-width", 1.5cm)
#let brand-vertical-logo-state = state("brand-vertical-logo", none)
#let brand-vertical-dy-state = state("brand-vertical-dy", 50%)

// Paleta de colores para teoremas (estilo modern)
#let thm-col-def   = rgb("#1565C0")
#let thm-col-thm   = rgb("#C62828")
#let thm-col-exm   = rgb("#2E7D32")
#let thm-col-exr   = rgb("#E65100")
#let thm-col-proof = rgb("#6A1B9A")
#let thm-col-sol   = rgb("#00695C")

// Renderizado moderno para teoremas (barra lateral coloreada)
#let thm-render(body, label, num, title, color) = {
  block(
    width: 100%,
    stroke: (left: 4pt + color),
    fill: color.lighten(90%),
    inset: (x: 0.8em, y: 0.6em),
    radius: 2pt,
  )[
    #set align(left)
    #set par(justify: true)
    #text(weight: "bold", fill: color, size: 0.9em)[#label #num.]
    #if title != [] {
      linebreak()
      text(style: "italic", size: 0.95em)[#title]
    }
    #v(0.3em)
    #body
  ]
}

// Función principal para TOC por capítulo
#let chapter-contents() = {
  context {
    if show-chapter-toc.get() {
      let loc = here()
      
      // Buscar el capítulo actual y siguientes subsecciones
      let headings = query(heading)
      let current-chapter-index = none
      
      // Encontrar el índice del capítulo actual
      for (i, h) in headings.enumerate() {
        if h.level == 1 and h.location().page() <= loc.page() {
          current-chapter-index = i
        }
      }
      
      if current-chapter-index != none {
        let current-chapter = headings.at(current-chapter-index)
        
        // Encontrar el siguiente capítulo
        let next-chapter-index = none
        for (i, h) in headings.enumerate() {
          if i > current-chapter-index and h.level == 1 {
            next-chapter-index = i
            break
          }
        }
        
        // Recopilar subsecciones
        let subsections = ()
        let start-index = current-chapter-index + 1
        let end-index = if next-chapter-index != none { next-chapter-index } else { headings.len() }
        
        for i in range(start-index, end-index) {
          let h = headings.at(i)
          if h.level > 1 and h.level <= 3 {
            subsections.push(h)
          }
        }
        
        if subsections.len() > 0 {
          // Crear la caja del TOC
          rect(
            width: 100%,
            inset: (x: 1.2em, y: 0.8em),
            fill: gradient.linear(rgb("#f0f8ff"), rgb("#e6f3ff")),
            stroke: rgb("#b3d9ff"),
            radius: 4pt
          )[
            #grid(
              columns: (auto, 1fr),
              column-gutter: 0.8em,
              grid.cell(align: left+bottom,               
              [📖]
              ),
              grid.cell(align: left+bottom, 
              text(weight: "bold", size: 11pt)[Índice de contenido:]  // Contenido de este capítulo:
              )              
            )
            
            #v(0.4em)
            
            #for subsection in subsections {
              let page-num = counter(page).at(subsection.location()).first()
              let indent = (subsection.level - 2) * 1.2em
              
              h(indent)
              link(subsection.location())[
                #if subsection.numbering != none {
                  let nums = counter(heading).at(subsection.location())
                  if nums.len() > 1 {
                    text(size: 10pt)[#nums.slice(1).map(str).join(".")]
                    h(0.3em)
                  }
                }
                #text(size: 10pt)[#subsection.body]
                #h(1fr)
                #text(size: 9pt, fill: gray)[pág. #page-num]
              ]
              linebreak()
            }
          ]
          v(1.5em)
        }
      }
    }
  }
}


// ── Funciones para estilo04 (sidebar) ──────────────────────────────

#let dibujar-sidebar(sidebar-w, color1, color2, nombre-capitulo, num, dx: 0.5cm) = {
  place(
    top + left,
    dx: dx,
    block(
      width: sidebar-w,
      height: 100%,
      fill: gradient.linear(color1, color2, angle: 90deg),
      stroke: none,
      radius: 3pt,
      clip: true,
    )[
      #set text(fill: white, weight: "bold", size: 11pt)
      #align(center + horizon)[
        #rotate(-90deg, origin: center)[
          #block(width: 4cm)[#nombre-capitulo #num]
        ]
      ]
    ]
  )
}

#let cabecera-capitulo-estilo04(it, nums, nombre-capitulo) = {
  v(0.5em)
  block[
    #text(size: 26pt, weight: "bold")[#it.body]
    #v(0.25em)
    #line(length: 60%, stroke: 3pt + rgb("#2c5282"))
  ]
  v(2em)
}

#let cabecera-apendice-estilo04(it, nums, apendice-nombre) = {
  v(0.5em)
  block[
    #text(size: 26pt, weight: "bold")[#it.body]
    #v(0.25em)
    #line(length: 60%, stroke: 3pt + rgb("#2c5282"))
  ]
  v(2em)
}

// ── article() ──────────────────────────────────────────────────────

#let article(
  // Document metadata
  title: none,
  subtitle: none,
  author: none,
  date: none,
  abstract: none,
  //abstract-title: "ABSTRACT",
  abstract-title: "RESUMEN",
  // Custom document metadata
  header: none,
  code-repo: none,
  keywords: none,
  custom-keywords: none,
  thanks: none,
  // Layout settings
  //margin: (x: 1.25in, y: 1.25in),  // equivale a: (x: 3.18cm, y: 3.18cm),
  margin: (x: 2.5cm, y: 2.5cm),
  paper: "a4",
  // Typography settings
  lang: "es",
  region: "ES",
  font: "libertinus serif",
  fontsize: 11pt,
  //sansfont: "libertinus sans",
  sansfont: "Helvetica",
  mathfont: "New Computer Modern Math",
  link-color: rgb("#483d8b"),
  internal-link-color: rgb("#5b5b9e"),
  cite-color: rgb("#6A1B9A"),
  sectionnumbering: "1.1.1",
  pagenumbering: "1",
  toc: true,
  tofiguras: true,
  totablas: true,
  portada: true,
  toccapitulos: false,
  centrar-matematicas: true,
  cabecera-capitulo: "estilo01",
  nombre-capitulo: "CAPÍTULO", // "TEMA"
  referencias-nombre: "Referencias",
  apendice-portada: "APÉNDICE",
  apendice-nombre: "APÉNDICE",
  sidebar-first-color: "#1a365d",
  sidebar-second-color: "#2c5282",
  sidebar-dx: 0.5cm,
  sidebar-show: "all",
  theorem-style: "default",
  heading-highlight: 0,
  heading-highlight-color: "#e8f0fe",
  heading-highlight-text-color: "#1a1a2e",
  watermark-text: none,
  watermark-opacity: 0.12,
  watermark-color: "#000000",
  watermark-fontsize: 72pt,
  watermark-angle: 35deg,
  brand-vertical-text: none,
  brand-vertical-color: "#999999",
  brand-vertical-fontsize: 0.8em,
  brand-vertical-width: 1.5cm,
  brand-vertical-dy: 50%,
  brand-vertical-logo: none,
  logo: none,
  tipo-TFG: "TRABAJO FIN DE GRADO",
  fecha-TFG: "Sevilla, Junio de 2025", //Sevilla, Octubre de 2025
  tutor-TFG: none,
  titulacion: "Grado en Estadística",//"Grado en Matemáticas y Estadística",
  facultad: none,
  universidad: none,
  agradecimientos: none,
  resumen: none,
  palabras-clave: none,
  bibliografia-completa: false, // true or false
  numerar-secciones-nivel1: "auto", // "auto" | "true" | "false"
  doc,
) = {

  cabecera-capitulo-state.update(str(cabecera-capitulo))
//let nombre-capitulo = "CAPÍTULO"
//let nombre-capitulo = [#nombre-capitulo]  //"TEMA"
let nombre-capitulo = nombre-capitulo  //"TEMA"

apendice-portada-state.update(str(apendice-portada))
apendice-nombre-state.update(str(apendice-nombre))

toccapitulos-state.update(toccapitulos)

// Normalizar colores: convierte string a color, o deja color intacto
// NOTA: No usar type(c) == "str" porque Typst 0.14 buguea el tipo
// retornado dentro de #show: doc => (el color se convierte en string).
// Usamos repr() como workaround.
let norm-color(c) = {
  let r = repr(c)
  if r.starts-with("\"") {
    let s = str(c).replace("\\", "")
    if s == "none" { return none }
    if s.starts-with("#") { return rgb(s) }
    return rgb("#" + s)
  }
  return c
}
sidebar-c1-state.update(norm-color(sidebar-first-color))
sidebar-c2-state.update(norm-color(sidebar-second-color))
sidebar-dx-state.update(sidebar-dx)
sidebar-show-state.update(str(sidebar-show))

// Convertir strings de color a colores válidos INMEDIATAMENTE
link-color = norm-color(link-color)
internal-link-color = norm-color(internal-link-color)
cite-color = norm-color(cite-color)

heading-highlight-state.update(heading-highlight)
heading-highlight-color-state.update(str(heading-highlight-color))
heading-highlight-text-color-state.update(str(heading-highlight-text-color))

watermark-text-state.update(
  if watermark-text == none { none } else { str(watermark-text) }
)
watermark-opacity-state.update(
  if watermark-opacity == none { 0.12 } else { watermark-opacity }
)
watermark-color-state.update(
  if watermark-color == none { none } else { str(watermark-color) }
)
watermark-fontsize-state.update(
  if watermark-fontsize == none { 72pt } else { watermark-fontsize }
)
watermark-angle-state.update(
  if watermark-angle == none { 35deg } else { watermark-angle }
)

brand-vertical-text-state.update(
  if brand-vertical-text == none { none } else { str(brand-vertical-text) }
)
brand-vertical-color-state.update(
  if brand-vertical-color == none { none } else { str(brand-vertical-color) }
)
brand-vertical-fontsize-state.update(
  if brand-vertical-fontsize == none { 0.8em } else { brand-vertical-fontsize }
)
brand-vertical-width-state.update(
  if brand-vertical-width == none { 1.5cm } else { brand-vertical-width }
)
brand-vertical-dy-state.update(
  if brand-vertical-dy == none { 50% } else { brand-vertical-dy }
)
brand-vertical-logo-state.update(
  if brand-vertical-logo == none { none } else { str(brand-vertical-logo) }
)

theorem-style-state.update(str(theorem-style))

// Función compartida para dibujar watermark y brand vertical en background
let dibujar-watermark-brand() = {
  // Watermark diagonal (BORRADOR, etc.)
  let wt = watermark-text-state.get()
  if wt != none and wt != "" and wt != "none" {
    let wcol-s = watermark-color-state.get()
    let wcol = if wcol-s == none or wcol-s == "none" { rgb("#000000") } else { rgb(wcol-s.replace("\\", "")) }
    let wp = watermark-opacity-state.get()
    let alpha = if wp != none { calc.trunc(wp * 255) } else { 31 }
    let comp = wcol.components()
    let wcol-alpha = rgb(comp.at(0), comp.at(1), comp.at(2), alpha)
    let parts = wt.split(" | ")
    let wm-body = if parts.len() > 1 {
      stack(dir: ttb, spacing: 0.3em,
        ..parts.map(p => text(fill: wcol-alpha, size: watermark-fontsize-state.get(), weight: "bold", align(center, p)))
      )
    } else {
      text(fill: wcol-alpha, size: watermark-fontsize-state.get(), weight: "bold", align(center, wt))
    }
    place(
      center + horizon,
      rotate(watermark-angle-state.get(), wm-body)
    )
  }
  // Brand vertical en margen derecho
  let bvt = brand-vertical-text-state.get()
  if bvt != none and bvt != "" and bvt != "none" {
    let bvcol-s = brand-vertical-color-state.get()
    let bvcol = if bvcol-s == none or bvcol-s == "none" { rgb("#999999") } else { rgb(bvcol-s.replace("\\", "")) }
    let bw = brand-vertical-width-state.get()
    let bdy = brand-vertical-dy-state.get()
    let logo-path = brand-vertical-logo-state.get()
    let logo-block = if logo-path != none and logo-path != "" and logo-path != "none" {
      stack(dir: ltr,
        image(logo-path, height: 1.2cm),
        v(0.3cm),
        rotate(-90deg, text(fill: bvcol, size: brand-vertical-fontsize-state.get(), bvt))
      )
    } else {
      rotate(-90deg, text(fill: bvcol, size: brand-vertical-fontsize-state.get(), bvt))
    }
    place(
      dx: 100% - bw - 0.3cm,
      dy: bdy,
      logo-block
    )
  }
}

  set page(
    paper: paper,
    margin: margin,
    //numbering: pagenumbering,
    numbering: "i",
    background: context {
      dibujar-watermark-brand()
    },
  )
  

let is-first-page-of-section() = {
  let heading-locations = query(heading.where(level: 1)).map(h => h.location())
  let current-page = here().page()
  heading-locations.any(loc => loc.page() == current-page)
}

let is-first-page-of-bibliography() = {
  let bib-query = query(bibliography)
  if bib-query.len() > 0 {
    bib-query.first().location().page() == here().page()
  } else {
    false
  }
}


  set page(
    header: context {
      let bib-query = query(bibliography)
      let in-bib = if bib-query.len() > 0 {
        here().page() >= bib-query.first().location().page()
      } else {
        false
      }

      if in-bib {
        if here().page() > bib-query.first().location().page() {
          align(right, text(size: 0.85em, tracking: 0.5pt)[#upper(referencias-nombre)])
          line(length: 100%)
        }
      } else if not is-first-page-of-section() {
        // Sección activa; si no hay sección todavía, se usa el capítulo como fallback
        let sec = hydra(2)
        let content = if sec != none { sec } else { hydra(1) }
        align(right, text(size: 0.85em, tracking: 0.5pt)[#upper(content)])
        line(length: 100%)
      }
    },
    footer: context {
      let bib-query = query(bibliography)
      let in-bib = if bib-query.len() > 0 {
        here().page() >= bib-query.first().location().page()
      } else {
        false
      }

      if in-bib {
        // Bibliografía: solo número de página
        line(length: 100%)
        align(right, text(size: 0.85em)[#counter(page).display()])
      } else if is-first-page-of-section() {
        // Primera página de capítulo: solo número de página centrado
        align(center, text(size: 0.85em)[#counter(page).display()])
      } else {
        // hydra() no funciona en footer; se usa query() para obtener el capítulo activo
        let chapters = query(heading.where(level: 1))
        let current-chapter = chapters.rev().find(h => h.location().page() <= here().page())
        line(length: 100%)
        if current-chapter != none {
          let nums = counter(heading).at(current-chapter.location())
          grid(
            columns: (1fr, auto),
            text(size: 0.85em, tracking: 0.5pt)[
              #if nums.len() > 0 and nums.at(0) > 0 {
                // "--" = sin etiqueta (coherente con cabecera-capitulo-estilo03)
                if nombre-capitulo == "--" {
                  upper(current-chapter.body)
                } else {
                  upper([#nombre-capitulo #str(nums.at(0)). #current-chapter.body])
                }
              } else {
                upper(current-chapter.body)
              }
            ],
            text(size: 0.85em)[#counter(page).display()]
          )
        } else {
          align(right, text(size: 0.85em)[#counter(page).display()])
        }
      }
    }
  )


  
  set par(justify: true)
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
  )
  show math.equation: set text(font: mathfont)

  // Centrado de ecuaciones en bloque corrigiendo la indentación de listas.
  // page.margin no expone .left/.right cuando el margen es uniforme; se lee
  // directamente del parámetro `margin` de la función, que sí está en el closure.
  show math.equation.where(block: true): it => context {
    if centrar-matematicas {
      let ml = if type(margin) == dictionary {
        if "left" in margin { margin.left }
        else if "x" in margin { margin.x }
        else { 2.5cm }
      } else { margin }
      let mr = if type(margin) == dictionary {
        if "right" in margin { margin.right }
        else if "x" in margin { margin.x }
        else { 2.5cm }
      } else { margin }
      let sangria = here().position().x - ml  // indentación acumulada de la lista
      let ancho = page.width - ml - mr        // ancho total de la columna de texto
      // block(width: auto) hace que el bloque interior se ajuste al contenido,
      // evitando que \boxed{} u otros decoradores hereden el ancho del contenedor.
      // align(center, ...) centra ese bloque de ancho natural dentro de la columna.
      move(
        dx: -sangria,
        block(width: ancho, align(center, block(width: auto, it)))
      )
    } else {
      it
    }
  }
  // numerar-secciones-nivel1: controla si el nivel 1 lleva número.
  // "auto"  → se activa la supresión si nombre-capitulo == "--" (modo report)
  // "true"  → siempre numera nivel 1 (comportamiento clásico)
  // "false" → nunca numera nivel 1
  // NOTA: set/show dentro de un bloque if{} tienen scope local; por eso se usa
  // la forma condicional inline  `set heading(numbering: if ... { } else { })`
  // que sí opera al nivel del scope de la función y afecta a todo el documento.
  let _suprimir-n1 = (
    (numerar-secciones-nivel1 == "auto" and str(nombre-capitulo) == "--") or
    numerar-secciones-nivel1 == "false"
  )
  set heading(numbering: if _suprimir-n1 { none } else { sectionnumbering })
  // Para los niveles 2-6, cuando se suprime nivel 1, usar numeración relativa:
  // los números del nivel 1 se eliminan del prefijo (n.slice(1)).
  show heading.where(level: 2): set heading(numbering: if _suprimir-n1 {
    (..nums) => { let n = nums.pos(); n.slice(1).map(str).join(".") + "." }
  } else { sectionnumbering })
  show heading.where(level: 3): set heading(numbering: if _suprimir-n1 {
    (..nums) => { let n = nums.pos(); n.slice(1).map(str).join(".") + "." }
  } else { sectionnumbering })
  show heading.where(level: 4): set heading(numbering: if _suprimir-n1 {
    (..nums) => { let n = nums.pos(); n.slice(1).map(str).join(".") + "." }
  } else { sectionnumbering })
  show heading.where(level: 5): set heading(numbering: if _suprimir-n1 {
    (..nums) => { let n = nums.pos(); n.slice(1).map(str).join(".") + "." }
  } else { sectionnumbering })
  show heading.where(level: 6): set heading(numbering: if _suprimir-n1 {
    (..nums) => { let n = nums.pos(); n.slice(1).map(str).join(".") + "." }
  } else { sectionnumbering })
  show heading: set text(weight: "semibold")

  // heading-highlight — fondo coloreado para secciones nivel 2 hasta max-level
  show heading: it => context {
    let max = heading-highlight-state.get()
    if max > 0 and it.level >= 2 and it.level <= max {
      let c = heading-highlight-color-state.get()
      let bg = if c == none or c == "none" { rgb("#e8f0fe") } else { rgb(c.replace("\\", "")) }
      let tc = heading-highlight-text-color-state.get()
      if tc != none and tc != "none" {
        set text(fill: rgb(tc.replace("\\", "")))
        block(fill: bg, width: 100%, inset: (x: 8pt, y: 4pt), radius: 3pt, it)
      } else {
        block(fill: bg, width: 100%, inset: (x: 8pt, y: 4pt), radius: 3pt, it)
      }
    } else {
      it
    }
  }

show raw.where(block: true): set block(
    fill: luma(245),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )


show raw.where(lang: "python", block: true): set block(
    //fill: rgb("#f3f051ff"), //luma(240),
    fill: rgb("#ffff473d"), //rgb("#678df56f"), //rgb("#FFFF47"),  rgb("#ffff473d") //rgb("#678CF5"),   rgb("#e8f0ff"),
    stroke: 0.4pt + black,
    width: 100%,
    inset: 8pt,
    radius: 4pt
)

/*
rgb("#f5f2f0")
stroke: (top: 1pt + rgb("#d1e3e1")),

*/

// color de fondo por defecto en los códigos de R en Quarto con typst: rgb("#F2F2F2")


show raw.where(lang: "r", block: true): set block(
    //fill: luma(240),
    fill: rgb("#1b50ab1f"),   // #1B51AB, // #eef6ff
    //stroke: 0.4pt + luma(250), //rgb("#f3f051ff"), //black,
    stroke: 0.4pt + rgb("#1B51AB"),   // luma(250), //rgb("#f3f051ff"), //black,
    width: 100%,
    inset: 8pt,
    radius: 4pt
)

show raw.where(lang: "markdown", block: true): set block(
    fill: rgb("#d1e3e155"), // luma(240),
    //fill: rgb("#1b50ab1f"),   // #1B51AB, // #eef6ff
    //stroke: 0.4pt + luma(250), //rgb("#f3f051ff"), //black,
    //stroke: 0.4pt + rgb("#1B51AB"),   // luma(250), //rgb("#f3f051ff"), //black,
    width: 100%,
    inset: 8pt,
    radius: 4pt
)


show raw.where(lang: none, block: true): set block(
    fill: luma(250),
    //stroke: 0.4pt + black,
    stroke: (top: 1pt + rgb("#d1e3e1"), bottom: 1pt + rgb("#d1e3e1")),
    width: 100%,
    inset: 8pt,
    radius: 4pt
)


show heading.where(level: 1): it => {
  
 if is-first-page-of-bibliography() {
   pagebreak(weak: true)
   text(size: 1.5em)[#referencias-nombre]
 } else { 

  let estilo = cabecera-capitulo-state.get() // Leemos el estado global

if estilo == "estilo01" {    


  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    pagebreak(weak: true)
    cabecera-capitulo-estilo01(it, nums, nombre-capitulo)   
    
  } else {
    it
  }

} else if estilo == "estilo02" {

  let number = counter(heading).at(it.location())
  if number.len() > 0 and number.at(0) > 0 {
    pagebreak(weak: true)
    cabecera-capitulo-estilo02(it, number, nombre-capitulo)

  } else {
    it
  }

} else if estilo == "estilo03" {    

  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    pagebreak(weak: true)
    if nombre-capitulo == "--" {
      // Modo report: crear heading invisible para TOC, luego mostrar contenido personalizado
      heading(level: 1, numbering: none, it.body)
      cabecera-capitulo-estilo03(it, nums, nombre-capitulo, author)
    } else {
      cabecera-capitulo-estilo03(it, nums, nombre-capitulo, author)
    }
    } else {
    it
    }

} else if estilo == "estilo04" {

  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    sidebar-activo-state.update(true)
    num-capitulo.update(nums.first())
    pagebreak(weak: true)
    cabecera-capitulo-estilo04(it, nums, nombre-capitulo)
  } else {
    it
  }

} else {

  let number = counter(heading).at(it.location())
  if number.len() > 0 and number.at(0) > 0 {
    pagebreak(weak: true)
    cabecera-capitulo-estilo01(it, number, nombre-capitulo)

  } else {
    it
  }
}

 }


}


  show figure.caption: it => context [
    #set text(size: 0.9em)
    #if it.supplement == [Figure] {
      set align(left)
      text(weight: "semibold")[#it.supplement #it.counter.display(it.numbering): ]
      it.body
    } else {
      text(weight: "semibold")[#it.supplement #it.counter.display(it.numbering): ]
      it.body
    }

  ]



  set bibliography(full: {bibliografia-completa == "true"} , title: [#referencias-nombre])


  
if portada {

// Portada A

page(margin: 2cm, header: none, footer: none,
[

#set text(font: "Libertinus Serif", lang: "es")

#align(center)[
  // Logo de la universidad
  #v(0.5cm)
  //#image("logo.png", width: 7cm)
  #if logo != none {
    image(logo, width: 7cm)
  } else {
    // Si no hay logo, mostramos un espacio vacío
    v(0.5cm)
  }
  //#image(logo, width: 7cm)
  
  #v(1cm)
  
  // Grado
  #text(size: 18pt, weight: "bold")[
    #titulacion //Grado en Matemáticas y Estadística
  ]
  #if facultad != none and facultad.trim() != "" {
    linebreak()
    text(size: 14pt)[
      #facultad
    ]
  }
  #if universidad != none and universidad.trim() != "" {
    linebreak()
    text(size: 12pt)[
      #universidad
    ]
  }
  
  #v(1.2cm)
  
  // Línea decorativa superior
  #line(length: 60%, stroke: 2pt + black)
  
  #v(0.2cm)
  
  // Trabajo fin de estudios
  #text(size: 16pt, weight: "bold")[
    #tipo-TFG //TRABAJO FIN DE GRADO
  ]
  
  #v(0.2cm)
  
  // Línea decorativa inferior
  #line(length: 60%, stroke: 2pt + black)
  
  #v(0.3cm)
  
  // Título del trabajo
  #text(size: 26pt, style: "italic", weight: "bold")[    
    #title
  ]
  
  #v(0.3cm)
  
  // Línea decorativa final
  #line(length: 80%, stroke: 1pt + black)
  
  #v(0.5cm)
  
  // Autor
  #text(size: 20pt, weight: "bold")[
    #author 
  ]
  
  #v(0.3cm)
  
  // Lugar y fecha
  #text(size: 16pt)[
    #fecha-TFG //Sevilla, Octubre de 2023
  ]

  #v(0.2cm)

  // Tutor
  #if tutor-TFG != none {
    text(size: 14pt)[
      #tutor-TFG //Tutor: Dr. Juan Pérez García
    ]
  }
]
]
)

}



  if toc {
    
    page(header: none,
    [
      #heading(numbering: none)[Índice de Contenidos]

      #v(0.3cm)

      #show outline.entry.where(level: 1): it => {
        v(10pt, weak: true)
        strong(it)
        v(6pt, weak: true)
      }
    

      #outline(
        title: none,
        depth: none,
      );
    ])
  }



if tofiguras {

// ==================== ÍNDICE DE FIGURAS ====================
page(header: none, 
[
  #heading(numbering: none)[Índice de Figuras]
  
  #v(0.3cm)
  
  #outline(
    title: "",
    target: figure.where(kind: "quarto-float-fig"), //figure //figure.where(kind: image)
  )
])

}


// DEBUG: Mostrar valor y tipo
// text([Valor de totablas: #repr(totablas)])
// h(3em)
// text([Tipo de totablas: #type(totablas)])

// #let debug(label, value) = [
//   *DEBUG [#label]:* #repr(value) (tipo: #type(value)) \
// ]
// 
// #let my-dict = (name: "Juan", age: 25)
// #let my-content = [Hola mundo]
// 
// #debug("mi diccionario", my-dict)
// #debug("mi contenido", my-content)
// #debug("tipo función", debug)



if totablas {

// ==================== ÍNDICE DE TABLAS ====================
page(header: none, 
[
  #heading(numbering: none)[Índice de Tablas]
  
  #v(0.3cm)
  
  #outline(
    title: "",
    target: figure.where(kind: "quarto-float-tbl"), //kind: table
  )
])


}



if agradecimientos != none {

// ==================== AGRADECIMIENTOS ====================
page(
  header: none,
    [
     // Agradecimientos - aparecerá en el índice sin numeración
     #heading(numbering: none)[Agradecimientos]
 
  // #align(center)[
  //   #text(size: 20pt, weight: "bold")[Agradecimientos]
  // ]
  
  #v(1cm)
   
  #text()[#agradecimientos]

])

}



if resumen != none {

// ==================== RESUMEN EN ESPAÑOL ====================
page(
  header: none,
[
  // #align(center)[
  //   #text(size: 20pt, weight: "bold")[Resumen]
  // ]

  #heading(numbering: none)[Resumen]

  
  #v(1cm)
   
  #text()[#resumen]
  
  #v(1cm)
  
  #if palabras-clave != none {
    text(weight: "semibold", size: 0.9em)[\ Palabras clave:]
    h(0.5em)
    text()[#palabras-clave]
 }

])

}





if abstract != none {

// ==================== RESUMEN EN INGLÉS ====================
page(
  header: none,
[
  // #align(center)[
  //   #text(size: 20pt, weight: "bold")[Abstract]
  // ]

  #heading(numbering: none)[Abstract]
  
  #v(1cm)
  
  #text()[#abstract]
  
  #v(1cm)
  
  #if keywords != none {
    text(weight: "semibold", size: 0.9em)[\ Keywords:]
    h(0.5em)
    text()[#keywords]
 }

])

}





// Reiniciar numeración de páginas
counter(page).update(1)

  set page(
    paper: paper,
    margin: margin,
    //numbering: pagenumbering,
    numbering: "1",
    background: context {
      if cabecera-capitulo-state.get() == "estilo04" and sidebar-activo-state.get() {
        // No mostrar sidebar en la página de bibliografía
        if not is-first-page-of-bibliography() {
          let mostrar = sidebar-show-state.get() == "all" or is-first-page-of-section()
          if mostrar {
            let en-apendice = apendice-activo-state.get()
            let etiqueta = if en-apendice { apendice-nombre-state.get() } else { "CAPÍTULO" }
            let num = num-capitulo.get()
            dibujar-sidebar(
              1.4cm,
              sidebar-c1-state.get(),
              sidebar-c2-state.get(),
              etiqueta,
              if en-apendice { numbering("A", num) } else { num },
               dx: sidebar-dx-state.get(),
            )
          }
        }
      }
      dibujar-watermark-brand()
    },
  )




  // Configuración de capítulos con TOC automático
  show heading.where(level: 1): it => {
    // Mostrar el heading normal
    it
    
    if toccapitulos {
    // Añadir TOC del capítulo
       chapter-contents()
    }
  }

  // Show rule para teoremas/definiciones con estilo modern
  // (las show rules se definen al final del fichero, fuera de article)

  doc
   
}


#let appendix(content) = {
  // Lógica para contar apéndices automáticamente.
  
  let tportada = context [#apendice-portada-state.get()]
  let apendice-nombre = context [#apendice-nombre-state.get()]
  

  context {
    // 1. Localizamos el punto donde empieza la sección de apéndices.
    let appendix-start = here()
    // 2. Buscamos todos los encabezados de nivel 1 en el documento.
    let headings = query(heading.where(level: 1))
    // 3. Filtramos para quedarnos solo con los que están después del inicio de los apéndices.
    let appendix-headings = headings.filter(h => h.location().page() >= appendix-start.page())
    // 4. Actualizamos el estado global con el número de apéndices encontrados.
    appendix-count-state.update(appendix-headings.len())
  
    

  }


{  // Página divisoria de apéndices, entre llaves para aislar el contexto
      set page(header: [], footer: none, background: none)

      // Centrar verticalmente el texto
      place(center + horizon)[
        #set text(size: 30pt, weight: "bold")
        //APÉNDICE
         #tportada

      ]
}
  // Reset Numbering
  set heading(numbering: "A.1.1")
  counter(heading).update(0)
  counter(figure.where(kind: "quarto-float-fig")).update(0)
  counter(figure.where(kind: "quarto-float-tbl")).update(0)

  // Figure & Table Numbering
  set figure(
    numbering: it => {
      [A.#it]
    },
  )

  
  pagebreak()
  
  

show heading.where(level: 1): it => {

    let bib-query = query(bibliography)
    let in-bib = if bib-query.len() > 0 {
      here().page() >= bib-query.first().location().page()
    } else {
      false
    }

    if in-bib {
      if here().page() > bib-query.first().location().page() {
        align(right, emph([#referencias-nombre]))
        line(length: 100%)
      } else {
        return (it)
      }
    }  


let estilo = cabecera-capitulo-state.get() // Leemos el estado global


if estilo == "estilo01" {    

  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    pagebreak(weak: true)
    
    cabecera-apendice-estilo01(it, nums, apendice-nombre)
    // 
  } else {
    it
  }

} else if estilo == "estilo02" {

  let number = counter(heading).at(it.location())
  if number.len() > 0 and number.at(0) > 0 {
    pagebreak(weak: true)

    cabecera-apendice-estilo02(it, number, apendice-nombre)
 
  } else {
    it
  }

} else if estilo == "estilo03" {

  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    pagebreak(weak: true)    
    cabecera-apendice-estilo03(it, nums, apendice-nombre)
  } else {
    it
  }

} else if estilo == "estilo04" {

  let nums = counter(heading).at(it.location())
  if nums.len() > 0 and nums.at(0) > 0 {
    apendice-activo-state.update(true)
    num-capitulo.update(nums.at(0))
    pagebreak(weak: true)
    cabecera-apendice-estilo04(it, nums, apendice-nombre)
  } else {
    it
  }

} else {

  let number = counter(heading).at(it.location())
  if number.len() > 0 and number.at(0) > 0 {
    pagebreak(weak: true)
    cabecera-apendice-estilo01(it, number, apendice-nombre)
  } else {
    it
  }
}

 }


// Configuración de capítulos con TOC automático
  show heading.where(level: 1): it => {
    // Mostrar el heading normal
    it

    //debug2("toccapitulos", [#toccapitulos])
    //debug("toccapitulos", toccapitulos-state.get())
    //debug2("toccapitulos", context [#toccapitulos-state.get()])

    if toccapitulos-state.get() {
    // Añadir TOC del capítulo
       chapter-contents()
    }
  }



  content
}


