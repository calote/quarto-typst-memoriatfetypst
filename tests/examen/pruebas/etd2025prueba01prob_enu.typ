// Simple numbering for non-book documents
#let equation-numbering = "(1)"
#let callout-numbering = "1"
#let subfloat-numbering(n-super, subfloat-idx) = {
  numbering("1a", n-super, subfloat-idx)
}

// Theorem configuration for theorion
// Simple numbering for non-book documents (no heading inheritance)
#let theorem-inherited-levels = 0

// Theorem numbering format (can be overridden by extensions for appendix support)
// This function returns the numbering pattern to use
#let theorem-numbering(loc) = "1.1"

// Default theorem render function
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
// Some definitions presupposed by pandoc's typst output.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let fields = old_block.fields()
  let _ = fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => {
          let subfloat-idx = quartosubfloatcounter.get().first() + 1
          subfloat-numbering(n-super, subfloat-idx)
        })
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => block({
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          })

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)  // no icon: title at index 0
  } else {
    children.at(1)  // with icon: title at index 1
  }

  // TODO use custom separator if available
  // Use the figure's counter display which handles chapter-based numbering
  // (when numbering is a function that includes the heading counter)
  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#kind #callout_num]
  } else {
    [#kind #callout_num: #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      if children.len() == 1 {
        new_title  // no icon: just the title
      } else {
        children.at(0) + new_title  // with icon: preserve icon block + new title
      }))

  align(left, block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1)))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt)[#if icon != none [#text(icon_color, weight: 900)[#icon] ]#title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#import "@preview/tablex:0.0.9": tablex, cellx, rowspanx, colspanx
//#import "@preview/cetz:0.2.2": util
#import "@preview/dice:1.0.0"   // https://typst.app/universe/package/dice

// Importar sistema de traducciones
//#import "_extensions/calote/examtypst/i18n.typ": t, traducciones

// ============================================
// SISTEMA DE INTERNACIONALIZACIÓN
// ============================================

#let traducciones = (
  es: (
    ejercicio: "Ejercicio",
    problema: "Problema",
    pregunta: "Pregunta",
    solucion: "Solución",
    puntos: "puntos",
    punto: "punto",
    nombre: "Nombre",
    apellidos: "Apellidos",
    dni: "DNI/NIF",
    grupo: "Grupo",
    fecha: "Fecha",
    calificacion: "Calificación",
    total: "Total",
    verdadero: "V",
    falso: "F",
    pagina: "Página",
    de: "de",
  ),
  
  en: (
    ejercicio: "Exercise",
    problema: "Problem",
    pregunta: "Question",
    solucion: "Solution",
    puntos: "points",
    punto: "point",
    nombre: "Name",
    apellidos: "Surname",
    dni: "ID",
    grupo: "Group",
    fecha: "Date",
    calificacion: "Grade",
    total: "Total",
    verdadero: "T",
    falso: "F",
    pagina: "Page",
    de: "of",
  ),
  
  fr: (
    ejercicio: "Exercice",
    problema: "Problème",
    pregunta: "Question",
    solucion: "Solution",
    puntos: "points",
    punto: "point",
    nombre: "Nom",
    apellidos: "Prénom",
    dni: "ID",
    grupo: "Groupe",
    fecha: "Date",
    calificacion: "Note",
    total: "Total",
    verdadero: "V",
    falso: "F",
    pagina: "Page",
    de: "de",
  ),
  
  de: (
    ejercicio: "Übung",
    problema: "Problem",
    pregunta: "Frage",
    solucion: "Lösung",
    puntos: "Punkte",
    punto: "Punkt",
    nombre: "Name",
    apellidos: "Nachname",
    dni: "Ausweis",
    grupo: "Gruppe",
    fecha: "Datum",
    calificacion: "Note",
    total: "Gesamt",
    verdadero: "W",
    falso: "F",
    pagina: "Seite",
    de: "von",
  ),
  
  pt: (
    ejercicio: "Exercício",
    problema: "Problema",
    pregunta: "Pergunta",
    solucion: "Solução",
    puntos: "pontos",
    punto: "ponto",
    nombre: "Nome",
    apellidos: "Sobrenome",
    dni: "ID",
    grupo: "Grupo",
    fecha: "Data",
    calificacion: "Nota",
    total: "Total",
    verdadero: "V",
    falso: "F",
    pagina: "Página",
    de: "de",
  ),
)

// Función para obtener traducciones
#let t(key, lang: "es") = {
  if lang in traducciones {
    if key in traducciones.at(lang) {
      return traducciones.at(lang).at(key)
    }
  }
  // Fallback a español
  return traducciones.es.at(key, default: key)
}

// ============================================
// VARIABLES DEL DOCUMENTO
// ============================================

// #let department = ""
// #let subject = ""
// #let degree = ""
// #let exam-type = ""
// #let exam-date = ""
// #let show-solutions = "false" == "true"
// #let show-ejercicio-cuadro = "" == "true"
// #let show-cabecera = "true" == "true"
// #let show-student-data = "false" == "true"
// #let lang = "es"

// Nombre del ejercicio con soporte i18n
// #let ejercicio-nombre = "ejercicio"

// Por esta versión corregida:
// #let additional-fields = ()


// Variables del documento con soporte bilingüe (español tiene prioridad)
#let department = "Departamento de Estadística e Investigación Operativa"
#let subject = "Teoría de la Decisión"
#let degree = "Grado en Estadística"
#let exam-type = "1ª Prueba Evaluación Continua"
#let exam-date = "6 de Noviembre de 2025"
#let show-solutions = "false" == "true"
#let show-ejercicio-cuadro = "false" == "true"
//#let show-cabecera = "true" == "true"
//#let show-cabecera = "true" == "false"
// ...existing code...
#let show-cabecera = "true" == "true"
// ...existing code...
// ...existing code...
#let show-student-data = "true" == "true"
#let lang = "es"

// Ejercicio nombre con soporte bilingüe (español tiene prioridad)
//#let ejercicio-nombre = "ejercicio"
#let ejercicio-nombre = "ejercicio"  //"ejercicio"

// Additional fields con soporte bilingüe (español tiene prioridad)
//#let additional-fields = ()

// Variables del documento - versión corregida para additional-fields
#let additional-fields-str = ""

// Función auxiliar mejorada para parsear campos adicionales
#let parse-additional-fields(fields-str) = {
  if fields-str == "" or fields-str == "()" {
    ()
  } else {
    // Separar por el delimitador | y filtrar elementos vacíos
    fields-str.split("|").filter(field => field.trim() != "")
  }
}

// Añadir junto a las otras variables
#let ejercicio-salto-linea = "false" == "true"


// ============================================
// SISTEMA DE CONTADORES GENÉRICO
// ============================================

// Función para generar etiquetas automáticas
#let generar-etiqueta(numero, tipo: "letra") = {
  if tipo == "letra" {
    // Convertir número a letra (a, b, c, ...)
    str.from-unicode(96 + numero) // 97 es 'a' en ASCII
  } else if tipo == "numero" {
    // Usar números (1, 2, 3, ...)
    str(numero)
  } else if tipo == "romano" {
    // Números romanos en minúscula (i, ii, iii, ...)
    numbering("i", numero)
  } else if tipo == "LETRA" {
    // Letras mayúsculas (A, B, C, ...)
    str.from-unicode(64 + numero) // 65 es 'A' en ASCII
  } else if tipo == "ROMANO" {
    // Números romanos en mayúscula (I, II, III, ...)
    numbering("I", numero)
  } else {
    // Por defecto, usar punto
    "•"
  }
}

// Función para aplicar contador automático
#let aplicar-contador(contador, tipo: "letra", formato: auto, custom-label: auto) = {
  if custom-label != auto {
    // Si se proporciona etiqueta personalizada
    return custom-label
  } else {
    // Generar etiqueta automática
    contador.step()
    context {
      let n = contador.get().first()
      if formato == auto {
        return generar-etiqueta(n, tipo: tipo)
      } else {
        // Permitir formato personalizado
        return formato(n)
      }
    }
  }
}

// Contador para apartados
#let contador-apartados = counter("apartado")

// Función para reiniciar el contador de apartados
#let reiniciar-apartados() = {
  contador-apartados.update(0)
}

// Añadir un contador para preguntas verdadero-falso
#let contador-vf = counter("verdadero-falso")

// Función para reiniciar el contador de verdadero-falso
#let reiniciar-vf() = {
  contador-vf.update(0)
}


// ============================================
// SISTEMA DE TEMAS
// ============================================

// Temas predefinidos
#let temas-predefinidos = (
  classic: (
    primary: rgb("#8B0000"),
    secondary: rgb("#007acc"),
    background: rgb("#f8f9fa"),
    solution-bg: rgb("#e6f3ff"),
    solution-border: rgb("#007acc"),
    ejercicio-border: gray,
    text-color: black,
    header-color: gray,
  ),
  modern: (
    primary: rgb("#2563eb"),
    secondary: rgb("#7c3aed"),
    background: rgb("#f1f5f9"),
    solution-bg: rgb("#ddd6fe"),
    solution-border: rgb("#7c3aed"),
    ejercicio-border: rgb("#2563eb"),
    text-color: rgb("#0f172a"),
    header-color: rgb("#475569"),
  ),
  green: (
    primary: rgb("#059669"),
    secondary: rgb("#0891b2"),
    background: rgb("#f0fdf4"),
    solution-bg: rgb("#cffafe"),
    solution-border: rgb("#0891b2"),
    ejercicio-border: rgb("#059669"),
    text-color: rgb("#064e3b"),
    header-color: rgb("#047857"),
  ),
  purple: (
    primary: rgb("#7c3aed"),
    secondary: rgb("#ec4899"),
    background: rgb("#faf5ff"),
    solution-bg: rgb("#fce7f3"),
    solution-border: rgb("#ec4899"),
    ejercicio-border: rgb("#7c3aed"),
    text-color: rgb("#581c87"),
    header-color: rgb("#6b21a8"),
  ),
  dark: (
    primary: rgb("#f97316"),
    secondary: rgb("#eab308"),
    background: rgb("#27272a"),
    solution-bg: rgb("#3f3f46"),
    solution-border: rgb("#eab308"),
    ejercicio-border: rgb("#f97316"),
    text-color: rgb("#fafafa"),
    header-color: rgb("#a1a1aa"),
  )
)

// Tema actual (cargar predefinido o personalizado)
#let theme = temas-predefinidos.at("classic")

// ============================================
// UTILIDADES
// ============================================

// Salto de línea manual
#let Mnewline = {
  linebreak()
}

// Caja para respuestas
#let MBox(width: 10em, height: 1.5em, stroke: black, baseline: 60%, hspace: 1fr) = {
  h(hspace) 
  box(baseline: baseline, rect(width: width, height: height, stroke: stroke))
} 

// ============================================
// CABECERA DEL DOCUMENTO
// ============================================

// #let make-title() = {
//   v(-2em)
//   tablex(
//     columns: (60pt, 10pt, 1fr),
//     rows: 1,
//     stroke: none,
//     gap: 0pt,
//     [
//       #align(left + horizon)[
//         #image("", width: 60pt)
//       ]
//     ],
//     [],
//     [
//       #align(center + horizon)[
//         #text(size: 12pt, weight: "bold", fill: theme.text-color)[#department]
//         #linebreak()
//         #text(size: 12pt, weight: "bold", fill: theme.text-color)[#subject]
//         #linebreak()
//         #text(size: 12pt, weight: "bold", fill: theme.text-color)[#degree]
//         #linebreak()
//         #text(size: 12pt, weight: "bold", fill: theme.text-color)[#exam-type - #exam-date]
//         #v(0.4em)
//         #line(length: 80%, stroke: theme.primary)
//       ]
//     ]
//   )
// }

// #let make-title(fontsize-header: 12pt) = {
//   v(-2em)
//   tablex(
//     columns: (60pt, 10pt, 1fr),
//     rows: 1,
//     stroke: none,
//     gap: 0pt,
//     [
//       #align(left + horizon)[
//         #image("", width: 60pt)
//       ]
//     ],
//     [],
//     [
//       #align(center + horizon)[
//         #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#department]
//         #linebreak()
//         #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#degree]
//         #linebreak()
//         #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#subject]
//         #linebreak()
        
//         // Construir la línea del examen de forma condicional
//         #if exam-type != "" and exam-date != "" {
//           v(-0.6em)
//           text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type - #exam-date]
//         } else if exam-type != "" and exam-date == "" {
//           v(-0.6em)
//           text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type]
//         } else if exam-type == "" and exam-date != "" {
//           v(-0.6em)
//           text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-date]
//         }
        
//         #v(0.4em)
//         #line(length: 80%, stroke: theme.primary)
//       ]
//     ]
//   )
// }



// ...existing code...
#let logo = "logo.png"
// ...existing code...

#let make-title(fontsize-header: 12pt) = {
  v(-2em)
  let has-logo = logo != ""
  if has-logo {
    tablex(
      columns: (60pt, 10pt, 1fr),
      rows: 1,
      stroke: none,
      gap: 0pt,
      [
        #align(left + horizon)[
          #image(logo, width: 60pt)
        ]
      ],
      [],
      [
        #align(center + horizon)[
          #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#department]
          #linebreak()
          #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#degree]
          #linebreak()
          #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#subject]
          #linebreak()
          #if exam-type != "" and exam-date != "" {
            v(-0.6em)
            text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type - #exam-date]
          } else if exam-type != "" {
            v(-0.6em)
            text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type]
          } else if exam-date != "" {
            v(-0.6em)
            text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-date]
          }
          #v(0.4em)
          #line(length: 80%, stroke: theme.primary)
        ]
      ]
    )
  } else {
    align(center + horizon)[
      #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#department]
      #linebreak()
      #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#degree]
      #linebreak()
      #text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#subject]
      #linebreak()
      #if exam-type != "" and exam-date != "" {
        v(-0.6em)
        text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type - #exam-date]
      } else if exam-type != "" {
        v(-0.6em)
        text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-type]
      } else if exam-date != "" {
        v(-0.6em)
        text(size: fontsize-header, weight: "bold", fill: theme.text-color)[#exam-date]
      }
      #v(0.4em)
      #line(length: 80%, stroke: theme.primary)
    ]
  }
}
// ...existing code...




// // Función auxiliar para parsear campos adicionales
// #let parse-additional-fields(fields-array) = {
//   if fields-array == () {
//     ()
//   } else {
//     fields-array
//   }
// }

// Función auxiliar para crear un spacer invisible con altura consistente
#let invisible-spacer(baseline: -0.8em) = {
  text(baseline: baseline, weight: "bold", fill: rgb(0, 0, 0, 0), size: 11pt)[X]
}

// Cabecera con datos del estudiante - versión con spacer
#let make-title-with-student(extra-fields: (), fontsize-header: 12pt) = {
  make-title(fontsize-header: fontsize-header)
  let baselinea = -0.8em

  v(1em)
  
  // Campos obligatorios
  grid(
    columns: (auto, 1fr, auto, 2fr),
    column-gutter: 1em,
    row-gutter: 1.5em,
    text(baseline: baselinea, weight: "bold", fill: theme.text-color)[#t("nombre", lang: lang):], 
    line(length: 100%, stroke: theme.text-color),
    text(baseline: baselinea, weight: "bold", fill: theme.text-color)[#t("apellidos", lang: lang):], 
    line(length: 100%, stroke: theme.text-color),
  )
  
  // Campos adicionales
  if extra-fields.len() > 0 {
    v(1em)
    
    let num-fields = extra-fields.len()
    
    if num-fields <= 3 {
      let columns = if num-fields == 1 {
        (auto, 1fr)
      } else if num-fields == 2 {
        (auto, 1fr, auto, 1fr)
      } else {
        //(auto, 1fr)
        (auto, 1fr, auto, 1fr)
        //(auto, 1fr, auto, 1fr, auto, 1fr)
      }
      
      let grid-content = ()
      for field in extra-fields {
        if field == "" or field == "-" {
          grid-content.push(invisible-spacer(baseline: baselinea))
        } else {
          grid-content.push(
            text(baseline: baselinea, weight: "bold", fill: theme.text-color)[#field:]
          )
        }
        grid-content.push(line(length: 100%, stroke: theme.text-color))
      }
      
      grid(
        columns: columns,
        column-gutter: 1em,
        row-gutter: 1.5em,
        ..grid-content
      )
    } else {
      // Layout vertical con spacer consistente
      for field in extra-fields {
        grid(
          columns: (auto, 1fr),
          column-gutter: 1em,
          row-gutter: 1.5em,
          if field == "" or field == "-" { invisible-spacer(baseline: baselinea) } else { 
            text(baseline: baselinea, weight: "bold", fill: theme.text-color)[#field:]
          }, 
          line(length: 100%, stroke: theme.text-color),
        )
        v(0.5em)
      }
    }
  }
  
  v(1em)
}


// ============================================
// CONTADORES
// ============================================

#let contador-ejercicios = counter("ejercicio")
#contador-ejercicios.step()
// ============================================
// FUNCIONES PRINCIPALES
// ============================================

// // Función para ejercicios
// #let ejercicio(title: none, puntos: none, body) = {
//   reiniciar-apartados()
//   reiniciar-vf()
//   v(0.2em)
//   context {
//     contador-ejercicios.step()
//     let n = contador-ejercicios.get().first()
    
//     // Usar directamente la función de traducción aquí
//     let ejercicio-text = if ejercicio-nombre == "ejercicio" {
//       t("ejercicio", lang: "es")
//     } else {
//       ejercicio-nombre
//     }

//     let header = if title != none {
//       [#ejercicio-text: #n #title]
//     } else {
//       [#ejercicio-text #n]
//     }
    
//     if puntos != none {
//       let punto-text = if puntos == 1 {
//           t("punto", lang: "es")
//         } else {
//           t("puntos", lang: "es")
//         }
//       header = [#header (#puntos #punto-text)]
//     }
    
//     if show-ejercicio-cuadro { 
//       text(weight: "bold", size: 11pt, fill: theme.text-color)[#header]
      
//       block(
//         breakable: true,
//         width: 100%,
//         stroke: 1pt + theme.ejercicio-border,
//         inset: 10pt,
//         radius: 3pt,
//         fill: theme.background
//       // rect(
//       //   width: 100%,
//       //   stroke: 1pt + theme.ejercicio-border,
//       //   inset: 10pt,
//       //   radius: 3pt,
//       //   fill: theme.background
//       )[#text(fill: theme.text-color)[#body]]
//     } else { 
//       text(weight: "bold", size: 11pt, fill: theme.text-color)[#h(-1em) #header]
//       v(0.3em)
//       text(fill: theme.text-color)[#body]
//     }
//   }
//   v(0.5em)
// }

// Función para ejercicios
#let ejercicio(title: none, puntos: none, body) = {
  reiniciar-apartados()
  reiniciar-vf()
  v(0.2em)
  context {
    contador-ejercicios.step()
    let n = contador-ejercicios.get().first()
    
    // Usar directamente la función de traducción aquí
    let ejercicio-text = if ejercicio-nombre == "ejercicio" {
      t("ejercicio", lang: lang)
    } else {
      ejercicio-nombre
    }

    let header = if title != none {
      [#ejercicio-text #n. #title]
    } else {
      [#ejercicio-text #n.]
    }
    
    if puntos != none {
      let punto-text = if puntos == 1 {
          t("punto", lang: lang)
        } else {
          t("puntos", lang: lang)
        }
      header = [#header (#puntos #punto-text)]
    }
    
    if show-ejercicio-cuadro { 
      //text(weight: "bold", size: 11pt, fill: theme.text-color)[#header]
      
      //text(weight: "bold", fill: theme.text-color)[#header]
      
      block(
        breakable: true,
        width: 100%,
        stroke: 1pt + theme.ejercicio-border,
        inset: 10pt,
        radius: 3pt,
        fill: theme.background
      )[
        #text(weight: "bold", fill: theme.text-color)[#header]
        #if ejercicio-salto-linea {
          v(0.3em)
        }
        #text(fill: theme.text-color)[#body]
        ]
    } else { 
      // Controlar salto de línea según el parámetro
      if ejercicio-salto-linea {
        // Con salto de línea (comportamiento por defecto)
        //text(weight: "bold", size: 11pt, fill: theme.text-color)[#h(-1em) #header]
        text(weight: "bold", fill: theme.text-color)[#h(-1em) #header]
        v(0.3em)
        text(fill: theme.text-color)[#body]
      } else {
        // Sin salto de línea (mismo párrafo)
        //text(weight: "bold", size: 11pt, fill: theme.text-color)[#h(-1em) #header]
        text(weight: "bold", fill: theme.text-color)[#h(-1em) #header]
        text(fill: theme.text-color)[#h(0.5em) #body]
      }
    }
  }
  v(0.5em)
}

// Función para soluciones
#let solucion(body) = {
  
  if show-solutions {
    v(0.5em)
    //text(weight: "bold", size: 10pt, fill: theme.solution-border)[#t("solucion", lang: "es"):]
    text(weight: "bold", fill: theme.solution-border)[#t("solucion", lang: "es"):]
    v(0.3em)
    
    block(
      breakable: true,
      width: 100%,
      stroke: 1pt + theme.solution-border,
      inset: 8pt,
      radius: 3pt,
      fill: theme.solution-bg
    )[
    // rect(
    //   width: 100%,
    //   stroke: 1pt + theme.solution-border,
    //   inset: 8pt,
    //   radius: 3pt,
    //   fill: theme.solution-bg
    // )[
      //#text(size: 9pt, fill: theme.text-color)[#body]
      #text(fill: theme.text-color)[#body]
    ]
    v(0.5em)
  }
}

// // Función para apartados
// #let apartado(letra: auto, body) = {
//   h(1em)
//   if letra == auto {
//     text(fill: theme.text-color)[• #body]
//   } else {
//     text(weight: "bold", fill: theme.text-color)[#letra) ] + text(fill: theme.text-color)[#body]
//   }
//   v(0.3em)
// }



// // Función para apartados con numeración automática
// #let apartado(letra: auto, tipo: "letra", body) = {
//   h(1em)
  
//   if letra == auto {
//     contador-apartados.step()
//     context {
//       let n = contador-apartados.get().first()
      
//       let etiqueta = if tipo == "letra" {
//         // Convertir número a letra (a, b, c, ...)
//         str.from-unicode(96 + n) // 97 es 'a' en ASCII
//       } else if tipo == "numero" {
//         // Usar números (1, 2, 3, ...)
//         str(n)
//       } else if tipo == "romano" {
//         // Números romanos en minúscula (i, ii, iii, ...)
//         numbering("i", n)
//       } else if tipo == "LETRA" {
//         // Letras mayúsculas (A, B, C, ...)
//         str.from-unicode(64 + n) // 65 es 'A' en ASCII
//       } else {
//         // Por defecto, usar punto
//         "•"
//       }
      
//       if tipo == "punto" {
//         text(fill: theme.text-color)[• #body]
//       } else {
//         text(weight: "bold", fill: theme.text-color)[#etiqueta) ] + text(fill: theme.text-color)[#body]
//       }
//     }
//   } else {
//     // Si se proporciona una letra/número específico
//     text(weight: "bold", fill: theme.text-color)[#letra) ] + text(fill: theme.text-color)[#body]
//   }
//   v(0.3em)
// }

// // Función para apartados con contador genérico
// #let apartado(letra: auto, tipo: "letra", body) = {
//   h(1em)
  
//   let etiqueta = aplicar-contador(
//     contador-apartados, 
//     tipo: tipo, 
//     custom-label: letra
//   )
  
//   context {
//     if tipo == "punto" or etiqueta == "•" {
//       text(fill: theme.text-color)[• #body]
//     } else {
//       text(weight: "bold", fill: theme.text-color)[#etiqueta) ] + text(fill: theme.text-color)[#body]
//     }
//   }
//   v(0.3em)
// }

// ...existing code...

// Función para apartados con contador genérico y puntos
#let apartado(letra: auto, tipo: "letra", puntos: none, body) = {
  h(1em)
  
  let etiqueta = aplicar-contador(
    contador-apartados, 
    tipo: tipo, 
    custom-label: letra
  )
  
  context {
    let contenido = if tipo == "punto" or etiqueta == "•" {
      text(fill: theme.text-color)[• #body]
    } else {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
      if puntos != none {
        let punto-text = if puntos == 1 {
          t("punto", lang: lang)
        } else {
          t("puntos", lang: lang)
        }
        text(fill: theme.text-color)[(#puntos #punto-text) ]
      }
      text(fill: theme.text-color)[#body]
    }
    contenido
  }
  v(0.3em)
}

// ...existing code...

// Función para caja de respuesta simple
#let respuesta(height: 3em, body) = {
  v(-0.5em)
  rect(
    width: 100%,
    height: height,
    stroke: 1pt + theme.text-color,
    inset: 5pt
  )[]
  v(0.2em)
}

// Función para tabla de respuestas
#let tabla-respuestas(rows: 3, cols: 2, cell-height: 2em, cell-width: 2em) = {
  v(0.5em)
  
  let cells = ()
  for i in range(rows * cols) {
    cells.push(
      cellx(
        inset: 5pt
      )[
        #rect(
          height: cell-height,
          width: cell-width,
          stroke: 1pt + theme.text-color
        )[]
      ]
    )
  }
  
  tablex(
    columns: cols,
    rows: rows,
    stroke: none,
    ..cells
  )
  v(0.5em)
}


// Uso: `#MBox(width: 20em)`{=typst}
#let CajaNoCheck(width: 1em, height: 1em, stroke: black, baseline: 0%, hspace: 1em) = {
  h(hspace) 
  box(baseline: baseline, rect(width: width, height: height, stroke: 1pt + theme.text-color)[])
} 
#let CajaCheck(width: 1em, height: 1em, stroke: black, baseline: 0%, hspace: 1em) = {
  h(hspace)
  box(
    baseline: baseline,
    rect(
      width: width,
      height: height,
      stroke: 1pt + theme.text-color
    )[
      #align(center + horizon)[
        #text(size: 1em, fill: theme.text-color)[✓]
      ]
    ]
  )
}


// Función para preguntas de opción múltiple
// #let pregunta-multiple(
//   enunciado,
//   opciones: (),
//   correcta: none,
//   columnas: 1
// ) = {
//   text(fill: theme.text-color)[#enunciado]
//   v(0.3em)
  
//   if columnas == 1 {
//     for (i, opcion) in opciones.enumerate() {
//       h(1em)
//       if show-solutions and i == correcta {
//         text(fill: theme.solution-border, weight: "bold")[#CajaCheck()] 
//       } else {
//         text(fill: theme.text-color)[#CajaNoCheck()] 
//       }
//       text(fill: theme.text-color)[ #opcion]
//       linebreak()
//     }
//   } else {
//     grid(
//       columns: columnas,
//       column-gutter: 1em,
//       row-gutter: 0.7em,
//       ..opciones.enumerate().map(((i, opt)) => {
//         if show-solutions and i == correcta {
//           text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #opt]
//         } else {
//           text(fill: theme.text-color)[#CajaNoCheck() #opt]
//         }
//       })
//     )
//   }
//   v(0.5em)
// }


// ...existing code...

// // Función para preguntas de opción múltiple
// #let pregunta-multiple(
//   enunciado,
//   opciones: (),
//   correcta: none,
//   columnas: 1
// ) = {
//   text(fill: theme.text-color)[#enunciado]
//   v(0.3em)
  
//   // Convertir correcta a array si es un único valor
//   let correctas = if type(correcta) == array {
//     correcta
//   } else if correcta != none {
//     (correcta,)
//   } else {
//     ()
//   }
  
//   if columnas == 1 {
//     for (i, opcion) in opciones.enumerate() {
//       h(1em)
//       if show-solutions and (i + 1) in correctas {
//         text(fill: theme.solution-border, weight: "bold")[#CajaCheck()] 
//       } else {
//         text(fill: theme.text-color)[#CajaNoCheck()] 
//       }
//       text(fill: theme.text-color)[ #opcion]
//       linebreak()
//     }
//   } else {
//     grid(
//       columns: columnas,
//       column-gutter: 1em,
//       row-gutter: 0.7em,
//       ..opciones.enumerate().map(((i, opt)) => {
//         if show-solutions and (i + 1) in correctas {
//           text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #opt]
//         } else {
//           text(fill: theme.text-color)[#CajaNoCheck() #opt]
//         }
//       })
//     )
//   }
//   v(0.5em)
// }

// // ...existing code...

// // Función para preguntas de opción múltiple con numeración automática
// #let pregunta-multiple(
//   enunciado,
//   opciones: (),
//   correcta: none,
//   columnas: 1,
//   numeracion: false,
//   tipo-numeracion: "numero",
//   opciones-tipo: "LETRA"  // Nuevo parámetro para el tipo de las opciones
// ) = {
//   // Aplicar numeración de la pregunta si se solicita
//   if numeracion {
//     let etiqueta = aplicar-contador(
//       contador-vf, 
//       tipo: tipo-numeracion
//     )
//     context {
//       text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
//     }
//   }
  
//   text(fill: theme.text-color)[#enunciado]
//   v(0.3em)
  
//   // Convertir correcta a array si es un único valor
//   let correctas = if type(correcta) == array {
//     correcta
//   } else if correcta != none {
//     (correcta,)
//   } else {
//     ()
//   }
  
//   if columnas == 1 {
//     for (i, opcion) in opciones.enumerate() {
//       h(1em)
      
//       // Generar etiqueta para la opción
//       let opcion-etiqueta = generar-etiqueta(i + 1, tipo: opciones-tipo)
      
//       if show-solutions and (i + 1) in correctas {
//         text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #opcion]
//       } else {
//         text(fill: theme.text-color)[#CajaNoCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em)  #opcion]
//       }
//       linebreak()
//     }
//   } else {
//     grid(
//       columns: columnas,
//       column-gutter: 1em,
//       row-gutter: 0.7em,
//       ..opciones.enumerate().map(((i, opt)) => {
//         let opcion-etiqueta = generar-etiqueta(i + 1, tipo: opciones-tipo)
        
//         if show-solutions and (i + 1) in correctas {
//           text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #opt]
//         } else {
//           text(fill: theme.text-color)[#CajaNoCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #opt]
//         }
//       })
//     )
//   }
//   v(0.5em)
// }


// Función para preguntas de opción múltiple con numeración automática y orden aleatorio
#let pregunta-multiple(
  enunciado,
  opciones: (),
  correcta: none,
  columnas: 1,
  numeracion: false,
  tipo-numeracion: "numero",
  opciones-tipo: "LETRA",  // Tipo de las opciones
  aleatorio: false,        // Nuevo parámetro para orden aleatorio
  semilla: 1          // Semilla opcional para reproducibilidad
) = {
  // Aplicar numeración de la pregunta si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  v(0.3em)
  
  // Convertir correcta a array si es un único valor
  let correctas = if type(correcta) == array {
    correcta
  } else if correcta != none {
    (correcta,)
  } else {
    ()
  }
  
  // Preparar opciones y índices
  let opciones-con-indices = opciones.enumerate().map(((i, opt)) => (
    indice-original: i + 1,
    opcion: opt
  ))
  
  // Mezclar aleatoriamente si se solicita
  let opciones-finales = if aleatorio {
    // // Usar semilla si se proporciona para reproducibilidad
    //if semilla == "none" {
       //random.seed(semilla)
    //   let semilla = dice.randominit() 
    //}
    // opciones-con-indices.shuffle()
    // Usar shuffle del paquete cetz
    //util.shuffle(opciones-con-indices, seed: semilla)
    let (opciones-con-indices, semilla) = dice.shuffle(opciones-con-indices, seed: semilla)
    opciones-con-indices
    //opciones-con-indices.shuffle(seed: semilla)

  } else {
    opciones-con-indices
  }
  
  if columnas == 1 {
    for (i, item) in opciones-finales.enumerate() {
      h(1em)
      
      // Generar etiqueta para la opción mostrada
      let opcion-etiqueta = generar-etiqueta(i + 1, tipo: opciones-tipo)
      
      // Verificar si esta opción es correcta basándose en el índice original
      let es-correcta = item.indice-original in correctas
      
      if show-solutions and es-correcta {
        text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #item.opcion]
      } else {
        text(fill: theme.text-color)[#CajaNoCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #item.opcion]
      }
      linebreak()
    }
  } else {
    grid(
      columns: columnas,
      column-gutter: 1em,
      row-gutter: 0.7em,
      ..opciones-finales.enumerate().map(((i, item)) => {
        let opcion-etiqueta = generar-etiqueta(i + 1, tipo: opciones-tipo)
        let es-correcta = item.indice-original in correctas
        
        if show-solutions and es-correcta {
          text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #item.opcion]
        } else {
          text(fill: theme.text-color)[#CajaNoCheck() #h(0.5em) #opcion-etiqueta) #h(0.2em) #item.opcion]
        }
      })
    )
  }
  v(0.5em)
}


// Variable global para almacenar el tipo de opciones actual
#let opciones-tipo-mode = state("opciones-tipo-mode", "LETRA")

// Variable global para almacenar opciones en pregunta-multiple-md
#let opciones-temp = state("opciones-temp", ())
#let correctas-temp = state("correctas-temp", ())

// Función pregunta-multiple-md que acepta el body con #opc
#let pregunta-multiple-md(
  enunciado,
  correctas: "",
  columnas: 1,
  numeracion: false,
  tipo-numeracion: "numero",
  opciones-tipo: "LETRA",
  aleatorio: false,
  semilla: 1,
  mostrar-solucion: true,
  solucion: none,
  explicacion: none,
  dificultad: none,
  puntos: none,
  body
) = {
  // Actualizar el estado global del tipo de opciones
  opciones-tipo-mode.update(opciones-tipo)
  
  // Aplicar numeración de la pregunta si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  // Mostrar puntos si se especifica
  if puntos != none {
    text(weight: "bold", fill: theme.text-color)[(#puntos puntos) ]
  }
  
  // Parsear las opciones correctas
  let opciones-correctas = ()
  if correctas != "" {
    opciones-correctas = correctas.split(",").map(x => int(x.trim()))
  }
  
  // Mostrar el enunciado
  text(fill: theme.text-color)[#enunciado]
  v(0.3em)
  
  // Reiniciar contador de apartados
  contador-apartados.update(0)
  
  // El body contiene las opciones con #opc
  body
  
  // Mostrar solución si está activado y existe
  if show-solutions and mostrar-solucion and solucion != none {
    v(0.3em)
    block(
      fill: theme.solution-bg,
      stroke: theme.solution-border + 1pt,
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      [
        #text(weight: "bold", fill: theme.solution-border)[Solución: ]
        #text(fill: theme.text-color)[#solucion]
      ]
    )
  }
  
  // Mostrar explicación si está activada y existe
  if show-solutions and explicacion != none {
    v(0.3em)
    block(
      fill: theme.solution-bg.lighten(50%),
      stroke: theme.solution-border.lighten(30%) + 1pt,
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      [
        #text(weight: "bold", fill: theme.solution-border.darken(10%))[Explicación: ]
        #text(fill: theme.text-color)[#explicacion]
      ]
    )
  }
  
  v(0.5em)
}

// Función para cada opción (usada por Quarto)
#let opc(es-correcta: false, body) = {
  contador-apartados.step()
  
  context {
    let n = contador-apartados.get().first()
    let tipo-opc = opciones-tipo-mode.get()
    let etiqueta = generar-etiqueta(n, tipo: tipo-opc)
    
    let icono = if show-solutions and es-correcta {
      text(fill: theme.solution-border, weight: "bold")[#CajaCheck()]
    } else {
      text(fill: theme.text-color)[#CajaNoCheck()]
    }
    
    let color-texto = if show-solutions and es-correcta {
      theme.solution-border
    } else {
      theme.text-color
    }
    
    let peso = if show-solutions and es-correcta {
      "bold"
    } else {
      "regular"
    }
    
    // Grid de 3 columnas: checkbox | etiqueta | contenido
    grid(
      columns: (auto, auto, 1fr),  // auto, auto, resto del espacio
      column-gutter: 0.5em,
      align: (center, left, left),
      // Columna 1: Checkbox
      icono,
      // Columna 2: Etiqueta
      text(fill: color-texto, weight: peso)[#etiqueta)],
      // Columna 3: Contenido
      text(fill: color-texto, weight: peso)[#body]
    )
  }
  v(0.3em)  // Espacio vertical entre opciones
}

// // Función para cada opción (usada por Quarto)
// #let opc(es-correcta: false, body) = {
//   contador-apartados.step()
//   h(1em)
//   
//   context {
//     let n = contador-apartados.get().first()
//     let etiqueta = generar-etiqueta(n, tipo: "LETRA")
//     
//     if show-solutions and es-correcta {
//       text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #h(0.5em) #etiqueta) #h(0.2em)]
//       text(fill: theme.solution-border, weight: "bold")[#body]
//     } else {
//       text(fill: theme.text-color)[#CajaNoCheck() #h(0.5em) #etiqueta) #h(0.2em)]
//       text(fill: theme.text-color)[#body]
//     }
//   }
//   linebreak()
// }
// 



// // Función para verdadero/falso
// #let verdadero-falso(enunciado, correcta: none) = {
//   text(fill: theme.text-color)[#enunciado]
//   h(1em)
  
//   let v-text = t("verdadero", lang: "es")
//   let f-text = t("falso", lang: "es")
  

//   if show-solutions {
//     if correcta == true {
//       text(fill: theme.solution-border, weight: "bold")[☑ #v-text] + text(fill: theme.text-color)[ #CajaNoCheck() #f-text]
//     } else if correcta == false {
//       text(fill: theme.text-color)[#CajaNoCheck() #v-text] + text(fill: theme.solution-border, weight: "bold")[ #CajaCheck() #f-text]
//     } else {
//       text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
//     }
//   } else {
//     text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
//   }
//   v(0.5em)
// }


// // Función para verdadero/falso con contador opcional
// #let verdadero-falso(enunciado, correcta: none, numeracion: none, tipo-numeracion: "numero") = {
//   // Aplicar numeración si se solicita
//   if numeracion != none {
//     let etiqueta = aplicar-contador(
//       numeracion, 
//       tipo: tipo-numeracion
//     )
//     context {
//       text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
//     }
//   }
  
//   text(fill: theme.text-color)[#enunciado]
//   h(1em)
  
//   let v-text = t("verdadero", lang: "es")
//   let f-text = t("falso", lang: "es")
  
//   if show-solutions {
//     if correcta == true {
//       text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #v-text] + text(fill: theme.text-color)[ #CajaNoCheck() #f-text]
//     } else if correcta == false {
//       text(fill: theme.text-color)[#CajaNoCheck() #v-text] + text(fill: theme.solution-border, weight: "bold")[ #CajaCheck() #f-text]
//     } else {
//       text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
//     }
//   } else {
//     text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
//   }
//   v(0.5em)
// }



// Función para verdadero/falso modificada
#let verdadero-falso(enunciado, correcta: none, numeracion: true, tipo-numeracion: "numero") = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  h(1em)
  
  let v-text = t("verdadero", lang: "es")
  let f-text = t("falso", lang: "es")
  
  if show-solutions {
    if correcta == true {
      text(fill: theme.solution-border, weight: "bold")[#CajaCheck() #v-text] + text(fill: theme.text-color)[ #CajaNoCheck() #f-text]
    } else if correcta == false {
      text(fill: theme.text-color)[#CajaNoCheck() #v-text] + text(fill: theme.solution-border, weight: "bold")[ #CajaCheck() #f-text]
    } else {
      text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
    }
  } else {
    text(fill: theme.text-color)[#CajaNoCheck() #v-text #CajaNoCheck() #f-text]
  }
  v(0.5em)
}

// Función para espacio de desarrollo
#let espacio-desarrollo(lineas: 5, puntos: false, body) = {
  if puntos {
    for i in range(lineas) {
      v(0.8em)
      box(width: 100%, line(length: 100%, stroke: 0.5pt + theme.header-color.lighten(40%)))
    }
  } else {
    v(lineas * 1em)
  }
}

// // Función para tabla de calificaciones
// #let tabla-calificaciones(ejercicios: (), body) = {
//   let headers = (
//     text(weight: "bold", fill: theme.text-color)[#t("ejercicio", lang: "es")], 
//     text(weight: "bold", fill: theme.text-color)[#t("puntos", lang: "es")]
//   )
//   let rows = ejercicios.map(e => (
//     text(fill: theme.text-color)[#e.nombre], 
//     text(fill: theme.text-color)[#e.puntos]
//   ))
//   rows.push((
//     text(weight: "bold", fill: theme.text-color)[#t("total", lang: "es")], 
//     text(weight: "bold", fill: theme.text-color)[#ejercicios.map(e => e.puntos).sum()]
//   ))
//   align(center)[
//   #tablex(
//     columns: (auto, auto),
//     rows: auto,
//     stroke: 1pt + theme.text-color,
//     align: left + horizon,
//     ..headers,
//     ..rows.flatten()
//   )      
//   ]

// }


// // Función para tabla de calificaciones (versión horizontal)
// #let tabla-calificaciones(ejercicios: (), body) = {
//   let num-ejercicios = ejercicios.len()
  
//   // Crear columnas: una por cada ejercicio + una para el total
//   let columns = range(num-ejercicios + 1).map(_ => auto)
  
//   // Primera fila: nombres de ejercicios + "Total"
//   let fila-nombres = ejercicios.map(e => 
//     text(weight: "bold", fill: theme.text-color, size: 9pt)[#e.nombre]
//   )
//   fila-nombres.push(
//     text(weight: "bold", fill: theme.text-color, size: 9pt)[#t("total", lang: "es")]
//   )
  
//   // Segunda fila: puntos máximos de cada ejercicio + suma total
//   let fila-puntos = ejercicios.map(e => 
//     text(fill: theme.text-color, size: 9pt)[#e.puntos]
//   )
//   fila-puntos.push(
//     text(weight: "bold", fill: theme.text-color, size: 9pt)[#ejercicios.map(e => e.puntos).sum()]
//   )
  
//   // Tercera fila: celdas vacías para calificación obtenida
//   let fila-calificacion = range(num-ejercicios + 1).map(_ => 
//     text(fill: theme.text-color, size: 9pt)[ ]
//   )
  
//   align(center)[
//     #tablex(
//       columns: columns,
//       rows: (auto, auto, 2em), // La tercera fila con altura fija para escribir
//       stroke: 1pt + theme.text-color,
//       align: center + horizon,
//       ..fila-nombres,
//       ..fila-puntos,
//       ..fila-calificacion
//     )      
//   ]
// }

// Función para tabla de calificaciones (versión horizontal con ancho mínimo)
//#let tabla-calificaciones(ejercicios: (), body) = {
#let tabla-calificaciones(ejercicios: (), min-width: 2cm, body) = {

  let num-ejercicios = ejercicios.len()
  
  let columns = range(num-ejercicios + 1).map(_ => min-width)

  // Crear columnas con ancho mínimo de 3cm cada una
  //let min-width = 1.5cm
  //let columns = range(num-ejercicios + 1).map(_ => min-width)
  
  // Primera fila: nombres de ejercicios + "Total"
  let fila-nombres = ejercicios.map(e => 
    text(weight: "bold", fill: theme.text-color, size: 9pt)[#e.nombre]
  )
  fila-nombres.push(
    text(weight: "bold", fill: theme.text-color, size: 9pt)[#t("total", lang: "es")]
  )
  
  // Segunda fila: puntos máximos de cada ejercicio + suma total
  let fila-puntos = ejercicios.map(e => 
    text(fill: theme.text-color, size: 9pt)[#e.puntos]
  )
  fila-puntos.push(
    text(weight: "bold", fill: theme.text-color, size: 9pt)[#ejercicios.map(e => e.puntos).sum()]
  )
  
  // Tercera fila: celdas vacías para calificación obtenida
  let fila-calificacion = range(num-ejercicios + 1).map(_ => 
    text(fill: theme.text-color, size: 9pt)[ ]
  )
  
  align(center)[
    #tablex(
      columns: columns,
      rows: (auto, auto, 2em), // La tercera fila con altura fija para escribir
      stroke: 1pt + theme.text-color,
      align: center + horizon,
      ..fila-nombres,
      ..fila-puntos,
      ..fila-calificacion
    )      
  ]
}

// ============================================
// FUNCIÓN PRINCIPAL DEL DOCUMENTO
// ============================================

#let examtypst(
  margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm),
  paper: "a4",
  fontsize: 11pt,
  fontsize-header: 12pt,  // Añadir este parámetro
  lang: "es",
  department: "Departamento",
  subject: "Asignatura",
  degree: "Grado",
  //exam-type: "Examen",
  //exam-date: "Fecha",
  exam-type: "",
  exam-date: "",
  show-student-data: false,
  body
) = {

  // Configuración del documento
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
    // header: context {
    //   if (counter(page).get().at(0) > 1) {
    //     align(right)[
    //       #text(size: 9pt, fill: theme.header-color)[#subject - #exam-type - #exam-date]
    //     ]
    //   }
    // },
    // En la función examtypst, reemplaza la sección header:
    header: context {
      if (counter(page).get().at(0) > 1) {
        align(right)[
          // Construir el header de forma condicional, igual que en make-title
          #if exam-type != "" and exam-date != "" {
            text(size: 9pt, fill: theme.header-color)[#subject - #exam-type - #exam-date]
          } else if exam-type != "" and exam-date == "" {
            text(size: 9pt, fill: theme.header-color)[#subject - #exam-type]
          } else if exam-type == "" and exam-date != "" {
            text(size: 9pt, fill: theme.header-color)[#subject - #exam-date]
          } else {
            text(size: 9pt, fill: theme.header-color)[#subject]
          }
        ]
      }
    },    
    footer: context {
      let current-page = counter(page).get().at(0)
      let total-pages = counter(page).final().at(0)
      
      if total-pages > 1 {
        if current-page > 1 {
          grid(
            columns: (1fr, auto),
            align: (left, right),
            [
              #text(size: 8pt, fill: theme.header-color)[#subject]
            ],
            [
              #text(size: 9pt, fill: theme.text-color)[#t("pagina", lang: "es") #current-page #t("de", lang: "es") #total-pages]
            ]
          )
        } else {
          align(right)[
            #text(size: 9pt, fill: theme.text-color)[#t("pagina", lang: "es") #current-page #t("de", lang: "es") #total-pages]
          ]
        }
      }
    }
  )

  set text(
    size: fontsize,
    lang: "es",
    fill: theme.text-color
  )

  set par(
    justify: true,
    leading: 0.6em
  )

  set heading(
    numbering: "1."
  )

  // Mostrar título
  if show-cabecera {
    if show-student-data {
      //make-title-with-student()
      //let extra-fields = parse-additional-fields(additional-fields)
     let extra-fields = parse-additional-fields(additional-fields-str)
      make-title-with-student(extra-fields: extra-fields)
    } else {
      make-title(fontsize-header: fontsize-header)
      v(1em)
    }
  } else {
    v(2em)
  }

  body
}



// ============================================
// NUEVOS TIPOS DE PREGUNTAS
// ============================================

// 1. Función para respuestas cortas
#let respuesta-corta(
  enunciado,
  ancho: 10em,
  lineas: 1,
  numeracion: false,
  tipo-numeracion: "numero"
) = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  v(0.3em)
  
  if lineas == 1 {
    // Una sola línea
    h(1em)
    line(length: ancho, stroke: 1pt + theme.text-color)
  } else {
    // Múltiples líneas
    for i in range(lineas) {
      h(1em)
      line(length: ancho, stroke: 1pt + theme.text-color)
      v(1em)
    }
  }
  v(0.5em)
}

// 2. Función para completar espacios (huecos en el texto)
#let hueco(ancho: 3em, altura: 1.2em) = {
  box(
    width: ancho,
    height: altura,
    stroke: (bottom: 1pt + theme.text-color),
    inset: (bottom: 2pt)
  )[]
}

// Función auxiliar para textos con huecos
#let texto-con-huecos(
  texto,
  numeracion: false,
  tipo-numeracion: "numero"
) = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#texto]
  v(0.5em)
}

// 3. Función para asociar/emparejar elementos
#let asociar-elementos(
  enunciado: "Asocia los elementos de ambas columnas:",
  columna-izq: (),
  columna-der: (),
  conexiones: (),  // Array de pares (índice_izq, índice_der) para las respuestas correctas (empezando desde 1)
  numeracion: false,
  tipo-numeracion: "numero",
  mostrar-lineas: true,
  body
) = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  v(0.5em)
  
  let max-items = calc.max(columna-izq.len(), columna-der.len())
  
  grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 2em,
    row-gutter: 1em,
    
    // Encabezados
    align(center)[
    #text(weight: "bold", fill: theme.text-color)[Columna A]],
    [],
    align(center)[
    #text(weight: "bold", fill: theme.text-color)[Columna B]],
    
    // Elementos
    ..range(max-items).map(i => {
      let izq = if i < columna-izq.len() {
        text(baseline: -0.4em, fill: theme.text-color)[#(i + 1). #columna-izq.at(i)]
      } else { [] }
      
      let centro = if mostrar-lineas {
        line(length: 3em, stroke: 1pt + theme.text-color)
      } else {
        //text(fill: theme.text-color)[( )]
      }
      
      let der = if i < columna-der.len() {
        text(baseline: -0.4em, fill: theme.text-color)[#str.from-unicode(97 + i)) #columna-der.at(i)]
      } else { [] }
      
      (izq, centro, der)
    }).flatten()
  )
  
  // Mostrar conexiones si hay soluciones
  if show-solutions and conexiones.len() > 0 {
    v(0.5em)
    text(weight: "bold", fill: theme.solution-border)[Respuestas correctas:]
    v(0.2em)
    for (izq-idx, der-idx) in conexiones {
      text(fill: theme.solution-border)[
        #izq-idx → #str.from-unicode(96 + der-idx)
      ]
      linebreak()
    }
  }
  
  v(0.5em)
}


// Función para emparejar con elementos mezclados (versión tabla)
#let emparejar-mezclado(
  enunciado: "Escribe la letra correcta junto a cada número:",
  columna-izq: (),
  columna-der: (),
  respuestas: (),
  numeracion: false,
  tipo-numeracion: "numero",
  body
) = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  v(0.5em)
  
  let max-items = calc.max(columna-izq.len(), columna-der.len())
  
  grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 2em,
    row-gutter: 1em,
    
    // Encabezados
    align(center)[
      #text(weight: "bold", fill: theme.text-color)[Columna A]
    ],
    [],
    align(center)[
      #text(weight: "bold", fill: theme.text-color)[Columna B]
    ],
    
    // Elementos
    ..range(max-items).map(i => {
      let izq = if i < columna-izq.len() {
        grid(
          columns: (auto, auto, auto),
          column-gutter: 1em,
          text(fill: theme.text-color)[#(i + 1).],
          text(fill: theme.text-color)[#columna-izq.at(i)],
          if show-solutions {
            text(fill: theme.solution-border, weight: "bold")[#h(1em) #respuestas.at(i)]
          } else {
            box(width: 2em, height: 1.2em, stroke: 1pt + theme.text-color)[]
          }
        )
      } else { [] }
      
      let centro = []
      
      let der = if i < columna-der.len() {
        text(fill: theme.text-color)[#str.from-unicode(97 + i)) #columna-der.at(i)]
      } else { [] }
      
      (izq, centro, der)
    }).flatten()
  )
  
  v(0.5em)
}


// Función para completar definiciones
#let completar-definiciones(
  enunciado: "Escribe el término que corresponde a cada definición:",
  definiciones: (),  // Array de definiciones
  respuestas: (),    // Array con las respuestas correctas
  numeracion: false,
  tipo-numeracion: "numero",
  body
) = {
  // Aplicar numeración si se solicita
  if numeracion {
    let etiqueta = aplicar-contador(
      contador-vf, 
      tipo: tipo-numeracion
    )
    context {
      text(weight: "bold", fill: theme.text-color)[#etiqueta) ]
    }
  }
  
  text(fill: theme.text-color)[#enunciado]
  v(0.2em)
  
  for (i, definicion) in definiciones.enumerate() {
    text(fill: theme.text-color)[#(i + 1). #definicion]
    h(1em)
    if show-solutions {
      text(fill: theme.solution-border, weight: "bold")[#respuestas.at(i)]
    } else {
      linebreak()
      text(fill: theme.text-color)[#h(1em) #v(1em)]
      line(length: 100%, stroke: 1pt + theme.text-color)
    }
    linebreak()
    v(0.2em)
  }
  v(0.2em)
}
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

#set page(
  paper: "a4",
  margin: (bottom: 1cm,left: 1cm,right: 1cm,top: 1cm,),
  numbering: "1",
  columns: 1,
)

#show: doc => examtypst(
    margin: (bottom: 1cm,left: 1cm,right: 1cm,top: 1cm,),
      paper: "a4",
        lang: "es",
      fontsize: 10pt,
      department: "Departamento de Estadística e Investigación Operativa",
      subject: "Teoría de la Decisión",
      degree: "Grado en Estadística",
      exam-type: "1ª Prueba Evaluación Continua",
      exam-date: "6 de Noviembre de 2025",
      show-student-data: true,
    //   //   // show-cabecera: true,
  //     //   
  doc
)

- #strong[Duración del examen:] 2 horas
- #strong[Material permitido:] Calculadora no programable
- #strong[Puntuación total:] 100 puntos

#horizontalrule

#ejercicio(puntos: 20)[
#strong[Decisión en ambiente de incertidumbre.] Una empresa debe lanzar un nuevo producto al mercado y se enfrenta a tres posibles estados de la naturaleza: $E_1$ (mercado favorable), $E_2$ (mercado estable) y $E_3$ (mercado desfavorable). Las alternativas disponibles son:

- $A_1$: Lanzar el producto a nivel nacional
- $A_2$: Lanzar el producto solo a nivel regional
- $A_3$: No lanzar el producto

La matriz de beneficios (en miles de €) es:

#table(
  columns: 4,
  align: (center,center,center,center,),
  table.header([Alternativa], [$E_1$], [$E_2$], [$E_3$],),
  table.hline(),
  [$A_1$], [120], [50], [-30],
  [$A_2$], [70], [40], [10],
  [$A_3$], [0], [0], [0],
)
+ Aplica el criterio de #strong[Laplace] (equiprobabilidad).
+ Aplica el criterio #strong[optimista] (maximax) y #strong[pesimista] (maximin).
+ Aplica el criterio de #strong[Hurwicz] con $alpha = 0.6$.

#espacio-desarrollo(lineas: 20, puntos: false)[
]
]
#ejercicio(puntos: 15)[
#strong[Decisión con probabilidades a priori.] Dadas las probabilidades: $P \( E_1 \) = 0.3$, $P \( E_2 \) = 0.5$, $P \( E_3 \) = 0.2$, calcula:

+ El #strong[valor esperado] de cada alternativa.
+ La alternativa óptima según el criterio del #strong[Valor Esperado].
+ El #strong[Valor Esperado de la Información Perfecta] (VEIP).

#espacio-desarrollo(lineas: 15, puntos: false)[
]
]
#pagebreak()
#ejercicio(puntos: 20)[
#strong[Teoría de la utilidad.] La función de utilidad de un decisor es $U \( x \) = 1 - e^(- 0.02 x)$, con $x gt.eq - 50$ (miles de €).

+ ¿Qué actitud frente al riesgo tiene? Justifica.
+ Dado: $A_1$: 50 000 € seguros; $A_2$: 100 000 € con $p = 0.5$ y 0 € con $p = 0.5$. ¿Qué elige según la #strong[utilidad esperada]?

#espacio-desarrollo(lineas: 15, puntos: false)[
]
]
#pagebreak()
#ejercicio(puntos: 20)[
#strong[Método PROMETHEE.] Una empresa selecciona una inversión entre cinco alternativas (E1--E5) según cuatro criterios a maximizar:

#table(
  columns: 5,
  align: (center,center,center,center,center,),
  table.header([Alternativa], [C1], [C2], [C3], [C4],),
  table.hline(),
  [E1], [90], [80], [-6], [5.4],
  [E2], [58], [65], [-2], [9.7],
  [E3], [60], [83], [-4], [7.2],
  [E4], [80], [40], [-10], [7.5],
  [E5], [72], [52], [-6], [2.0],
)
Pesos: 0.2, 0.2, 0.3, 0.3. Funciones de preferencia: - C1: tipo 3 (lineal) con $p = 30$ - C2: tipo 2 (cuasi) con $q = 10$ - C3: tipo 5 (lineal indiferencia) con $q = 0.5$, $p = 5$ - C4: tipo 4 (nivel) con $q = 1$, $p = 6$

¿Cuáles son correctas?

#pregunta-multiple-md(
  [
]
)[
  #opc(es-correcta: true)[
En PROMETHEE~II, E2 es la mejor clasificada.
]
  #opc(es-correcta: true)[
En PROMETHEE~II, E4 es la peor clasificada.
]
  #opc[
Al cambiar los pesos a 0.3,0.3,0.2,0.2, E1 mantiene su posición.
]
  #opc(es-correcta: true)[
E2 siempre está 1ª al modificar fpref de C3 ($q = 0.5$, $p = 5$, $s = 3$).
]
  #opc[
E3 siempre está en 3ª posición al modificar parámetros de C3 ($p = q + 5$, $s = 0$, $q$ variando entre 0.5 y 10).
]
]
]
#ejercicio(puntos: 15)[
#strong[Criterios de decisión.] Responde razonadamente:

#apartado(letra: "a", puntos: 5)[
Define el criterio #strong[minimax] de Savage.]

#apartado(letra: "b", puntos: 5)[
Diferencia entre actitud #strong[neutral] y #strong[aversión] al riesgo.]

#apartado(letra: "c", puntos: 5)[
Explica el concepto de #strong[tasa de sustitución].]

#espacio-desarrollo(lineas: 12, puntos: false)[
]
]
#pagebreak()
#ejercicio(puntos: 10)[
#strong[Test.] Selecciona la respuesta correcta:

#pregunta-multiple(opciones: ("Busca el máximo de los mínimos", "Busca el mínimo de los máximos", "Minimiza la pérdida máxima posible"), correcta: 3, columnas: 1)[
El criterio #strong[minimax] de Savage consiste en:]

#pregunta-multiple(opciones: ("Lineal", "Cóncava", "Convexa"), correcta: 2, columnas: 1)[
Una función de utilidad con aversión al riesgo es:]

#verdadero-falso(correcta: true)[
En WSM los pesos deben sumar 1.]

#verdadero-falso(correcta: false)[
Laplace asigna probabilidades distintas a cada estado.]
]

#solucion[
#strong[Ejercicio 1:] 1. Laplace: $V E \( A_1 \) = 46.67$, $V E \( A_2 \) = 40$, $V E \( A_3 \) = 0 arrow.r A_1$. 2. Maximax: $A_1$ (120), Maximin: $A_2$ (10). 3. Hurwicz ($alpha = 0.6$): $H \( A_1 \) = 60$, $H \( A_2 \) = 46$, $H \( A_3 \) = 0 arrow.r A_1$.

#strong[Ejercicio 2:] $V E \( A_1 \) = 55$, $V E \( A_2 \) = 43$, $V E \( A_3 \) = 0 arrow.r A_1$. VEIP = 8.

#strong[Ejercicio 3:] $U'' < 0 arrow.r$ cóncava $arrow.r$ aversión. $U \( 50 \) = 0.6321 > E U \( A_2 \) = 0.4323 arrow.r$ elige $A_1$.

#strong[Ejercicio 4:] Correctas: 1 (E2 mejor), 2 (E4 peor), 4 (E2 siempre 1ª). Incorrectas: 3, 5.

#strong[Ejercicio 5:] a) Minimax: minimiza la máxima pérdida de oportunidad. b) Neutral: utilidad lineal; aversión: cóncava. c) Tasa a la que un criterio compensa a otro.

#strong[Ejercicio 6:] 1. Minimiza la pérdida máxima posible. 2. Cóncava. 3. V. 4. F (Laplace asigna igual probabilidad).]
