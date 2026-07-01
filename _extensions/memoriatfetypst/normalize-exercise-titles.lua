-- normalize-exercise-titles.lua
-- Filtro para normalizar title: none → title: "" en bloques de ejercicios/teoremas
-- Se ejecuta ANTES de que Pandoc genere el código Typst final

function Div(el)
  -- Detectar divs con ID que comienzan con prefijos de teoremas
  local id = el.identifier or ""
  local theorem_prefixes = {"def-", "thm-", "lem-", "cor-", "prp-", "exm-", "exr-", "proof", "solution"}
  
  local is_theorem = false
  for _, prefix in ipairs(theorem_prefixes) do
    if id:find("^" .. prefix) then
      is_theorem = true
      break
    end
  end
  
  if not is_theorem then
    return el
  end
  
  -- Si es un bloque de teorema/definición/ejercicio, procesamos
  -- Buscamos si tiene un encabezado de nivel 5 (##### Título)
  local has_title = false
  local title_level = 5
  
  for i, block in ipairs(el.content) do
    if block.t == "Header" and block.level == title_level then
      has_title = true
      break
    end
  end
  
  -- Si NO tiene título nivel 5, agregamos metadata que Pandoc usará
  -- para generar title: "" en lugar de title: none
  if not has_title then
    -- Marcamos el div con un atributo especial que Pandoc puede usar
    el.attributes = el.attributes or {}
    el.attributes["data-no-title"] = "true"
  end
  
  return el
end

-- Este es el filtro "amigo" - intercepta RawBlock de typst para reemplazar title: none
function RawBlock(el)
  if el.format == "typst" then
    -- Reemplazar #exercise(title: none, en #exercise(title: "",
    el.text = el.text:gsub(
      "#exercise%(title: none,",
      "#exercise(title: \"\","
    )
    
    -- Hacer lo mismo para otras funciones de teoremas
    el.text = el.text:gsub("#definition%(title: none,", "#definition(title: \"\",")
    el.text = el.text:gsub("#theorem%(title: none,", "#theorem(title: \"\",")
    el.text = el.text:gsub("#lemma%(title: none,", "#lemma(title: \"\",")
    el.text = el.text:gsub("#example%(title: none,", "#example(title: \"\",")
    el.text = el.text:gsub("#proof%(title: none,", "#proof(title: \"\",")
    
    return el
  end
end
