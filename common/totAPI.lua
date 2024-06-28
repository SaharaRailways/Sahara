tot = {}

--tot is an API of miscellaneous functions observed to be used by Cockroaches in the Sahara desert
function tot.listLen(list)
	--returns the length of the list (this is for key value pairs)
	local counter = 0
	for _ in pairs(list) do
		counter = counter + 1
	end
	return counter
end
function tot.splitString(string, maxChunkSize)
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

function tot.createInputBox(x,y,len,def,BC,TC)--Create an input box "object"(A table with some params and methods)
    local InputBox = {}
    InputBox.x = x or 1
    InputBox.y = y or 1
    InputBox.len = math.floor(len or 1)
    InputBox.def = def or "" --default text for the input box
    InputBox.BC = BC or colours.gray --background color
    InputBox.TC = TC or colours.white--text color
    InputBox.message = "" -- variable that stores the text you input
    function InputBox:getInput()
        local isEditing = false -- check whether you're inputting text or not
        local isShift = false --check if you're holding shift or not for typing Capital letter
        local spc = " " -- space character to fill the input box if there's not enough characters
        self.message = "" --reset the input
        while true do
            local eventData = {os.pullEvent()} --get the last event and all of it's data
            local event = eventData[1] -- get the event name
            if event == "mouse_click" then
                local mouseX = eventData[3]
                local mouseY = eventData[4]
                isEditing = (mouseX >= self.x and mouseX <= self.x+self.len-1 and mouseY == self.y) -- check if you clicked within the boundaries of the inputBox 
            elseif event == "key" and isEditing then --check if you pressed a key and if you're getting the input
                local key = eventData[2] --get the pressed key value(Integer)
                local fkey = keys.getName(key) --get the human readable key value with keys API (string)
                if key > 0 and key < 255 then --check if the character is within the range between 0-255 because string.char breaks otherwise(Cuz it's using ASCII and accepts only one byte of info)
                    if isShift == false and #fkey == 1 then --check if you press shift and if you pressed the letter keys(1 char long) and put the letters in lowercase if you didn't
                        key = key+32 --add 32 to the key integer because this is the difference between capital letters and lowercase letter
                    end
                    self.message = self.message..string.char(key) --finally add the pressed key to the message
                elseif fkey == "backspace" or fkey == "delete" then --delete the last character if you pressed backspace or delete
                    self.message = self.message:sub(1,-2)
                elseif fkey == "leftShift" or fkey == "rightShift" then --check if you pressed shift to start capitalazing letters
                    isShift = true
                elseif fkey == "enter" then -- stop editing and exit the loop if you press enter
                    isEditing = false
                    break
                end
            elseif event == "key_up" then --check if you stopped pressing the key(Used only for shift atm)
                local key = eventData[2]--get the unpressed key value(Integer)
                local fkey = keys.getName(key) --get the human readable key value with keys API (string)
                if fkey == "leftShift" or fkey == "rightShift" then --check if you stopped pressing shift to stop capitalizing letter
                    isShift = false
                end
            end
            term.setBackgroundColor(self.BC)
            term.setTextColor(self.TC)
            term.setCursorPos(self.x,self.y) -- set the cursor to the input box position
            if isEditing then --display default text if you're not getting the input and turn on the cursor blink if you're editing
                prn = self.message:sub(-self.len+1,-1) --cut the message one character less than the length of the input box to make space for cursor
                term.setCursorBlink(true)
            else
                prn = self.def:sub(-self.len,-1) --cut the default text to the lenth of the input box so it doesn't get out of bounds
                term.setCursorBlink(false)
            end
            term.write(prn..spc:rep(self.len-#prn)) --write the input and concat spaces to it if it's missing some characters(It places the cursor to the end of the input box which is bad)
            term.setCursorPos(self.x+#prn,self.y) --set cursor back to the end of the input text
        end
        return InputBox.message
    end
    return InputBox
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