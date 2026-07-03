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

// #let department = "$department$"
// #let subject = "$subject$"
// #let degree = "$degree$"
// #let exam-type = "$exam-type$"
// #let exam-date = "$exam-date$"
// #let show-solutions = "$show-solutions$" == "true"
// #let show-ejercicio-cuadro = "$show-ejercicio-cuadro$" == "true"
// #let show-cabecera = "$show-cabecera$" == "true"
// #let show-student-data = "$show-student-data$" == "true"
// #let lang = "$if(lang)$$lang$$else$es$endif$"

// Nombre del ejercicio con soporte i18n
// #let ejercicio-nombre = "$if(ejercicio-nombre)$$ejercicio-nombre$$else$ejercicio$endif$"

// Por esta versión corregida:
// #let additional-fields = ($if(additional-fields)$$for(additional-fields)$"$it$"$sep$, $endfor$$else$$endif$)


// Variables del documento con soporte bilingüe (español tiene prioridad)
#let department = "$if(departamento)$$departamento$$elseif(department)$$department$$else$$endif$"
#let subject = "$if(asignatura)$$asignatura$$elseif(subject)$$subject$$else$$endif$"
#let degree = "$if(titulacion)$$titulacion$$elseif(degree)$$degree$$else$$endif$"
#let exam-type = "$if(tipo-examen)$$tipo-examen$$elseif(exam-type)$$exam-type$$else$$endif$"
#let exam-date = "$if(fecha-examen)$$fecha-examen$$elseif(exam-date)$$exam-date$$else$$endif$"
#let show-solutions = "$if(mostrar-soluciones)$$mostrar-soluciones$$elseif(show-solutions)$$show-solutions$$else$false$endif$" == "true"
#let show-ejercicio-cuadro = "$if(mostrar-ejercicio-cuadro)$$mostrar-ejercicio-cuadro$$elseif(show-ejercicio-cuadro)$$show-ejercicio-cuadro$$else$false$endif$" == "true"
//#let show-cabecera = "$if(mostrar-cabecera)$$mostrar-cabecera$$elseif(show-cabecera)$$show-cabecera$$else$false$endif$" == "true"
//#let show-cabecera = "$if(mostrar-cabecera)$$mostrar-cabecera$$else$$if(show-cabecera)$$show-cabecera$$else$true$endif$$endif$" == "false"
// ...existing code...
#let show-cabecera = "$show-cabecera-effective$" == "true"
// ...existing code...
// ...existing code...
#let show-student-data = "$if(mostrar-datos-estudiante)$$mostrar-datos-estudiante$$elseif(show-student-data)$$show-student-data$$else$false$endif$" == "true"
#let lang = "$if(idioma)$$idioma$$elseif(lang)$$lang$$else$es$endif$"

// Ejercicio nombre con soporte bilingüe (español tiene prioridad)
//#let ejercicio-nombre = "$if(nombre-ejercicio)$$nombre-ejercicio$$elseif(ejercicio-nombre)$$ejercicio-nombre$$else$ejercicio$endif$"
#let ejercicio-nombre = "$ejercicio-nombre$"  //"$if(ejercicio-nombre)$$ejercicio-nombre$$else$ejercicio$endif$"

// Additional fields con soporte bilingüe (español tiene prioridad)
//#let additional-fields = ($if(campos-adicionales)$$for(campos-adicionales)$"$it$"$sep$, $endfor$$elseif(additional-fields)$$for(additional-fields)$"$it$"$sep$, $endfor$$else$$endif$)

// Variables del documento - versión corregida para additional-fields
#let additional-fields-str = "$if(campos-adicionales)$$for(campos-adicionales)$$it$$sep$|$endfor$$elseif(additional-fields)$$for(additional-fields)$$it$$sep$|$endfor$$else$$endif$"

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
#let ejercicio-salto-linea = "$if(ejercicio-salto-linea)$$ejercicio-salto-linea$$elseif(exercise-line-break)$$exercise-line-break$$else$false$endif$" == "true"


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
$if(theme-preset)$
#let theme = temas-predefinidos.at("$theme-preset$")
$else$
#let theme = (
  primary: rgb("$if(theme.primary)$$theme.primary$$else$#8B0000$endif$"),
  secondary: rgb("$if(theme.secondary)$$theme.secondary$$else$#007acc$endif$"),
  background: rgb("$if(theme.background)$$theme.background$$else$#f8f9fa$endif$"),
  solution-bg: rgb("$if(theme.solution-bg)$$theme.solution-bg$$else$#e6f3ff$endif$"),
  solution-border: rgb("$if(theme.solution-border)$$theme.solution-border$$else$#007acc$endif$"),
  ejercicio-border: $if(theme.ejercicio-border)$rgb("$theme.ejercicio-border$")$else$gray$endif$,
  text-color: $if(theme.text-color)$rgb("$theme.text-color$")$else$black$endif$,
  header-color: $if(theme.header-color)$rgb("$theme.header-color$")$else$gray$endif$,
)
$endif$

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
//         #image("$logo$", width: 60pt)
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
//         #image("$logo$", width: 60pt)
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
#let logo = "$if(escudo)$$escudo$$elseif(logo)$$logo$$else$$endif$"
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
//       t("ejercicio", lang: "$lang$")
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
//           t("punto", lang: "$lang$")
//         } else {
//           t("puntos", lang: "$lang$")
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
    //text(weight: "bold", size: 10pt, fill: theme.solution-border)[#t("solucion", lang: "$lang$"):]
    text(weight: "bold", fill: theme.solution-border)[#t("solucion", lang: "$lang$"):]
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
  
//   let v-text = t("verdadero", lang: "$lang$")
//   let f-text = t("falso", lang: "$lang$")
  

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
  
//   let v-text = t("verdadero", lang: "$lang$")
//   let f-text = t("falso", lang: "$lang$")
  
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
  
  let v-text = t("verdadero", lang: "$lang$")
  let f-text = t("falso", lang: "$lang$")
  
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
//     text(weight: "bold", fill: theme.text-color)[#t("ejercicio", lang: "$lang$")], 
//     text(weight: "bold", fill: theme.text-color)[#t("puntos", lang: "$lang$")]
//   )
//   let rows = ejercicios.map(e => (
//     text(fill: theme.text-color)[#e.nombre], 
//     text(fill: theme.text-color)[#e.puntos]
//   ))
//   rows.push((
//     text(weight: "bold", fill: theme.text-color)[#t("total", lang: "$lang$")], 
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
//     text(weight: "bold", fill: theme.text-color, size: 9pt)[#t("total", lang: "$lang$")]
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
    text(weight: "bold", fill: theme.text-color, size: 9pt)[#t("total", lang: "$lang$")]
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
              #text(size: 9pt, fill: theme.text-color)[#t("pagina", lang: "$lang$") #current-page #t("de", lang: "$lang$") #total-pages]
            ]
          )
        } else {
          align(right)[
            #text(size: 9pt, fill: theme.text-color)[#t("pagina", lang: "$lang$") #current-page #t("de", lang: "$lang$") #total-pages]
          ]
        }
      }
    }
  )

  set text(
    size: fontsize,
    lang: "$lang$",
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