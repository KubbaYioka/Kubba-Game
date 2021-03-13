kubbaStartX = 150
kubbaStartY = 100
testPlatform = true

-- combines a body, fixture, and shape into one attribute. Technically a hitbox
-- created a collider object at x y position 360 and 100 at 80 x 80 pixels
-- associates hitbox with collision class "Player"
-- speed line accounts for framerate
kubba = world:newRectangleCollider(kubbaStartX, kubbaStartY, 32, 32, {collision_class = "Kubba"}) 
--disables rotation
kubba:setFixedRotation(true) 

kubba.animation = kubbaAnimations.stand
kubba.speed = 75
kubba.moving = false
kubba.direction = 1
kubba.onGround = false
kubba.attacking = false

--velocity
kubba.velocity = 0
kubba.acceleration = 1

--animation loop control for 32x32 sprites
--takes five arguments, the range in the animation grid, the row of the animation
--, the number of times that animation is to be played, and the associated boolean that will be made false at the 
--end of the loop. The last variable is dt.

function animationLoopReg(gridRange, row, loopNumber, aniSpeed, aniBoolean, dt)
    local kubbaRegular = anim8.newGrid(32, 32, sprites.kubba:getWidth(), sprites.kubba:getHeight())

    if aniBoolean then
        local frameNumber = kubbaRegular:getFrames(gridRange, row)
        local totalLoop = #frameNumber * loopNumber
        if regFrameTotal >= totalLoop * aniSpeed then
            aniBoolean = false
        else
            regFrameTotal = regFrameTotal + 1 * dt
        end
    end
    if aniBoolean == false then
        kubba.animation = kubbaAnimations.stand
    end
end

function kubbaUpdate(dt)
    --checks to see that the kubba hitbox exists
    if kubba.body then
        local kx, ky = kubba:getPosition()

        --checks to see if the kubba is on the ground
        local colliders = world:queryRectangleArea(kubba:getX() - 15, kubba:getY() + 15, 30, 2, {'Ground'})
        if #colliders >0 then
            kubba.onGround = true
        else
            kubba.onGround = false
        end

        kubba.moving = false
        -- function that checks every frame for keypresses for left and right. 
        -- If either is pressed, then the x value for the kubba changes. * dt ties to FPS

        if love.keyboard.isDown('right') then
            if kubba.attacking == false then
                kubba:setX(kx + kubba.speed*dt)
                if love.keyboard.isDown('c') then
                    kubba:setX(kx + (kubba.speed + 50) * dt)
                end
                kubba.moving = true
            end
            kubba.direction = 1
        end
        if love.keyboard.isDown('left') then
            if kubba.attacking == false then
                kubba:setX(kx - kubba.speed*dt)
                if love.keyboard.isDown('c') then
                    kubba:setX(kx - (kubba.speed + 50) * dt)
                end
                kubba.moving = true
            end
            kubba.direction = -1
        end

        --check for kubba danger collision
        if kubba:enter('Danger') then
            kubba:setPosition(kubbaStartX, kubbaStartY)
        end
    end    
    
    --animation control
    if kubba.onGround then
        kubba.animation = kubbaAnimations.stand
        if kubba.attacking then
            kubba.animation = kubbaAnimations.attackClaw
            animationLoopReg('1-9', 3, 1, 0.05, kubba.attacking, dt)
        end
    else
        kubba.animation = kubbaAnimations.inAir
    end

    if testPlatform then
        spawnPlatform(50, 150, 150, 40)
        spawnPlatform(200, 130, 100, 60)
        testPlatform = false
    end
    kubba.animation:update(dt)
end

function drawKubba()
    --draw sprites
    local kx, ky = kubba:getPosition()
    kubba.animation:draw(sprites.kubba, kx, ky, nil, 1 * kubba.direction, 1, 16, 16)
    --love.graphics.draw()
end

