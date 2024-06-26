--this is a test to see if it updates on github...
local totAPI = require("totAPI")
local screenW,screenL = term.getSize()

function createInputBox(x,y,len,def,BC,TC)--Create an input box "object"(A table with some params and methods)
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
                if mouseX >= self.x and mouseX <= self.x+self.len-1 and mouseY == self.y then -- check if you clicked within the boundaries of the inputBox 
                    isEditing = true -- start getting input if you did and stop getting input if you didn't
                else
                    isEditing = false
                end
            elseif event == "key" and isEditing then --check if you pressed a key and if you're getting the input
                local key = eventData[2] --get the pressed key value(Integer)
                local fkey = keys.getName(key) --get the human readable key value with keys API (string)
                if fkey == "enter" then -- stop editing and exit the loop if you press enter
                    isEditing = false
                    break
                elseif fkey == "backspace" or fkey == "delete" then --delete the last character if you pressed backspace or delete
                    self.message = self.message:sub(1,-2)
                elseif fkey == "leftShift" or fkey == "rightShift" then --check if you pressed shift to start capitalazing letters
                    isShift = true
                elseif key > 0 and key < 255 then --check if the character is within the range between 0-255 because string.char breaks otherwise(Cuz it's using ASCII and accepts only one byte of info)
                    if isShift == false and #fkey == 1 then --check if you press shift and if you pressed the letter keys(1 char long) and put the letters in lowercase if you didn't
                        key = key+32 --add 32 to the key integer because this is the difference between capital letters and lowercase letter
                    end
                    self.message = self.message..string.char(key) --finally add the pressed key to the message
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
function setupScreen(options) --{{option default text= string, option info = string, background colour = number, text colour = number, inputBackground colour = number, input foreground colour = number},{...}}
    local inputBox = createInputBox() --create an input box for the setup screen
    for _,option in pairs(options) do --iterate trough each setup option
        --assign some parameters from the current option to the variables or use defaults if there is none
        local optionInfo = totAPI.splitString(option.info,screenW) or {""}
        local optionBC = option.BC or colours.white
        local optionTC = option.TC or colours.black
        inputBox.def = option.defaultText or ""
        inputBox.BC = colors.inputBC or colours.lightGray
        inputBox.TC = option.inputTC or colours.gray
        inputBox.x = math.floor((screenW-screenW/4)/2)
        inputBox.y = math.floor(screenL - screenL/8)
        inputBox.len = math.floor(screenW/4)
        --
        --set background and text colour and then clear everything to fill the screen with the background colour
        term.setBackgroundColour(optionBC) 
        term.setTextColor(optionTC)
        term.clear()
        --
        for i = 1,#optionInfo do --print each line of the splitted text
            term.setCursorPos((screenW-#optionInfo[i])/2+1,(screenL-#optionInfo)/2+i)
            term.write(optionInfo[i])
        end
        input=inputBox:getInput() -- get input(We're not doing anything with it atm)
    end
end

function printReceipt(playerName, receipt, priceList, nationName)--Chanied's code idk
    printer = peripheral.find("printer")
    printer.newPage()
    local cursorPos = 1
    local total = 0
    printer.setPageTitle("Receipt from Phottoquick")
    printer.setCursorPos(1,1)
    printer.write("Invoice for "..playerName.. " for nation:")
    for i = 1, #receipt do
        splitShit = totAPI.splitString(receipt[i]..": "..priceList[i], 25)
        for j = 1,#splitShit do
            cursorPos = cursorPos + 1
            printer.setCursorPos(1,cursorPos)
            printer.write(splitShit[j])
        end
        total = total + priceList[i]
    end
    printer.setCursorPos(1,cursorPos+1)
    printer.write("Total: "..total)
    printer.endPage()
    
end
-- "ooga booga" - QuickPlayz_ 19/06/2024
function cost(frameType) --returns cost of frame type   
    if frameType == "B&W frames" then
        return 1, "cog"
    elseif frameType == "trichromatic frames" then
        return 4, "cog"
    elseif frameType == "full color frames" then
        return 16, "cog"
    elseif frameType == "days of onsite work" then
        return 1, "sun"
    else
        error("Invalid frame type")
    end
    
    -- [16]x colour frames for [16 cogs]
    -- [15]x trichromatic frames for [16 cogs]
    -- [11]x B&W frames for [16 cogs]
    -- [1]day onsite work in [Zealandia] for [1 Sun, 2 crowns]
end
function generateReceipt(playerName, orderList, nationName) -- orderList = {frameType1Ammount = 5, frameType2Ammount = 3, frameType3Ammount = 7}
    local receipt = {}
    local priceList = {}
    for frameType, ammount in pairs(orderList) do
        local frameCost, frameCurrency = cost(frameType)
            if not (frameCost == 1) then
                frameCurrency = frameCurrency.."s"
            end
        if frameType == "of onsite work" then
            day = "day " and ammount == 1 or "days "
            table.insert(receipt, ammount.."x "..day..frameType.." in "..nationName..": "..frameCost.." "..frameCurrency)
        else
            table.insert(receipt, ammount.."x "..frameType..": "..frameCost.." "..frameCurrency)
        end
        table.insert(priceList, frameCost * ammount)
    end
    printReceipt(playerName,receipt,priceList,nationName)
end
setupScreen({{name="test",info="this is a long sentance that will be split up using code. The line will wrap around the screen",BC = 1,TC = 15},{name="I regret",info = "Do you regret wasting your time on making a split function when it's already implemented in the standard CC?",BC = 3, TC = 5,inputBC = 5,inputTC = 7}})

generateReceipt("QuickPlayz_", {["B&W frames"] = 11, ["trichromatic frames"] = 15, ["full color frames"] = 16, ["days of onsite work"] = 1}, "Zealandia")
