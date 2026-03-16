-- boxed-filter.lua

local function extract_boxed(mathstr)
  local segments = {}
  local i = 1
  local len = #mathstr
  while i <= len do
    local s, e = mathstr:find("\\boxed{", i, true)
    if not s then
      segments[#segments + 1] = {type = "text", content = mathstr:sub(i)}
      break
    end
    if s > i then
      segments[#segments + 1] = {type = "text", content = mathstr:sub(i, s - 1)}
    end
    local depth = 1
    local j = e + 1
    local content_start = j
    while j <= len and depth > 0 do
      local c = mathstr:sub(j, j)
      if c == "{" then depth = depth + 1
      elseif c == "}" then depth = depth - 1
      end
      if depth > 0 then j = j + 1 end
    end
    segments[#segments + 1] = {type = "boxed", content = mathstr:sub(content_start, j - 1)}
    i = j + 1
  end
  return segments
end

local function has_boxed(mathstr)
  return mathstr:find("\\boxed{", 1, true) ~= nil
end

local function latex_to_typst(mathstr, mathtype)
  local doc = pandoc.Pandoc({pandoc.Para({pandoc.Math(mathtype, mathstr)})})
  local result = pandoc.write(doc, "typst")
  local inner = result:match("%$%s*(.-)%s*%$")
  return inner or mathstr
end

-- Parámetros configurables
local INSET    = "7pt"
local BASELINE = "0.55em"  -- ajusta este valor según necesites

-- local function make_rect(inner, is_inline)
--   if is_inline then
--     return '#rect(inset: ' .. INSET .. ', baseline: ' .. BASELINE .. ')[$' .. inner .. '$]'
--   else
--     return '#rect(inset: ' .. INSET .. ')[$' .. inner .. '$]'
--   end
-- end

local function make_rect(inner, is_inline)
  if is_inline then
    return '#box(stroke: 0.5pt, inset: ' .. INSET .. ', baseline: ' .. BASELINE .. ')[$' .. inner .. '$]'
  else
    return '#rect(inset: ' .. INSET .. ')[$' .. inner .. '$]'
  end
end


function Para(el)
  if #el.content == 1
    and el.content[1].t == "Math"
    and el.content[1].mathtype == "DisplayMath" then
    local math = el.content[1]
    if not has_boxed(math.text) then return el end
    local segments = extract_boxed(math.text)
    local parts = {}
    for _, seg in ipairs(segments) do
      if seg.type == "text" and seg.content ~= "" then
        parts[#parts + 1] = latex_to_typst(seg.content, "DisplayMath")
      elseif seg.type == "boxed" then
        local inner = latex_to_typst(seg.content, "InlineMath")
        parts[#parts + 1] = make_rect(inner, false)
      end
    end
    return pandoc.RawBlock("typst", "$ " .. table.concat(parts, " ") .. " $\n\n")
  end
  return el
end

function Math(el)
  if el.mathtype ~= "InlineMath" then return el end
  if not has_boxed(el.text) then return el end
  local segments = extract_boxed(el.text)
  local parts = {}
  for _, seg in ipairs(segments) do
    if seg.type == "text" and seg.content ~= "" then
      parts[#parts + 1] = latex_to_typst(seg.content, "InlineMath")
    elseif seg.type == "boxed" then
      local inner = latex_to_typst(seg.content, "InlineMath")
      parts[#parts + 1] = make_rect(inner, true)
    end
  end
  -- Sin espacios alrededor para inline
  return pandoc.RawInline("typst", "$" .. table.concat(parts, " ") .. "$")
end