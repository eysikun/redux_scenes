function SceneTarget()
    local Cam = GetGameplayCamCoord()
    local _, Hit, Coords, _, Entity = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(Cam, GetCoordsFromCam(10.0, Cam), -1, PlayerPedId(), 4))
    if Hit then
        return Coords
    else
        return nil
    end
end


function GetCoordsFromCam(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3(math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z))
    local direction = vector3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
    return vector3(coords.x + direction.x * distance, coords.y + direction.y * distance, coords.z + direction.z * distance)
end


function DrawScene(coords, text, color)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    
    if onScreen then
        local camCoords = GetGameplayCamCoord()
        local dist = Vdist(camCoords.x, camCoords.y, camCoords.z, coords.x, coords.y, coords.z)
        
        local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 55
        
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringKeyboardDisplay(text)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextScale(0.0, 0.50 * scale)
        SetTextFont(0)
        SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 155)
        EndTextCommandDisplayText(x, y)
        
        local height = GetTextScaleHeight(0.50 * scale, 0)
        local length = string.len(text)
        local limiter = 120
        if length > 98 then
            length = 98
            limiter = 200
        end
        local width = length / limiter * scale
        
        DrawRect(x, (y + scale / 50), width, height - 0.005, 41, 11, 41, 68)
    end
end


function ClosestScene(scene)
    local scenes = scene
    local closestDistance = 1000.0
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    for i = 1, #scenes do
        local distance = Vdist(scenes[i].coords.x, scenes[i].coords.y, scenes[i].coords.z, playerCoords.x, playerCoords.y, playerCoords.z)
        
        if distance < closestDistance then
            closestDistance = distance
        end
    end
    
    return closestDistance
end

