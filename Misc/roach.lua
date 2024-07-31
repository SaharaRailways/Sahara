vanilla_model.PLAYER:setVisible(false)

vanilla_model.ARMOR:setVisible(false)

vanilla_model.HELMET_ITEM:setVisible(true)


vanilla_model.CAPE:setVisible(false)


vanilla_model.ELYTRA:setVisible(false)


--tick event, called 20 times per second
local head = models.model.root.Head
local roaches = models.model.root.Head.roach
local followedModelPart = head
local roachPos = roaches:partToWorldMatrix():apply():scale(16)-roaches:getPivot()
local roachRot
local playerRot

local input = vec(0,0,0)
local velocity = vec(0,0,0)
local movement = vec(0,0,0)
local playerLook = vec(0,0,0)
local betterLookScale = 0
local betterLookX = 0
local betterLookZ = 0

local isFlying = false
local watchingRoach = true
local flyToggle = keybinds:newKeybind("Toggles the roach flying", "key.keyboard.u", false)
local perspectiveToggle = keybinds:newKeybind("Switches between the player and roach perspective while it is flying", "key.keyboard.o", false)
local forwardKey = keybinds:newKeybind("Move forward", "key.keyboard.y", false)
local backKey = keybinds:newKeybind("Move backwards", "key.keyboard.h", false)
local leftKey = keybinds:newKeybind("Move left", "key.keyboard.g", false)
local rightKey = keybinds:newKeybind("Move right", "key.keyboard.j", false)
local upKey = keybinds:newKeybind("Move up", "key.keyboard.i", false)
local downKey = keybinds:newKeybind("Move down", "key.keyboard.k", false)
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
flyToggle:setOnPress(function()
    isFlying = not isFlying
    if isFlying then
      updatePosition()
      roaches:setPos(roachPos+input*2)
      roaches:setRot(roachRot)
      print(roaches:getPos())
      roaches:setParentType("WORLD")
      watchingRoach = true
    else
      roaches:setPos(0,0,0)
      roaches:setRot(0,0,0)
      roaches:setParentType("NIL")
      renderer:setOffsetCameraPivot(vec(0,0,0))
      renderer:setCameraPos(0,0,0)
    end
end)
perspectiveToggle:setOnPress(function()
    watchingRoach = not watchingRoach
end)
function events.tick()

end

function events.post_render(delta)
  if forwardKey:isPressed() then
    input[1] = input[1] + 1
  end
  if backKey:isPressed() then
    input[1] = input[1] - 1
  end
  if upKey:isPressed() then
    input[2] = input[2] + 1
  end
  if downKey:isPressed() then
    input[2] = input[2] - 1
  end
  if rightKey:isPressed() then
    input[3] = input[3] + 1
  end
  if leftKey:isPressed() then
    input[3] = input[3] - 1
  end

  if isFlying then
    --if input:lengthSquared() > 1 then
    --  input:normalize()
    --end
    roachPos = roaches:getPos()
    playerPos = player:getPos()
    movement = vec(0,0,0)
    velocity = velocity:mul(0.8,0.8,0.8)
    playerRot = player:getRot()
    roachRot = vec(-playerRot[1],180-playerRot[2],0)
    playerLook = player:getLookDir()
    betterLookScale = 1/(math.abs(playerLook[1])+math.abs(playerLook[3]))
    betterLookX = playerLook[1]*betterLookScale
    betterLookZ = playerLook[3]*betterLookScale
    movement = movement:add(0, input[2], 0)
    if input[1] ~= 0 then
      movement = movement:add(betterLookX*input[1], 0, betterLookZ*input[1])
    end
    if input[3] ~= 0 then
      movement = movement:add(-1*(betterLookZ*input[3]), 0, betterLookX*input[3])
    end
    local acceleration = 1.2
    velocity = velocity:add(movement*acceleration)
    velocity = velocity*0.9
    roachPos:add(velocity)
    --local dv = acceleration*delta
    --local v0 = velocity
    --local v1 = velocity+dv
    --local movement = (velocity + velocity + acceleration*delta) * delta
    roaches:setPos(roachPos)
    roaches:setRot(roachRot)
    --velocity = v1
    input = vec(0,0,0)
    
    if watchingRoach then
      renderer:setCameraPivot(roachPos:div(vec(16,16,16)):add(vec(0,2,0)))
    else
      --renderer:setCameraPivot(playerPos:div(vec(16,16,16)):add(vec(0,2,0)))
      --renderer:setOffsetCameraPivot(vec(0,0,0))
      --renderer:setCameraPos(vec(0,1,0))
      renderer:setCameraPivot()
    end
  else
  --renderer:setCameraPivot(playerPos:div(vec(16,16,16)):add(vec(0,2,0)))
  renderer:setCameraPivot()
  end
  
end


