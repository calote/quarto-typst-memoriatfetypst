// Funciones de examtypst para usar con memoriatfetypst
// Incluir via include-in-header en Quarto
// Estética clásica: granate (#8B0000) + azul (#007ACC)

#import "@preview/tablex:0.0.9": tablex

#let theme-primary = rgb("#8B0000")
#let theme-secondary = rgb("#007acc")
#let theme-bg = rgb("#f8f9fa")
#let theme-text = black
#let theme-sol-bg = rgb("#e6f3ff")
#let theme-sol-border = rgb("#007acc")
#let theme-ej-border = gray
#let theme-header = gray
#let theme-correct = rgb("#16a34a")

// Estados para alternar entre el estilo "cuadro" (con borde/fondo de color,
// comportamiento actual) y el estilo "plano" sin cuadros ni colores en el
// enunciado (como en examtypst-typst con show-ejercicio-cuadro: false).
// Se actualizan desde typst-show.typ leyendo la metadata YAML del .qmd.
#let estilo-cuadro-ejercicio = state("estilo-cuadro-ejercicio", true)
#let estilo-cuadro-solucion = state("estilo-cuadro-solucion", true)
#let ejercicio-salto-linea = state("ejercicio-salto-linea", true)

// Contadores
#let contador-ejercicios = counter("ejercicio")
#let contador-apartados = counter("apartado")
#let contador-vf = counter("verdadero-falso")

#let reiniciar-apartados() = { contador-apartados.update(0) }
#let reiniciar-vf() = { contador-vf.update(0) }

#let generar-etiqueta(numero, tipo: "letra") = {
  if tipo == "letra" { str.from-unicode(96 + numero) }
  else if tipo == "numero" { str(numero) }
  else if tipo == "romano" { numbering("i", numero) }
  else if tipo == "LETRA" { str.from-unicode(64 + numero) }
  else if tipo == "ROMANO" { numbering("I", numero) }
  else { "•" }
}

#let aplicar-contador(contador, tipo: "letra", formato: auto, custom-label: auto) = {
  if custom-label != auto { custom-label }
  else {
    contador.step()
    context {
      let n = contador.get().first()
      if formato == auto { generar-etiqueta(n, tipo: tipo) }
      else { formato(n) }
    }
  }
}

#let CajaCheck() = text(fill: theme-correct, weight: "bold")[✔]
#let CajaNoCheck() = text(fill: theme-header)[□]

#let ejercicio(title: none, puntos: none, mostrar-cuadro: none, salto-linea: none, body) = {
  reiniciar-apartados()
  reiniciar-vf()
  contador-ejercicios.step()
  context {
    let n = contador-ejercicios.get().first()
    let header = if title != none { [*Ejercicio #n. #title*] }
      else { [*Ejercicio #n*] }
    if puntos != none { header = [#header  (#puntos puntos)] }
    let _cuadro = if mostrar-cuadro == none { estilo-cuadro-ejercicio.get() } else { mostrar-cuadro }
    let _salto = if salto-linea == none { ejercicio-salto-linea.get() } else { salto-linea }
    if _cuadro {
      block(
        breakable: true, width: 100%,
        stroke: 1pt + theme-ej-border, inset: 10pt, radius: 3pt,
        fill: theme-bg,
      )[
        #text(weight: "bold", fill: theme-text)[#header]
        #if _salto { v(0.3em) }
        #text(fill: theme-text)[#body]
      ]
    } else {
      if _salto {
        text(weight: "bold", fill: theme-text)[#header]
        v(0.3em)
        text(fill: theme-text)[#body]
      } else {
        text(weight: "bold", fill: theme-text)[#header]
        text(fill: theme-text)[#h(0.5em) #body]
      }
      v(0.5em)
    }
  }
}

#let solucion(body, mostrar-cuadro: none) = {
  context {
    let _cuadro = if mostrar-cuadro == none { estilo-cuadro-solucion.get() } else { mostrar-cuadro }
    if _cuadro {
      block(
        fill: theme-sol-bg, stroke: 1pt + theme-sol-border,
        radius: 4pt, inset: 10pt, width: 100%,
        above: 0.8em, below: 0.8em,
        [*Solución:*  #body]
      )
    } else {
      v(0.5em)
      [*Solución:* #h(0.4em) #body]
      v(0.5em)
    }
  }
}

#let apartado(letra: auto, tipo: "letra", puntos: none, body) = {
  let lbl = if letra == auto { aplicar-contador(contador-apartados, tipo: tipo) } else { letra }
  let header = [ *#lbl)* ]
  if puntos != none { header = [#header  (#puntos puntos)] }
  [ #header  #body ]
}

#let pregunta-multiple(
  opciones: (), correcta: none, columnas: 1,
  numeracion: false, tipo-numeracion: "numero", opciones-tipo: "LETRA",
  body,
) = {
  text(fill: theme-text)[#body]
  v(0.3em)
  let correctas = if type(correcta) == array { correcta }
    else if correcta != none { (correcta,) } else { () }
  let opcs = opciones.enumerate().map(((i, opt)) => (indice-original: i + 1, opcion: opt))
  if columnas == 1 {
    for (i, item) in opcs.enumerate() {
      h(1em)
      let etq = generar-etiqueta(i + 1, tipo: opciones-tipo)
      text(fill: theme-text)[#CajaNoCheck() #h(0.5em) #etq) #h(0.2em) #item.opcion]
      linebreak()
    }
  } else {
    grid(columns: columnas, column-gutter: 1em, row-gutter: 0.7em,
      ..opcs.enumerate().map(((i, item)) => {
        let etq = generar-etiqueta(i + 1, tipo: opciones-tipo)
        text(fill: theme-text)[#CajaNoCheck() #h(0.5em) #etq) #h(0.2em) #item.opcion]
      })
    )
  }
  v(0.5em)
}

#let verdadero-falso(correcta: none, numeracion: true, tipo-numeracion: "numero", body) = {
  if numeracion {
    let etiqueta = aplicar-contador(contador-vf, tipo: tipo-numeracion)
    context { text(weight: "bold", fill: theme-text)[#etiqueta) ] }
  }
  text(fill: theme-text)[#body]
  h(1em)
  text(fill: theme-text)[#CajaNoCheck() V] + text(fill: theme-text)[ #CajaNoCheck() F]
  v(0.5em)
}

#let espacio-desarrollo(lineas: 5, puntos: false, body) = {
  if puntos {
    for i in range(lineas) {
      v(0.8em)
      box(width: 100%, line(length: 100%, stroke: 0.5pt + theme-header.lighten(40%)))
    }
  } else { v(lineas * 1em) }
}

#let pregunta-multiple-md(body, opciones: (), correcta: none, columnas: 1) = {
  pregunta-multiple(body,
    opciones: opciones, correcta: correcta,
    columnas: columnas, numeracion: false, opciones-tipo: "LETRA",
  )
}

#let respuesta-corta(lineas: 3, body) = {
  text(fill: theme-text)[#body]
  for i in range(lineas) {
    v(0.6em)
    line(length: 100%, stroke: 0.5pt + theme-header)
  }
  v(0.5em)
}

#let completar-definiciones(definiciones: (), body) = {
  text(fill: theme-text, weight: "bold")[Completa las siguientes definiciones:]
  for (i, def) in definiciones.enumerate() {
    v(0.5em)
    text(fill: theme-text)[#(i + 1). #def.enunciado]
    v(0.3em)
    box(width: 100%, line(length: 100%, stroke: 0.5pt + theme-header))
  }
  v(0.5em)
}

// ============================================
// CABECERA INSTITUCIONAL (estilo examtypst)
// ============================================
#let exam-header(
  logo: none,
  departamento: "",
  titulacion: "",
  asignatura: "",
  tipo-examen: "",
  fecha-examen: "",
  body,
) = {
  v(-1.5em)
  let has-logo = logo != none and logo != ""
  if has-logo {
    grid(
      columns: (60pt, 1fr),
      column-gutter: 10pt,
      align(left + horizon)[
        image(logo, width: 60pt)
      ],
      align(center + horizon)[
        text(size: 12pt, weight: "bold", fill: theme-text)[#departamento]
        linebreak()
        text(size: 12pt, weight: "bold", fill: theme-text)[#titulacion]
        linebreak()
        text(size: 12pt, weight: "bold", fill: theme-text)[#asignatura]
        #if tipo-examen != "" and fecha-examen != "" {
          linebreak()
          v(-0.6em)
          text(size: 12pt, weight: "bold", fill: theme-text)[#tipo-examen - #fecha-examen]
        } else if tipo-examen != "" {
          linebreak()
          v(-0.6em)
          text(size: 12pt, weight: "bold", fill: theme-text)[#tipo-examen]
        } else if fecha-examen != "" {
          linebreak()
          v(-0.6em)
          text(size: 12pt, weight: "bold", fill: theme-text)[#fecha-examen]
        }
        v(0.4em)
        line(length: 80%, stroke: theme-primary)
      ]
    )
  } else {
    align(center + horizon)[
      text(size: 12pt, weight: "bold", fill: theme-text)[#departamento]
      linebreak()
      text(size: 12pt, weight: "bold", fill: theme-text)[#titulacion]
      linebreak()
      text(size: 12pt, weight: "bold", fill: theme-text)[#asignatura]
      #if tipo-examen != "" and fecha-examen != "" {
        linebreak()
        v(-0.6em)
        text(size: 12pt, weight: "bold", fill: theme-text)[#tipo-examen - #fecha-examen]
      } else if tipo-examen != "" {
        linebreak()
        v(-0.6em)
        text(size: 12pt, weight: "bold", fill: theme-text)[#tipo-examen]
      } else if fecha-examen != "" {
        linebreak()
        v(-0.6em)
        text(size: 12pt, weight: "bold", fill: theme-text)[#fecha-examen]
      }
      v(0.4em)
      line(length: 80%, stroke: theme-primary)
    ]
  }
}

// ============================================
// DATOS DEL ESTUDIANTE (estilo examtypst)
// ============================================
#let exam-student-data(body) = {
  v(1em)
  grid(
    columns: (auto, 1fr, auto, 2fr),
    column-gutter: 1em,
    row-gutter: 1.5em,
    text(weight: "bold", fill: theme-text)[Nombre:],
    line(length: 100%, stroke: theme-text),
    text(weight: "bold", fill: theme-text)[Apellidos:],
    line(length: 100%, stroke: theme-text),
  )
  v(1em)
}

// ============================================
// TABLA DE CALIFICACIONES (estilo examtypst)
// ============================================
#let tabla-calificaciones(ejercicios: (), min-width: 2cm, body) = {
  let num-ejercicios = ejercicios.len()
  let columns = range(num-ejercicios + 1).map(_ => min-width)
  let fila-nombres = ejercicios.map(e =>
    text(weight: "bold", fill: theme-text, size: 9pt)[#e.nombre]
  )
  fila-nombres.push(
    text(weight: "bold", fill: theme-text, size: 9pt)[Total]
  )
  let fila-puntos = ejercicios.map(e =>
    text(fill: theme-text, size: 9pt)[#e.puntos]
  )
  fila-puntos.push(
    text(weight: "bold", fill: theme-text, size: 9pt)[#ejercicios.map(e => e.puntos).sum()]
  )
  let fila-calificacion = range(num-ejercicios + 1).map(_ =>
    text(fill: theme-text, size: 9pt)[ ]
  )
  align(center)[
    tablex(
      columns: columns, rows: (auto, auto, 2em),
      stroke: 1pt + theme-text,
      align: center + horizon,
      ..fila-nombres, ..fila-puntos, ..fila-calificacion
    )
  ]
}
