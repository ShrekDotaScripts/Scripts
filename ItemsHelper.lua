local ItemsHelper = {}

ItemsHelper.MenuPath = {"Utility", "Items Helper"}
ItemsHelper.MEnabled = Menu.AddOptionBool(ItemsHelper.MenuPath, "Enabled", false)
ItemsHelper.MBlink = Menu.AddOptionBool(ItemsHelper.MenuPath, "Max Blink Range", false)
ItemsHelper.LocalHero = nil

function ItemsHelper.ResetVars()
	ItemsHelper.LocalHero = nil
end

function ItemsHelper.CheckBlink(p1, p2, p3, p4)
	if p4 == Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_POSITION and p1 ~= nil and p1 ~= 0 and Entity.IsEntity(p1) and Ability.GetName(p1) == 'item_blink' then
		
		local k1 = Entity.GetAbsOrigin(p3)
		local k2 = Vector(p2:GetX() - k1:GetX(), p2:GetY() - k1:GetY(), p2:GetZ() - k1:GetZ())
		local k3 = math.sqrt(math.pow(k2:GetX(), 2) + math.pow(k2:GetY(), 2) + math.pow(k2:GetZ(), 2))
		if k3 < 1200 then return false end
		local k4 = Vector(k1:GetX() + k2:GetX() / k3 * 1199, k1:GetY() + k2:GetY() / k3 * 1199, k1:GetZ() + k2:GetZ() / k3 * 1199)
		Ability.CastAbilityPosition(p1,k4)
		return true
	end
end

function ItemsHelper.OnPrepareUnitOrders(p1)
	if Menu.IsEnabled(ItemsHelper.MEnabled) == false or ItemsHelper.LocalHero == nil or p1 == nil then return end

	if Menu.IsEnabled(ItemsHelper.MBlink) and ItemsHelper.CheckBlink(p1.ability, p1.position, p1.npc, p1.order) then
		return false
	end

	return true
end

function ItemsHelper.OnUpdate(p1)
	ItemsHelper.LocalHero = Heroes.GetLocal()
	if ItemsHelper.LocalHero == nil then return end
	
end

function ItemsHelper.OnGameStart()
	ItemsHelper.ResetVars()
end

function ItemsHelper.OnGameEnd()
	ItemsHelper.ResetVars()
end

return ItemsHelper