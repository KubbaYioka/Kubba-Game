mapDetails = {}

function spawnSolid(x, y, width, height)
    local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "solid"})
    platform:setType('static')
    platform:setFriction(1) --friction set to 1 for each platform to prevent sliding.
    table.insert(platforms, platform)
end

function spawnSolidSlope(polyTable)
    local platform = world:newPolygonCollider(x1, y1, x2, y2, x3, y3, x4, y4, {collision_class = "solid"})
    platform:setType('static')
    platform:setFriction(1)
    table.insert(platforms, platform)
end

function spawnSemiSolid(x, y, width, height)
    local semiPlatform = world:newRectangleCollider(x, y, width, height, {collision_class = "semiSolid"})
    semiPlatform:setType('static')
    semiPlatform:setFriction(1)
    table.insert(semiPlatforms, semiPlatform)
end

function spawnSemiSolidSlope(polyTable) 
    local semiSlopePlatform = world:newPolygonCollider(polyTable, {collision_class = "semiSolid"})
    semiSlopePlatform:setType('static')
    semiSlopePlatform:setFriction(1)
    table.insert(semiSlopePlatforms, semiSlopePlatform)
end

function loadLevel(levelName)

    levelMap = sti("levels/" .. levelName .. ".lua")
    mapDetails = levelMap:getLayerProperties(levelMap.layers["background"])

    cameraView()

    for i, obj in pairs(levelMap.layers["start"].objects) do
        kubbaStartX = obj.x
        kubbaStartY = obj.y
    end

    kubba:setPosition(kubbaStartX, kubbaStartY)

    for i, obj in pairs(levelMap.layers["solid"].objects) do
        spawnSolid(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(levelMap.layers["solidSlope"].objects) do
        spawnSolidSlope(obj.x1, obj.y1, obj.x2, obj.y2, obj.x3, obj.y3, obj.x4, obj.y4)
    end
    
    for i, obj in pairs(levelMap.layers["semiSolid"].objects) do
        spawnSemiSolid(obj.x, obj.y, obj.width, obj.height)
    end

    --Spawning Slopes
    local semiSlope = levelMap.layers["semiSolidSlope"].objects
    for objnum = 1, #semiSlope do
        local polygons = {}
        local polyObj = semiSlope[objnum].polygon
        for vertNum = 1, #polyObj do
            local vert = polyObj[vertNum]
            table.insert(polygons, vert.x) 
            table.insert(polygons, vert.y)
        end
        spawnSemiSolidSlope(polygons) 
    end

end
