local camel = require("camelAPI")
local tot = require("totAPI")

modem = "modem_0"
money_stock = peripheral.wrap("create:depot_22")
money_drop = peripheral.wrap("create:depot_7")
monitor = peripheral.wrap("monitor_2")
monitor2 = peripheral.wrap("monitor_3")
--diamondStock = peripheral.wrap("redrouter_1")

repeat
	redCartNum = file.readLine()
	redCartName = file.readLine()
	redStockTable[redCartName] = peripheral.wrap("redrouter_"..redCartNum)
	redStockSignal[redCartName] = 
	--stockDepot = peripheralTable[item_name].items()
	--outOfStockList[item_name] = not pcall(stockCount, stockDepot, 1) -- the pcall sends a "protected call" that returns true if the function is successful and false if it errors
	--priceList[item_name] = item_price
	--stockChute = peripheral.call("create:chute_"..chute_name, "list")
	--lowStockList[item_name] = not pcall(stockCount, stockChute[1], 1) -- the pcall sends a "protected call" that returns true if the function is successful and false if it errors
	
	stockBuild = 0
	if lowStockList[item_name] then
		if not outOfStockList[item_name] then
			for slot, item in pairs(peripheral.call("minecraft:barrel_"..barrel_name, "list")) do
				if pcall(stockCount, item) then
					stockBuild = stockBuild + 1
				end
			end
			if stockBuild == 0 then
				outOfStockList[item_name] = true
			end
		else
			stockBuild = 0
		end
	else
		stockBuild = 27
	end
	
	stockAmountList[item_name] = stockBuild
	print("lowStockList "..tostring(lowStockList[item_name]).."   outOfStockList "..tostring(outOfStockList[item_name]).."  "..stockBuild)

	file.close()
	counter = counter + 1
	file = fs.open("saharasaves/depot"..counter,"r")
	print(file)
until file == nil

camel.requestStock()

print("itemList recieved")
itemList = message[1]
priceList = message[2]
lowStockList = message[3]
outOfStockList = message[4]
stockAmountList = message[5]
print(message)

local itemCartList = {}
local price = 0

local input = ""

repeat
	local event, monitorID, xpos, ypos = os.pullEvent("key")
		print("Type ADD to add an item to the cart, SAVE to save the cart for later, READ to read saved a cart, CHANGE to change the saved station, or DONE to finish the order")
		input = read()
		if input == "CHANGE" then
			monitor.clear()
			monitor.setCursorPos(1,1)
			monitor.write("Use console for input")
			print("enter the station's name")
			stationName = read()
			fs.makeDir("saharasaves")
			local file = fs.open("saharasaves/station","w")
			file.writeLine(stationName)
			file.close()
			print("enter the item's name")
			item = read()
		elseif input == "DONE" then
			break
		elseif input == "SAVE" then
			print("enter the name of the cart")
			local cartName = read()
			camel.saveCart(itemCartList, cartName)
		elseif input == "READ" then
			print("enter the name of the cart")
			local cartName = read()
			itemCartList, price = camel.readSavedCart(itemCartList, cartName, outOfStockList, priceList, lowStockList, stockAmountList, price)
		elseif input == "ADD" then
			item = read()
			itemCartList, price = camel.addToCart(item, outOfStockList, itemCartList, priceList, lowStockList, stockAmountList, price, 1)
		end
until input == "DONE"

camel.sendCoinsToTrain(price, money_stock, money_drop)

if tot.listLen(itemCartList) > 0 then
	local file = fs.open("saharasaves/station","r")
	stationName = file.readLine()
	file.close()

	if camel.sendCart(itemCartList, stationName) then
		print("Order sent")
		monitor.write("Order sent")
	else
		error("Server not responding",1)
		monitor.write("Server not responding")
	end
end

rednet.close(modem)
