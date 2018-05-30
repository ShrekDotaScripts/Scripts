local Utils = {}

_G.Config = {}

function math.pow(p1, p2)
	local k1 = 1
	for i = 1, p2 do
		k1 = k1 * p1 
	end
	return k1
end

function NPC.GetAbsOrigin(p1)
	return Entity.GetAbsOrigin(p1)
end

function NPC.GetUnitsInRadius(p1, p2, p3) 
	local answer = Entity.GetUnitsInRadius(p1, p2, p3)
	if answer ~= nil then
		return answer
	else
		return {}
	end
end

function NPC.GetHeroesInRadius(p1, p2, p3)
	return Heroes.InRadius(Entity.GetAbsOrigin(p1), p2, Entity.GetTeamNum(p1), p3)
end


function Renderer.DrawTextCenteredX(p1, p2, p3, p4, p5)
	return Renderer.DrawText(p1, p2, p3, p4)
end

function Renderer.DrawTextCenteredY(p1, p2, p3, p4, p5)
	return Renderer.DrawText(p1, p2, p3, p4)
end

function Renderer.DrawTextCentered(p1, p2, p3, p4, p5)
	return Renderer.DrawText(p1, p2-6, p3-6, p4)
end

function Ability.CastAbilityPosition(p1, p2)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_POSITION, nil, p2, p1, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_CURRENT_UNIT_ONLY, nil, false, false)
	return true
end

function Ability.CastCustomTarget(p1, p2, p3)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_TARGET, Heroes.GetLocal(), Vector(0,0,0), p1, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, p3)

	return true
end

function Ability.GetRange(p1)
	return Ability.GetLevelSpecialValueFor(p1, "radius")
end

function Config.ReadString(name, key, defValue)
	return ""
end

function Config.ReadInt(name, key, defValue)
	return ""
end

function Config.ReadFloat(name, key, defValue)
	return ""
end

function Config.WriteInt(name, key, defValue)
	return ""
end

function Config.WriteFloat(name, key, defValue)
	return ""
end


function Config.WriteString(name, key, defValue)
	return ""
end

return Utils