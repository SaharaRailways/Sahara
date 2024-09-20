local catch = {}

-- Internal function to listen for events
-- Don't call this function in your own code
function catch.listen()
    listenFor["modem_message"] = true
    while true do
        local catchDataTemp = {os.pullEvent()}
        print("catchDataTemp: " .. catchDataTemp[1])
        if listenFor[catchDataTemp[1]] or listenFor["all"] then
            if catchDataTemp[1] == "modem_message" then
                if listenForProtocol[catchDataTemp[5].sProtocol] then
                    catch.store(catchDataTemp)
                end
            else
                catch.store(catchDataTemp)
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
    table.insert(catchData[storedData[1]], 1, {storedData, os.clock()})
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

-- Adds a grab for a specific rednet protocal
function catch.addRednetGrab(protocol)
    listenForProtocol[protocol] = true
end

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

-- Provide the name of the script you want to run in parallel to the catchAPI (just put the name of the main function)
function catch.setup(mainThreadName)
    catchData = {}
    catchDataTemp = {}
    listenFor = {}

    -- Get the function from the global table using its name
    local mainThread = _G[mainThreadName]

    -- Check if the function exists
    if type(mainThread) == "function" then
        parallel.waitForAny(catch.listen, mainThread)
    else
        error("Function " .. mainThreadName .. " does not exist")
    end
end

-- Gets the data from the catchData table
function catch.pull(eventName, pullAll) -- pullAll is a boolean that determines if you want to pull all the data from the event or just the most recent
    if pullAll then
        return catchData[eventName] or {}
    else
        return catchData[eventName][1] or {}
    end
end

-- Clears the data from the catchData table

-- Returns the data from the catchData table and removes it from the table
-- If you want to return and remove all events, call catch.pop() with no arguments
function catch.pop(eventName, pullAll, deleteAll)
    if eventName then
        if deleteAll then
            local tempData = catchData[eventName]
            catchData[eventName] = {}
            if pullAll then
                return tempData or {}
            else
                return tempData[1]
            end
        else
            return table.remove(catchData[eventName], 1)
        end
    else
        local tempData = catchData
        catchData = {}
        return tempData or {}
    end
    
end

return catch
