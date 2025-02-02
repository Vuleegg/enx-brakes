local VuleTablica = {}

local cekirajOwned = function(convars, tablica, callback)
    local query = ([[SELECT 1 FROM %s WHERE plate = ? LIMIT 1]]):format(convars)
    
    exports.oxmysql:execute(query, {tablica}, function(result)
        if result and #result > 0 then
            callback(true) 
        else
            callback(false) 
        end
    end)
end

local loadujJson = function()
    local jsondata = LoadResourceFile(GetCurrentResourceName(), "shared/status.json")
    if jsondata and jsondata ~= "" then
        local success, parsed = pcall(json.decode, jsondata)
        if success and type(parsed) == "table" then
            VuleTablica = parsed
        else
            VuleTablica = {}
        end
    else
        VuleTablica = {}
    end
    GlobalState.VuleTablica = VuleTablica
end

local SacuvajJson = function()
    SaveResourceFile(GetCurrentResourceName(),  "shared/status.json", json.encode(VuleTablica, { indent = true }), -1)
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadujJson()
    end
end)

RegisterNetEvent("vule-kocnice:server:Akcija", function(data)
    if not data then return print("[VULE-GG] - Data table does not exist") end 
    if not data.tablice then return print("[VULE-GG] - Plates do not exist in the data table") end 
    if data.state == nil then return print("[VULE-GG] - State does not exist in the data table") end

    if VuleTablica == nil then
        VuleTablica = {}
    end

    cekirajOwned(dbTable, data.tablice, function(exists)
        if exists then
            VuleTablica[data.tablice] = data.state
            GlobalState.VuleTablica = VuleTablica 
            SacuvajJson()
        else
            print(string.format("[VULE-GG] - No need for a JSON file, no one owns a vehicle with plates %s", data.tablice))
        end
    end)
end)
