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
local xOffset = 0
local yOffset = 0
local zOffset = 0
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
myKey:setOnPress(function()
  if roach then
    oldPos = roaches:partToWorldMatrix():apply():mul(16,16,16)
    oldRot = player:getRot()
  end
  roach = not roach
  if roach then
    --print(roaches:getPos())
    roaches:setPos(0,0,0)
    roaches:setRot(0,0,0)
    roaches:moveTo(models.model.root.Head)
  else
    roaches:setPos(oldPos-roaches:getPivot())
    roaches:setRot(-oldRot[1],180-oldRot[2],0)
    roaches:moveTo(models.model.WORLD)
  end
end)
function events.tick()
  if secKey:isPressed() then
    xOffset = xOffset + 2
  end
  if thirdKey:isPressed() then
    xOffset = xOffset - 2
  end
  if fourKey:isPressed() then
    zOffset = zOffset - 2
  end
  if fiveKey:isPressed() then
    zOffset = zOffset + 2
  end
  if sixKey:isPressed() then
    yOffset = yOffset - 2
  end
  if sevenKey:isPressed() then
    yOffset = yOffset + 2
  end
  if math.abs(xOffset) > 0.5 then
    xOffset = xOffset - 0.1*xOffset
  else
    xOffset = 0
  end
  if math.abs(yOffset) > 0.5 then
    yOffset = yOffset - 0.1*yOffset
  else
    yOffset = 0
  end
  if math.abs(zOffset) > 0.2 then
    zOffset = zOffset - 0.1*zOffset
  else
    zOffset = 0
  end
  if not roach then
  sPos = roaches:getPos()
  curPos = roaches:getPos():add(vec(xOffset,yOffset,zOffset):mul(player:getLookDir()))
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