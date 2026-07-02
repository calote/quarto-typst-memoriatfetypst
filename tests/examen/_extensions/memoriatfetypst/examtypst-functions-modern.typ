// Funciones de examen — Estética Moderna (minimal, tarjetas, acentos)
// Incluir via include-in-header en Quarto
// Alternativa a examtypst-functions.typ

// Paleta: slate + amber + teal
#let accent-ej = rgb("#d97706")
#let accent-sol = rgb("#059669")
#let accent-ap = rgb("#6366f1")
#let theme-bg = rgb("#f8fafc")
#let theme-text = rgb("#1e293b")
#let theme-muted = rgb("#94a3b8")
#let theme-sol-bg = rgb("#f0fdf4")
#let theme-sol-stroke = rgb("#22c55e")
#let theme-ej-stroke = accent-ej

// Contadores
#let contador-ejercicios = counter("ejercicio")
#let contador-apartados = counter("apartado")
#let contador-vf = counter("verdadero-falso")

#let reiniciar-apartados() = { contador-apartados.update(0) }
#let reiniciar-vf() = { contador-vf.update(0) }

// Generar etiquetas
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
      let n = contador.get().first() + 1
      if formato == auto { generar-etiqueta(n, tipo: tipo) }
      else { formato(n) }
    }
  }
}

#let CajaCheck() = text(fill: accent-sol, weight: "bold")[✔]
#let CajaNoCheck() = text(fill: theme-muted)[□]

// ============================================
// EJERCICIO — estilo tarjeta con borde izquierdo
// ============================================
#let ejercicio(title: none, puntos: none, body) = {
  reiniciar-apartados()
  reiniciar-vf()
  context {
    contador-ejercicios.step()
    let n = contador-ejercicios.get().first() + 1
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

// ============================================
// SOLUCIÓN — tarjeta verde con borde izquierdo
// ============================================
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

// ============================================
// APARTADO
// ============================================
#let apartado(letra: auto, tipo: "letra", puntos: none, body) = {
  let lbl = if letra == auto { aplicar-contador(contador-apartados, tipo: tipo) } else { letra }
  let header = [ #text(weight: "bold", fill: accent-ap, size: 0.9em)[#lbl).] ]
  if puntos != none { header = [#header  #text(fill: theme-muted, size: 0.85em)[(#puntos puntos)]] }
  [ #header  #body ]
}

// ============================================
// PREGUNTA MÚLTIPLE
// ============================================
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

// ============================================
// VERDADERO / FALSO
// ============================================
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

// ============================================
// ESPACIO DE DESARROLLO
// ============================================
#let espacio-desarrollo(lineas: 5, puntos: false, body) = {
  if puntos {
    for i in range(lineas) {
      v(0.6em)
      box(width: 100%, line(length: 100%, stroke: 0.5pt + theme-muted))
    }
  } else { v(lineas * 0.8em) }
}

// ============================================
// RESPUESTA CORTA
// ============================================
#let respuesta-corta(lineas: 3, body) = {
  text(fill: theme-text, weight: "bold")[#body]
  for i in range(lineas) {
    v(0.5em)
    line(length: 100%, stroke: 0.3pt + theme-muted)
  }
  v(0.5em)
}
