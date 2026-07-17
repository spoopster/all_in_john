local DAMAGE_UP = 0.5
local LUCK_UP = 3

---@param id Card
---@param player EntityPlayer
---@param flags UseFlag
local function useCard(_, id, player, flags)
    local pos = AllInJohn.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position)
    local coin = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 0, pos, Vector.Zero, nil):ToPickup()

    AllInJohn:playAnnouncerVoice(AllInJohn.SFX_VOICE_CHARM_1, flags)
end
AllInJohn:AddCallback(ModCallbacks.MC_USE_CARD, useCard, AllInJohn.CARD_CHARM)

---@param player EntityPlayer
local function checkFlagsOnAddRemoveCard(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_LUCK, true)
end
AllInJohn:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_CARD, checkFlagsOnAddRemoveCard, AllInJohn.CARD_CHARM)
AllInJohn:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_CARD, checkFlagsOnAddRemoveCard, AllInJohn.CARD_CHARM)

---@param player EntityPlayer
---@param pickup EntityPickup
local function destroyDroppedCard(_, player, pickup)
    pickup.Wait = 1000
    pickup.Timeout = 30

    AllInJohn.SFX:Play(SoundEffect.SOUND_THUMBS_DOWN)
end
AllInJohn:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_CARD, destroyDroppedCard, AllInJohn.CARD_CHARM)

---@param player EntityPlayer
local function evalCache(_, player)
    local mult = 0
    for i=0, 3 do
        if(player:GetCard(i)==AllInJohn.CARD_CHARM) then
            mult = mult+1
        end
    end

    if(mult==0) then return end

    player.Luck = player.Luck+mult*LUCK_UP
end
AllInJohn:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_LUCK)

---@param player EntityPlayer
---@param val number
local function evalStat(_, player, _, val)
    local mult = 0
    for i=0, 3 do
        if(player:GetCard(i)==AllInJohn.CARD_CHARM) then
            mult = mult+1
        end
    end

    if(mult==0) then return end

    return val+mult*DAMAGE_UP
end
AllInJohn:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat, EvaluateStatStage.FLAT_DAMAGE)