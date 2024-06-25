--this is a test to see if it updates on github...
local totAPI = require("totAPI")
local screenW,screenL = term.getSize()

function createInputBox(x,y,len)
    local InputBox = {}
    InputBox.x = x
    InputBox.y = y
    InputBox.len = len
    InputBox.message = ""
    function InputBox:getInput()
        local eventData = {os.pullEvent()}
        local event = eventData[1]
        if event == "mouse_click" then
            local mouseX = eventData[3]
            local mouseY = eventData[4]
            term.setCursorPos(mouseX,mouseY)
            if mouseX >= self.x and mouseX <= self.x+len-1 and mouseY == self.y then
                isEditing = true
            else
                isEditing = false
            end
        elseif event == "key" and isEditing then
            local key = keys.getName(eventData[2])
            switch 
            stg = stg..string.char(key)
            elseif key == 257 then
                isEditing = false
            end
        end
        term.setBackgroundColor(3)
        term.setTextColor(7)
        term.setCursorPos((screenW-screenW/4)/2,screenL/8)
        term.write(stg:sub(-screenW/4,-1))
    end
end
function setupScreen(options) --{{option name = string, option info = string, background colour = number, text colour = number},{...}}
    for _,option in pairs(options) do
        local optionName = option.name
        local optionInfo = totAPI.splitToChunksByWords(option.info,screenW)
        local optionBC = option.BC
        local optionTC = option.TC
        local isEditing = true
        local stg = ""
        term.setBackgroundColour(optionBC)
        term.setTextColor(optionTC)
        term.clear()
        for i = 1,#optionInfo do
            term.setCursorPos((screenW-#optionInfo[i])/2+1,(screenL-#optionInfo)/2+i)
            term.write(optionInfo[i])
        end
        
    end
end

function printReceipt(playerName, receipt, priceList, nationName)
    printer = peripheral.find("printer")
    printer.newPage()
    cursorPos = 1
    local total = 0
    printer.setPageTitle("Receipt from Phottoquick")
    printer.setCursorPos(1,1)
    printer.write("Invoice for "..playerName.. " for nation:")
    for i = 1, #receipt do
        cursorPos = cursorPos + 1
        printer.setCursorPos(1,cursorPos)
        printer.write(name..": "..price)
        total = total + priceList[i]
    end
    printer.setCursorPos(1,cursorPos+1)
    printer.write("Total: "..total)
    printer.endPage()
    
end
-- "ooga booga" - QuickPlayz_ 19/06/2024
function cost(frameType) --returns cost of frame type
    local frameType = "frameType1"        
    local frameCost = 0
    if frameType == "B&W frames" then
        return 1, "cog"
    elseif frameType == "trichromatic frames" then
        return 4, "cog"
    elseif frameType == "full color frames" then
        return 16, "cog"
    elseif frameType == "days of onsite work" then
        return 1, "sun"
    end
    return frameCost
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
            day = "day " and amount == 1 or "days "
            table.insert(receipt, ammount.."x "..day..frameType.." in "..nationName..": "..frameCost.." "..frameCurrency)
        else
            table.insert(receipt, ammount.."x "..frameType..": "..frameCost.." "..frameCurrency)
        end
        table.insert(priceList, frameCost * ammount)
    end
    printReceipt(playerName,receipt,priceList,nationName)
end
setupScreen({{name="shi",info="this is a long sentance that will be split up using code. The line will wrap around the screen",BC = 1,TC = 5}})
