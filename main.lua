function love.load()
    love.window.setMode(400,240)

    anim8 = require 'libraries/anim8/anim8'
    wf = require 'libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    vector = require 'libraries/hump/vector'
    
    world = wf.newWorld(0, 600, false)
    --allows for collision query 
    world:setQueryDebugDrawing(true)

    --collision classes

    world:addCollisionClass('Ground')
    world:addCollisionClass('Kubba')

    --sprites and sprite tables
    sprites = {}
    sprites.kubba = love.graphics.newImage('graphics/kubbaSheet.png')

    -- animation grids

    --Kubba
    local kubbaRegular = anim8.newGrid(32, 32, sprites.kubba:getWidth(), sprites.kubba:getHeight())
    local kubbaLarge = anim8.newGrid(64, 64, sprites.kubba:getWidth(), sprites.kubba:getHeight())

    --animations
    kubbaAnimations = {}

    kubbaAnimations.stand = anim8.newAnimation(kubbaRegular('1-4', 1), 0.3)
    kubbaAnimations.inAir = anim8.newAnimation(kubbaRegular('1-2', 2), 0.07)
    kubbaAnimations.attackClaw = anim8.newAnimation(kubbaRegular('1-9', 3), 0.05)

    --required
    require('kubba')

    --Other Tables
    platforms = {}

    --debug material DELETE WHEN DONE TESTING
    regFrameTotal = 0
    debugug = 0
    debugugug = 0
    debugugugug = 0
end

function love.update(dt)
    world:update(dt)

    kubbaUpdate(dt)

    deBug()
end

function love.draw()
    world:draw()
    drawKubba()
    love.graphics.print(regFrameTotal, 20, 20)
    love.graphics.print("onground " ..debugug, 20, 40)
    love.graphics.print("attacking: " ..debugugug, 20, 60)
    love.graphics.print("onground not attacking:" ..debugugugug, 120, 40)
end

function love.keypressed(key)
    local kx, ky = kubba:getPosition()
    
    if key == 'space' then        
        if kubba.onGround and not kubba.attacking then
            kubba:applyLinearImpulse(0, -400)  
        end
    end
    if key == 'z' then
        if kubba.onGround then
            kubba.attacking = true
            regFrameTotal = 0.00
        end
    end
end

function deBug()
    if kubba.onGround then
        debugug = 1
    else
        debugug = 0
    end
    if kubba.attacking then
        debugugug = 1
    else
        debugugug = 0
    end
    if kubba.onGround and not kubba.attacking then
        debugugugug = 1
    else
        debugugugug = 0
    end

end

function spawnPlatform(x, y, width, height)
    -- second physics hitbox for a STATIC hitbox (does not move)
    local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Ground"})
    platform:setType('static')
    table.insert(platforms, platform)
end
