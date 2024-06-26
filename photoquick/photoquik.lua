--this is a test to see if it updates on github...
local totAPI = require("totAPI")
local screenW,screenL = term.getSize()

function createInputBox(x,y,len,def,BC,TC)
    local InputBox = {}
    InputBox.x = x or 1
    InputBox.y = y or 1
    InputBox.len = len or 1
    InputBox.def = def or ""
    InputBox.BC = BC or colours.gray
    InputBox.TC = TC or colours.white
    InputBox.message = ""
    function InputBox:getInput()
        local eventData = {os.pullEvent()}
        local event = eventData[1]
        local switch = {
                enter = function()    -- for case 1
                    isEditing = false
                end,
                backspace = function()    -- for case 2
                    print "Case 2."
                    self.message = self.message:sub(1,-2)
                end,
                delete = function()    -- for case 3
                    self.message = self.message:sub(1,-2)
                end
            }
        if event == "mouse_click" then
            local mouseX = eventData[3]
            local mouseY = eventData[4]
            if mouseX >= self.x and mouseX <= self.x+len-1 and mouseY == self.y then
                isEditing = true
            else
                isEditing = false
            end
        elseif event == "key" and isEditing then
            local key = keys.getName(eventData[2])
            if switch[key] then
                switch[key]()
            elseif #key == 1
                self.message = self.message..key
            end
        end
        term.setBackgroundColor(BC)
        term.setTextColor(TC)
        term.setCursorPos(self.x,self.y)
        if #self.message > 0 then
            prn = self.message
        else
            prn = self.def
        end
        term.write(prn:sub(-len,-1))
    end
    return InputBox
end
function setupScreen(options) --{{option name = string, option info = string, background colour = number, text colour = number},{...}}
    local inputBox = createInputBox()
    for _,option in pairs(options) do
        local optionName = option.name
        local optionInfo = totAPI.splitString(option.info,screenW)
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
--setupScreen({{name="shi",info="this is a long sentance that will be split up using code. The line will wrap around the screen",BC = 1,TC = 5}})

generateReceipt("QuickPlayz_", {["B&W frames"] = 11, ["trichromatic frames"] = 15, ["full color frames"] = 16, ["days of onsite work"] = 1}, "Zealandia")
