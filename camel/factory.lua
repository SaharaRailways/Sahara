local camel = require("camelAPI")
local tot = require("totAPI")

modem = "modem_0"
money_stock = peripheral.wrap("create:depot_22")
money_drop = peripheral.wrap("create:depot_7")
monitor = peripheral.wrap("monitor_2")
monitor2 = peripheral.wrap("monitor_3")

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
