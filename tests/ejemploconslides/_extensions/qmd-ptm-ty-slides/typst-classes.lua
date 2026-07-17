--[[
typst-classes.lua
=================
Filtro Pandoc que convierte spans y divs con clases específicas
en llamadas a funciones o alineaciones Typst.

USO EN EL .qmd
══════════════

ALINEACIÓN (Div únicamente):
  :::{.center}        →  #align(center)[...]
  contenido
  :::

  :::{.right}         →  #align(right)[...]
  :::

  :::{.left}          →  #align(left)[...]   (normalmente ya es el default)
  :::

  También acepta el atributo `align` para alineación vertical:
    :::{.center align="horizon"}   →  #align(center + horizon)[...]

FUNCIONES TYPST (Span inline y Div bloque):
  [texto]{.alert}     →  #alert[texto]
  [texto]{.emph}      →  #emph[texto]

  :::{.alert}         →  #alert[
  contenido               contenido
  :::                 →  ]

AÑADIR MÁS FUNCIONES:
  Añade una línea a la tabla TYPST_FUNCTIONS con { clase = "nombre-función" }.
]]

-- ── Funciones Typst reconocidas (clase → nombre de función) ──────────────────
local TYPST_FUNCTIONS = {
  alert  = "alert",
  emph   = "emph",
}

-- ── Clases de alineación reconocidas ─────────────────────────────────────────
local ALIGN_CLASSES = {
  center = "center",
  right  = "right",
  left   = "left",
}

-- ── Serializa contenido Pandoc a código Typst (sin cabecera de plantilla) ────
local function to_typst(content_list, is_blocks)
  local doc
  if is_blocks then
    doc = pandoc.Pandoc(content_list)
  else
    doc = pandoc.Pandoc({ pandoc.Plain(content_list) })
  end
  -- pandoc.write() en un filtro Lua produce salida no-standalone por defecto,
  -- así que no es necesario especificar opciones adicionales.
  return pandoc.write(doc, "typst"):gsub("^%s+", ""):gsub("%s+$", "")
end

-- ── Spans (inline) ────────────────────────────────────────────────────────────
function Span(el)
  for class, fn in pairs(TYPST_FUNCTIONS) do
    if el.classes:includes(class) then
      local inner = to_typst(el.content, false)
      return pandoc.RawInline("typst", "#" .. fn .. "[" .. inner .. "]")
    end
  end
end

-- ── Divs (bloque) ─────────────────────────────────────────────────────────────
function Div(el)
  -- Alineación horizontal (center / right / left)
  for class, align in pairs(ALIGN_CLASSES) do
    if el.classes:includes(class) then
      -- Alineación vertical adicional vía atributo: :::{.center align="horizon"}
      local valign = el.attributes["align"]
      local align_expr = valign and (align .. " + " .. valign) or align
      local inner = to_typst(el.content, true)
      return pandoc.RawBlock("typst",
        "#align(" .. align_expr .. ")[\n" .. inner .. "\n]"
      )
    end
  end

  -- Funciones Typst genéricas
  for class, fn in pairs(TYPST_FUNCTIONS) do
    if el.classes:includes(class) then
      local inner = to_typst(el.content, true)
      return pandoc.RawBlock("typst", "#" .. fn .. "[\n" .. inner .. "\n]")
    end
  end
end
