local catch = {}

-- Internal function to listen for events
function catch.listen()
    while true do
        local catchDataTemp = {os.pullEvent()}
        print("catchDataTemp: " .. catchDataTemp[1])
        if listenFor[catchDataTemp[1]] or listenFor["all"] then
            if catchData[catchDataTemp[1]] == nil then
                catchData[catchDataTemp[1]] = {}
            end
            table.insert(catchData[catchDataTemp[1]], 1, {catchDataTemp, os.clock()})
        end
    end
end

-- Call this function to start listening for an event
function catch.add(eventName)
    listenFor[eventName] = true
end

--Call this function to start listening for all events
--To stop listening for all events, call catch.remove("all")   -this will not delete the other listenFor entries, only prevent every event from being caught
function catch.addAll()
    listenFor["all"] = true
end

-- Call this function to stop listening for an event
function catch.remove(eventName)
    listenFor[eventName] = false
end

--Call this function to stop listening to any events spcified by catch.add()
function catch.removeAll()
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

-- An oversimplified way to get the data from the catchData table
function catch.getData(eventName)
    return catchData[eventName] or {}
end

-- An oversimplified way to clear the data from the catchData table
function catch.clearData(eventName)
    if eventName then
        catchData[eventName] = nil
    else
        catchData = {}
    end
end

return catch

-- Example main thread function
-- function mainThread() while true do sleep(1) os.queueEvent("test") end end