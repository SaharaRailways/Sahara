camel = {}
camel.version = 0.1

function camel.requestStock()
    -- Request stock data from the server and return the list
    
    rednet.open(modem)
    server_ip = rednet.lookup("sahara", "saharaServer")
    if server_ip == nil then
        return "Server not Open"
    end

    rednet.send(server_ip,"itemList","sahara")
    local counter = 0
    repeat
        counter  = counter + 1
        if counter > 10 then
            --If the server does not respond after 10 tries, return false
            return false
        end
        transmitedID, message, protocol = rednet.receive("sahara", 3)
    until transmitedID == server_ip
    return message
    -- Returns message, which is a table with the following structure: {itemList, priceList, lowStockList, outOfStockList, stockAmountList}
    
end

function camel.sendCart(cartList, stationName)
    --First turn the key value format of the cartList into a normal list of items.
    -- cartListSend = {}
	-- for item, amount in pairs(cartList) do
	-- 	for i = 1, amount do
	-- 		table.insert(cartListSend, item)
	-- 	end
	-- end
    
    message = false
    rednet.send(server_ip, {stationName, cartList}, "sahara")
    transmitedID, message, protocol = rednet.receive("sahara", 10)
    return not not message -- Return true if the server responded, false if it timed out after waiting 10 seconds (the server may take a bit to respond)
end

function camel.priceOfCartList(cartList, priceList)
    -- Calculate the price of the inputted cart list with the inputted price list
    local price = 0
	for item, amount in pairs(cartList) do
		price = price + priceList[item] * amount
	end
    return price
end


function camel.sendCoinsToTrain(price, stockLocation, dropLocation)
    -- stockLocation is the peripheral name of the where the coins are being stored. 
    -- dropLocation is the peripheral name of where the coins will be picked up by the train. (DO NOT USE THE PORTABLE STORAGE INTERFACE. You must use a container with as many slots as you will require for coins, and then pipe it into the interface)
    -- Send coins to the portable storage interface to wait for the train to pick up. If you don't have enough coins, return false. If you do, return true.
    local remaining_price = price
	local new_remaining_price = remaining_price
	while remaining_price > 0 do
		sleep(1.5)
		local depot_info = money_stock.items()
		local stack_info = depot_info[1]
		
		if stack_info == nil then
			error("no coins in storage",1)
		else
			
			
			new_remaining_price = remaining_price - stack_info["count"]
			stockLocation.pushItem(peripheral.getName(dropLocation),"minecraft:redstone",remaining_price)
			remaining_price = new_remaining_price
			print("remaining price: "..remaining_price)
		end
	end
	print("payment complete")
end

function camel.saveCart(cartList, cartName)
    -- Save the cart list to a file in the saharasaves folder
    local file = fs.open("saharasaves/cart/"..cartName,"w")
    for item, amount in pairs(cartList) do
        file.writeLine(item)
        file.writeLine(amount)
    end
    file.close()
    
end

function camel.readSavedCart(cartList, cartName, outOfStockList, priceList, lowStockList, stockAmountList, price)
    -- Read a saved cart list from a file in the saharasaves folder and appends it to the inputted cart list
    local file = fs.open("saharasaves/cart/"..cartName,"r")
    cartList = {}
    while true do
        local item = file.readLine()
        if item == nil then
            break
        end
        local amount = file.readLine()
        cartList, price = camel.addToCart(item, outOfStockList, cartList, priceList, lowStockList, stockAmountList, price, amount)
    end
    file.close()
    return cartList, price
end

function camel.getDepotItem(depotName)
    return ((depotName.items())[1])["name"]
end

function camel.addToCart(item, outOfStockList, cartList, priceList, lowStockList, stockAmountList, price, ammount)

	if not outOfStockList[item] then
		if cartList[item] == nil then
			cartList[item] = 0
		end
		if lowStockList[item] then
			if cartList[item] + ammount <= stockAmountList[item] then
				print(item)
				cartList[item] = itemCartList[item] + ammount
				price = priceList[item] + (price * ammount)
			end
		else
			print(item)
			cartList[item] = cartList[item] + ammount
			price = priceList[item] + (price * ammount)
		end
	end
    return cartList, price
end

return camel
