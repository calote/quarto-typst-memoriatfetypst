// Funciones de examen — Estética Moderna (slate + amber + teal)
// Incluir via include-in-header en Quarto

#import "@preview/tablex:0.0.9": tablex

#let accent-ej = rgb("#d97706")
#let accent-sol = rgb("#059669")
#let accent-ap = rgb("#6366f1")
#let theme-bg = rgb("#f8fafc")
#let theme-text = rgb("#1e293b")
#let theme-muted = rgb("#94a3b8")
#let theme-sol-bg = rgb("#f0fdf4")
#let theme-sol-stroke = rgb("#22c55e")
#let theme-ej-stroke = accent-ej
#let theme-primary = rgb("#2563eb")

// Estados para compatibilidad con typst-show.typ (no afectan al estilo moderno
// que siempre usa tarjetas con barra lateral de color)
#let estilo-cuadro-ejercicio = state("estilo-cuadro-ejercicio", true)
#let estilo-cuadro-solucion = state("estilo-cuadro-solucion", true)
#let ejercicio-salto-linea = state("ejercicio-salto-linea", true)

#let contador-ejercicios = counter("ejercicio")
#let contador-apartados = counter("apartado")
#let contador-vf = counter("verdadero-falso")

#let reiniciar-apartados() = { contador-apartados.update(0) }
#let reiniciar-vf() = { contador-vf.update(0) }

#let generar-etiqueta(numero, tipo: "letra") = {
  if tipo == "letra" { str.from-unicode(96 + numero) }
  else if tipo == "numero" { str(numero) }
  else if tipo == "LETRA" { str.from-unicode(64 + numero) }
  else if tipo == "romano" { numbering("i", numero) }
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

#let CajaCheck() = text(fill: accent-sol, weight: "bold")[✔]
#let CajaNoCheck() = text(fill: theme-muted)[□]

#let ejercicio(title: none, puntos: none, body) = {
  reiniciar-apartados()
  reiniciar-vf()
  contador-ejercicios.step()
  context {
    let n = contador-ejercicios.get().first()
    let header = if title != none {
      text(weight: "bold", fill: theme-text, size: 1em)[Ejercicio #n.  #title]
    } else {
      text(weight: "bold", fill: theme-text, size: 1em)[Ejercicio #n]
    }
    if puntos != none {
      header = [#header  #text(fill: theme-muted, size: 0.85em)[(#puntos puntos)]]
    }
    block(
      fill: theme-bg,
      stroke: (left: 4pt + accent-ej),
      inset: (x: 12pt, y: 8pt),
      width: 100%,
      above: 0.8em, below: 0.5em,
      [ #header  #v(0.25em)  #text(fill: theme-text, size: 0.95em)[#body] ]
    )
  }
}

#let solucion(body) = {
  block(
    fill: theme-sol-bg,
    stroke: (left: 4pt + accent-sol),
    inset: (x: 12pt, y: 6pt),
    width: 100%,
    above: 0.5em, below: 0.5em,
    [ #text(weight: "bold", fill: accent-sol)[Solución:]  #text(fill: theme-text)[#body] ]
  )
}

#let apartado(letra: auto, tipo: "letra", puntos: none, body) = {
  let lbl = if letra == auto { aplicar-contador(contador-apartados, tipo: tipo) } else { letra }
  let header = [ #text(weight: "bold", fill: accent-ap, size: 0.9em)[#lbl).] ]
  if puntos != none { header = [#header  #text(fill: theme-muted, size: 0.85em)[(#puntos puntos)]] }
  [ #header  #body ]
}

#let pregunta-multiple(
  opciones: (), correcta: none, columnas: 1,
  numeracion: false, tipo-numeracion: "numero", opciones-tipo: "LETRA",
  body,
) = {
  text(fill: theme-text, weight: "bold")[#body]
  v(0.2em)
  let correctas = if type(correcta) == array { correcta }
    else if correcta != none { (correcta,) } else { () }
  let opcs = opciones.enumerate().map(((i, opt)) => (indice-original: i + 1, opcion: opt))
  if columnas == 1 {
    for (i, item) in opcs.enumerate() {
      h(0.8em)
      let etq = generar-etiqueta(i + 1, tipo: opciones-tipo)
      text(fill: theme-text, size: 0.9em)[#CajaNoCheck()  #etq)  #item.opcion]
      linebreak()
    }
  } else {
    grid(columns: columnas, column-gutter: 0.8em, row-gutter: 0.5em,
      ..opcs.enumerate().map(((i, item)) => {
        let etq = generar-etiqueta(i + 1, tipo: opciones-tipo)
        text(fill: theme-text, size: 0.9em)[#CajaNoCheck()  #etq)  #item.opcion]
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
  text(fill: theme-text, weight: "bold")[#body]
  h(0.8em)
  text(size: 0.9em, fill: theme-text)[#CajaNoCheck()  Verdadero  #CajaNoCheck()  Falso]
  v(0.5em)
}

#let espacio-desarrollo(lineas: 5, puntos: false, body) = {
  if puntos {
    for i in range(lineas) {
      v(0.6em)
      box(width: 100%, line(length: 100%, stroke: 0.5pt + theme-muted))
    }
  } else { v(lineas * 0.8em) }
}

#let respuesta-corta(lineas: 3, body) = {
  text(fill: theme-text, weight: "bold")[#body]
  for i in range(lineas) {
    v(0.5em)
    line(length: 100%, stroke: 0.3pt + theme-muted)
  }
  v(0.5em)
}

// ============================================
// CABECERA INSTITUCIONAL (estilo examtypst moderno)
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
// DATOS DEL ESTUDIANTE (estilo examtypst moderno)
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
// TABLA DE CALIFICACIONES (estilo examtypst moderno)
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
