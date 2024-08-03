vanilla_model.PLAYER:setVisible(false)

vanilla_model.ARMOR:setVisible(false)

vanilla_model.HELMET_ITEM:setVisible(true)


vanilla_model.CAPE:setVisible(false)


vanilla_model.ELYTRA:setVisible(false)


--tick event, called 20 times per second
local forward = keybinds:newKeybind("Name", "key.keyboard.u", false)
local back = keybinds:newKeybind("Name", "key.keyboard.j", false)
local left = keybinds:newKeybind("Name", "key.keyboard.h", false)
local right = keybinds:newKeybind("Name", "key.keyboard.k", false)
local calculateAABB = keybinds:newKeybind("Name", "key.keyboard.i", false)
local jump = keybinds:newKeybind("Name", "key.keyboard.right.alt", false)
local player1 = models.model.WORLD.player
local input = vec(0,0,0)
local velocity = vec(0,0,0)
--player1:setPos(player1:partToWorldMatrix():apply()*16)
local boxes = { }
local miniDude = {}
--- @param modelPart? ModelPart miniDude's model
--- @param dPos? Vector3 position of this miniDude
--- @param baseSpeed? number base speed of this miniDude
--- @param jumpForce? number force of the jump of this midiDude
--- @param gravity? number force of the gravity applied to this miniDude
function miniDude:new(modelPart,dPos, baseSpeed ,jumpForce,gravity)
  local obj = {
    dude = modelPart,
    attributes = {
      baseSpeed = {
        1
      },
      baseJumpForce = 2
    },
    dPos = dPos or modelPart:partToWorldMatrix():apply(),
    
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end
function miniDude:getPos()
  return miniDude.dPos
end
miniDude:new(player1)
function events.entity_init()
end
calculateAABB:onPress(function ()
  for _,modelPart in pairs(models.model.WORLD:getChildren()) do
    local position = modelPart:partToWorldMatrix():apply()
    local pivot = modelPart:getPivot()
    local textureVertices = modelPart:getAllVertices()
    for _,vertices in pairs(textureVertices) do
      local smallest_vertex = vertices[1]:getPos()
      local largest_vertex = smallest_vertex
      for i = 2, #vertices do
        local vertex = vertices[i]:getPos()
        if vertex[1] < smallest_vertex[1] then
          smallest_vertex = vertex
        elseif vertex[1] == smallest_vertex[1] and vertex[2] < smallest_vertex[2] then
          smallest_vertex = vertex
        elseif vertex[1] == smallest_vertex[1] and vertex[2] == smallest_vertex[2] and vertex[3] < smallest_vertex[3] then
          smallest_vertex = vertex
        end
        if vertex[1] > largest_vertex[1] then
          largest_vertex = vertex
        elseif vertex[1] == largest_vertex[1] and vertex[2] > largest_vertex[2] then
          largest_vertex = vertex
        elseif vertex[1] == largest_vertex[1] and vertex[2] == largest_vertex[2] and vertex[3] > largest_vertex[3] then
          largest_vertex = vertex
        end
      end
      local aabb = {position+(smallest_vertex-pivot)/16,position+(largest_vertex-pivot)/16}
      table.insert(boxes,aabb)
    end
  end
end)
function events.tick()
  input = vec(0,0,0)
  if forward:isPressed() then
    input[1] = input[1] + 1
  end
  if back:isPressed() then
    input[1] = input[1] - 1
  end
  if left:isPressed() then
    input[3] = input[3] - 1
  end
  if right:isPressed() then
    input[3] = input[3] +1
  end
  if jump:isPressed() then
    input[2] = input[2] + 1
  end
end

function events.post_render(delta)
  roachPos = player1:getPos()
  playerPos = player:getPos()
  movement = vec(0,0,0)
  velocity = velocity*0.9
  playerRot = player:getRot()
  roachRot = vec(-playerRot[1],180-playerRot[2],0)
  playerLook = player:getLookDir()
  betterLookScale = 1/(math.abs(playerLook[1])+math.abs(playerLook[3]))
  betterLookX = playerLook[1]*betterLookScale
  betterLookZ = playerLook[3]*betterLookScale
  if input[1] ~= 0 then
    movement = movement:add(betterLookX*input[1], 0, betterLookZ*input[1])
  end
  if input[3] ~= 0 then
    movement = movement:add(-1*(betterLookZ*input[3]), 0, betterLookX*input[3])
  end
  local acceleration = 1.2
  velocity = velocity:add(movement*acceleration)
  roachPos:add(velocity)
  --local dv = acceleration*delta
  --local v0 = velocity
  --local v1 = velocity+dv
  --local movement = (velocity + velocity + acceleration*delta) * delta
  player1:setPos(roachPos)
  player1:setRot(roachRot)
  --velocity = v1

end
function events.render(delta)
end