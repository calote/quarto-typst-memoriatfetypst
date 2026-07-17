function HorizontalRule(el)
  return {}
end

function Para(el)
  local contenido = pandoc.utils.stringify(el)
  contenido = contenido:gsub("%s+", "")

  if contenido == "- ..." or contenido == "..." or contenido == "…" or contenido == ". . ." then
    return {}
  end
end
