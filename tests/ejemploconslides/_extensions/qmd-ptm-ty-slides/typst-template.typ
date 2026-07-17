// typst-template.typ
// Plantilla principal para touying-slides
// Integra el paquete Touying con el tema "metropolis"

#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

// ── Función principal del documento ──────────────────────────────────────────
//
// Mapa de parámetros de color a colores internos de Metropolis:
//
//   header-color   → secondary    : fondo de la barra de título en cada slide
//   section-color  → neutral-dark : fondo de las diapositivas de sección (H1)
//   accent-color   → primary      : barra de progreso y elemento de acento
//
// Si solo se pasa `header-color`, `section-color` toma el mismo valor.
// Si solo se pasa `accent-color`, la barra de progreso cambia de color.
//
#let slides(
  title: none,
  subtitle: none,
  author: none,
  date: none,
  institution: none,
  // Opciones visuales
  aspect-ratio: "16-9",
  handout: false,            // true → modo handout: colapsa los #pause, solo el paso final
  header-color: rgb("#003f72"),   // fondo barra de título (secondary)
  section-color: none,            // fondo sección H1 (neutral-dark); si none → header-color
  accent-color: rgb("#eb811b"),   // barra de progreso y acento (primary)
  // Contenido
  body,
) = {
  let sc = if section-color != none { section-color } else { header-color }

  // Configurar el tema Metropolis de Touying
  show: metropolis-theme.with(
    aspect-ratio: aspect-ratio,
    config-colors(
      primary:      accent-color,   // barra de progreso
      secondary:    header-color,   // fondo de la barra de título
      neutral-dark: sc,             // fondo de las diapositivas de sección
    ),
    // Por defecto touying colorea todo #strong con el color de acento.
    // Lo desactivamos para que la negrita sea solo negrita.
    config-common(show-strong-with-alert: false, handout: handout),
    config-info(
      title: title,
      subtitle: subtitle,
      author: author,
      date: date,
      institution: institution,
    ),
  )

  // Diapositiva de título automática
  title-slide()

  // Resto del contenido (las diapositivas generadas por el filtro Lua)
  body
}

// ── Helpers adicionales ───────────────────────────────────────────────────────

// Diapositiva de sección (usada por H1 en el filtro Lua)
// Usa focus-slide del tema Metropolis, que gestiona internamente
// el congelado del contador y el fondo de color corporativo.
// `body` se usa para inyectar el ancla de navegación (#metadata <label>)
// sin que touying interfiera con ella.
// `..args` acepta el bloque opcional [...]
// (en Typst, los corchetes tras una llamada son siempre argumento posicional)
#let section-slide(title: "", color: none, ..args) = {
  let body = if args.pos().len() > 0 { args.pos().at(0) } else { none }
  // Si se pasa `color`, sobreescribe el fill de la página para esta diapositiva.
  // focus-slide acepta `config:` que se aplica después de su configuración interna,
  // por lo que config-page(fill: color) anula el neutral-dark del tema.
  let cfg = if color != none { config-page(fill: color) } else { (:) }
  focus-slide(config: cfg)[
    #set text(weight: "bold")
    #if body != none { body }
    #title
  ]
}

// Diapositiva de tabla de contenidos
//   items     : array de dicts (text, lbl, level) generados por el filtro Lua
//   font-size : tamaño de fuente (p.ej. 0.9em), ajustable si el TOC es largo
//   title     : título de la diapositiva
//   columns   : número de columnas (1 = una columna, 2 = dos columnas, etc.)
//
// Cada entrada es un enlace PDF que salta a la diapositiva correspondiente.
// Los niveles > 1 se indentan 1.5em por nivel y se muestran en peso normal.
// Con columns >= 2, los ítems se reparten equitativamente entre columnas.
#let toc-slide(items: (), font-size: 1em, title: "Contenido", columns: 1) = slide(
  title: title,
)[
  #set text(size: font-size)
  // Helper: renderiza una columna de ítems TOC
  #let render-col(col-items) = stack(
    dir: ttb,
    spacing: 0.45em,
    ..col-items.map(item => pad(
      left: (item.level - 1) * 1.5em,
      if item.level == 1 {
        strong(link(label(item.lbl), item.text))
      } else {
        link(label(item.lbl), item.text)
      }
    ))
  )
  #if columns >= 2 {
    // Dividir ítems en N grupos iguales
    let n    = calc.max(1, columns)
    let size = calc.ceil(items.len() / n)
    let chunks = range(n).map(i => {
      let start = i * size
      let end   = calc.min(start + size, items.len())
      if start < items.len() { items.slice(start, end) } else { () }
    })
    grid(
      columns: range(n).map(_ => 1fr),
      column-gutter: 2em,
      ..chunks.map(chunk => render-col(chunk))
    )
  } else {
    render-col(items)
  }
]
