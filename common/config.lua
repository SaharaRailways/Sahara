config = {}

config["version"] = "0.1.0"

function config.add(programName, configName, defaultValue)
    if not fs.exists("saharasaves/"..programName.."/"..configName) then
        local file = fs.open("saharasaves/"..programName.."/"..configName,"w")
        file.write(defaultValue)
        file.close()
    end
end

function config.display(programName) --displays all config options for a program
    local configList = fs.list("saharasaves/"..programName)
    for i, configName in ipairs(configList) do
        local file = fs.open("saharasaves/"..programName.."/"..configName,"r")
        print(configName..": "..file.readLine())
        file.close()
    end
end




return config