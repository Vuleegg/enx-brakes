function Trimaj(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function GetajTablicu(vehicle)
    if vehicle == 0 then return end
    return Trimaj(GetVehicleNumberPlateText(vehicle))
end

local function setBrakes(vehicle, cut)
    if cut then
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", 0.0)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 0.0)
    else
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", 1.0)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 0.5)
    end

    Entity(vehicle).state.brakesCut = cut
end

local function sjebiKocnice(entity)

    local success = lib.progressBar({
        duration = 5000,
        label = Strings['Onesposobljavate'],
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = { dict = Animations['AnimationDict'], clip = Animations['AnimationName'] }
    })

    if success then
        setBrakes(entity, true)
        Alert(Strings['BrakesCutDesc'])
        TriggerServerEvent('vule-kocnice:server:Akcija', { 
            tablice = GetajTablicu(entity),
            state = true,
        })        
    else
        Alert(Strings['CanceledDesc'])
    end
end

local function fixajKocnice(entity)
    local success = lib.progressBar({
        duration = 5000,
        label = Strings['Popravljate'],
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = { dict = Animations['AnimationDict'], clip = Animations['AnimationName'] }
    })

    if success then
        setBrakes(entity, false)
        Alert(Strings['FixaneKocnice'])
        TriggerServerEvent('vule-kocnice:server:Akcija', { 
            tablice = GetajTablicu(entity),
            state = false,
        }) 
    else
        Alert(Strings['OtkazanaFixTool'])
    end
end

exports.ox_target:addGlobalVehicle({
    {
        name = 'cut_brakes',
        icon = 'fa-solid fa-scissors',
        label = Strings['Preseci'],
        distance = 2.0,
        bones = {'wheel_lr', 'wheel_rr', 'wheel_lf', 'wheel_rf'},
        item = Items['Cutters'],
        onSelect = function(data)
            sjebiKocnice(data.entity)
        end,
        canInteract = function(entity)
            return not Entity(entity).state.brakesCut
        end,
    },
    {
        name = 'cut_brakes',
        icon = 'fa-solid fa-screwdriver',
        label = Strings['Fixaj'],
        distance = 2.0,
        bones = {'wheel_lr', 'wheel_rr', 'wheel_lf', 'wheel_rf'},
        item = Items['FixTool'],
        onSelect = function(data)
            fixajKocnice(data.entity)
        end,
        canInteract = function(entity)
            return Entity(entity).state.brakesCut
        end,
    },
})

lib.onCache('vehicle', function(vehicle)
    if vehicle then
        local state = Entity(vehicle).state.brakesCut
        setBrakes(vehicle, state)
        local tablicevozila = GetajTablicu(vehicle) 
        local json = GlobalState.VuleTablica[tablicevozila]
        if json then 
            Entity(vehicle).state.brakesCut = json
            setBrakes(vehicle, json)
        end
    end
end)
