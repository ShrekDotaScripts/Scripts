local courierReuse = {}

courierReuse.OptionEnabled = Menu.AddOptionBool({"Utility", "Courier"}, "Enabled", false)
courierReuse.optionKey = Menu.AddKeyOption({ "Utility", "Courier"}, "Key to reuse", Enum.ButtonCode.KEY_T)
courierReuse.optionMuteFilter = Menu.AddOptionBool({"Utility", "Courier"}, "Mute Filter", false)
courierReuse.players = {}
courierReuse.muted = {}

function courierReuse.OnUpdate()
  if not Engine.IsInGame() or not Heroes.GetLocal() then
    for i = 0, 10 do
      if courierReuse.players[i] then
        Menu.RemoveOption(courierReuse.players[i]) courierReuse.players[i] = nil
      end
    end
  end
  if not Menu.IsEnabled(courierReuse.OptionEnabled) then return end
  local myHero = Heroes.GetLocal()
  if myHero == nil then return end
  local myTeam = Entity.GetTeamNum(myHero)
  local bReuse = false
  for i = 1, Players.Count() do
    local player = Players.Get(i)
    if Player.IsMuted(player) then
      courierReuse.muted[Player.GetPlayerID(player)] = 1
    else
      courierReuse.muted[Player.GetPlayerID(player)] = nil
    end
  end
  for i = 1, Heroes.Count() do
    local hero = Heroes.Get(i)
    if courierReuse.muted[Hero.GetPlayerID(hero)] then
      courierReuse.muted[hero] = true
    else
      courierReuse.muted[hero] = false
    end
    if Entity.IsSameTeam(myHero, hero) and hero ~= myHero and not courierReuse.players[Hero.GetPlayerID(hero)] then
      courierReuse.players[Hero.GetPlayerID(hero)] = Menu.AddOptionBool({"Utility", "Courier"}, string.upper(string.sub(NPC.GetUnitName(hero), 15)), false)
    end
    if Entity.IsSameTeam(myHero, hero) and hero ~= myHero then
      if Menu.IsEnabled(courierReuse.players[Hero.GetPlayerID(hero)]) then
        courierReuse.muted[hero] = true
      else
        courierReuse.muted[hero] = false
      end
    end
  end
  for i = 1, Couriers.Count() do
    local index_npc = Couriers.Get(i)
    if index_npc ~= nil then
      if Entity.IsSameTeam(index_npc, myHero) and Entity.IsAlive(index_npc) then
        local courierEnt = Courier.GetCourierStateEntity(index_npc)
        local reuse = NPC.GetAbilityByIndex(index_npc, 4)
        local reuse_2 = NPC.GetAbilityByIndex(index_npc, 3)
        local go_home = NPC.GetAbilityByIndex(index_npc, 0)
        if Menu.IsKeyDown(courierReuse.optionKey) then
          Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_NO_TARGET, myHero, Vector(0, 0, 0), reuse, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, index_npc)
        end
        if courierEnt then
          if (Menu.IsEnabled(courierReuse.optionMuteFilter) and courierReuse.muted[courierEnt]) or Menu.IsEnabled(courierReuse.players[Hero.GetPlayerID(courierEnt)]) then
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_NO_TARGET, myHero, Vector(0, 0, 0), go_home, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, index_npc)
          end
        end
      end
    end
  end
end
return courierReuse
