kubbaStartX = 150
kubbaStartY = 100
testPlatform = true

-- combines a body, fixture, and shape into one attribute. Technically a hitbox
-- created a collider object at x y position 360 and 100 at 80 x 80 pixels
-- associates hitbox with collision class "Player"
-- speed line accounts for framerate
kubba = world:newRectangleCollider(kubbaStartX, kubbaStartY, 20, 20, {collision_class = "Kubba"})
--disables rotation
kubba:setFixedRotation(true)
kubba:setFriction(1)

kubba.animation = kubbaAnimations.stand
kubba.speed = 2
kubba.moving = false
kubba.direction = 1
kubba.onGround = false
kubba.attacking = false
kubba.currentWeapon = 1

--velocity
kubba.vel = 0
kubba.accel = 2
kubba.decel = 2

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
        regFrameTotal = 0
    end
    return aniBoolean
end

function kubbaUpdate(dt)
    --checks to see that the kubba hitbox exists
    if kubba.body then
        local kx, ky = kubba:getPosition()

        --checks to see if the kubba is on the ground
        local colliders = world:queryRectangleArea(kubba:getX() - 10, kubba:getY() + 10, 20, 4, {'solid', 'semiSolid'})
        if #colliders >0 then
            kubba.onGround = true
        else
            kubba.onGround = false
        end

        --kubba.moving = false
        -- function that checks every frame for keypresses for left and right.
        -- If either is pressed, then the x value for the kubba changes. * dt ties to FPS

        if love.keyboard.isDown('right') then
            if kubba.attacking == false then
                kubba.vel = kubba.vel + (kubba.speed * kubba.accel * dt)
                if kubba.vel > kubba.speed then
                    kubba.vel = kubba.speed
                end
                kubba:setX(kx + kubba.vel)
                kubba.moving = true
            end
            kubba.direction = 1
        elseif love.keyboard.isDown('left') then
            if kubba.attacking == false then
                kubba.vel = kubba.vel - (kubba.speed * kubba.accel * dt)
                if kubba.vel < -kubba.speed then
                    kubba.vel = -kubba.speed
                end
                kubba:setX(kx + kubba.vel)
                kubba.moving = true
            end
            kubba.direction = -1
        else
            kubba.moving = false
            if kubba.vel > 0 then
                kubba.vel = kubba.vel - (kubba.speed * kubba.decel * dt)
                if kubba.vel < 0 then
                    kubba.vel = 0
                end
            elseif kubba.vel < 0 then
                kubba.vel = kubba.vel + (kubba.speed * kubba.decel * dt)
                if kubba.vel > 0 then
                    kubba.vel = 0
                end
            end

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
            kubba.attacking = animationLoopReg('1-9', 3, 1, 0.05, kubba.attacking, dt)
        end
    else
        kubba.animation = kubbaAnimations.inAir
    end

    if testPlatform then
        loadLevel('testLevel')
        testPlatform = false
    end
    kubba.animation:update(dt)
end

function kubbaAttackBox()

        --create hitbox with given dimensions at the specified coordinates during the frames specified
        --check for special conditions (if attackTable.projectile == true, etc)
end

function switchWeapon()
  local w = kubba.currentWeapon
  local b = weaponTable[w].weaponEnabled
    while b == false do
      b = weaponTable[w].weaponEnabled
      w = w+1
      if w <= 9 then
        if b then
          return w
        end
      else
        w = 1
        return w
      end
    end
end

function drawKubba()
    --draw sprites
    local kx, ky = kubba:getPosition()
    if kubba.animation == kubbaAnimations.inAir then
        kubba.animation:draw(sprites.kubba, kx, ky, nil, 1 * kubba.direction, 1, 16, 11)
    else
        kubba.animation:draw(sprites.kubba, kx, ky, nil, 1 * kubba.direction, 1, 18, 22)
    end
end
