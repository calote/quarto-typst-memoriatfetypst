
local function addCustomCSS(meta)
  local css = [[
<style>
/* ... estilos existentes ... */

/* Estilos para soluciones en formato pestañas */
.solutions-section .panel-tabset {
  margin-top: 1em;
}

.solutions-section .panel-tabset > h2 {
  margin-top: 0;
  padding: 0.75em 1em;
  background-color: #f8f9fa;
  border: 1px solid #dee2e6;
  cursor: pointer;
  border-radius: 4px 4px 0 0;
}

/* Estilos para soluciones colapsables de ejercicios */
.ejercicio-solucion-details {
  margin: 1em 0;
  border: 2px solid #0066cc;
  border-radius: 6px;
  padding: 0;
}

.ejercicio-solucion-summary {
  background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
  color: white;
  padding: 1em 1.5em;
  cursor: pointer;
  font-weight: 600;
  font-size: 1.1em;
  border-radius: 4px;
  user-select: none;
  list-style: none;
}

.ejercicio-solucion-summary::-webkit-details-marker {
  display: none;
}

.ejercicio-solucion-summary::before {
  content: "▶ ";
  display: inline-block;
  transition: transform 0.3s;
  margin-right: 0.5em;
}

.ejercicio-solucion-details[open] .ejercicio-solucion-summary::before {
  transform: rotate(90deg);
}

.ejercicio-solucion-summary:hover {
  background: linear-gradient(135deg, #0052a3 0%, #003d7a 100%);
}

.ejercicio-solucion-content {
  padding: 1.5em;
  background-color: #f8f9ff;
}

/* Estilos para soluciones de verdadero/falso y preguntas múltiples dentro de ejercicios colapsados */
.ejercicio-solucion-content .verdadero-falso-solucion,
.ejercicio-solucion-content .pregunta-multiple-solucion {
  margin: 0.5em 0;
  border: 1px solid #d0d0d0;
}

.ejercicio-solucion-content .verdadero-falso-solucion .solucion-summary,
.ejercicio-solucion-content .pregunta-multiple-solucion .solucion-summary {
  background-color: #e9ecef;
  color: #333;
  padding: 0.5em 1em;
  font-size: 0.95em;
}

/* Pestañas personalizadas */
.custom-tabset {
  margin-top: 1em;
}

.custom-tabset .tab-buttons {
  display: flex;
  gap: 4px;
  border-bottom: 2px solid #dee2e6;
  margin-bottom: 1em;
}

.custom-tabset .tab-buttons button {
  background-color: #f8f9fa;
  border: 1px solid #dee2e6;
  border-bottom: none;
  padding: 0.75em 1.5em;
  cursor: pointer;
  font-size: 1em;
  font-weight: 500;
  border-radius: 4px 4px 0 0;
  transition: background-color 0.2s;
}

.custom-tabset .tab-buttons button:hover {
  background-color: #e9ecef;
}

.custom-tabset .tab-buttons button.active {
  background-color: white;
  border-bottom: 2px solid white;
  margin-bottom: -2px;
  color: #0066cc;
}

.custom-tabset .tab-content {
  padding: 1em 0;
}

/* ... estilos existentes ... */

/* Pestañas personalizadas con badges */
.custom-tabset {
  margin-top: 1em;
}

.custom-tabset .tab-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  padding: 1em 0;
  border-bottom: 2px solid #dee2e6;
  margin-bottom: 1.5em;
}

.custom-tabset .tab-buttons button {
  background-color: #f8f9fa;
  border: 2px solid #dee2e6;
  padding: 0.6em 1.2em;
  cursor: pointer;
  font-size: 0.95em;
  font-weight: 600;
  border-radius: 20px;
  transition: all 0.3s ease;
  color: #495057;
  min-width: 120px;
  position: relative;
}

.custom-tabset .tab-buttons button:hover {
  background-color: #e9ecef;
  border-color: #adb5bd;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.custom-tabset .tab-buttons button.active {
  background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
  border-color: #0066cc;
  color: white;
  box-shadow: 0 4px 12px rgba(0, 102, 204, 0.3);
}

.custom-tabset .tab-buttons button.active::before {
  content: "✓ ";
  margin-right: 4px;
}

.custom-tabset .tab-content {
  padding: 1em 0.5em;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Variante: Solo números (más compacta) */
.custom-tabset.compact .tab-buttons button {
  min-width: 50px;
  padding: 0.5em 0.8em;
  border-radius: 50%;
  font-size: 1em;
}

/* Estilos para soluciones colapsables... (resto del CSS) */

/* ... estilos existentes ... */

/* Ocultar numeración automática en ejercicios */
.ejercicio > h2::before,
.ejercicio > h3::before,
.ejercicio > h4::before {
  content: none !important;
  display: none !important;
}

/* También para headers dentro de ejercicios */
.ejercicio h2 .header-section-number,
.ejercicio h3 .header-section-number,
.ejercicio h4 .header-section-number {
  display: none !important;
}

/* ... resto de estilos ... */


</style>
]]
  
  return pandoc.RawBlock('html', css)
end


-- Función mejorada para parsear argumentos de Typst
local function parseTypstArguments(argumentsStr)
  if not argumentsStr or argumentsStr == "" then
    return {}
  end
  
  local args = {}
  
  -- Parsear listas tipo "opciones: (a, b, c)"
  for key, value in string.gmatch(argumentsStr, '([%w%-]+):%s*%(([^)]+)%)') do
    local items = {}
    for item in string.gmatch(value, '[^,]+') do
      item = item:gsub('^%s*"?', ''):gsub('"?%s*$', '')
      table.insert(items, item)
    end
    args[key] = items
  end
  
  -- Parsear argumentos simples tipo "key: value"
  for key, value in string.gmatch(argumentsStr, '([%w%-]+):%s*([^,%(][^,]*)') do
    if not args[key] then
      value = value:gsub('^%s*', ''):gsub('%s*$', '') -- trim espacios
      value = value:gsub('^"', ''):gsub('"$', '') -- quitar comillas
      
      -- Convertir tipos
      if value == "true" then
        args[key] = true
      elseif value == "false" then
        args[key] = false
      else
        local num = tonumber(value)
        if num then
          args[key] = num
        else
          args[key] = value
        end
      end
    end
  end
  
  return args
end

-- Contador global para ejercicios
local ejercicio_counter = 0
local apartado_counters = {}
local verdaderoFalso_counters = {}

local function resetApartadoCounter()
  apartado_counters[ejercicio_counter] = {
    numero = 0,
    letra = 0
  }
end

local function resetVerdaderoFalsoCounter()
  verdaderoFalso_counters[ejercicio_counter] = {
    numero = 0,
    letra = 0
  }
end

local function getNextApartadoNumero()
  if not apartado_counters[ejercicio_counter] then
    resetApartadoCounter()
  end
  apartado_counters[ejercicio_counter].numero = apartado_counters[ejercicio_counter].numero + 1
  return tostring(apartado_counters[ejercicio_counter].numero)
end

local function getNextApartadoLetra()
  if not apartado_counters[ejercicio_counter] then
    resetApartadoCounter()
  end
  apartado_counters[ejercicio_counter].letra = apartado_counters[ejercicio_counter].letra + 1
  local letra_idx = apartado_counters[ejercicio_counter].letra
  return string.char(96 + letra_idx)
end

local function getNextVerdaderoFalsoNumero()
  if not verdaderoFalso_counters[ejercicio_counter] then
    resetVerdaderoFalsoCounter()
  end
  verdaderoFalso_counters[ejercicio_counter].numero = verdaderoFalso_counters[ejercicio_counter].numero + 1
  return tostring(verdaderoFalso_counters[ejercicio_counter].numero)
end

local function getNextVerdaderoFalsoLetra()
  if not verdaderoFalso_counters[ejercicio_counter] then
    resetVerdaderoFalsoCounter()
  end
  verdaderoFalso_counters[ejercicio_counter].letra = verdaderoFalso_counters[ejercicio_counter].letra + 1
  local letra_idx = verdaderoFalso_counters[ejercicio_counter].letra
  return string.char(96 + letra_idx)
end

local function processEjercicio(div, meta)
  if div.classes:includes("ejercicio") then
    ejercicio_counter = ejercicio_counter + 1
    resetApartadoCounter()
    resetVerdaderoFalsoCounter()
    
    local args = parseTypstArguments(div.attributes.arguments)
    local puntos = args.puntos or div.attributes.puntos or ""
    local content = div.content
    
    local ejercicioNombre = meta["ejercicio-nombre"] or "Ejercicio"
    if ejercicioNombre then
      ejercicioNombre = pandoc.utils.stringify(ejercicioNombre)
    end
    
    local headerText = ejercicioNombre .. " " .. ejercicio_counter
    local header = pandoc.Div({
      pandoc.Header(3, {pandoc.Str(headerText)})
    }, pandoc.Attr("", {"ejercicio-header"}, {}))
    
    if puntos ~= "" then
      header.content:insert(pandoc.Span({
        pandoc.Str(" (" .. puntos .. " puntos)")
      }, pandoc.Attr("", {"puntos"}, {})))
    end
    
    return pandoc.Div({
      header,
      pandoc.Div(content, pandoc.Attr("", {"ejercicio-content"}, {}))
    }, pandoc.Attr("", {"ejercicio"}, {}))
  end
end

local function processSolucion(div, meta)
  if div.classes:includes("solucion") then
    local showSolutions = meta["show-solutions"] or meta["mostrar-soluciones"]
    local collapsibleSolutions = meta["collapsible-solutions"] or meta["soluciones-colapsables"]
    -- local tabbedSolutions = meta["tabbed-solutions"] or meta["soluciones-pestanas"] -- PEDRO
    local tabbedSolutions = meta["solutions-at-end"] or meta["soluciones-al-final"]

    if showSolutions and pandoc.utils.stringify(showSolutions) == "true" then
      -- Opción con pestañas: NO procesar ahora, solo marcar
      if tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true" then
        div.attributes["data-solution"] = "true"
        return div
      -- Opción colapsable
      elseif collapsibleSolutions and pandoc.utils.stringify(collapsibleSolutions) == "true" then
        local result = pandoc.Div({}, pandoc.Attr("", {"solucion", "collapsible"}, {}))
        
        result.content:insert(pandoc.RawBlock("html", '<details class="solucion-details">'))
        result.content:insert(pandoc.RawBlock("html", '<summary class="solucion-summary">Solución</summary>'))
        result.content:insert(pandoc.RawBlock("html", '<div class="solucion-content">'))
        
        for _, block in ipairs(div.content) do
          result.content:insert(block)
        end
        
        result.content:insert(pandoc.RawBlock("html", '</div>'))
        result.content:insert(pandoc.RawBlock("html", '</details>'))
        
        return result
      else
        -- Mostrar soluciones normalmente
        return pandoc.Div({
          pandoc.Header(4, {pandoc.Str("Solución:")}, pandoc.Attr("", {"solucion-header"}, {})),
          pandoc.Div(div.content, pandoc.Attr("", {"solucion-content"}, {}))
        }, pandoc.Attr("", {"solucion"}, {}))
      end
    else
      return {}
    end
  end
end

-- ...existing code hasta collectSolutionsFromBlocks...
-- ...existing code hasta collectSolutionsFromBlocks...

local function collectSolutionsFromBlocks(blocks)
  local exerciseBlocks = {}
  local solutionsByExercise = {}
  local currentExerciseNum = 0
  
  local function removeSolutionsFromBlock(block)
    if not block or not block.t then
      return block
    end
    
    if block.t == "Div" then
      if not block.classes then
        return block
      end
      
      -- Eliminar soluciones marcadas
      if block.classes:includes("solucion") and 
         block.attributes and
         block.attributes["data-solution"] == "true" then
        return nil
      end
      
      -- NUEVO: También marcar verdadero-falso y pregunta-multiple para extracción
      if (block.classes:includes("verdadero-falso") or 
          block.classes:includes("pregunta-multiple")) and
         block.attributes and
         block.attributes["data-solution"] == "true" then
        return nil
      end
      
      if block.content then
        local newContent = pandoc.List()
        for _, content in ipairs(block.content) do
          local cleanedContent = removeSolutionsFromBlock(content)
          if cleanedContent then
            newContent:insert(cleanedContent)
          end
        end
        block.content = newContent
      end
    end
    
    return block
  end
  
  local function collectSolutionsFromBlock(block)
    if not block or not block.t then
      return
    end
    
    if block.t == "Div" and block.classes then
      -- Recopilar soluciones tradicionales
      if block.classes:includes("solucion") and 
         block.attributes and
         block.attributes["data-solution"] == "true" then
        if currentExerciseNum > 0 then
          table.insert(solutionsByExercise[currentExerciseNum], block)
        end
      end
      
      -- NUEVO: Recopilar verdadero-falso y pregunta-multiple
      if (block.classes:includes("verdadero-falso") or 
          block.classes:includes("pregunta-multiple")) and
         block.attributes and
         block.attributes["data-solution"] == "true" then
        if currentExerciseNum > 0 then
          table.insert(solutionsByExercise[currentExerciseNum], block)
        end
      end
      
      if block.content then
        for _, content in ipairs(block.content) do
          collectSolutionsFromBlock(content)
        end
      end
    end
  end
  
  for _, block in ipairs(blocks) do
    if block and block.t == "Div" and block.classes and block.classes:includes("ejercicio") then
      currentExerciseNum = currentExerciseNum + 1
      solutionsByExercise[currentExerciseNum] = {}
      
      collectSolutionsFromBlock(block)
      local cleanedExercise = removeSolutionsFromBlock(block)
      table.insert(exerciseBlocks, cleanedExercise)
    else
      table.insert(exerciseBlocks, block)
    end
  end
  
  return exerciseBlocks, solutionsByExercise
end


-- Función para crear la sección de soluciones al final
local function createTabbedDocument(blocks, meta)
  local tabbedSolutions = meta["tabbed-solutions"] or meta["soluciones-pestanas"]
  local solutionsAtEnd = meta["solutions-at-end"] or meta["soluciones-al-final"]
  local solutionsFormat = meta["solutions-format"] or meta["formato-soluciones"]
  
  -- Determinar el formato de soluciones
  local formatoSol = "normal"
  if solutionsFormat then
    formatoSol = pandoc.utils.stringify(solutionsFormat)
  end

  -- Si no hay ninguna opción activa, retornar bloques sin cambios
  if not ((tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true") or
          (solutionsAtEnd and pandoc.utils.stringify(solutionsAtEnd) == "true")) then
    return blocks
  end
  
  local exerciseBlocks, solutionsByExercise = collectSolutionsFromBlocks(blocks)
  
  local hasSolutions = false
  for k, solutions in pairs(solutionsByExercise) do
    if #solutions > 0 then
      hasSolutions = true
    end
  end
  
  if not hasSolutions then
    quarto.log.output("No se encontraron soluciones marcadas")
    return blocks
  end
  
  local result = pandoc.List()
  
  local preExerciseBlocks = pandoc.List()
  local exerciseContentBlocks = pandoc.List()
  local postExerciseBlocks = pandoc.List()
  
  local foundFirstExercise = false
  --local inExerciseSection = false
  
  for i, block in ipairs(exerciseBlocks) do
    --if block and block.t == "Div" and block.classes and block.classes:includes("ejercicio") then
      if block.t == "Div" and block.classes:includes("ejercicio") then
      foundFirstExercise = true
      exerciseContentBlocks:insert(block)
      -- if not foundFirstExercise then
      --   foundFirstExercise = true
      --   --inExerciseSection = true
      -- end
      --exerciseContentBlocks:insert(block)
      elseif not foundFirstExercise then
        preExerciseBlocks:insert(block)
    -- elseif inExerciseSection then
    --   local hasMoreExercises = false
    --   for j = i + 1, #exerciseBlocks do
    --     local futureBlock = exerciseBlocks[j]
    --     if futureBlock and futureBlock.t == "Div" and futureBlock.classes and 
    --        futureBlock.classes:includes("ejercicio") then
    --       hasMoreExercises = true
    --       break
    --     end
    --   end
      
    --   if not hasMoreExercises then
    --     inExerciseSection = false
    --     postExerciseBlocks:insert(block)
    --   end
      else
        --postExerciseBlocks:insert(block)
        exerciseContentBlocks:insert(block)
      end
  end
  
  -- Añadir bloques pre-ejercicios
  for _, block in ipairs(preExerciseBlocks) do
    result:insert(block)
  end
  
  -- Ordenar las claves de soluciones
  local sortedKeys = {}
  for k in pairs(solutionsByExercise) do
    table.insert(sortedKeys, k)
  end
  table.sort(sortedKeys)
  
  -- MODO 1: PANEL-TABSET (pestañas) - Solo con tabbed-solutions
  if tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true" then
    result:insert(pandoc.RawBlock("html", '<div class="panel-tabset">'))
    result:insert(pandoc.RawBlock("html", '<h2>Ejercicios</h2>'))
    
    for _, block in ipairs(exerciseContentBlocks) do
      result:insert(block)
    end
    
    result:insert(pandoc.RawBlock("html", '<h2>Soluciones</h2>'))
    
    for _, exerciseNum in ipairs(sortedKeys) do
      local solutions = solutionsByExercise[exerciseNum]
      if #solutions > 0 then
        local ejercicioNombre = meta["ejercicio-nombre"] or "Ejercicio"
        ejercicioNombre = pandoc.utils.stringify(ejercicioNombre)
        
        result:insert(pandoc.Header(3, {
          pandoc.Str("Solución " .. ejercicioNombre .. " " .. exerciseNum)
        }))
        
        for _, solution in ipairs(solutions) do
          if solution and solution.content then
            for _, content in ipairs(solution.content) do
              result:insert(content)
            end
          end
        end
      end
    end
    
    result:insert(pandoc.RawBlock("html", '</div>'))
    
-- MODO 2: SOLUCIONES AL FINAL
elseif solutionsAtEnd and pandoc.utils.stringify(solutionsAtEnd) == "true" then
  -- Insertar ejercicios
  for _, block in ipairs(exerciseContentBlocks) do
    result:insert(block)
  end
  
  -- Separador
  result:insert(pandoc.RawBlock("html", '<hr style="margin: 3em 0; border: 2px solid #ccc;">'))
  
  quarto.log.output("solutions-at-end activo, formato: " .. formatoSol)
  

-- FORMATO A: Panel con pestañas (tabset) - SIN PESTAÑA ACTIVA INICIAL
if formatoSol == "tabset" or formatoSol == "pestañas" or formatoSol == "pestanas" then
  
  result:insert(pandoc.Header(2, {pandoc.Str("Soluciones")}))
  
  -- Determinar si usar versión compacta (solo números)
  local compactMode = meta["solutions-compact"] or meta["soluciones-compactas"]
  local compactClass = (compactMode and pandoc.utils.stringify(compactMode) == "true") and " compact" or ""
  
  -- Crear pestañas con HTML/CSS personalizado
  result:insert(pandoc.RawBlock("html", '<div class="custom-tabset' .. compactClass .. '">'))
  result:insert(pandoc.RawBlock("html", '<div class="tab-buttons">'))
  
  -- Crear botones de pestañas (NINGUNO activo inicialmente)
  for i, exerciseNum in ipairs(sortedKeys) do
    local solutions = solutionsByExercise[exerciseNum]
    if #solutions > 0 then
      local ejercicioNombre = meta["ejercicio-nombre"] or "Ejercicio"
      ejercicioNombre = pandoc.utils.stringify(ejercicioNombre)
      
      -- Versión compacta: solo números
      local buttonText
      if compactClass ~= "" then
        buttonText = tostring(exerciseNum)
      else
        buttonText = ejercicioNombre .. " " .. exerciseNum
      end
      
      -- SIN clase "active" inicial
      result:insert(pandoc.RawBlock("html", 
        '<button onclick="openTab(event, \'tab-' .. exerciseNum .. '\')" ' ..
        'title="' .. ejercicioNombre .. ' ' .. exerciseNum .. '">' .. 
        buttonText .. '</button>'))
    end
  end
  
  result:insert(pandoc.RawBlock("html", "</div>"))
  
  -- Crear contenido de pestañas (TODAS ocultas inicialmente)
  for i, exerciseNum in ipairs(sortedKeys) do
    local solutions = solutionsByExercise[exerciseNum]
    if #solutions > 0 then
      -- TODAS con display: none
      result:insert(pandoc.RawBlock("html", 
        '<div id="tab-' .. exerciseNum .. '" class="tab-content" style="display: none;">'))
      
      for _, solution in ipairs(solutions) do
        if solution and solution.content then
          for _, content in ipairs(solution.content) do
            result:insert(content)
          end
        end
      end
      
      result:insert(pandoc.RawBlock("html", '</div>'))
    end
  end
  
  result:insert(pandoc.RawBlock("html", "</div>"))
  
  -- JavaScript para las pestañas
  result:insert(pandoc.RawBlock("html", [[
<div id="tab-placeholder" class="tab-placeholder" style="display: block;">
  <p style="text-align: center; color: #6c757d; padding: 2em; font-style: italic;">
    👆 Selecciona un ejercicio para ver su solución
  </p>
</div>
  <script>
function openTab(evt, tabId) {
  var clickedButton = evt.currentTarget;
  var targetContent = document.getElementById(tabId);
  var placeholder = document.getElementById("tab-placeholder");
  
  // Si ya está activo, cerrar
  if (clickedButton.classList.contains("active")) {
    targetContent.style.display = "none";
    clickedButton.classList.remove("active");
    
    // Mostrar placeholder de nuevo
    if (placeholder) {
      placeholder.style.display = "block";
    }
    return;
  }
  
  // Ocultar placeholder
  if (placeholder) {
    placeholder.style.display = "none";
  }
  
  // Ocultar SOLO el contenido de pestañas de SOLUCIONES (dentro de .custom-tabset)
  var tabcontent = document.querySelectorAll(".custom-tabset .tab-content");
  for (var i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }
  
  // Remover clase active SOLO de los botones de SOLUCIONES
  var tabbuttons = document.querySelectorAll(".custom-tabset .tab-buttons button");
  for (var i = 0; i < tabbuttons.length; i++) {
    tabbuttons[i].classList.remove("active");
  }
  
  // Mostrar la pestaña actual y marcar el botón como activo
  targetContent.style.display = "block";
  clickedButton.classList.add("active");
}

</script>
]]))


  -- FORMATO B: Colapsable
  elseif formatoSol == "colapsable" or formatoSol == "collapse" or formatoSol == "collapsible" then
    
    result:insert(pandoc.Header(2, {pandoc.Str("Soluciones")}))
    
    for _, exerciseNum in ipairs(sortedKeys) do
      local solutions = solutionsByExercise[exerciseNum]
      if #solutions > 0 then
        local ejercicioNombre = meta["ejercicio-nombre"] or "Ejercicio"
        ejercicioNombre = pandoc.utils.stringify(ejercicioNombre)
        
        result:insert(pandoc.RawBlock("html", 
          '<details class="ejercicio-solucion-details">'))
        result:insert(pandoc.RawBlock("html", 
          '<summary class="ejercicio-solucion-summary">' .. 
          ejercicioNombre .. " " .. exerciseNum .. '</summary>'))
        result:insert(pandoc.RawBlock("html", 
          '<div class="ejercicio-solucion-content">'))
        
        for _, solution in ipairs(solutions) do
          if solution and solution.content then
            for _, content in ipairs(solution.content) do
              result:insert(content)
            end
          end
        end
        
        result:insert(pandoc.RawBlock("html", '</div>'))
        result:insert(pandoc.RawBlock("html", '</details>'))
      end
    end
  
  -- FORMATO C: Normal (expandido)
  else
    result:insert(pandoc.Header(2, {pandoc.Str("Soluciones")}))
    
    for _, exerciseNum in ipairs(sortedKeys) do
      local solutions = solutionsByExercise[exerciseNum]
      if #solutions > 0 then
        local ejercicioNombre = meta["ejercicio-nombre"] or "Ejercicio"
        ejercicioNombre = pandoc.utils.stringify(ejercicioNombre)
        
        result:insert(pandoc.Header(3, {
          pandoc.Str("Solución " .. ejercicioNombre .. " " .. exerciseNum)
        }))
        
        for _, solution in ipairs(solutions) do
          if solution and solution.content then
            for _, content in ipairs(solution.content) do
              result:insert(content)
            end
          end
        end
      end
    end
  end
end
  
  -- Añadir bloques post-ejercicios
  for _, block in ipairs(postExerciseBlocks) do
    result:insert(block)
  end
  
  return result
end
-- ...resto del código sin cambios...

-- ...resto del código sin cambios...
-- local function processApartado(div)
--   if div.classes:includes("apartado") then
--     local args = parseTypstArguments(div.attributes.arguments)
--     local letra = args.letra or div.attributes.letra
--     local tipo = args.tipo or div.attributes.tipo
--     local content = div.content
--     
--     local prefix_text = ""
--     
--     if letra and letra ~= "" then
--       prefix_text = letra .. ") "
--     elseif tipo then
--       if tipo == "LETRA" or tipo == "letra" then
--         prefix_text = getNextApartadoLetra() .. ") "
--       elseif tipo == "NUMERO" or tipo == "numero" then
--         prefix_text = getNextApartadoNumero() .. ") "
--       elseif tipo == "" then
--         prefix_text = ""
--       else
--         prefix_text = getNextApartadoLetra() .. ") "
--       end
--     else
--       prefix_text = getNextApartadoLetra() .. ") "
--     end
--     
--     if prefix_text ~= "" then
--       local prefix = pandoc.Para({pandoc.Strong({pandoc.Str(prefix_text)})})
--       table.insert(content, 1, prefix)
--     end
--     
--     return pandoc.Div(content, pandoc.Attr("", {"apartado"}, {}))
--   end
-- end

local function processApartado(div)
  if div.classes:includes("apartado") then
    local args = parseTypstArguments(div.attributes.arguments)
    local letra = args.letra or div.attributes.letra
    local tipo = args.tipo or div.attributes.tipo
    local content = div.content
    
    local prefix_text = ""
    
    -- Lógica de determinación del texto del prefijo (se mantiene igual)
    if letra and letra ~= "" then
      prefix_text = letra .. ") "
    elseif tipo then
      if tipo == "LETRA" or tipo == "letra" then
        prefix_text = getNextApartadoLetra() .. ") "
      elseif tipo == "NUMERO" or tipo == "numero" then
        prefix_text = getNextApartadoNumero() .. ") "
      elseif tipo == "" then
        prefix_text = ""
      else
        prefix_text = getNextApartadoLetra() .. ") "
      end
    else
      prefix_text = getNextApartadoLetra() .. ") "
    end
    
    -- LÓGICA MODIFICADA PARA LA MISMA LÍNEA
    if prefix_text ~= "" then
      -- Creamos el prefijo como un elemento "Inline" (negrita)
      local prefix_inline = pandoc.Strong({pandoc.Str(prefix_text)})
      
      -- Comprobamos si el primer elemento del contenido es un párrafo
      if content[1] and (content[1].t == "Para" or content[1].t == "Plain") then
        -- Insertamos el prefijo al inicio de la lista de inlines del primer párrafo
        table.insert(content[1].content, 1, prefix_inline)
        -- Opcional: añadir un espacio extra si prefix_text no lo tiene
        -- table.insert(content[1].content, 2, pandoc.Space())
      else
        -- Si el contenido no empieza por un párrafo (ej. empieza por una tabla o lista),
        -- creamos un párrafo nuevo para que no se pierda el prefijo.
        table.insert(content, 1, pandoc.Para({prefix_inline}))
      end
    end
    
    return pandoc.Div(content, pandoc.Attr("", {"apartado"}, {}))
  end
end


local function processPreguntaMultiple(div, meta)
  if div.classes:includes("pregunta-multiple") then
    local args = parseTypstArguments(div.attributes.arguments)
    local correcta = args.correcta or {}
    local opciones = args.opciones or {}
    local aleatorio = args.aleatorio
    local content = div.content
    
    if type(correcta) == "number" then
      correcta = {correcta}
    end
    
    local showSolutions = meta["show-solutions"] or meta["mostrar-soluciones"]
    local solutionsAtEnd = meta["solutions-at-end"] or meta["soluciones-al-final"]
    local tabbedSolutions = meta["tabbed-solutions"] or meta["soluciones-pestanas"]
    local collapsibleSolutions = meta["collapsible-solutions"] or meta["soluciones-colapsables"]
    
    local mostrarSoluciones = showSolutions and pandoc.utils.stringify(showSolutions) == "true"
    local solAlFinal = solutionsAtEnd and pandoc.utils.stringify(solutionsAtEnd) == "true"
    local solPestanas = tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true"
    local solColapsable = collapsibleSolutions and pandoc.utils.stringify(collapsibleSolutions) == "true"
    
    -- CASO 1: Soluciones al final o en pestañas
    if mostrarSoluciones and (solAlFinal or solPestanas) then
      
      -- Versión SIN solución (para ejercicios)
      local resultSinSolucion = pandoc.Div({}, pandoc.Attr("", {"pregunta-multiple"}, {}))
      
      for _, block in ipairs(content) do
        resultSinSolucion.content:insert(block)
      end
      
      if #opciones > 0 then
        local opcionesDiv = pandoc.Div({}, pandoc.Attr("", {"opciones-multiple"}, {}))
        
        for i, opcion in ipairs(opciones) do
          local checkbox = pandoc.RawInline("html", '<input type="checkbox" disabled>')
          
          opcionesDiv.content:insert(pandoc.Para({
            checkbox,
            pandoc.Space(),
            pandoc.Str(opcion)
          }))
        end
        
        resultSinSolucion.content:insert(opcionesDiv)
      end
      
      -- Versión CON solución (para sección de soluciones)
      local resultConSolucion = pandoc.Div({}, pandoc.Attr("", {"pregunta-multiple"}, {["data-solution"] = "true"}))
      
      for _, block in ipairs(content) do
        resultConSolucion.content:insert(block)
      end
      
      if #opciones > 0 then
        local opcionesDivSol = pandoc.Div({}, pandoc.Attr("", {"opciones-multiple"}, {}))
        
        for i, opcion in ipairs(opciones) do
          local esCorrecta = false
          
          for _, idx in ipairs(correcta) do
            if tonumber(idx) == i then
              esCorrecta = true
              break
            end
          end
          
          local checkbox
          if esCorrecta then
            checkbox = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
          else
            checkbox = pandoc.RawInline("html", '<input type="checkbox" disabled>')
          end
          
          opcionesDivSol.content:insert(pandoc.Para({
            checkbox,
            pandoc.Space(),
            pandoc.Str(opcion)
          }))
        end
        
        resultConSolucion.content:insert(opcionesDivSol)
      end
      
      return pandoc.Div({
        resultSinSolucion,
        resultConSolucion
      }, pandoc.Attr("", {"pregunta-multiple-container"}, {}))
      
    -- CASO 2: Soluciones inline colapsables
    elseif mostrarSoluciones and solColapsable then
      
      local result = pandoc.Div({}, pandoc.Attr("", {"pregunta-multiple"}, {}))
      
      for _, block in ipairs(content) do
        result.content:insert(block)
      end
      
      -- Opciones sin marcar
      if #opciones > 0 then
        local opcionesDiv = pandoc.Div({}, pandoc.Attr("", {"opciones-multiple"}, {}))
        
        for i, opcion in ipairs(opciones) do
          local checkbox = pandoc.RawInline("html", '<input type="checkbox" disabled>')
          
          opcionesDiv.content:insert(pandoc.Para({
            checkbox,
            pandoc.Space(),
            pandoc.Str(opcion)
          }))
        end
        
        result.content:insert(opcionesDiv)
      end
      
      -- NUEVO: Añadir solución colapsable
      result.content:insert(pandoc.RawBlock("html", '<details class="solucion-details pregunta-multiple-solucion">'))
      result.content:insert(pandoc.RawBlock("html", '<summary class="solucion-summary">Solución</summary>'))
      result.content:insert(pandoc.RawBlock("html", '<div class="solucion-content">'))
      
      local respuestasCorrectas = {}
      for _, idx in ipairs(correcta) do
        local numIdx = tonumber(idx)
        if numIdx and opciones[numIdx] then
          table.insert(respuestasCorrectas, opciones[numIdx])
        end
      end
      
      if #respuestasCorrectas > 0 then
        result.content:insert(pandoc.Para({pandoc.Strong({pandoc.Str("Respuestas correctas:")})}))
        for _, resp in ipairs(respuestasCorrectas) do
          result.content:insert(pandoc.Para({pandoc.Str("• " .. resp)}))
        end
      end
      
      result.content:insert(pandoc.RawBlock("html", '</div>'))
      result.content:insert(pandoc.RawBlock("html", '</details>'))
      
      return result
      
    -- CASO 3: Soluciones inline normales
    elseif mostrarSoluciones then
      
      local result = pandoc.Div({}, pandoc.Attr("", {"pregunta-multiple"}, {}))
      
      for _, block in ipairs(content) do
        result.content:insert(block)
      end
      
      if #opciones > 0 then
        local opcionesDiv = pandoc.Div({}, pandoc.Attr("", {"opciones-multiple"}, {}))
        
        for i, opcion in ipairs(opciones) do
          local esCorrecta = false
          
          for _, idx in ipairs(correcta) do
            if tonumber(idx) == i then
              esCorrecta = true
              break
            end
          end
          
          local checkbox
          if esCorrecta then
            checkbox = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
          else
            checkbox = pandoc.RawInline("html", '<input type="checkbox" disabled>')
          end
          
          opcionesDiv.content:insert(pandoc.Para({
            checkbox,
            pandoc.Space(),
            pandoc.Str(opcion)
          }))
        end
        
        result.content:insert(opcionesDiv)
      end
      
      return result
      
    -- CASO 4: Sin soluciones
    else
      
      local result = pandoc.Div({}, pandoc.Attr("", {"pregunta-multiple"}, {}))
      
      for _, block in ipairs(content) do
        result.content:insert(block)
      end
      
      if #opciones > 0 then
        local opcionesDiv = pandoc.Div({}, pandoc.Attr("", {"opciones-multiple"}, {}))
        
        for i, opcion in ipairs(opciones) do
          local checkbox = pandoc.RawInline("html", '<input type="checkbox" disabled>')
          
          opcionesDiv.content:insert(pandoc.Para({
            checkbox,
            pandoc.Space(),
            pandoc.Str(opcion)
          }))
        end
        
        result.content:insert(opcionesDiv)
      end
      
      return result
    end
  end
end




local function processTablaCalificaciones(div)
  if not div.classes:includes('tabla-calificaciones') then
    return nil
  end
  
  local args = div.attributes['arguments'] or ''
  
  -- Parsear ejercicios del formato: ejercicios: ((nombre: "...", puntos: X), ...)
  local ejercicios = {}
  for ejercicio_str in string.gmatch(args, '%(nombre:%s*"([^"]+)",%s*puntos:%s*([%d.]+)%)') do
    -- Esta regex necesita ajuste, usa un parser más robusto:
  end
  
  -- Parser mejorado
  local ejercicio_pattern = 'nombre:%s*"([^"]+)",%s*puntos:%s*([%d.]+)'
  for nombre, puntos in string.gmatch(args, ejercicio_pattern) do
    table.insert(ejercicios, {nombre = nombre, puntos = tonumber(puntos)})
  end
  
  if #ejercicios == 0 then
    return pandoc.Para({pandoc.Strong({pandoc.Str("Tabla de Calificaciones (sin ejercicios)")})})
  end
  
  -- Construir HTML
  local html = [[
<div class="tabla-calificaciones">
  <table>
    <thead>
      <tr>]]
  
  for _, ej in ipairs(ejercicios) do
    html = html .. '<th>' .. ej.nombre .. '</th>'
  end
  html = html .. '<th><strong>Total</strong></th></tr></thead>'
  
  html = html .. '<tbody><tr class="puntos-maximos">'
  local total = 0
  for _, ej in ipairs(ejercicios) do
    html = html .. '<td>' .. ej.puntos .. '</td>'
    total = total + ej.puntos
  end
  html = html .. '<td><strong>' .. total .. '</strong></td></tr>'
  
  -- html = html .. '<tr class="calificacion-obtenida">'
  -- for i = 1, #ejercicios + 1 do
  --   html = html .. '<td>&nbsp;</td>'
  -- end
  html = html .. '</tr></tbody></table></div>'
  
  return pandoc.RawBlock('html', html)
end




local function processVerdaderoFalso(div, meta)
  if div.classes:includes("verdadero-falso") then
    local args = parseTypstArguments(div.attributes.arguments)
    
    -- CORRECCIÓN: No usar 'or' con booleanos
    local correcta
    if args.correcta ~= nil then
      correcta = args.correcta
    else
      correcta = div.attributes.correcta
    end
    
    local numeracion
    if args.numeracion ~= nil then
      numeracion = args.numeracion
    else
      numeracion = div.attributes.numeracion
    end
    
    local tipoNumeracion = args["tipo-numeracion"] or div.attributes["tipo-numeracion"]
    local content = div.content
    
    local mostrar_numero = true
    if numeracion == false or numeracion == "false" then
      mostrar_numero = false
    end
    
    local showSolutions = meta["show-solutions"] or meta["mostrar-soluciones"]
    local solutionsAtEnd = meta["solutions-at-end"] or meta["soluciones-al-final"]
    local tabbedSolutions = meta["tabbed-solutions"] or meta["soluciones-pestanas"]
    local collapsibleSolutions = meta["collapsible-solutions"] or meta["soluciones-colapsables"]
    
    -- Generar el número/letra una sola vez
    local numero_text = ""
    if mostrar_numero then
      if tipoNumeracion == "letra" or tipoNumeracion == "LETRA" then
        numero_text = getNextVerdaderoFalsoLetra() .. ") "
      else
        numero_text = getNextVerdaderoFalsoNumero() .. ". "
      end
    end
    
    local mostrarSoluciones = showSolutions and pandoc.utils.stringify(showSolutions) == "true"
    local solAlFinal = solutionsAtEnd and pandoc.utils.stringify(solutionsAtEnd) == "true"
    local solPestanas = tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true"
    local solColapsable = collapsibleSolutions and pandoc.utils.stringify(collapsibleSolutions) == "true"
    
    -- CASO 1: Soluciones al final o en pestañas
    if mostrarSoluciones and (solAlFinal or solPestanas) then
      
      -- Versión SIN solución (para ejercicios)
      local resultSinSolucion = pandoc.Div({}, pandoc.Attr("", {"verdadero-falso"}, {}))
      
      local contentSinSol = pandoc.List()
      for _, block in ipairs(content) do
        contentSinSol:insert(block:clone())
      end
      
      if numero_text ~= "" then
        if #contentSinSol > 0 and contentSinSol[1].t == "Para" then
          table.insert(contentSinSol[1].content, 1, pandoc.Str(numero_text))
        else
          table.insert(contentSinSol, 1, pandoc.Para({pandoc.Str(numero_text)}))
        end
      end
      
      for _, block in ipairs(contentSinSol) do
        resultSinSolucion.content:insert(block)
      end
      
      local checkboxV = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      local checkboxF = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      
      resultSinSolucion.content:insert(pandoc.Para({
        checkboxV,
        pandoc.Str(" Verdadero "),
        pandoc.Space(),
        checkboxF,
        pandoc.Str(" Falso")
      }))
      
      -- Versión CON solución (para la sección de soluciones)
      local resultConSolucion = pandoc.Div({}, pandoc.Attr("", {"verdadero-falso"}, {["data-solution"] = "true"}))
      
      local contentConSol = pandoc.List()
      for _, block in ipairs(content) do
        contentConSol:insert(block:clone())
      end
      
      if numero_text ~= "" then
        if #contentConSol > 0 and contentConSol[1].t == "Para" then
          table.insert(contentConSol[1].content, 1, pandoc.Str(numero_text))
        else
          table.insert(contentConSol, 1, pandoc.Para({pandoc.Str(numero_text)}))
        end
      end
      
      for _, block in ipairs(contentConSol) do
        resultConSolucion.content:insert(block)
      end
      
      local checkboxVSol = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      local checkboxFSol = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      
      local esVerdadero = false
      local esFalso = false
      
      if type(correcta) == "boolean" then
        esVerdadero = correcta == true
        esFalso = correcta == false
      elseif type(correcta) == "string" then
        local correctaLower = string.lower(correcta)
        esVerdadero = (correctaLower == "true")
        esFalso = (correctaLower == "false")
      end
      
      if esVerdadero then
        checkboxVSol = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
      elseif esFalso then
        checkboxFSol = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
      end
      
      resultConSolucion.content:insert(pandoc.Para({
        checkboxVSol,
        pandoc.Str(" Verdadero "),
        pandoc.Space(),
        checkboxFSol,
        pandoc.Str(" Falso")
      }))
      
      return pandoc.Div({
        resultSinSolucion,
        resultConSolucion
      }, pandoc.Attr("", {"verdadero-falso-container"}, {}))
      
    -- CASO 2: Soluciones inline colapsables
    elseif mostrarSoluciones and solColapsable then
      
      local result = pandoc.Div({}, pandoc.Attr("", {"verdadero-falso"}, {}))
      
      local contentCopia = pandoc.List()
      for _, block in ipairs(content) do
        contentCopia:insert(block:clone())
      end
      
      if numero_text ~= "" then
        if #contentCopia > 0 and contentCopia[1].t == "Para" then
          table.insert(contentCopia[1].content, 1, pandoc.Str(numero_text))
        else
          table.insert(contentCopia, 1, pandoc.Para({pandoc.Str(numero_text)}))
        end
      end
      
      for _, block in ipairs(contentCopia) do
        result.content:insert(block)
      end
      
      -- Checkboxes sin marcar
      local checkboxV = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      local checkboxF = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      
      result.content:insert(pandoc.Para({
        checkboxV,
        pandoc.Str(" Verdadero "),
        pandoc.Space(),
        checkboxF,
        pandoc.Str(" Falso")
      }))
      
      -- NUEVO: Añadir solución colapsable
      local esVerdadero = false
      local esFalso = false
      
      if type(correcta) == "boolean" then
        esVerdadero = correcta == true
        esFalso = correcta == false
      elseif type(correcta) == "string" then
        local correctaLower = string.lower(correcta)
        esVerdadero = (correctaLower == "true")
        esFalso = (correctaLower == "false")
      end
      
      local respuestaTexto = "No especificada"
      if esVerdadero then
        respuestaTexto = "Verdadero"
      elseif esFalso then
        respuestaTexto = "Falso"
      end
      
      result.content:insert(pandoc.RawBlock("html", '<details class="solucion-details verdadero-falso-solucion">'))
      result.content:insert(pandoc.RawBlock("html", '<summary class="solucion-summary">Solución</summary>'))
      result.content:insert(pandoc.RawBlock("html", '<div class="solucion-content">'))
      result.content:insert(pandoc.Para({pandoc.Strong({pandoc.Str("Respuesta correcta: " .. respuestaTexto)})}))
      result.content:insert(pandoc.RawBlock("html", '</div>'))
      result.content:insert(pandoc.RawBlock("html", '</details>'))
      
      return result
      
    -- CASO 3: Soluciones inline normales (mostrar directamente)
    elseif mostrarSoluciones then
      
      local checkboxV = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      local checkboxF = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      
      local esVerdadero = false
      local esFalso = false
      
      if type(correcta) == "boolean" then
        esVerdadero = correcta == true
        esFalso = correcta == false
      elseif type(correcta) == "string" then
        local correctaLower = string.lower(correcta)
        esVerdadero = (correctaLower == "true")
        esFalso = (correctaLower == "false")
      end
      
      if esVerdadero then
        checkboxV = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
      elseif esFalso then
        checkboxF = pandoc.RawInline("html", '<input type="checkbox" checked disabled>')
      end
      
      local result = pandoc.Div({}, pandoc.Attr("", {"verdadero-falso"}, {}))
      
      local contentCopia = pandoc.List()
      for _, block in ipairs(content) do
        contentCopia:insert(block:clone())
      end
      
      if numero_text ~= "" then
        if #contentCopia > 0 and contentCopia[1].t == "Para" then
          table.insert(contentCopia[1].content, 1, pandoc.Str(numero_text))
        else
          table.insert(contentCopia, 1, pandoc.Para({pandoc.Str(numero_text)}))
        end
      end
      
      for _, block in ipairs(contentCopia) do
        result.content:insert(block)
      end
      
      result.content:insert(pandoc.Para({
        checkboxV,
        pandoc.Str(" Verdadero "),
        pandoc.Space(),
        checkboxF,
        pandoc.Str(" Falso")
      }))
      
      return result
      
    -- CASO 4: Sin soluciones
    else
      
      local result = pandoc.Div({}, pandoc.Attr("", {"verdadero-falso"}, {}))
      
      local contentCopia = pandoc.List()
      for _, block in ipairs(content) do
        contentCopia:insert(block:clone())
      end
      
      if numero_text ~= "" then
        if #contentCopia > 0 and contentCopia[1].t == "Para" then
          table.insert(contentCopia[1].content, 1, pandoc.Str(numero_text))
        else
          table.insert(contentCopia, 1, pandoc.Para({pandoc.Str(numero_text)}))
        end
      end
      
      for _, block in ipairs(contentCopia) do
        result.content:insert(block)
      end
      
      local checkboxV = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      local checkboxF = pandoc.RawInline("html", '<input type="checkbox" disabled>')
      
      result.content:insert(pandoc.Para({
        checkboxV,
        pandoc.Str(" Verdadero "),
        pandoc.Space(),
        checkboxF,
        pandoc.Str(" Falso")
      }))
      
      return result
    end
  end
end


local function processEspacioDesarrollo(div)
  if div.classes:includes("espacio-desarrollo") then
    local args = parseTypstArguments(div.attributes.arguments)
    local lineas = args.lineas or div.attributes.lineas or "5"
    local altura = tonumber(lineas) * 1.5
    
    return pandoc.Div({
      pandoc.RawBlock("html", '<div style="min-height: ' .. altura .. 'em; border: 0px dashed #ccc; padding: 0em; margin: 0em 0;"></div>')
    }, pandoc.Attr("", {"espacio-desarrollo"}, {}))
  end
end




local function createDocumentHeader(meta)
  local mostrarCabecera = meta["mostrar-cabecera"] or meta["show-cabecera"]
  
  if not mostrarCabecera or pandoc.utils.stringify(mostrarCabecera) ~= "true" then
    return nil
  end
  
  local header = pandoc.Div({}, pandoc.Attr("", {"document-header"}, {}))
  
  if meta.logo then
    local logoPath = pandoc.utils.stringify(meta.logo)
    if logoPath ~= "" then
      local logoImg = pandoc.Para({
        pandoc.Image({}, logoPath, "", pandoc.Attr("", {"document-logo"}, {}))
      })
      header.content:insert(logoImg)
    end
  end
  
  if meta.title then
    header.content:insert(pandoc.Header(1, meta.title))
  end
  
  local info = {}
  
  if meta.departamento then
    table.insert(info, pandoc.Str(pandoc.utils.stringify(meta.departamento)))
  end
  
  if meta.titulacion then
    if #info > 0 then table.insert(info, pandoc.LineBreak()) end
    table.insert(info, pandoc.Str(pandoc.utils.stringify(meta.titulacion)))
  end
  
  if meta.asignatura then
    if #info > 0 then table.insert(info, pandoc.LineBreak()) end
    table.insert(info, pandoc.Strong({pandoc.Str(pandoc.utils.stringify(meta.asignatura))}))
  end
  
  if meta["tipo-examen"] then
    if #info > 0 then table.insert(info, pandoc.LineBreak()) end
    table.insert(info, pandoc.Str(pandoc.utils.stringify(meta["tipo-examen"])))
  end
  
  if meta["fecha-examen"] then
    if #info > 0 then table.insert(info, pandoc.LineBreak()) end
    table.insert(info, pandoc.Str(pandoc.utils.stringify(meta["fecha-examen"])))
  end
  
  if #info > 0 then
    header.content:insert(pandoc.Div({
      pandoc.Para(info)
    }, pandoc.Attr("", {"document-info"}, {})))
  end
  
  return header
end

local function applyColorTheme(meta)
  local colorTheme = meta["color-theme"]
  local primaryColor = meta["primary-color"]
  local secondaryColor = meta["secondary-color"]
  
  if not colorTheme and not primaryColor and not secondaryColor then
    return nil
  end
  
  local styles = {}
  
  if primaryColor then
    table.insert(styles, "--examtypst-primary-color: " .. pandoc.utils.stringify(primaryColor) .. ";")
  end
  
  if secondaryColor then
    table.insert(styles, "--examtypst-secondary-color: " .. pandoc.utils.stringify(secondaryColor) .. ";")
  end
  
  if #styles > 0 then
    return pandoc.RawBlock("html", "<style>:root { " .. table.concat(styles, " ") .. " }</style>")
  end
  
  return nil
end



return {
  {
    Meta = function(meta)
      _G.document_meta = meta
      
      ejercicio_counter = 0
      apartado_counters = {}
      verdaderoFalso_counters = {}
      
      return meta
    end
  },
  {
    Div = function(div)
      local meta = _G.document_meta or {}
      
      local result = processEjercicio(div, meta)
      if result then return result end
      
      result = processSolucion(div, meta)
      if result then return result end
      
      result = processApartado(div)
      if result then return result end
      
      result = processPreguntaMultiple(div, meta)
      if result then return result end
      
      result = processVerdaderoFalso(div, meta)
      if result then return result end
      
      result = processEspacioDesarrollo(div)
      if result then return result end
      
      result = processTablaCalificaciones(div)
      if result then return result end
      
      return div
    end
  },
  {
    Pandoc = function(doc)
      -- AÑADIR ESTA LÍNEA AL PRINCIPIO:
      table.insert(doc.blocks, 1, addCustomCSS(doc.meta))
      local themeBlock = applyColorTheme(doc.meta)
      if themeBlock then
        table.insert(doc.blocks, 1, themeBlock)
      end
      
      local colorTheme = doc.meta["color-theme"]
      if colorTheme then
        local themeName = pandoc.utils.stringify(colorTheme)
        if themeName ~= "default" then
          table.insert(doc.blocks, 1, pandoc.RawBlock("html", '<div class="theme-' .. themeName .. '">'))
          table.insert(doc.blocks, pandoc.RawBlock("html", '</div>'))
        end
      end
      
      local header = createDocumentHeader(doc.meta)
      
      if header then
        local insertPos = themeBlock and 2 or 1
        table.insert(doc.blocks, insertPos, header)
      end
      
      -- local tabbedSolutions = doc.meta["tabbed-solutions"] or doc.meta["soluciones-pestanas"]
      local tabbedSolutions = doc.meta["solutions-at-end"] or doc.meta["soluciones-al-final"]  -- PEDRO
      if tabbedSolutions and pandoc.utils.stringify(tabbedSolutions) == "true" then
        doc.blocks = createTabbedDocument(doc.blocks, doc.meta)
      end
      
      return doc
    end
  }
}
