worldDim = {}
worldDim.x = 0
worldDim.y = 0

cameraLook = {}
cameraLook.x = 300
cameraLook.y = 200

cameraRect = {}
cameraRect.x = 400
cameraRect.y = 240


function cameraView(dimX, dimY)
    --calculate level's max X and max Y dimensions. Test Level is 
    worldDim.x = dimX * 32
    worldDim.y = dimY * 32

    local kx, ky =  kubba:getPosition()
    cameraLook.x = kubbaStartX
    cameraLook.y = kubbaStartY
    
end

--note, still need to implement the bounding box for inside the screen so the player has a threshold. 
function cameraUpdate(dt)
    local kx, ky = kubba:getPosition()
    cameraLook.x = kx
    cameraLook.y = ky

    cameraLook.x = math.max(cameraLook.x, 0 + cameraRect.x / 2)
    cameraLook.x = math.min(cameraLook.x, worldDim.x - cameraRect.x / 2)
    cameraLook.y = math.max(cameraLook.y, 0 + cameraRect.y / 2)
    cameraLook.y = math.min(cameraLook.y, worldDim.y - cameraRect.y / 2)
    
    cam:lookAt(cameraLook.x, cameraLook.y)

    
end