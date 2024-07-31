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
local jump = keybinds:newKeybind("Name", "key.keyboard.right.alt", false)
local player1 = models.model.WORLD.player
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
function events.tick()
  --input = vec(0,0,0)
  if forward:isPressed() then
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
  end
  if back:isPressed() then
    local eyePos = player:getPos() + vec(0, player:getEyeHeight(), 0)
    local eyeEnd = eyePos + (player:getLookDir() * 20)
    local _, pos = raycast:aabb(eyePos,eyeEnd,boxes)
    if pos then
    player1:setPos(pos*16)
    end
    animations.model.walkin:play()
  end
  if left:isPressed() then
    input.z = -1
  end
  if right:isPressed() then
    input.z = 1
  end
  if jump:isPressed() then
    if velocity == 0 then
    velocity = 1
    end
  end
  --pPos = player1:getPos()
  --local cameraForward = player:getLookDir()
  --local cameraRight = cameraForward:crossed(vec(0,1,0))
  --local movementVector = vec(cameraRight.x * input.z + cameraForward.x * input.x,0,cameraRight.z * input.z + cameraForward.z * input.x):normalize();
  --player1:setPos(pPos)
  --renderer:setCameraPos(0, 0, -3)
  --renderer:setCameraPivot(pPos/16)
end
function events.render(delta)
end