local catch = {}

function catch.setup(mainThreadName)

    -- Get the function from the global table using its name
    local mainThread = _G[mainThreadName]
    local catchData = {}
    local catchDataTemp = {}
    local listenFor = {}
    local enabled = true
    local catchTemp = {}

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
    listenFor["modem_message"] = true
    while true do
        if enabled then
            local catchDataTemp = {os.pullEvent()}
            print("catchDataTemp: " .. catchDataTemp[1])
            if listenFor[catchDataTemp[1]] or listenFor["all"] then
                if catchDataTemp[1] == "modem_message" then
                    if listenForProtocol[catchDataTemp[5].sProtocol] then
                        catch.store("rednet_message", catchDataTemp[4], catchDataTemp[5].message, catchDataTemp[5].sProtocol)
                    end
                    if listenFor["modem_message"] then
                        catch.store(catchDataTemp)
                    end
                else
                    catch.store(catchDataTemp)
                end
            end
        end
    end
end

-- Internal function to store data 
-- Only call this funciton if you know what you're doing
function catch.store(storedData)
    if catchData[storedData[1]] == nil then
        catchData[storedData[1]] = {}
    end
    if catchData[storedData[1]] == "rednet_message" then
        table.insert(catchData[storedData[1]], 1, {storedData[2], storedData[3], storedData[4]})
    else
        table.insert(catchData[storedData[1]], 1, storedData)
    end
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
            return catchData[eventName] or {}
        else
            return catchData or {}
        end
    else
        if eventName then
            if eventName == "rednet_message" then
                return {catchData[eventName][1][2], catchData[eventName][1][3], catchData[eventName][1][4]} or {}
            else
                return catchData[eventName][1] or {}
            end
        end
    end
end

-- Clears the data from the catchData table

-- Returns the data from the catchData table and removes it from the table
-- If you want to return and remove all events, call catch.pop() with no arguments
function catch.pop(eventName, pullAll, deleteAll)
    if eventName then
        if deleteAll then
            catchTemp = catchData[eventName]
            catchData[eventName] = {}
            if pullAll then
                return catchTemp or {}
            else
                return catchTemp[1] or {}
            end
        else
            return table.remove(catchData[eventName], 1) or {}
        end
    else
        catchTemp = catchData
        catchData = {}
        return catchTemp or {}
    end
    
end

return catch