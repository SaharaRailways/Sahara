print("What is the new item's name?")
local name = read()
print("What is the new item's price?")
local price = read()
print("What is the new item's depot number?")
local depot_num = read()
print("What is the new item's chute number?")
local chute_num = read()
print("What is the new item's barrel number?")
local barrel_num = read()
print("What number is the item?")
local item_num = read()

fs.makeDir("saves") -- Here we make the folder the saves will go in.
local file = fs.open("saharasaves/depot"..item_num,"w") -- This opens the file with the users name in the folder "saves" for writing.
file.writeLine(name) -- Put the real name in the file.
file.writeLine(price) -- Put the price in the file.
file.writeLine(depot_num) -- Put the depot number in the file.
file.writeLine(chute_num) -- Put the chute number in the file.
file.writeLine(barrel_num) -- Put the barrel number in the file.
file.close()
