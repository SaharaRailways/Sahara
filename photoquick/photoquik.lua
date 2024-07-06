--this is a test to see if it updates on github...
local totAPI = require("totAPI")
local requiredSettings = {depositor,printer}
local optionalSettings = {monitor,speaker,redrouter}
local screenW,screenL = term.getSize()
if settings.load("photoConfig.settings") then
    local unsStg =  {}
    
end


function setupScreen(options) --{{option default text= string, option info = string, background colour = number, text colour = number, inputBackground colour = number, input foreground colour = number},{...}}
    local inputBox = tot.createInputBox() --create an input box for the setup screen
    for _,option in pairs(options) do --iterate trough each setup option
        --assign some parameters from the current option to the variables or use defaults if there is none
        local optionInfo = totAPI.splitString(option.info,screenW) or {""}
        local optionBC = option.BC or colours.white
        local optionTC = option.TC or colours.black
        inputBox.def = option.defaultText or ""
        inputBox.BC = option.inputBC or colours.lightGrey
        inputBox.TC = option.inputTC or colours.grey
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
        table.insert(priceList, tot.toCogs(frameCost,frameCurrency) * ammount)
    end
    tot.printReceipt(playerName,receipt,priceList,"Invoice for "..playerName.." for nation:"..nationName)
end
setupScreen({{name="test",info="this is a long sentance that will be split up using code. The line will wrap around the screen",BC = 1,TC = 15},{name="I regret",info = "Do you regret wasting your time on making a split function when it's already implemented in the standard CC?",BC = 3, TC = 5,inputBC = 5,inputTC = 7}})

generateReceipt("QuickPlayz_", {["B&W frames"] = 11, ["trichromatic frames"] = 15, ["full color frames"] = 16, ["days of onsite work"] = 1}, "Zealandia")
