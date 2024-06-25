local camel = require("camelAPI")
local tot = require("totAPI")

modem = "modem_0"
money_stock = peripheral.wrap("create:depot_22")
money_drop = peripheral.wrap("create:depot_7")

local file = fs.open("saharasaves/factory/powerside","r")
local powerside = file.readLine()
if not redstone.getInput(powerside) then
	error("Computer is not powered, turn on to order",1)
end

local counter = 0
local redCartCounter = 0
local redStockTable = {}
local redStockSignal = {}
repeat
	counter = counter + 1
	file = fs.open("saharasaves/factory/order/"..counter,"r")
	if file == nil then
		break
	end
	redCartNum = file.readLine()
	if redCartNum == "0" then
		--skips the order
		file.close()
	else
		local redCartName = file.readLine()
		local redCartSide = file.readLine()
		redStockTable[redCartName] = peripheral.wrap("redrouter_"..redCartNum)
		redStockSignal[redCartName] = redStockTable[redCartName].getInput(redCartSide)
		if redStockSignal[redCartName] then
			redCartCounter = redCartCounter + 1
		end
		file.close()
	end
	
until false

if redCartCounter == 0 then
	file = fs.open("saharasaves/factory/terminate","r")
	if file.readLine() == "true" then
		print("No carts requested, terminating computer in 10 seconds")
		sleep(10)
		os.shutdown()
	end
end

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
		print("Type ADD to add an item to the cart, SAVE to save the cart for later, READ to read saved a cart, or DONE to finish the order")
		input = read()
		if input == "DONE" then
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
