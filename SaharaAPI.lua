sahara = {}
sahara.version = 0.1

function sahara.requestStock()
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

function sahara.sendCart(cartList, stationName)
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

function sahara.priceOfCartList(cartList, priceList)
    -- Calculate the price of the inputted cart list with the inputted price list
    price = 0
	for item, amount in pairs(cartList) do
		price = price + priceList[item] * amount
	end
    return price
end


function sahara.sendCoinsToTrain(price, stockLocation, dropLocation)
    -- stockLocation is the peripheral name of the where the coins are being stored. 
    -- dropLocation is the peripheral name of where the coins will be picked up by the train. (DO NOT USE THE PORTABLE STORAGE INTERFACE. You must use a container with as many slots as you will require for coins, and then pipe it into the interface)
    -- Send coins to the portable storage interface to wait for the train to pick up. If you don't have enough coins, return false. If you do, return true.
    local remaining_price = price
	local new_remaining_price = remaining_price
	while remaining_price > 0 do
		sleep(1.5)
		depot_info = money_stock.items()
		stack_info = depot_info[1]
		
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


function sahara.getDepotItem(depotName)
    return ((depotName.items())[1])["name"]
end
return sahara