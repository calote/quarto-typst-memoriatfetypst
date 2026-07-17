--[[
slides-headings.lua
====================
Filtro Quarto/Pandoc que transforma encabezados de nivel 1–5
en diapositivas de Touying (Typst).

Comportamiento por defecto (slide-level: 2):
  - `#`     (H1): Diapositiva de sección (fondo de color)
  - `##–#####` (H2–H5): Diapositiva normal con título

Parámetros YAML:
  section-level   : int    – Nivel mínimo de heading para slides de contenido.
                             Los niveles MENORES se convierten en section-slides.
                             Valor por defecto: 2
                             Ejemplos:
                               section-level: 1  → todos los headings son slides de contenido
                               section-level: 2  → H1=sección,  H2–H5=título  (defecto)
                               section-level: 3  → H1–H2=sección, H3–H5=título
  slide-numbering : bool   – Prefijo "1.2.3 Título" en cada diapositiva
  toc-slide       : bool   – Insertar diapositiva de tabla de contenidos
  toc-levels      : int    – Profundidad del TOC (1=solo #, 2=# y ##, ...)
  toc-font-size   : string – Tamaño de fuente del TOC (p.ej. "0.8em")
  toc-title       : string – Título de la diapositiva TOC
  primary-color   : string – Color principal en hex (con o sin "#")
]]

-- ── Utilidades ────────────────────────────────────────────────────────────────

local function inlines_to_text(inlines)
  local result = {}
  for _, inline in ipairs(inlines) do
    if     inline.t == "Str"       then table.insert(result, inline.text)
    elseif inline.t == "Space"     then table.insert(result, " ")
    elseif inline.t == "SoftBreak" then table.insert(result, " ")
    elseif inline.t == "LineBreak" then table.insert(result, " ")
    elseif inline.t == "Emph"      then table.insert(result, inlines_to_text(inline.content))
    elseif inline.t == "Strong"    then table.insert(result, inlines_to_text(inline.content))
    elseif inline.t == "Code"      then table.insert(result, inline.text)
    end
  end
  return table.concat(result)
end

-- Convierte una expresión LaTeX math al equivalente Typst.
-- Cubre los casos más habituales en títulos de diapositivas
-- (subíndices, superíndices, letras griegas, fracciones, acentos).
local function latex_to_typst_math(s)
  -- 1. \frac{num}{den} → (num)/(den)  [puede haber fracciones anidadas]
  local changed = true
  while changed do
    local new_s = s:gsub("\\frac%s*(%b{})%s*(%b{})", function(num, den)
      return "(" .. num:sub(2,-2) .. ")/(" .. den:sub(2,-2) .. ")"
    end)
    changed = (new_s ~= s)
    s = new_s
  end
  -- 2. Comandos con un argumento: \cmd{arg} → mapped(arg)
  s = s:gsub("\\(%a+)%s*(%b{})", function(cmd, braces)
    local arg = braces:sub(2, -2)
    local m = {
      bar="overline", overline="overline", widehat="hat", hat="hat",
      tilde="tilde", widetilde="tilde", vec="arrow", dot="dot",
      ddot="dot.double", dddot="dot.triple", grave="grave", acute="acute",
      check="caron", breve="breve", underline="underline", underbar="underline",
      sqrt="sqrt", text="upright", mathrm="upright", mathbf="bold",
      mathit="italic", mathcal="cal", boldsymbol="bold",
    }
    local inner = latex_to_typst_math(arg)
    return (m[cmd] or cmd) .. "(" .. inner .. ")"
  end)
  -- 3. Comandos sin argumento: \cmd → símbolo Typst equivalente
  s = s:gsub("\\(%a+)", function(cmd)
    local m = {
      -- Griegas minúsculas
      alpha="alpha", beta="beta", gamma="gamma", delta="delta",
      epsilon="epsilon", varepsilon="epsilon.alt", zeta="zeta", eta="eta",
      theta="theta", vartheta="theta.alt", iota="iota", kappa="kappa",
      lambda="lambda", mu="mu", nu="nu", xi="xi", pi="pi", varpi="pi.alt",
      rho="rho", varrho="rho.alt", sigma="sigma", varsigma="sigma.alt",
      tau="tau", upsilon="upsilon", phi="phi.alt", varphi="phi",
      chi="chi", psi="psi", omega="omega",
      -- Griegas mayúsculas
      Gamma="Gamma", Delta="Delta", Theta="Theta", Lambda="Lambda",
      Xi="Xi", Pi="Pi", Sigma="Sigma", Upsilon="Upsilon",
      Phi="Phi", Psi="Psi", Omega="Omega",
      -- Operadores y relaciones
      cdot="dot.op", times="times", div="div.op",
      pm="plus.minus", mp="minus.plus",
      leq="lt.eq", le="lt.eq", geq="gt.eq", ge="gt.eq",
      neq="eq.not", ne="eq.not", approx="approx", sim="tilde.op",
      equiv="equiv", propto="prop",
      -- Conjuntos
      ["in"]="in", notin="in.not", subset="subset", supset="supset",
      cup="union", cap="sect",
      -- Miscelánea
      infty="infinity", partial="partial", nabla="nabla",
      sum="sum", prod="product", int="integral",
      ldots="dots.h", cdots="dots.c", vdots="dots.v",
      to="arrow.r", rightarrow="arrow.r", leftarrow="arrow.l",
      quad="wide",
    }
    return m[cmd] or cmd  -- si no está en el mapa, quitar el backslash igualmente
  end)

  -- 4. Post-proceso: separar subíndice/superíndice de una letra o número
  --    cuando va seguido directamente de otra letra, para evitar que Typst
  --    los interprete como un identificador multi-letra (variable desconocida).
  --    Ejemplos: {}_nM_x → {}_n M_x,  _1M_x → _1 M_x,  e^oM → e^o M
  s = s:gsub("([_%^])(%a)(%a)", "%1%2 %3")
  s = s:gsub("([_%^])(%d+)(%a)", "%1%2 %3")

  return s
end

-- Convierte inlines de Pandoc a contenido Typst (para usar dentro de [...]).
-- A diferencia de inlines_to_text, preserva las matemáticas convirtiéndolas
-- a sintaxis Typst mediante latex_to_typst_math.
local function inlines_to_typst_content(inlines)
  if not inlines or #inlines == 0 then return "" end
  local result = {}
  for _, inline in ipairs(inlines) do
    if inline.t == "Str" then
      -- Escapar caracteres que Typst interpreta en modo contenido
      local s = inline.text
        :gsub("\\", "\\\\")
        :gsub("#",  "\\#")
        :gsub("%$", "\\$")
        :gsub("%[", "\\[")
        :gsub("%]", "\\]")
      table.insert(result, s)
    elseif inline.t == "Space"
        or inline.t == "SoftBreak"
        or inline.t == "LineBreak" then
      table.insert(result, " ")
    elseif inline.t == "Emph" then
      table.insert(result, "_" .. inlines_to_typst_content(inline.content) .. "_")
    elseif inline.t == "Strong" then
      table.insert(result, "*" .. inlines_to_typst_content(inline.content) .. "*")
    elseif inline.t == "Code" then
      table.insert(result, "`" .. inline.text .. "`")
    elseif inline.t == "Math" then
      local typst_math = latex_to_typst_math(inline.text)
      if inline.mathtype == "InlineMath" then
        table.insert(result, "$" .. typst_math .. "$")
      else
        table.insert(result, "$ " .. typst_math .. " $")
      end
    elseif inline.t == "RawInline" and inline.format == "typst" then
      table.insert(result, inline.text)
    end
  end
  return table.concat(result)
end

local function escape_typst(s)
  return s:gsub('"', '\\"')
end

local function meta_bool(meta, key, default)
  if meta[key] == nil then return default end
  local v = meta[key]
  if type(v) == "boolean" then return v end
  local s = pandoc.utils.stringify(v):lower()
  if s == "true"  or s == "yes" or s == "1" then return true  end
  if s == "false" or s == "no"  or s == "0" then return false end
  return default
end

-- Lee un parámetro de color del metadata y lo normaliza:
--   nil / YAML null → devuelve default
--   "none" / "None" → devuelve nil  (sin fondo)
--   "#rrggbb" / "rrggbb" → devuelve "rrggbb" (sin "#")
local function normalize_code_color(meta, key, default)
  local raw = meta[key]
  if raw == nil then return default end
  local ok, val = pcall(function() return pandoc.utils.stringify(raw) end)
  if not ok or val == nil or val == "" then return default end
  val = val:gsub("^#", "")
  if val:lower() == "none" then return nil end
  return val
end

-- Envuelve bloques de código Quarto en bloques Typst coloreados.
-- Maneja tanto CodeBlock directos (bloques estáticos ```r```) como
-- la estructura Div que genera Quarto para celdas ejecutadas ({r}):
--   Div.cell  →  desempaquetar y procesar hijos
--   Div.cell-code  →  código fuente, fondo code_bg
--   Div.cell-output* → salidas, fondo output_bg
local function wrap_code_block(block, code_bg, output_bg, code_text)

  -- ── CodeBlock directo ─────────────────────────────────────────────────────
  if block.t == "CodeBlock" then
    local is_output = false
    for _, cls in ipairs(block.classes) do
      if cls:find("^cell%-output") then is_output = true; break end
    end
    local bg = is_output and output_bg or code_bg
    if not bg then return pandoc.List { block } end
    local result = pandoc.List()
    result:insert(pandoc.RawBlock("typst",
      '#block(fill: rgb("' .. bg .. '"), width: 100%)['
    ))
    if code_text and not is_output then
      result:insert(pandoc.RawBlock("typst",
        '#set text(fill: rgb("' .. code_text .. '"))'
      ))
    end
    result:insert(block)
    result:insert(pandoc.RawBlock("typst", "]"))
    return result
  end

  -- ── Divs de Quarto ────────────────────────────────────────────────────────
  if block.t == "Div" then

    -- Div.cell: contenedor de la celda ejecutada → desempaquetar y procesar hijos
    if block.classes:includes("cell") then
      local result = pandoc.List()
      for _, child in ipairs(block.content) do
        for _, wb in ipairs(wrap_code_block(child, code_bg, output_bg, code_text)) do
          result:insert(wb)
        end
      end
      return result
    end

    -- Div.cell-code: código fuente de la celda → fondo code_bg
    if block.classes:includes("cell-code") then
      if not code_bg then return pandoc.List { block } end
      local result = pandoc.List()
      result:insert(pandoc.RawBlock("typst",
        '#block(fill: rgb("' .. code_bg .. '"), width: 100%)['
      ))
      if code_text then
        result:insert(pandoc.RawBlock("typst",
          '#set text(fill: rgb("' .. code_text .. '"))'
        ))
      end
      for _, child in ipairs(block.content) do result:insert(child) end
      result:insert(pandoc.RawBlock("typst", "]"))
      return result
    end

    -- Div.cell-output*: salidas de la celda → fondo output_bg
    for _, cls in ipairs(block.classes) do
      if cls:find("^cell%-output") then
        if not output_bg then
          -- sin fondo: desempaquetar sin bloque coloreado
          local result = pandoc.List()
          for _, child in ipairs(block.content) do result:insert(child) end
          return result
        end
        local result = pandoc.List()
        result:insert(pandoc.RawBlock("typst",
          '#block(fill: rgb("' .. output_bg .. '"), width: 100%)['
        ))
        for _, child in ipairs(block.content) do result:insert(child) end
        result:insert(pandoc.RawBlock("typst", "]"))
        return result
      end
    end

  end

  -- Todo lo demás: sin cambios
  return pandoc.List { block }
end



-- ── Columnas ──────────────────────────────────────────────────────────────────
--
-- Convierte un Div con clase "cols" en un #grid de Typst.
-- Si el bloque no es un .cols, lo devuelve sin tocar (en una lista de 1 elemento).
-- Se llama tanto desde el bucle principal como al procesar el contenido de un slide.
--
-- Uso en el .qmd:
--   ::::{.cols}                    (gutter opcional: ::::{.cols gutter="1em"})
--   :::::{.col}
--   Contenido columna izquierda
--   :::::
--   :::::{.col}
--   Contenido columna derecha
--   :::::
--   ::::
local function process_cols(block)
  if not (block.t == "Div" and block.classes:includes("cols")) then
    return pandoc.List { block }
  end

  local gutter = block.attributes["gutter"] or "2em"
  local col_contents = {}
  for _, child in ipairs(block.content) do
    if child.t == "Div" and child.classes:includes("col") then
      table.insert(col_contents, child.content)
    end
  end

  if #col_contents < 2 then
    -- Sin columnas suficientes: pasar el div tal cual
    return pandoc.List { block }
  end

  local widths = {}
  for j = 1, #col_contents do table.insert(widths, "1fr") end
  local cols_str = "(" .. table.concat(widths, ", ") .. ")"

  local result = pandoc.List()
  result:insert(pandoc.RawBlock("typst",
    "#grid(columns: " .. cols_str .. ", gutter: " .. gutter .. ",["
  ))
  for j, col_content in ipairs(col_contents) do
    for _, cb in ipairs(col_content) do
      result:insert(cb)
    end
    if j < #col_contents then
      result:insert(pandoc.RawBlock("typst", "],["))
    else
      result:insert(pandoc.RawBlock("typst", "])"))
    end
  end
  return result
end

-- ── Contador jerárquico ───────────────────────────────────────────────────────

local counters = {0, 0, 0, 0, 0}

local function bump(lvl)
  counters[lvl] = counters[lvl] + 1
  for l = lvl + 1, 5 do counters[l] = 0 end
end

local function make_prefix(lvl)
  local parts = {}
  for l = 1, lvl do table.insert(parts, tostring(counters[l])) end
  return table.concat(parts, ".") .. " "
end

-- Versión del cálculo de prefijo para el pre-paso (usa tabla local)
local function make_prefix_with(ctrs, lvl)
  local parts = {}
  for l = 1, lvl do table.insert(parts, tostring(ctrs[l])) end
  return table.concat(parts, ".") .. " "
end

-- ── Filtro principal ──────────────────────────────────────────────────────────

function Pandoc(doc)
  local numbering  = meta_bool(doc.meta, "slide-numbering", false)
  local show_toc   = meta_bool(doc.meta, "toc-slide", false)
  local is_handout = meta_bool(doc.meta, "handout", false)

  -- ── slide-level: nivel mínimo para slides de contenido ──────────────────────
  -- Niveles 1 .. slide_level-1  →  section-slide (fondo de color)
  -- Niveles slide_level .. 5    →  slide con título
  -- Valor por defecto: 2  (comportamiento original: H1=sección, H2–H5=título)
  local slide_level = 2
  if doc.meta["section-level"] then
    local v = tonumber(pandoc.utils.stringify(doc.meta["section-level"]))
    if v then
      slide_level = math.max(1, math.min(6, math.floor(v)))
    end
  end
  local toc_depth = 1
  if doc.meta["toc-levels"] then
    toc_depth = tonumber(pandoc.utils.stringify(doc.meta["toc-levels"])) or 1
  end

  local toc_font_size = "1em"
  if doc.meta["toc-font-size"] then
    toc_font_size = pandoc.utils.stringify(doc.meta["toc-font-size"])
  end

  local toc_title = "Contenido"
  if doc.meta["toc-title"] then
    toc_title = pandoc.utils.stringify(doc.meta["toc-title"])
  end

  local toc_columns = 1
  if doc.meta["toc-columns"] then
    toc_columns = tonumber(pandoc.utils.stringify(doc.meta["toc-columns"])) or 1
    toc_columns = math.max(1, math.floor(toc_columns))
  end

  -- ── Normalizar colores de tema: quitar "#" inicial para Typst rgb() ──────────
  for _, key in ipairs({ "header-color", "section-color", "accent-color", "primary-color" }) do
    if doc.meta[key] then
      local color = pandoc.utils.stringify(doc.meta[key]):gsub("^#", "")
      doc.meta[key] = pandoc.MetaInlines({ pandoc.Str(color) })
    end
  end
  -- Compatibilidad: si el usuario usa el antiguo primary-color, mapearlo a header-color
  if doc.meta["primary-color"] and not doc.meta["header-color"] then
    doc.meta["header-color"] = doc.meta["primary-color"]
  end

  -- ── Colores de bloques de código ─────────────────────────────────────────────
  -- Leídos como variables Lua locales; los bloques se envuelven en Typst
  -- con wrap_code_block() en lugar de usar template variables de Pandoc.
  local code_bg   = normalize_code_color(doc.meta, "code-bg-color",  "e8f0fe")
  local output_bg = normalize_code_color(doc.meta, "output-bg-color", "f0f4e8")
  local code_text = normalize_code_color(doc.meta, "code-text-color", nil)

  -- ── Colores por nivel de sección ──────────────────────────────────────────────
  -- section-color-N sobrescribe el color de fondo de las diapositivas de sección
  -- del nivel N (cuando section-level > 2 hay múltiples niveles de sección).
  -- Nivel 1 ya está cubierto por `section-color` (vía typst-show.typ).
  -- Ejemplo YAML:  section-color-2: "#7B241C"   # H2 → rojo oscuro
  --                section-color-3: "#1A5276"   # H3 → azul oscuro
  local section_level_colors = {}
  for lvl = 1, 5 do
    section_level_colors[lvl] = normalize_code_color(doc.meta, "section-color-" .. lvl, nil)
  end

  -- ── Pre-paso: asignar etiquetas a todos los headings y recoger items TOC ─────
  --
  -- Se hace en un único recorrido sobre doc.blocks para que las etiquetas
  -- (toc-slide-N) sean consistentes entre el pre-paso y el bucle principal.
  -- label_by_idx[i] = etiqueta del heading en la posición i de doc.blocks.

  local label_by_idx = {}
  local toc_items    = {}

  do
    local slide_counter  = 0
    local temp_counters  = {0, 0, 0, 0, 0}

    for idx, block in ipairs(doc.blocks) do
      if block.t == "Header" and block.level >= 1 and block.level <= 5 then
        slide_counter = slide_counter + 1
        local lbl = "toc-slide-" .. slide_counter
        label_by_idx[idx] = lbl

        -- Acumular en TOC solo los niveles solicitados
        if show_toc and block.level <= toc_depth then
          local title         = inlines_to_text(block.content)
          local typst_content = inlines_to_typst_content(block.content)
          if numbering then
            temp_counters[block.level] = temp_counters[block.level] + 1
            for l = block.level + 1, 5 do temp_counters[l] = 0 end
            local prefix = make_prefix_with(temp_counters, block.level)
            title         = prefix .. title
            typst_content = prefix .. typst_content
          end
          table.insert(toc_items, {
            level   = block.level,
            text    = title,          -- texto plano (no usado en el TOC pero útil para depuración)
            content = typst_content,  -- contenido Typst con math incluido
            lbl     = lbl,
          })
        end
      end
    end
  end

  -- ── Construir el documento ────────────────────────────────────────────────────

  local new_blocks = pandoc.List()

  -- Diapositiva TOC (va antes del contenido, tras la portada automática)
  if show_toc and #toc_items > 0 then
    local typst_items = {}
    for _, item in ipairs(toc_items) do
      table.insert(typst_items, string.format(
        '(text: [%s], lbl: "%s", level: %d)',
        item.content, item.lbl, item.level
      ))
    end
    local items_str = "(" .. table.concat(typst_items, ", ") .. ",)"
    new_blocks:insert(pandoc.RawBlock("typst",
      '#toc-slide(' ..
        'items: '    .. items_str               .. ', ' ..
        'font-size: '.. toc_font_size           .. ', ' ..
        'columns: '  .. toc_columns             .. ', ' ..
        'title: "'   .. escape_typst(toc_title) .. '"'  ..
      ')'
    ))
  end

  -- ── Helper: emitir slides de contenido, dividiendo en `---` ─────────────────
  -- Divide `content` (lista de bloques) en segmentos separados por HorizontalRule.
  -- El `first_title` y el `anchor` se colocan en el primer segmento NO VACÍO,
  -- de modo que si el contenido empieza con "------" el título no se pierde.
  -- Los segmentos siguientes crean slides con title: none.
  local function emit_content_slides(content, first_title, anchor)
    local segments = {}
    local current = pandoc.List()
    for _, b in ipairs(content) do
      if b.t == "HorizontalRule" then
        table.insert(segments, current)
        current = pandoc.List()
      else
        current:insert(b)
      end
    end
    table.insert(segments, current)

    -- Determinar en qué segmento se colocan el título y el ancla.
    -- Si el primer segmento está vacío, se trasladan al primer segmento no vacío
    -- para que el título aparezca sobre el contenido real y no en una diapositiva
    -- vacía (esto ocurre cuando el heading va seguido inmediatamente de "------").
    local title_seg = 1
    if #segments[1] == 0 then
      for si = 2, #segments do
        if #segments[si] > 0 then
          title_seg = si
          break
        end
      end
    end

    for seg_idx, segment in ipairs(segments) do
      local is_title   = (seg_idx == title_seg)
      local has_anchor = is_title and (anchor ~= nil)
      if #segment == 0 and not has_anchor then
        -- segmento vacío sin título ni ancla: ignorar
      else
        local title_str
        if is_title and first_title ~= nil then
          title_str = first_title  -- ya formateado como "[contenido Typst]"
        else
          title_str = "none"
        end
        new_blocks:insert(pandoc.RawBlock("typst", '#slide(title: ' .. title_str .. ')['))
        if has_anchor then
          new_blocks:insert(pandoc.RawBlock("typst", anchor))
        end
        for _, cb in ipairs(segment) do
          for _, pb in ipairs(process_cols(cb)) do
            for _, wb in ipairs(wrap_code_block(pb, code_bg, output_bg, code_text)) do
              new_blocks:insert(wb)
            end
          end
        end
        new_blocks:insert(pandoc.RawBlock("typst", ']'))
      end
    end
  end

  -- Bucle principal: convertir headings en diapositivas según slide-level
  local i = 1
  local blocks = doc.blocks

  while i <= #blocks do
    local block = blocks[i]

    -- Niveles 1 .. slide_level-1 → diapositiva de sección (fondo de color)
    if block.t == "Header" and block.level >= 1 and block.level < slide_level then
      local raw_title    = inlines_to_text(block.content)
      local typst_content = inlines_to_typst_content(block.content)
      if numbering then
        bump(block.level)
        local prefix = make_prefix(block.level)
        raw_title    = prefix .. raw_title
        typst_content = prefix .. typst_content
      end
      local lbl = label_by_idx[i] or ("toc-slide-unlabeled-" .. i)
      -- Color: section-color-N sobrescribe el color del nivel N; de lo contrario
      -- section-slide usa el neutral-dark del tema (= section-color en YAML).
      local lvl_color = section_level_colors[block.level]
      local color_arg = lvl_color and (', color: rgb("' .. lvl_color .. '")') or ""
      -- El ancla va DENTRO del body para que touying no interfiera
      new_blocks:insert(pandoc.RawBlock("typst",
        '#section-slide(title: [' .. typst_content .. ']' .. color_arg .. ')[#metadata(none) <' .. lbl .. '>]'
      ))
      i = i + 1

      -- Recoger contenido hasta el próximo heading.
      -- Con section-level > 2 puede haber contenido entre un section-slide y el
      -- siguiente heading: se envuelve en slides (dividiendo en --- si los hay).
      local section_content = pandoc.List()
      while i <= #blocks do
        local nb = blocks[i]
        if nb.t == "Header" and nb.level >= 1 and nb.level <= 5 then break end
        section_content:insert(nb)
        i = i + 1
      end
      if #section_content > 0 then
        local title_typst = typst_content ~= "" and ("[" .. typst_content .. "]") or nil
        emit_content_slides(section_content, title_typst, nil)
      end

    -- Niveles slide_level .. 5 → diapositiva normal con título
    elseif block.t == "Header" and block.level >= slide_level and block.level <= 5 then
      local lvl          = block.level
      local raw_title    = inlines_to_text(block.content)
      local typst_content = inlines_to_typst_content(block.content)
      if numbering then
        bump(lvl)
        local prefix = make_prefix(lvl)
        raw_title    = prefix .. raw_title
        typst_content = prefix .. typst_content
      end
      local lbl = label_by_idx[i] or ("toc-slide-unlabeled-" .. i)

      -- Recoger contenido hasta el siguiente heading (cualquier nivel H1–H5)
      local slide_content = pandoc.List()
      i = i + 1
      while i <= #blocks do
        local nb = blocks[i]
        if nb.t == "Header" and nb.level >= 1 and nb.level <= 5 then break end
        slide_content:insert(nb)
        i = i + 1
      end

      -- El helper emit_content_slides divide el contenido en "---" y emite
      -- el primer segmento con el título del heading (y el ancla),
      -- los segmentos adicionales como slides sin título.
      --
      -- En modo normal se usa #only(1)[#metadata...] para evitar etiquetas
      -- duplicadas cuando la diapositiva tiene #pause (Touying genera una
      -- página por paso y el contenido se repite en cada una).
      -- En modo handout Touying produce UNA sola página por slide (el último
      -- paso), así que #only(1) ocultaría el ancla → etiqueta no encontrada.
      -- Sin #only(1) en handout no hay duplicados porque solo hay una página.
      local title_typst = typst_content ~= "" and ("[" .. typst_content .. "]") or nil
      local anchor
      if is_handout then
        anchor = '\n#metadata(none) <' .. lbl .. '>'
      else
        anchor = '\n#only(1)[#metadata(none) <' .. lbl .. '>]'
      end
      emit_content_slides(slide_content, title_typst, anchor)

    else
      -- Bloque genérico: procesar .cols y código coloreado
      for _, pb in ipairs(process_cols(block)) do
        for _, wb in ipairs(wrap_code_block(pb, code_bg, output_bg, code_text)) do
          new_blocks:insert(wb)
        end
      end
      i = i + 1
    end
  end

  return pandoc.Pandoc(new_blocks, doc.meta)
end
