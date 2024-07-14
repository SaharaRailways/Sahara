vanilla_model.PLAYER:setVisible(false)

vanilla_model.ARMOR:setVisible(false)

vanilla_model.HELMET_ITEM:setVisible(true)


vanilla_model.CAPE:setVisible(false)


vanilla_model.ELYTRA:setVisible(false)


--tick event, called 20 times per second
local isFlying = false
local head = models.model.root.Head
local roaches = models.model.root.Head.roach
local followedModelPart = head
local roachPos = roaches:partToWorldMatrix():apply():scale(16)-roaches:getPivot()
local roachRot
local playerRot
local input = vec(0,0,0)
local velocity = vec(0,0,0)
local followRoach = keybinds:newKeybind("Follow the roach toggle", "key.keyboard.u", false)
local forward = keybinds:newKeybind("Move forward", "key.keyboard.y", false)
local back = keybinds:newKeybind("Move backwards", "key.keyboard.h", false)
local left = keybinds:newKeybind("Move left", "key.keyboard.g", false)
local right = keybinds:newKeybind("Move right", "key.keyboard.j", false)
local up = keybinds:newKeybind("Move up", "key.keyboard.b", false)
local down = keybinds:newKeybind("Move down", "key.keyboard.n", false)
--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  playerRot = player:getRot()
  roachRot = vec(-playerRot[1],180-playerRot[2],0)
  input = vec(0,0,0)
end
function updatePosition()
  if player:isLoaded() then
    roachRot = vec(-playerRot[1],180-playerRot[2],0)
    roachPos = roaches:partToWorldMatrix():apply():scale(16)-roaches:getPivot()
    input = vec(0,0,0)
    velocity = vec(0,0,0)
  else 
    return
  end
end
followRoach:setOnPress(function()
    isFlying = not isFlying
    if isFlying then
      updatePosition()
      roaches:setPos(roachPos+input*2)
      roaches:setRot(roachRot)
      print(roaches:getPos())
      roaches:setParentType("WORLD")
    else
      roaches:setPos(0,0,0)
      roaches:setRot(0,0,0)
      roaches:setParentType("NIL")
    end
end)
function events.tick()

end

function events.post_render(delta)
  if forward:isPressed() then
    input[1] = input[1] + 1
  end
  if back:isPressed() then
    input[1] = input[1] - 1
  end
  if up:isPressed() then
    input[2] = input[2] + 1
  end
  if down:isPressed() then
    input[2] = input[2] - 1
  end
  if right:isPressed() then
    input[3] = input[3] + 1
  end
  if left:isPressed() then
    input[3] = input[3] - 1
  end

  if isFlying then
    --if input:lengthSquared() > 1 then
    --  input:normalize()
    --end
    roachPos = roaches:getPos()
    playerRot = player:getRot()
    roachRot = vec(-playerRot[1],180-playerRot[2],0)
    playerLook = player:getLookDir()
    betterLookScale = 1/(math.abs(playerLook[1])+math.abs(playerLook[3]))
    betterLookX = playerLook[1]*betterLookScale
    betterLookZ = playerLook[3]*betterLookScale
    if not (input[1] == 0) then
      roachPos = roachPos:add(betterLookX*input[1], 0, betterLookZ*input[1])
    end
    if not (input[3] == 0) then
      roachPos = roachPos:add(-1*(betterLookZ*input[3]), 0, betterLookX*input[3])
    end
    local acceleration = 0.05
    --local dv = acceleration*delta
    --local v0 = velocity
    --local v1 = velocity+dv
    --local movement = (velocity + velocity + acceleration*delta) * delta
    roaches:setPos(roachPos)
    roaches:setRot(roachRot)
    --velocity = v1
    input = vec(0,0,0)
  end
end


--[[
  speed = 5
  playerLook = player:getLookDir()
  betterLookScale = 1/(math.abs(playerLook[1])+math.abs(playerLook[3]))
  betterLookX = playerLook[1]*betterLookScale*speed--*math.sign(playerLook[3])
  betterLookZ = playerLook[3]*betterLookScale*speed--*math.sign(playerLook[1])
  betterLookY = 0
  if up and (not down) then
    betterLookY = speed
  elseif down and (not up) then
    betterLookY = -speed
  end
  curPos = curPos:add(0, betterLookY, 0)
  --playerLook = vec(math.abs(playerLook[1]),math.abs(playerLook[2]),math.abs(playerLook[3]))
  if toggle then
  sPos = roaches:getPos()
  end
  if forward then
    curPos = curPos:add(betterLookX, 0, betterLookZ)
  end
  if right then
    curPos = curPos:add(1-betterLookZ, 0, betterLookX)
  end
  if left then
    curPos = curPos:add(betterLookZ, 0, 1-betterLookX)
  end
  if backward then
    curPos = curPos:add(1-betterLookX, 0, 1-betterLookZ)
  end
  
  print("EEEEEEEEEEEE")
  print(betterLookX)
  print(betterLookZ)
  print(betterLookY)
  print(up)
  print(down)
  print(up and down)
end]]