--[[
shortcodes.lua
==============
Shortcodes de la extensión touying-slides.

Uso en el .qmd:

  {{< pause >}}
      Inserta un punto de pausa en una diapositiva. El contenido posterior
      aparece en el siguiente paso del overlay (#pause de Touying).
      No-op silencioso si el formato activo no es touying-slides-typst.

  {{< fontsize 0.8em >}}
      Reduce (o aumenta) el tamaño de fuente para el resto de la
      diapositiva actual. El valor puede ser relativo (0.8em, 1.2em)
      o absoluto (16pt, 20pt).
      Scope: solo afecta a la diapositiva en la que se usa, ya que
      Typst limita los `set` rules al bloque de contenido de la slide.
      No-op silencioso si el formato activo no es touying-slides-typst.

Detección de formato:
  `quarto.doc.is_format("touying-slides-typst")` no devuelve true de forma
  fiable para formatos de extensión en la API de shortcodes. En su lugar, se
  detecta el formato comprobando la clave `touying-slides-format` en los
  metadatos del documento: esta clave se define en los defaults de
  _extension.yml, por lo que solo estará presente cuando el formato activo
  sea touying-slides-typst.
]]

-- Devuelve true solo cuando el formato activo es touying-slides-typst.
-- La detección se basa en la clave `touying-slides-format` inyectada por
-- los defaults de _extension.yml; no aparece en format: typst estándar.
-- Excepción explícita: si `formato-typst-a4` está presente y es true,
-- devuelve false aunque touying-slides-format esté inyectado por Quarto
-- al cargar los shortcodes de la extensión en el contexto del proyecto.
local function is_truthy(val)
  if val == nil then return false end
  if type(val) == "boolean" then return val end
  local s = pandoc.utils.stringify(val):lower()
  return s == "true" or s == "yes" or s == "1"
end

local function is_touying(meta)
  if meta == nil then return false end
  -- Si estamos en modo A4, nunca es touying aunque el default esté inyectado
  if is_truthy(meta["formato-typst-a4"]) then return false end
  return is_truthy(meta["touying-slides-format"])
end

-- {{< pause >}} ──────────────────────────────────────────────────────────────
local function pause(args, kwargs, meta)
  if not is_touying(meta) then
    return pandoc.Blocks {}
  end
  return pandoc.Blocks { pandoc.RawBlock("typst", "#pause") }
end

-- {{< fontsize 0.8em >}} ─────────────────────────────────────────────────────
local function fontsize(args, kwargs, meta)
  if not is_touying(meta) then
    return pandoc.Blocks {}
  end
  if #args == 0 then
    io.stderr:write("[touying-slides] shortcode 'fontsize' requires a size argument (e.g. 0.8em)\n")
    return pandoc.Blocks {}
  end
  local size = pandoc.utils.stringify(args[1])
  return pandoc.Blocks {
    pandoc.RawBlock("typst", "#set text(size: " .. size .. ")")
  }
end

return {
  ["pause"]    = pause,
  ["fontsize"] = fontsize,
}
