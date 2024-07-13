-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
--re-enable the helmet item
vanilla_model.HELMET_ITEM:setVisible(true)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end

--tick event, called 20 times per second
local isFollowing = true
local head = models.model.root.Head
local roaches = models.model.root.Head.roach
local followedModelPart = head
local roachHeadPos = roaches:partToWorldMatrix():apply()
local roachHeadRot = player:getRot():mul(-1,-1,1):add(0,180,0)
local followRoach = keybinds:newKeybind("Follow the roach toggle", "key.keyboard.u", false)
local forward = keybinds:newKeybind("Move forward", "key.keyboard.y", false)
local back = keybinds:newKeybind("Move backwards", "key.keyboard.h", false)
local left = keybinds:newKeybind("Move left", "key.keyboard.g", false)
local right = keybinds:newKeybind("Move right", "key.keyboard.j", false)
local up = keybinds:newKeybind("Move up", "key.keyboard.b", false)
local down = keybinds:newKeybind("Move down", "key.keyboard.n", false)
followRoach:setOnPress(function()
    --if isFollowing then
    --  followedModelPart = head
  --    roachHeadPos = followedModelPart:partToWorldMatrix():apply()
--      roachHeadRot = player:getRot():mul(-1,-1,1):add(0,180,0)
    --else
      --followedModelPart = roaches
--      roachHeadPos = roaches:partToWorldMatrix():apply()
  --    roachHeadRot = player:getRot():mul(-1,-1,1):add(0,180,0)
    --end
    roaches:changeParentType("WORLD")

end)
function events.tick()
  
end


function events.post_render(delta)
    if followedModelPart then
        local pos = followedModelPart:partToWorldMatrix():apply():mul(16,16,16)
        local rot = player:getRot()
        followedModelPart:setPos(pos)
        followedModelPart:setRot(-rot[1],180-rot[2],0)
    end
end











-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
--re-enable the helmet item
vanilla_model.HELMET_ITEM:setVisible(true)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end

--tick event, called 20 times per second
local roach = true
local roaches = models.model.root.Head.roach
local movement = vec(0,0,0)
local oldPos = vec(0,0,0)
local sPos = vec(0,0,0)
local curPos = vec(0,0,0)
local sRot = vec(0,0,0)
local curRot = vec(0,0,0)
local myKey = keybinds:newKeybind("Name", "key.keyboard.u", false)
local secKey = keybinds:newKeybind("Name", "key.keyboard.y", false)
local thirdKey = keybinds:newKeybind("Name", "key.keyboard.h", false)
local fourKey = keybinds:newKeybind("Name", "key.keyboard.g", false)
local fiveKey = keybinds:newKeybind("Name", "key.keyboard.j", false)
local sixKey = keybinds:newKeybind("Name", "key.keyboard.b", false)
local sevenKey = keybinds:newKeybind("Name", "key.keyboard.n", false)
local eightKey = keybinds:newKeybind("Name", "key.keyboard.n", false)
myKey:setOnPress(function()
  roach = not roach
  if roach then
    --print(roaches:getPos())
    roaches:setPos(0,0,0)
    roaches:setRot(0,0,0)
    roaches:moveTo(models.model.root.Head)
  else
    oldPos = roaches:partToWorldMatrix():apply():mul(16,16,16)
    oldRot = player:getRot()
    roaches:setPos(oldPos-roaches:getPivot())
    roaches:setRot(-oldRot[1],180-oldRot[2],0)
    roaches:moveTo(models.model.WORLD)
  end
end)
local toggle = false
function events.tick()
  testing = false
  forward = false
  backward = false
  left = false 
  right = false
  up = false
  down = false
  if secKey:isPressed() then
    forward = true
  end
  if thirdKey:isPressed() then
    backward = true
  end
  if fourKey:isPressed() then
    left = true
  end
  if fiveKey:isPressed() then
    right = true
  end
  if sixKey:isPressed() then
    down = true
  end
  if sevenKey:isPressed() then
    up = true
  end
  if eightKey:isPressed() then
    toggle = not toggle
  end
  --[[if math.abs(movement:length()) > 0.5 then
    movement = movement:sub(vec(0.1,0.1,0.1):mul(movement))
  else
    xOffset = 0
  end]]
  if not roach then
    if toggle then
      curPos = models.model.root.Head:getPos()
    else
      curPos = roaches:getPos()
    end
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
  end
end


function events.post_render(delta)
  if not roach then
    roaches:setPos(math.lerp(sPos,curPos,delta))
    roaches:setRot(-player:getRot()[1],180-player:getRot()[2],0)
    renderer:setCameraPivot(math.lerp(sPos,curPos,delta):div(vec(16,16,16)):add(vec(0,2,0)))
  else
    renderer:setOffsetCameraPivot(vec(0,0,0))
    --renderer:setCameraPos(0,0,0)
  end
end