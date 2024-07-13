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
    roachHeadPos = roaches:partToWorldMatrix():apply()
    roachHeadRot = player:getRot():mul(-1,-1,1):add(0,180,0)
    if isFollowing then
      followedModelPart = roaches
    else
      followedModelPart = head
    
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