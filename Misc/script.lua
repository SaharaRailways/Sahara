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
local fixLighting = keybinds:newKeybind("Name", "key.keyboard.y", false)
local jump = keybinds:newKeybind("Name", "key.keyboard.right.alt", false)
local copy = keybinds:newKeybind("Name", "key.keyboard.right.alt", false)
local player1 = models.model.WORLD.player
--player1:setPos(player1:partToWorldMatrix():apply()*16)
local boxes = { }
local controller = {
  keybinds_ = {
    forward = keybinds:newKeybind("Name", "key.keyboard.u", false),
    back = keybinds:newKeybind("Name", "key.keyboard.j", false),
    left = keybinds:newKeybind("Name", "key.keyboard.h", false),
    right = keybinds:newKeybind("Name", "key.keyboard.k", false),
    jump = keybinds:newKeybind("Name", "key.keyboard.right.alt", false),
    attack = keybinds:newKeybind("Name", "key.keyboard.right.alt", false)
  },
  input = vec(0,0,0)
}
local metaController = {__index=controller}
function controller:new(forward,back,left,right,jump,attack)-- u
  local newController = {
    keybinds_ = {
      ["forward"] = keybinds:newKeybind("forward",forward,false),
      ["back"] = keybinds:newKeybind("back",back,false),
      ["left"] = keybinds:newKeybind("left",left,false),
      ["right"] = keybinds:newKeybind("right",right,false),
      ["jump"] = keybinds:newKeybind("jump",jump,false),
      ["attack"] = keybinds:newKeybind("attack",attack,false),
    },
    keysPressed_ = {
      ["forward"] = false,
      ["back"] = false,
      ["left"] = false,
      ["right"] = false,
      ["jump"] = false,
      ["attack"] = false,
    }
  }
  return setmetatable(newController,metaController)
end
function controller:onInput(functions)
  keysPressed_ = {
    ["forward"] = self.keybinds_["forward"]:isPressed(),
    ["back"] = self.keybinds_["back"]:isPressed(),
    ["left"] = self.keybinds_["left"]:isPressed(),
    ["right"] = self.keybinds_["right"]:isPressed(),
    ["jump"] = self.keybinds_["jump"]:isPressed(),
    ["attack"] = self.keybinds_["attack"]:isPressed(),
  }
  functions(keysPressed_)
end
--[[input = vec(0,0,0)
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
    input[3] = input[3] + 1
  end
  if jump:isPressed() then
  end]]

 local miniDude = {
  model = models.model:newPart("miniDude","WORLD"),
  position = vec(0,0,0),
  facing = vec(0,0,0),
  velocity = vec(0,0,0),
  input = vec(0,0,0),
  attributes = {
    speed = 0.0625,
    jumpForce = 0.125,
    badass = 1,
    gay = 0.5,
  },
}
local metaDude = {__index=miniDude}

function miniDude:new(modelPart,position,facing,velocity,attributes)
  local t = {
    model = modelPart,
    position = position,
    facing = facing,
    velocity = velocity,
    attributes = attributes
  }
  return setmetatable(t,metaDude)
end
function miniDude:getPos()
  return miniDude.dPos
end
local as = miniDude:new(player1,vec(1,12,3),vec(12,3,1),vec(12,32,1),{speed = 0.0625})
print(as.attributes.jumpForce)
function events.entity_init()
end
fixLighting:onPress(function ()
  for _,modelPart in pairs(models.model.WORLD:getChildren()) do
    modelPart:setLight(0,15)
  end
end)
calculateAABB:onPress(function ()
  for _,modelPart in pairs(models.model.WORLD:getChildren()) do
    if not modelPart:getChildren()[1] then
      local position = modelPart:partToWorldMatrix():apply()
      local pivot = modelPart:getPivot()
      local textureVertices = modelPart:getAllVertices()
      local smallest_vertex = vec(0,0,0)
      local largest_vertex = smallest_vertex
      for _,vertices in pairs(textureVertices) do
        for i = 1, #vertices do
          local vertex = vertices[i]:getPos()
          if vertex[1] > smallest_vertex[1] then
           smallest_vertex[1] = vertex[1]
          end
          if vertex[2] > smallest_vertex[2] then
            smallest_vertex[2] = vertex[2]
          end
          if vertex[3] > smallest_vertex[3] then
            smallest_vertex[3] = vertex[3]
          end
          if vertex[1] > largest_vertex[1] then
            largest_vertex[1] = vertex[1]
          end
          if vertex[2] > largest_vertex[2] then
            largest_vertex[2] = vertex[2]
          end
          if vertex[3] > largest_vertex[3] then
            largest_vertex[3] = vertex[3]
          end
        end
        table.insert(boxes,{position+(smallest_vertex-pivot)/16,position+(largest_vertex-pivot)/16})
      end
    end
  end
end)
function events.tick()
  
end

function events.post_render(delta)
  
end
function events.render(delta)
end