local oxmysql = exports.oxmysql
local scenes = {}

RegisterNetEvent('redux_scenes:fetch', function()
    local src = source
    oxmysql:execute('SELECT * FROM scenes', {}, function(result)
        if result and #result > 0 then
          
            for i, scene in ipairs(result) do
                scene.coords = json.decode(scene.coords)
                scene.color = json.decode(scene.color) 
            end
            TriggerClientEvent('redux_scenes:send', src, result)
        else
            TriggerClientEvent('redux_scenes:send', src, {})
        end
    end)
end)



RegisterNetEvent('redux_scenes:add', function(coords, message, color, distance)
    if coords and message and color and distance then
        local coordsJson = json.encode(coords)
        local colorJson = json.encode(color) 

        oxmysql:insert('INSERT INTO scenes (message, color, distance, coords) VALUES (?, ?, ?, ?)', {message, colorJson, distance, coordsJson}, function(insertId)
            if insertId then
                local scene = {
                    id = math.random(1, 999),
                    message = message,
                    color = color,
                    distance = distance,
                    coords = coords
                }
                table.insert(scenes, scene)
                TriggerClientEvent('redux_scenes:send', -1, scenes)
            else
                print('Failed to insert scene into database.')
            end
        end)
    else
        print('redux_scenes:add - Invalid parameters')
        print('coords:', coords)
        print('message:', message)
        print('color:', color)
        print('distance:', distance)
    end
end)



RegisterNetEvent('redux_scenes:delete', function(key)
    if scenes[key] then
        local sceneId = scenes[key].id
        oxmysql:execute('DELETE FROM scenes WHERE id = ?', {sceneId}, function(affectedRows)
            if affectedRows > 0 then
                table.remove(scenes, key)
                TriggerClientEvent('redux_scenes:send', -1, scenes)
            else
                print('Failed to delete scene from database.')
            end
        end)
    else
        print('redux_scenes:delete - Invalid key: ' .. tostring(key))
    end
end)


