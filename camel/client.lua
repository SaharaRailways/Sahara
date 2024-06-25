--modem = peripheral.wrap("modem_0")

local camel = require("camelAPI")
local tot = require("totAPI")

modem = "modem_0"
money_stock = peripheral.wrap("create:depot_22")
money_drop = peripheral.wrap("create:depot_7")
monitor = peripheral.wrap("monitor_2")
monitor2 = peripheral.wrap("monitor_3")

function writeCart()


	monitor2.clear()
	max_scroll2 = math.ceil(#itemCartList / scroll_height) - 1
	local scrollmin = scroll2 * scroll_height
	local scrollmax = scrollmin + scroll_height + 1

	local counter = 0
	for item, amount in pairs(itemCartList) do
		counter = counter + 1
		if counter > scrollmin and counter < scrollmax then
			monitor2.setCursorPos(1,counter - scrollmin)
			monitor2.write(item)
			monitor2.setCursorPos(width+1-string.len(amount),counter - scrollmin)
			monitor2.write(amount)
			print(item.. ": "..amount)
		end
	end


	--for i=1, scroll_height do
	--	if i-1 + scroll2 * scroll_height >= #itemCartList then
	--		break
	--	end
	--	local item_num = scroll2 * scroll_height + i
	--	monitor2.setCursorPos(1,i)
	--	monitor2.write(itemCartList[item_num])
	--	monitor2.setCursorPos(width+1-string.len(priceList[itemCartList[item_num]]),i)
	--	monitor2.write(priceList[itemCartList[item_num]])
	--	print(itemCartList[item_num].. ": "..priceList[itemCartList[item_num]])
	--end
	monitor2.setCursorPos(1,height)
	monitor2.setTextColour(10, 240, 10)
	monitor2.write("Price: "..price)
	monitor2.setTextColour(1)
	monitor2.setCursorPos(width-2,height)
	monitor2.blit(string.sub("«",2,2), "b", "f")
	monitor2.setCursorPos(width,height)
	monitor2.blit(string.sub("»",2,2), "b", "f")
end

function writeStock()
	 
	monitor.clear()
	
	for i=1, scroll_height do
		if i-1 + scroll * scroll_height >= #itemList then
			break
		end
		local item_num = scroll * scroll_height + i
		monitor.setCursorPos(1,i)
		if outOfStockList[itemList[item_num]] == true then
			monitor.setTextColour(colors.red)
		elseif lowStockList[itemList[item_num]] == true then
			monitor.setTextColour(colors.yellow)
		else
			monitor.setTextColour(colors.white)
		end
		
		monitor.write(itemList[item_num])
		monitor.setCursorPos(width+1-string.len(priceList[itemList[item_num]]),i)
		monitor.write(priceList[itemList[item_num]])
		print(itemList[item_num].. ": "..priceList[itemList[item_num]])
	end
	monitor.setCursorPos(1,height)
	monitor.blit("Finish Order", "dddddddddddd", "ffffffffffff")
	monitor.setCursorPos(width-2,height)
	monitor.blit(string.sub("«",2,2), "b", "f")
	monitor.setCursorPos(width,height)
	monitor.blit(string.sub("»",2,2), "b", "f")
end


monitor.write("Waiting for Server")

camel.requestStock()

monitor.clear()
monitor2.clear()
monitor.setCursorPos(1,1)

print("itemList recieved")
itemList = message[1]
priceList = message[2]
lowStockList = message[3]
outOfStockList = message[4]
stockAmountList = message[5]
print(message)


scroll = 0
scroll2 = 0

width, height = monitor.getSize()
scroll_height = height - 2
itemCartList = {}
price = 0
max_scroll = math.ceil(#itemList / scroll_height) - 1
max_scroll2 = 0
writeStock()
writeCart()

print("Select the item with the monitor or press any key to enter the item's name manually/change stored data")

local input = ""

repeat
	local event, monitorID, xpos, ypos = os.pullEvent()
	if monitorID == "monitor_2" then
		if event == "monitor_touch" then
			if ypos == height then
				if xpos == width-2 then
					if scroll ~= 0 then
						scroll = scroll - 1
						writeStock()
					end
				elseif xpos == width then
					if scroll ~= max_scroll then
						scroll = scroll + 1
						writeStock()
					end
				elseif xpos <= 13 then
					input = "DONE"
				end
				print("scroll: "..scroll)
			else
				input = itemList[scroll * scroll_height + ypos]
				itemCartList, price = camel.addToCart(input, outOfStockList, itemCartList, priceList, lowStockList, stockAmountList, price, 1)
				writeCart()
				--if stockAmountList[input] then
					-- finish this pls ok i'm gonna make it long so you can see it ok now don't ignore it
					
				--end
			end
		end
	elseif monitorID == "monitor_3" then
		if ypos == height then
			if xpos == width-2 then
				if scroll2 ~= 0 then
					scroll2 = scroll2 - 1
					writeCart()
				end
			elseif xpos == width then
				if scroll2 ~= max_scroll2 then
					scroll2 = scroll2 + 1
					writeCart()
				end
			end
			print("scroll: "..scroll2)
		else
			itemCartList[tot.indexToKey(itemCartList, scroll2 * scroll_height + ypos)] = nil
			writeCart()
			price = camel.priceOfCartList(itemCartList, priceList)
		end
	elseif event == "key" then
		print("Type ADD to add an item to the cart, SAVE to save the cart for later, READ to read saved a cart, CHANGE to change the saved station, or DONE to finish the order")
		input = read()
		if input == "CHANGE" then
			monitor.clear()
			monitor.setCursorPos(1,1)
			monitor.write("Use console for input")
			print("enter the station's name")
			stationName = read()
			camel.setStation(stationName)
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
			writeCart()
		end
	end

until input == "DONE"


if tot.listLen(itemCartList) > 0 then
	monitor.clear()
	monitor.setCursorPos(1,1)
	monitor.setTextColour(1)
	monitor.write("Order sent!")
	redstone.setOutput("back",true) -- sends redstone power out the back to signal whatever you want. The default is a whistle sound.
	sleep(0.1)
	redstone.setOutput("back",false)
	print(#itemCartList)
	print("price is "..price)
	camel.sendCoinsToTrain(price, money_stock, money_drop)
	--local remaining_price = price
	--local new_remaining_price = remaining_price
	--while remaining_price > 0 do
		--sleep(1.5)
		--depot_info = money_stock.items() --.list() DOES NOT EXIST AAAAAH
		--stack_info = depot_info[1]
		
		--if stack_info == nil then
		--	error("no coins in storage",1)
		--else
			
			
			--new_remaining_price = remaining_price - stack_info["count"]
			--money_stock.pushItem(peripheral.getName(money_drop),"minecraft:redstone",remaining_price)
			--remaining_price = new_remaining_price
			--print("remaining price: "..remaining_price)
		--end
	--end
	--print("payment complete")
		
	
	local file = fs.open("saharasaves/station","r")
	stationName = file.readLine()
	file.close()
	monitor.clear()
	monitor.setCursorPos(1,1)
	monitor.setTextColour(1)
	monitor.write("Waiting for Server")
	if camel.sendCart(itemCartList, stationName) then
		print("Order sent")
		monitor.write("Order sent")
	else
		error("Server not responding",1)
		monitor.write("Server not responding")
	end
	--itemCartListSend = {}
	--for item, amount in pairs(itemCartList) do
		--for i = 1, amount do
			--table.insert(itemCartListSend, item)
		--end
	--end
	--rednet.send(server_ip, {stationName, itemCartListSend}, "sahara")
	
	--local counter = 0
	--repeat
		--counter  = counter + 1
		--if counter > 10 then
			--error("Server not responding",1)
		--end
		--transmitedID, message, protocol = rednet.receive("sahara", 3)
	--until transmitedID == server_ip

	--print("recieved")
	--monitor.clear()
	--print(message)
	--monitor.setCursorPos(1,1)
	--monitor.setTextColour(1)
	--monitor.write("Order Complete")
end

rednet.close(modem)
