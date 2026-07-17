function Span(el)
  if el.classes:includes("clemsonorange") or el.classes:includes("naranja") then
    if FORMAT == "typst" then
      local content = pandoc.write(pandoc.Pandoc(el.content), "typst")
      return pandoc.RawInline("typst", '#text(fill: rgb("#F66733"))[' .. content .. ']')
    end
  end
  if el.classes:includes("verde") then
    if FORMAT == "typst" then
      local content = pandoc.write(pandoc.Pandoc(el.content), "typst")
      return pandoc.RawInline("typst", '#text(fill: rgb("#228B22"))[' .. content .. ']')
    end
  end
  if el.classes:includes("rosado") then
    if FORMAT == "typst" then
      local content = pandoc.write(pandoc.Pandoc(el.content), "typst")
      return pandoc.RawInline("typst", '#text(fill: rgb("#E91E63"))[' .. content .. ']')
    end
  end
  return el
end
