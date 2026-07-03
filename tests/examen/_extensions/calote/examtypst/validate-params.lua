-- return {
--   Meta = function(meta)
--     local function coalesce_bool(m, keys)
--       for _, k in ipairs(keys) do
--         if m[k] ~= nil then
--           local v = m[k]
--           local t = pandoc.utils.type(v)
--           if t == 'MetaBool' then
--             return v
--           elseif t == 'MetaString' then
--             local s = pandoc.utils.stringify(v):lower()
--             if s == 'true' then return true end
--             if s == 'false' then return false end
--           end
--         end
--       end
--       return nil
--     end

--     local val = coalesce_bool(meta, { 'mostrar-cabecera', 'show-cabecera' })
--     if val == nil then val = true end
--     meta['show-cabecera-effective'] = pandoc.MetaString(tostring(val))
--     return meta
--   end
-- }


-- Coalescencia booleana robusta para mostrar/ocultar cabecera
local function coalesce_bool(meta, keys)
  for _, k in ipairs(keys) do
    if meta[k] ~= nil then
      local s = pandoc.utils.stringify(meta[k]):lower()
      if s == 'true' then return true end
      if s == 'false' then return false end
    end
  end
  return nil
end

return {
  Meta = function(meta)
    -- Prioridad: mostrar-cabecera (aunque sea false) > show-cabecera > por defecto true
    local val = coalesce_bool(meta, { 'mostrar-cabecera', 'show-cabecera' })
    if val == nil then val = true end
    meta['show-cabecera-effective'] = pandoc.MetaString(tostring(val))
    return meta
  end
}