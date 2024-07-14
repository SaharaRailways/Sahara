vanilla_model.PLAYER:setVisible(false)

vanilla_model.ARMOR:setVisible(false)

vanilla_model.HELMET_ITEM:setVisible(true)


vanilla_model.CAPE:setVisible(false)


vanilla_model.ELYTRA:setVisible(false)


--tick event, called 20 times per second
local isFollowing = false
local head = models.model.root.Head
local roaches = models.model.root.Head.roach
local followedModelPart = head
local roachHeadPos = roaches:partToWorldMatrix():apply():scale(16)-roaches:getPivot()
local roachHeadRot
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
  roachHeadRot = vec(-playerRot[1],180-playerRot[2],0)
  input = vec(0,0,0)
end
function updatePosition()
  if player:isLoaded() then
    roachHeadRot = vec(-playerRot[1],180-playerRot[2],0)
    roachHeadPos = roaches:partToWorldMatrix():apply():scale(16)-roaches:getPivot()
    input = vec(0,0,0)
    velocity = vec(0,0,0)
  else 
    return
  end
end
followRoach:setOnPress(function()
    isFollowing = not isFollowing
    if isFollowing then
      updatePosition()
      roaches:setPos(roachHeadPos+input*2)
      roaches:setRot(roachHeadRot)
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
  if isFollowing then
    if input:lengthSquared() > 1 then
      input:normalize()
    end
    roachHeadPos = roaches:getPos()
    playerRot = player:getRot()
    roachHeadRot = vec(-playerRot[1],180-playerRot[2],0)
    local acceleration = input*0.05
    local dv = acceleration*delta
    local v0 = velocity
    local v1 = velocity+dv
    local movement = (v0 + v1) * delta * 0.5
    roaches:setPos(roachHeadPos+movement)
    roaches:setRot(roachHeadRot)
    velocity = v1
    input = vec(0,0,0)
  end
end