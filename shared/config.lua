dbTable = "player_vehicles" -- # for ESX owned_vehicles is tableName

Items = {
    Cutters = 'brake_cutter',
    FixTool = "fixkit"
}

Animations = {
    AnimationDict = 'mp_car_bomb',
    AnimationName = 'car_bomb_mechanic',
}

Strings = {
    BrakesCutDesc = "The vehicle's brakes are disabled.",
    CanceledDesc = "You canceled the brake cutting.",
    Onesposobljavate = "Disabling the brakes..",
    Preseci = "Cut the brakes",
    Fixaj = "Repair the brakes",
    FixaneKocnice = "The brakes have been repaired",
    OtkazanaFixTool = "You canceled the brake repair",
    Popravljate = "Repairing the brakes.."    
}

Alert = function(msg) -- # ovde stavis tvoje notif nisi tolko glup
    exports.qbx_core:Notify(msg)
end
