function Div(el)
  if el.classes:includes("pregunta-multiple-md") then
    -- Extraer atributos
    local correctas_str = el.attributes.correctas or ""
    local numeracion = el.attributes.numeracion == "true"
    
    -- Construir array de correctas
    local correctas_array = {}
    for num in correctas_str:gmatch("%d+") do
      correctas_array[tonumber(num)] = true
    end
    
    -- Separar enunciado de opciones
    local content_parts = {}
    local opciones = {}
    local in_list = false
    
    for _, block in ipairs(el.content) do
      if block.t == "OrderedList" then
        in_list = true
        for idx, item in ipairs(block.content) do
          table.insert(opciones, {index = idx, content = item})
        end
      elseif not in_list then
        table.insert(content_parts, block)
      end
    end
    
    -- Construir salida
    local output = {}
    
    -- Cabecera de la función
    local header = "#pregunta-multiple-md(\n"
    if numeracion then
      header = header .. "  numeracion: true,\n"
    end
    header = header .. "  ["
    table.insert(output, pandoc.RawBlock("typst", header))
    
    -- Agregar enunciado
    for _, p in ipairs(content_parts) do
      table.insert(output, p)
    end
    
    -- Cerrar enunciado, abrir body
    table.insert(output, pandoc.RawBlock("typst", "]\n)[\n"))
    
    -- Agregar cada opción
    for _, opt in ipairs(opciones) do
      local is_correct = correctas_array[opt.index] == true
      
      if is_correct then
        table.insert(output, pandoc.RawBlock("typst", "  #opc(es-correcta: true)["))
      else
        table.insert(output, pandoc.RawBlock("typst", "  #opc["))
      end
      
      -- Contenido de la opción
      for _, block in ipairs(opt.content) do
        table.insert(output, block)
      end
      
      table.insert(output, pandoc.RawBlock("typst", "]\n"))
    end
    
    -- Cerrar body
    table.insert(output, pandoc.RawBlock("typst", "]"))
    
    return output
  end
end