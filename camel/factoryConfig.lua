print("What is the redrouter's number?")
local num = read()
print("What is the name of the cart to order?")
local name = read()
print

fs.makeDir("saves") -- Here we make the folder the saves will go in.
local file = fs.open("saharasaves/factory/redrouter_"..num,"w") -- This opens the file with the users name in the folder "saves" for writing.
file.writeLine(num) -- Put the number of the redrouter in the file.
file.writeLine(name) -- Put the name of the cart in the file.
file.close()