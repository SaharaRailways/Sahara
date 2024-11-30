tot = {}

--tot is an API of miscellaneous functions used across Sahara programs 
--we put functions in here to help update them and prevent inconsistencies when the same function is used between programs
function tot.require()
    --in the future, this will be used to auto download updated versions of all of the Sahara Libraries
end


function tot.listLen(list)
	--returns the length of the list (this is for key value pairs)
	local counter = 0
	for _ in pairs(list) do
		counter = counter + 1
	end
	return counter
end
function tot.splitString(string, maxChunkSize)
    --literally a rewrite of cc.pretty
    local chunks = {} 
    local chunk = "" 
    for word in string:gfind("%A?[%a%d]+%A?") do 
        if #chunk+#word < maxChunkSize then 
            chunk = chunk..word
        else 
            chunks[#chunks+1] = chunk 
            chunk = word 
        end 
    end
    chunks[#chunks+1] = chunk
    return chunks 
end
function tot.keyToIndex(list, key)
	--turns key into its index in the list
	local counter = 0
	for k in pairs(list) do
		counter = counter + 1
		if k == key then
			return counter
		end
	end
	return nil
	
end
function tot.indexToKey(list, index)
	--turns the index in list into the key 
	local counter = 0
	for k in pairs(list) do
		counter = counter + 1
		if counter == index then
			return k
		end
	end
	return nil
end
function tot.failCheck(list, index)
	--used to run pcalls
    --tbh i don't know if this is actully needed, but i made it a while ago
	return list[index]
end

function tot.toCogs(ammount, type)
    --converts ammount of items to cogs
    
    if type == "spur" then
        return math.floor(ammount / 64), ammount % 64
    elseif type == "bevel" then
        return math.floor(ammount / 16), ammount % 16
    elseif type == "sprocket" then
        return math.floor(ammount / 4), ammount % 4
    elseif type == "cog" then
        return ammount, 0
    elseif type == "crown" then
        return ammount * 8, 0
    elseif type == "sun" then  
        return ammount * 64, 0
    end
end

function tot.fromCogs(ammount, type)
    if type == "spur" then
        return ammount * 64, 0
    elseif type == "bevel" then
        return ammount * 16, 0
    elseif type == "sprocket" then
        return ammount * 4, 0
    elseif type == "cog" then
        return ammount, 0
    elseif type == "crown" then
        return math.floor(ammount / 8), ammount % 8
    elseif type == "sun" then  
        return math.floor(ammount / 64), ammount % 64
    end
end

function tot.printReceipt(playerName, receipt, priceList, pageHeader)
    local printer = peripheral.find("printer")
    printer.newPage()
    local cursorPos = 2
    local total = 0
    printer.setPageTitle("Receipt from Phottoquick for "..playerName)
    printer.setCursorPos(1,1)
    printer.write(pageHeader)
    for i = 1, #receipt do
        splitList = totAPI.splitString(receipt[i], 25)
        --splitShit = totAPI.splitString(receipt[i]..": "..priceList[i], 25) OLD CODE THAT WAS REPLACED
        for j = 1,#splitList do
            cursorPos = cursorPos + 1
            printer.setCursorPos(1,cursorPos)
            printer.write(splitList[j])
        end
        total = total + priceList[i]
    end
    printer.setCursorPos(1,cursorPos+1)
    printer.write("Total Cogs: "..total)
    printer.endPage()
    
end

return tot
