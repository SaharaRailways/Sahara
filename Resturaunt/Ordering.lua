tableList = {} -- each item table delivers items from its number slot in the storage and delivers it to the table 
tableList[item1] = {1, 5, 6}
tableList[item2] = {}
tableList[item3] = {}
tableList[item4] = {}
tableList[item5] = {}
tableList[item6] = {}
tableList[item7] = {}
tableList[item8] = {}
tableList[item9] = {}
tableList[item10] = {}
tableList[item11] = {}
tableList[item12] = {}
tableList[item13] = {}
tableList[item14] = {}
tableList[item15] = {}


local payment = rs.getInput("back")
local menuItem = rs.getAnalogInput("right")
local table1 = peripheral.wrap("minecraft:barrel_0")
local storage = peripheral.wrap("minecraft:chest_0")

local function getTableBySignal(signal)
    local tableName = "item" .. signal
    return tableList[tableName]
end

local function getOrder()
    for i,v in ipairs(getTableBySignal(menuItem)) do
        storage.pushItems(peripheral.getName(table1), v , 1)
        sleep(7)
    end
end

print("Startup Complete")
while true do
    sleep(0.5)
    if (rs.getInput("back")) then
        print("Getting Order")
        getOrder()
        sleep(2)
        print("Got Order")
    end
end
