--local modem = peripheral.wrap("back")
local modem = "back"
local station = peripheral.wrap("top")
local export = peripheral.wrap("minecraft:barrel_2")
local coins = peripheral.wrap("create:depot_4")
local coin_stash = peripheral.wrap("create:depot_6")
local sahara = require("saharaAPI")

local function stockCount(stockChuteSlot, slotNum)
    return stockChuteSlot.count
end

rednet.open(modem)
rednet.host("sahara", "saharaServer")

function updateStock()
    peripheralTable = {}
    local counter = 1
    local item_name = ""
    local item_price = ""
    local depot_name = ""
    local chute_name = ""
    local barrel_name = ""
    priceList = {}
    lowStockList = {}
    outOfStockList = {}
    stockAmountList = {}
    local stockChute = ""
    local stockDepot = ""
    local stockBuild = 0
    local file = fs.open("saharasaves/depot"..counter,"r")
    repeat
        item_name = file.readLine()
        item_price = file.readLine()
        depot_name = file.readLine()
        chute_name = file.readLine()
        barrel_name = file.readLine()
        peripheralTable[item_name] = peripheral.wrap("create:depot_"..depot_name)
        stockDepot = peripheralTable[item_name].items()
        outOfStockList[item_name] = not pcall(stockCount, stockDepot, 1) -- the pcall sends a "protected call" that returns true if the function is successful and false if it errors
        priceList[item_name] = item_price
        stockChute = peripheral.call("create:chute_"..chute_name, "list")
        lowStockList[item_name] = not pcall(stockCount, stockChute[1], 1) -- the pcall sends a "protected call" that returns true if the function is successful and false if it errors
        
        stockBuild = 0
        if lowStockList[item_name] then
            if not outOfStockList[item_name] then
                for slot, item in pairs(peripheral.call("minecraft:barrel_"..barrel_name, "list")) do
                    if pcall(stockCount, item) then
                        stockBuild = stockBuild + 1
                    end
                end
                if stockBuild == 0 then
                    outOfStockList[item_name] = true
                end
            else
                stockBuild = 0
            end
        else
            stockBuild = 27
        end
        
        stockAmountList[item_name] = stockBuild
        print("lowStockList "..tostring(lowStockList[item_name]).."   outOfStockList "..tostring(outOfStockList[item_name]).."  "..stockBuild)

        file.close()
        counter = counter + 1
        file = fs.open("saharasaves/depot"..counter,"r")
        print(file)
    until file == nil
end


repeat

    transmitedID, message, protocol = rednet.receive("sahara")

    if message == "itemList" then
        print("recieved, message is itemList")
        updateStock()
        print("recieved, message is stock")
        local itemList = {}
        for key,value in pairs(peripheralTable) do
            print(key)
            table.insert(itemList, key)
        end
        rednet.send(transmitedID, {itemList, priceList, lowStockList, outOfStockList, stockAmountList}, "sahara")
    elseif type(message) == "table" then
        print("recieved, message is a table")
        rednet.send(transmitedID, "success", "sahara")
        print(message[1])
        







        local counter = 0
        local location = message[1]
        local itemCartList = message[2]
        print("items are ...")
        for name, amount in pairs(itemCartList) do
            print(name.." "..amount)
        end
        
        local price = sahara.priceOfCartList(itemCartList, priceList)
        
        print("sending banker to "..location)
        
        schedule = {
            cyclic=false,
            entries = {
            
            {
                instruction = {
                    id = "create:destination",
                    data = {
                        text = location,
                    },
                },
                
                conditions = {
                    {
                    {
                        id = "create:idle",
                            data = {
                                value = 5,
                                time_unit = 1,
                            },
                    },
                    
                    
                    {
                        id = "create:delay",
                        data = {
                        value = 10,
                        time_unit = 1,
                        },
                    },
                    },
                    
                },
            },
            {
                instruction = {
                    id = "create:destination",
                    data = {
                        text = "warehouse",
                    },
                },
                conditions = {
                    {
                        id = "create:delay",
                        data = {
                        value = 5,
                        time_unit = 1,
                        },
                    },
                },
            },
            },
        }

        station.setSchedule(schedule)

        print("waiting for banker to return")
        repeat
            sleep(5)
        until station.isTrainPresent() == true
        print("banker has returned")

        local depot_info = coins.items()
        print(depot_info[1])
        local stack_info = depot_info[1]
        print(stack_info.count)

        local ammount_paid = 0
        if stack_info then
            repeat
                ammount_paid = ammount_paid + stack_info.count
                coins.pushItem(peripheral.getName(coin_stash),"minecraft:redstone")
                sleep(1.5)
                depot_info = coins.items()
                stack_info = depot_info[1]
                print(stack_info)
            until stack_info == nil
                
        else
            print("no coins in the train")
        end
    

        if ammount_paid >= price then
            print("sending items to "..location)
        
            for item, ammount in pairs(itemCartList) do
                for i = 1, ammount do
                    peripheralTable[item].pushItem(peripheral.getName(export),sahara.getDepotItem(peripheralTable[item]))
                    sleep(1)
                end
            end
            sleep(1)

            schedule = {
                cyclic=false,
                entries = {
                {
                    instruction = {
                        id = "create:destination",
                        data = {
                            text = location,
                        },
                    },
                    conditions = {
                    {
                    {
                        id = "create:idle",
                            data = {
                                value = 5,
                                time_unit = 1,
                            },
                    },
                    
                    
                    {
                        id = "create:delay",
                        data = {
                        value = 10,
                        time_unit = 1,
                        },
                    },
                    },
                    },
                },
                {
                    instruction = {
                        id = "create:destination",
                        data = {
                            text = "warehouse",
                        },
                    },
                    conditions = {
                    {
                    {
                        id = "create:delay",
                        data = {
                            value = 10,
                            time_unit = 1,
                        },
                    },
                    },
                    },
                },  
                },
            }

            station.setSchedule(schedule)
            
        end
    else 
        print("invalid message")
    end

until redstone.getInput("left") == false
rednet.unhost("sahara", "saharaServer")
rednet.close(modem)