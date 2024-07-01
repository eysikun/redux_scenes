local hidden = false
local scenes = {}
local settingScene = false
local coords = {}
local colors = {
    ["white"] = {255, 255, 255},
    ["red"] = {255, 0, 0},
    ["blue"] = {0, 0, 255},
    ["green"] = {0, 128, 0},
    ["yellow"] = {255, 255, 0},
    ["purple"] = {128, 0, 128},
}

require('functions')

RegisterNetEvent('redux_scenes:send', function(sentScenes)
    scenes = sentScenes
end)

RegisterCommand('+scenecreate', function()
   
end)

RegisterCommand('-scenecreate', function()
    if settingScene then 
        settingScene = false 
        return 
    end
    
    local placement = SceneTarget()
    coords = {}
    settingScene = true

    while settingScene do
        Wait(5)
        DisableControlAction(0, 200, true)
        placement = SceneTarget()
        
        if placement then
            DrawMarker(28, placement.x, placement.y, placement.z, 0, 0, 0, 0, 0, 0, 0.15, 0.15, 0.15, 93, 17, 100, 255, false, false)
        end
        
        if IsControlJustReleased(0, 202) then
            settingScene = false
            return
        end
    end

    if not placement or placement.x == 0.0 or placement.y == 0.0 or placement.z == 0.0 then
        return
    end
    
    coords = placement
    
    local scene = lib.inputDialog('Add Scene', {
        {type = 'input', label = 'Enter Text', description = 'Scene Text', required = true, min = 4, max = 600},
        {type = 'input', label = 'Color', description = 'Color', icon = 'hashtag'},
        {type = 'number', label = 'Distance'}
    })

    if not scene or not scene[1] then
        return
    end
    
    local message = scene[1]
    local color = scene[2]
    local distance = tonumber(scene[3]) or 10.0
    
    if distance > 10.0 then
        distance = 10.0
    elseif distance < 1.1 then
        distance = 1.1
    end
    
    color = colors[string.lower(color)] or colors["white"]
    
    TriggerServerEvent('redux_scenes:add', coords, message, color, distance)
end)

RegisterCommand('+scenehide', function()
    hidden = not hidden
    if hidden then
        print("Scenes Disabled")
    else
        print("Scenes Enabled")
    end
end)

RegisterCommand('+scenedelete', function()
    local scene = ClosestSceneLooking(scenes)
    if scene then
        TriggerServerEvent('redux_scenes:delete', scene)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if #scenes > 0 then
            if not hidden then
                local closest = ClosestScene(scenes)
                if closest > 10.0 then
                    Wait(250)
                else
                    local plyCoords = GetEntityCoords(PlayerPedId())
                    for k, v in pairs(scenes) do
                        local distance = Vdist(plyCoords, v.coords.x, v.coords.y, v.coords.z)
                        if distance <= v.distance then
                            DrawScene(v.coords, v.message, v.color)
                        end
                    end
                end
            else
                Wait(250)
            end
        else
            Wait(250)
        end
    end
end)

TriggerServerEvent('redux_scenes:fetch')
RegisterKeyMapping('+scenecreate', '(scenes): Place Scene', "keyboard", "i")
RegisterKeyMapping('+scenehide', '(scenes): Toggle Scenes', "keyboard", "o")
RegisterKeyMapping('+scenedelete', '(scenes): Delete Scene', "keyboard", "n")
