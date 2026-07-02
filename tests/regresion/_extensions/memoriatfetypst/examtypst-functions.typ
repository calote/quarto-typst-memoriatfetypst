// Funciones de examtypst para usar con memoriatfetypst
// Incluir via include-in-header en Quarto

// Colores de tema
#let theme-primary = rgb("#2563eb")
#let theme-secondary = rgb("#7c3aed")
#let theme-bg = rgb("#f8f9fa")
#let theme-text = rgb("#1a1a2e")
#let theme-sol-bg = rgb("#f0fdf4")
#let theme-sol-border = rgb("#22c55e")
#let theme-ej-border = rgb("#2563eb")
#let theme-header = rgb("#475569")
#let theme-correct = rgb("#16a34a")

// Contadores
#let contador-ejercicios = counter("ejercicio")
#let contador-apartados = counter("apartado")
#let contador-vf = counter("verdadero-falso")

#let reiniciar-apartados() = { contador-apartados.update(0) }
#let reiniciar-vf() = { contador-vf.update(0) }

// Generar etiquetas (a, b, c... / A, B, C... / 1, 2, 3...)
#let generar-etiqueta(numero, tipo: "letra") = {
  if tipo == "letra" { str.from-unicode(96 + numero) }
  else if tipo == "numero" { str(numero) }
  else if tipo == "romano" { numbering("i", numero) }
  else if tipo == "LETRA" { str.from-unicode(64 + numero) }
  else if tipo == "ROMANO" { numbering("I", numero) }
  else { "•" }
}

// Aplicar contador automático
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

// Símbolos check/empty
#let CajaCheck() = text(fill: theme-correct, weight: "bold")[✔]
#let CajaNoCheck() = text(fill: theme-header)[□]

// ============================================
// EJERCICIO
// ============================================
#let ejercicio(title: none, puntos: none, body) = {
  reiniciar-apartados()
  reiniciar-vf()
  context {
    contador-ejercicios.step()
    let n = contador-ejercicios.get().first()
    let header = if title != none { [*Ejercicio #n.* #title] }
      else { [*Ejercicio #n*] }
    if puntos != none { header = [#header  (#puntos puntos)] }
    block(
      breakable: true, width: 100%,
      stroke: 1pt + theme-ej-border, inset: 10pt, radius: 3pt,
      fill: theme-bg,
    )[
      #text(weight: "bold", fill: theme-text)[#header]
      #v(0.3em)
      #text(fill: theme-text)[#body]
    ]
  }
}

// ============================================
// SOLUCIÓN
// ============================================
#let solucion(body) = {
  block(
    fill: theme-sol-bg, stroke: 1pt + theme-sol-border,
    radius: 4pt, inset: 10pt, width: 100%,
    above: 0.8em, below: 0.8em,
    [*Solución:*  #body]
  )
}

// ============================================
// APARTADO
// ============================================
#let apartado(letra: auto, tipo: "letra", puntos: none, body) = {
  let lbl = if letra == auto { aplicar-contador(contador-apartados, tipo: tipo) } else { letra }
  let header = [ *#lbl)* ]
  if puntos != none { header = [#header  (#puntos puntos)] }
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

// ============================================
// VERDADERO / FALSO
// ============================================
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

// ============================================
// ESPACIO DE DESARROLLO
// ============================================
#let espacio-desarrollo(lineas: 5, puntos: false, body) = {
  if puntos {
    for i in range(lineas) {
      v(0.8em)
      box(width: 100%, line(length: 100%, stroke: 0.5pt + theme-header.lighten(40%)))
    }
  } else { v(lineas * 1em) }
}

// ============================================
// PREGUNTA MÚLTIPLE MARKDOWN (con #opc en body)
// ============================================
#let pregunta-multiple-md(body, opciones: (), correcta: none, columnas: 1) = {
  pregunta-multiple(
    enunciado: body, opciones: opciones, correcta: correcta,
    columnas: columnas, numeracion: false, opciones-tipo: "LETRA"
  )
}

// ============================================
// RESPUESTA CORTA
// ============================================
#let respuesta-corta(lineas: 3, body) = {
  text(fill: theme-text)[#body]
  for i in range(lineas) {
    v(0.6em)
    line(length: 100%, stroke: 0.5pt + theme-header)
  }
  v(0.5em)
}

// ============================================
// COMPLETAR DEFINICIONES
// ============================================
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
