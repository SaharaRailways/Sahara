local catch = {}

function catch.setup(mainThreadName)

    -- Get the function from the global table using its name
    local mainThread = _ENV[mainThreadName]

    -- Check if the function exists
    if type(mainThread) == "function" then
        parallel.waitForAny(catch.listen, mainThread)
    else
        error("Function " .. mainThreadName .. " does not exist")
    end
end

-- Internal function to listen for events
-- Don't call this function in your own code
function catch.listen()
    local catchData = {}
    local catchDataTemp = {}
    local listenFor = {}
    local listenForProtocol = {}
    local enabled = true
    local catchTemp = {}
    --All events return {eventName, arg1...}
    --Rednet messages return {"modem_message", modem_name, channel, reply_channel, {message=, nMessageID=, nRecipient=, nSender=, sProtocol=}, distance}
    --"rednet_message" is not a real event
    while true do
        if enabled then
            local catchDataTemp = {os.pullEvent()}
            print("catchDataTemp: " .. catchDataTemp[1])
            if listenFor[catchDataTemp[1]] or listenFor["all"] then
                catch.store(catchDataTemp)
            end
            if listenForProtocol[catchDataTemp[5].sProtocol] then
                catch.store("rednet_message", catchDataTemp[5].nSender, catchDataTemp[5].message, catchDataTemp[5].sProtocol)
                --this mimics the structure of a rednet message, but adds on "rednet_message" to the beginning to be consistent with other events
                --this is later removed when the data is pulled to be consistent with rednet messages 

            end
        end
    end
end

-- Internal function to store data 
-- Stores data in the format {"eventName"={"eventname", arg2...}}     --eventname is arg1
function catch.store(storedData)
    if catchData[storedData[1]] == nil then
        catchData[storedData[1]] = {}
    end
    table.insert(catchData[storedData[1]], 1, storedData)
end

-- Starts listening for a specified event
function catch.addGrab(eventName)
    listenFor[eventName] = true
end

-- Starts listening for any event (adds all events with a single event)
function catch.addGrabAny()
    listenFor["any"] = true
end

-- Stops listening for any event, and instead listen for specified events (removes the event that listens for all events)
-- undoes catch.addGrabAny()
function catch.removeGrabAny()
    listenFor["any"] = false
end

-- Adds a grab for a specific rednet protocol
-- You have to open/host the rednet yourself
function catch.addRednetGrab(protocol)
    listenForProtocol[protocol] = true
end

-- Stops listening for the specified rednet protocol
function catch.removeRednetGrab(protocol)
    listenForProtocol[protocol] = false
end

-- Stops listening for the specified event
function catch.removeGrab(eventName)
    listenFor[eventName] = false
end

-- Stop listening to any events specified by catch.add()
function catch.removeAllGrabs()
    listenFor = {}
end

-- Enables listening for events
function catch.enable()
    enabled = true
end

-- Disables listening for events
function catch.disable()
    enabled = false
end

-- Provide the name of the script you want to run in parallel to the catchAPI (just put the name of the main function)


-- Gets the data from the catchData table
-- eventName is the name of the event you want to pull data from, or false to pull all events
-- pullAll is a boolean that determines if you want to pull all the data from the event or just the most recent
function catch.pull(eventName, pullAll) 
    if pullAll then
        if eventName then
            return catchData[eventName]
        else
            return catchData
        end
    else
        if eventName then
            if eventName == "rednet_message" then
                return catchData[eventName][1]
            else
                return catchData[eventName][1]
            end
        end
    end
end

-- Clears the data from the catchData table

-- Returns the data from the catchData table and removes it from the table
-- If you want to return and remove all events, call catch.pop() with no arguments
function catch.pop(eventName, pullAll, deleteAll)
    local catchTemp
    if eventName then
        if deleteAll then
            catchTemp = catchData[eventName]
            catchData[eventName] = {}
            if pullAll then
                return table.unpack(catchTemp)
            else
                return catchTemp[1]
            end
        else
            catchTemp = {pcall(table.remove, catchData[eventName], 1)}
            if catchTemp[1] then
                return catchTemp[2]
            else
                return nil
            end
        end
    else
        catchTemp = catchData
        catchData = {}
        return table.unpack(catchTemp)
    end
end

return catch