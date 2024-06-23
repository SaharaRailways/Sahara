local screenW,screenL = term.getSize()

local function split(string, chunkSize)
    local chunks = {} 
    local chunk = "" 
    for word in string:gfind("%A?%a+%A?") do 
        if #chunk+#word < chunkSize then 
            chunk = chunk..word 
        else 
            chunks[#chunks+1] = chunk 
            chunk = word 
        end 
    end
    chunks[#chunks+1] = chunk
    return chunks
end

function setupScreen(options) --{{option name = string, option info = string, background colour = number, text colour = number},{...}}
    for _,option in pairs(options) do
        local optionName = option.name
        local optionInfo = split(option.info,screenW)
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
        while true do
                
            local eventData = {os.pullEvent()}
            local event = eventData[1]
            if event == "mouse_click" then
                local mouseX = eventData[3]
                local mouseY = eventData[4]
                if mouseX > (screenW-screenW/4)/2 and mouseX < (screenW+screenW/4)/2 and mouseY == math.floor(screenL/8) then
                    isEditing = true
                end
            elseif event == "key" and isEditing then
                local key = eventData[2]
                if key > 0 and key < 256 then
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
end

function printReceipt(playerName, receipt, priceList) 
    printer = peripheral.find("printer")
    printer.newPage()
    cursorPos = 1
    local total = 0
    printer.setPageTitle("Recipt from Phottoquick")
    printer.setCursorPos(1,1)
    printer.write("Invoice for "..playerName.. ":")
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
function cost() --returns cost of frame type
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
    end
    printReceipt("Szedan",{"Apple", "Banana", "Orange"},{1,2,3})
end
setupScreen({{name="shi",info="this is a long sentance that will be split up using code. The line will wrap around the screen",BC = 1,TC = 5}})
