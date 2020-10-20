-- Converted by xaneh#6591
-- For more fivem scripts, https://discord.gg/wBNwPCv

ESX = nil
TriggerEvent('QBCore:GetObject', function(obj) ESX = obj end)

-- Code

RegisterCommand("skin", function(source, args)
	TriggerClientEvent("qb-clothing:client:openMenu", source)
end, false)

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if model ~= nil and skin ~= nil then 
        MySQL.Async.fetchAll(false, "DELETE FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
            MySQL.Async.fetchAll(false, "INSERT INTO `playerskins` (`citizenid`, `model`, `skin`, `active`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."', 1)")
        end)
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin")
AddEventHandler('qb-clothes:loadPlayerSkin', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll(false, "SELECT * FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("qb-clothes:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("qb-clothes:saveOutfit")
AddEventHandler("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.Async.execute(false, "INSERT INTO `player_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            MySQL.Async.fetchAll(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit")
AddEventHandler("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    MySQL.Async.execute(false, "DELETE FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        MySQL.Async.fetchAll(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

RegisterServerCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local anusVal = {}

    MySQL.Async.fetchAll(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

RegisterServerEvent('qb-clothing:print')
AddEventHandler('qb-clothing:print', function(data)
    print(data)
end)

RegisterCommand("helm", function(source, args)
    TriggerClientEvent("qb-clothing:client:adjustfacewear", source, 1) -- Hat
end)

RegisterCommand("glasses", function(source, args)
	TriggerClientEvent("qb-clothing:client:adjustfacewear", source, 2)
end)

RegisterCommand("mask", function(source, args)
	TriggerClientEvent("qb-clothing:client:adjustfacewear", source, 4)
end)