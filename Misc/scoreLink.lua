local modem = peripheral.find("modem")
local scoreLinkBroadcast = 52964
local targetDestination = 0 --ID of the computer you are connecting to
print("true for source, false for target")
local source = read() -- true or false for source or target
name = "test1"
computerID = os.getComputerID()
local sourceDestination, message, protocol
local targetList = {} --list of all the conections that are currently open
--{targetDestination = {source, name}}



function recieve()
    local recieved = {}
    while true do
        if targetDestination == 0 then
            recieved = rednet.receive("scoreLinkBroadcast", 3)
            if (not (recieved[2])[1] == source) and (not recieved[1] == computerID) then
                sourceDestination, message, protocol = recieved[1], recieved[2], recieved[3]
                targetList[sourceDestination] = message
            end
        end
    end
end

function send()
    rednet.send(52964, {source, name}, "scoreLinkBroadcast")
end

function main()
    
end

rednet.open(modem)
parallel.waitForAll(main, recieve)