package.path = '../preload/?.lua'
class = require 'middleclass'

local Fruit = class('Fruit') -- 'Fruit' is the class' name

function Fruit:initialize(sweetness)
  self.sweetness = sweetness
end

Fruit.static.sweetness_threshold = 5 -- class variable (also admits methods)

function Fruit:isSweet()
  return self.sweetness > Fruit.sweetness_threshold
end

local Lemon = class('Lemon', Fruit) -- subclassing
Lemon.static.good = 1
Lemon.static.sweetness_threshold = 6

function Lemon:initialize()
 --  Fruit.initialize(self, 1) -- invoking the superclass' initializer
     Fruit:initialize(1)
end

local lemon = Lemon:new()

print(Lemon.static.good)
print(Lemon.static.sweetness_threshold)
print(Fruit.static.sweetness_threshold)
print(lemon:isSweet())
