local catch = {}

-- Internal function to listen for events
-- Don't call this function in your own code
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
function catch.addGrab(eventName)
    listenFor[eventName] = true
end

--Call this function to start listening for all events
--To stop listening for all events, call catch.remove("all")   -this will not delete the other listenFor entries, only prevent every event from being caught
function catch.addAllGrabs()
    listenFor["all"] = true
end

-- Call this function to stop listening for an event
function catch.removeGrab(eventName)
    listenFor[eventName] = false
end

--Call this function to stop listening to any events spcified by catch.add()
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
function catch.pull(eventName, pullAll) --pullAll is a boolean that determines if you want to pull all the data from the event or just the most recent
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
