local function val_to_str(v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, '[^\'"]', ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        return "table" == type(v) and table.stringify(v) or tostring(v)
    end
end

local function key_to_str(k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return "[\"" .. k .. "\"]"
    else
        return "[" .. val_to_str(k) .. "]"
    end
end

return function(tbl)
    local ret, done = {}, {}
    for i, v in ipairs(tbl) do
        table.insert(ret, val_to_str(v))
        done[i] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(ret, key_to_str(k) .. " = " .. val_to_str(v))
        end
    end
    return "{" .. table.concat(ret, ", ") .. "}"
end
