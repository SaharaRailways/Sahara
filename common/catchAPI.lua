catch = {}

--you haven't tested the listen start and stop part yet!
--do that
--now
--you don't have a choice lol

function catch.setup(mainThread)
    --don't call this function in your own code
    catchData = {}
    catchDataTemp = {}
    listenFor = {}
    parallel.waitForAny(catch.listen, mainThread)
end

function catch.listen()
    while true do
        catchDataTemp = {os.pullEvent()}
        if listenFor[catchDataTemp[1]] then
            if catchData[catchDataTemp[1]] == nil then
                catchData[catchDataTemp[1]] = {}
            end
            table.insert(catchData[catchDataTemp[1]], catchDataTemp)
        elseif catchDataTemp[1] == "startListen" then
            listenFor[catchDataTemp[2]] = true
        elseif catchDataTemp[1] == "stopListen" then
            listenFor[catchDataTemp[2]] = false
        end
    end
end

return catch
