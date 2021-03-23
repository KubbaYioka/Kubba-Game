function love.load()
    love.window.setMode(400,240)

    anim8 = require 'libraries/anim8/anim8'
    wf = require 'libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    vector = require 'libraries/hump/vector'

    cam = cameraFile()

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

    world = wf.newWorld(0, 600, false)
    --allows for collision query
    world:setQueryDebugDrawing(true)

    --collision classes

    world:addCollisionClass('solid')
    world:addCollisionClass('semiSolid')
    world:addCollisionClass('Kubba')

    --required
    require('kubba')
    require('levelControl')
    require('cameraControl')
    require('progressTables')

    --Other Tables
    platforms = {}
    semiPlatforms = {}
    semiSlopePlatforms = {}

    -- global vars
    regFrameTotal = 0

    --debug
    debugX = 0
    debugY = 0
end

function love.update(dt)
    world:update(dt)
    kubbaUpdate(dt)

    cameraUpdate(dt)
end

function love.draw()
    cam:attach()
        levelMap:drawLayer(levelMap.layers["background"])
        levelMap:drawLayer(levelMap.layers["level"])

        world:draw()
        drawKubba()
        levelMap:drawLayer(levelMap.layers["foreground"])
    cam:detach()
    love.graphics.print(kubba.currentWeapon)
    love.graphics.print(debugX, 0, 10)
    love.graphics.print(debugY, 0, 20)
end

function love.keypressed(key)
    local kx, ky = kubba:getPosition()
    if key == 'space' then
        if kubba.onGround and not kubba.attacking then
            kubba:applyLinearImpulse(0, -200)
        end
    end
    if key == 'z' then
        if kubba.onGround then
            kubba.attacking = true
        end
    end
    if key == 't' then
        kubba.currentWeapon = switchWeapon()
    end
end
