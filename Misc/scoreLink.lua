local modem = peripheral.find("modem")
local basalt = require("basalt")
local main = basalt.createFrame()
local scoreLinkBroadcast = 52964
local targetDestination = 0 --ID of the computer you are connecting to
print("true for source, false for target")
local source = read() -- true or false for source or target
name = "test1"
computerID = os.getComputerID()
local sourceDestination, message, protocol
local openList = {} --list of all the conections that are currently open
--{targetDestination = {source, name}}
local connectionList = {} --list of all the connections that have been made
--{targetDestination = {source, name}}
local searching = true --is the computer searching for a connection?
local curpos = 0
local update = false


function recieve()
    while true do
        if searching == true then
            sourceDestination, message, protocol = rednet.receive("scoreLinkBroadcast")
            if (not message[1] == source) and (not sourceDestination == computerID) then
                openList[sourceDestination] = message
                update = true
                print("recieved")
            end
        end
    end
end

function send()
    rednet.broadcast({source, name}, "scoreLinkBroadcast")
end

function displayOpenConnections()
    print("Open Connections:")
    curpos = 1
    for key, list in pairs(openList) do
        curpos = curpos + 1
        term.setCursorPos(1, curpos)
        term.write(list[2])
        term.setCursorPos(51-#(list[1]), curpos)
        term.write(list[1])
    end
end
function main()
    local pingTimer = os.startTimer(5)
    local sendTimerFinish = false
    parallel.waitForAny(function()--basalt:Threadorsomething("")
        local event, id
        while true do
            event, id = os.pullEvent("timer")
            if id == pingTimer then
                sendTimerFinish = true
                pingTimer = os.startTimer(5)
                print("timer")
            end
        end
    end,
    function()
        while true do
            if update == true then
                displayOpenConnections()
                update = false
                print("updated")
            end
            if searching == true and sendTimerFinish == true then
                send()
                sendTimerFinish = false
                print("sent")
            end
            sleep(0.5)
        end
    end)
end

rednet.open(peripheral.getName(modem))
parallel.waitForAll(main, recieve)

basalt.autoUpdate()
----------------------------------------------------------------------------------------------------
--https://basalt.madefor.cc/#/objects/Thread
local basalt = require("basalt")
local main = basalt.createFrame()
local modem = peripheral.find("modem")
rednet.open(modem)
function update()
    rednet.broadcast({})
end
basalt.autoUpdate()