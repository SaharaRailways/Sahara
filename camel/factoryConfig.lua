camel = require("camelAPI")
print("Enter the order number to add or change a cart item, or type 'config' to change other saved information")
local input = read()
if input == "config" then
    print("Enter 'station' to change the station's saved name, enter 'power' to enter the input side of the computer that must be powered to order, or enter 'terminate' to control if the program terminates if there are no requested saved carts")
    input = read()
    if input == "station" then
        print("enter the station's name")
        stationName = read()
        camel.setStation(stationName)
    elseif input == "power" then
        print("Enter the side of the computer that must be powered to order (left, right, front, back, top, bottom)")
        --this makes sure that an order is not accidentally made when the computer is turned on
        local inputSide = read()
        local file = fs.open("saharasaves/factory/powerside","w") -- This opens the file with the users name in the folder "saves" for writing.
        file.writeLine(inputSide) -- Put the side of the computer in the file.
        file.close()
    elseif input == "terminate" then
        print("Enter 'true' to terminate the program if there are no requested saved carts, or 'false' to continue the program (the default is true)")
        local terminate = read()
        if terminate == "true" or terminate == "false" then
            local file = fs.open("saharasaves/factory/terminate","w") -- This opens the file with the users name in the folder "saves" for writing.
            file.writeLine(terminate) -- Put the side of the computer in the file.
            file.close()
        else
            error("Invalid input: please enter true or false")
        end
    else
        error("Invalid input: not an option for configuration")
    end
elseif tonumber(input) then
    local orderNum = tonumber(input)
    print("Enter the number of the redrouter, or enter 0 to skip the order")
    local redRouterNum = read()
    print("Enter the name of the saved cart")
    local name = read()
    print("Enter the side of the redrouter that the redstone signal will come from (left, right, front, back, top, bottom)")
    local inputSide = read()
    --fs.makeDir("saves") -- Here we make the folder the saves will go in.
    local file = fs.open("saharasaves/factory/order/"..orderNum,"w") -- This opens the file with the users name in the folder "saves" for writing.
    file.writeLine(redRouterNum) -- Put the number of the redrouter in the file.
    file.writeLine(name) -- Put the name of the cart in the file.
    file.writeLine(inputSide) -- Put the side of the redrouter in the file.
    file.close()
    print("Saved")
else
    error("Invalid input")
end


