local deployers = {
    ["player1"] = peripheral.wrap("deployer_2"),
    ["player2"] = peripheral.wrap("deployer_3"),
    ["player3"] = peripheral.wrap("deployer_4"),
    ["player4"] = peripheral.wrap("deployer_5"),
    ["player5"] = peripheral.wrap("deployer_6"),
    ["player6"] = peripheral.wrap("deployer_7")
}

local depositors = {
    ["player1"] = peripheral.wrap("depositor_1"),
    ["player2"] = peripheral.wrap("depositor_2"),
    ["player3"] = peripheral.wrap("depositor_3"),
    ["player4"] = peripheral.wrap("depositor_4"),
    ["player5"] = peripheral.wrap("depositor_5"),
    ["player6"] = peripheral.wrap("depositor_6")
}

local depositorSignals = {
    ["player1"] = peripheral.wrap("redrouter_18"),
    ["player2"] = peripheral.wrap("redrouter_19"),
    ["player3"] = peripheral.wrap("redrouter_20"),
    ["player4"] = peripheral.wrap("redrouter_21"),
    ["player5"] = peripheral.wrap("redrouter_22"),
    ["player6"] = peripheral.wrap("redrouter_23")
} --temperary until numistics compat is on testing server

local payQueue = {
    ["player1"] = {{"player3",5}},
    ["player2"] = {{"player3",1984},{"player5",1488},{"player4",420}},
    ["player3"] = {},
    ["player4"] = {},
    ["player5"] = {},
    ["player6"] = {}
} --stored as {"AccountName1" = {{fromPlayer, ammount}, "AccountName2" = {fromPlayer, ammount}}}

local function getBalance(player)

    return
end

local function setDepositor(player, ammount)
    return true
end

local function payPlayer(fromPlayer, toPlayer, ammount)
    local fromPlayerBalance = getBalance(fromPlayer)
    if fromPlayerBalance < ammount then
        return false, "reason 1"
    end
    if not setDepositor(toPlayer, ammount) then
        return false, "reason 2"
    end

end