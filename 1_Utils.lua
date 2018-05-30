local Utils = {}
-- Queue Timer --
Utils.time = 0
-- // --

-- Global Vars --
_G.Ag = {}
_G.Config = {}
_G.Wrapper = {}
Ag.IsEnabled = Menu.IsEnabled
Ag.SetValue  = Menu.SetValue
Ag.GetValue  = Menu.GetValue
Ag.IsAbility = Entity.IsAbility
Ag.IsNPC 	 = Entity.IsNPC
Ag.IsHero 	 = Entity.IsHero
Ag.GetUnitsInRadius = Entity.GetUnitsInRadius
Ag.InRadius  = Heroes.InRadius
Ag.IsSameTeam = Entity.IsSameTeam
-- // --

-- Local Vars --
local QueueList = {}
Wrapper.MenuList = {}
local combo = 0
-- // --

function _G.Length(p1)
	if p1 ~= nil then
		return #p1
	end
end

function _G.getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end

function math.pow(p1, p2)
	local k1 = 1
	for i = 1, p2 do
		k1 = k1 * p1 
	end
	return k1
end

function Menu.AddOption(p1, p2, p3, p4, p5, p6)
	Utils.time = os.time() + 5
	combo = combo + 1
	local curcombo = combo
	-- Slider / Combo --
	if p6 ~= nil then
		local NewList = {
			path = p1,
			name = p2,
			items = {},
			fmin = p4,
			fmax = p5,
			fdef = p6,
			cur = curcombo,
			mode = 1,
		}
		table.insert(QueueList, NewList)
		return '' .. curcombo
	end
	
	-- Combo / Slider --
	if p5 ~= nil then 
		local NewList = {
			path = p1,
			name = p2,
			items = {},
			cur = curcombo,
			mode = 2,
		}
		table.insert(QueueList, NewList)
		return '' .. curcombo
	end
	
	-- Bool --
	if p3 ~= nil then
		local NewList = {
			path = p1,
			name = p2,
			items = {},
			cur = curcombo,
			mode = 0,
		}
		table.insert(QueueList, NewList)
		return '' .. curcombo
	end
	
end

function Menu.SetValueName(p1, p2, p3)
	Utils.time = os.time() + 5
	if p1 ~= nil and p2 ~= nil and p3 ~= nil then
		p1 = p1 + 0
		QueueList[p1].items[p2] = ' ' .. p3
	end
end

function Menu.SetValue(p1,p2,p3)
	if type(p1) == "number" then
		return Ag.SetValue(p1,p2,p3)
	end
	if type(p1) == "string" then
		p1 = p1 + 0
		if Wrapper.MenuList[p1] ~= nil then
			if Wrapper.MenuList[p1][2] == 0 then
				if p2 == 0 then
					return Menu.SetEnabled(Wrapper.MenuList[p1][1],false)
				elseif p2 == 1 then
					return Menu.SetEnabled(Wrapper.MenuList[p1][1],true)
				end
			else
				return Ag.SetValue(Wrapper.MenuList[p1][1],p2,p3)
			end
		end
		
	end
end

function Menu.GetValue(p1)
	if type(p1) == "number" then
		return Ag.GetValue(p1)
	end
	
	if type(p1) == "string" then
		p1 = p1 + 0
		if Wrapper.MenuList[p1] ~= nil then
			-- Bool -- 
			if Wrapper.MenuList[p1][2] == 0 then
				if Ag.IsEnabled(Wrapper.MenuList[p1][1]) then
					return 1
				else
					return 0
				end
			end
			-- Slider --
			if Wrapper.MenuList[p1][2] == 1 then
				return Ag.GetValue(Wrapper.MenuList[p1][1])
			end
			-- Combo --
			if Wrapper.MenuList[p1][2] == 2 then
				return Ag.GetValue(Wrapper.MenuList[p1][1]) + 1
			end
		end
	end
end

function Menu.IsEnabled(p1)
	if type(p1) == "string" then
		p1 = p1 + 0
		if Wrapper.MenuList[p1] ~= nil then
			if Wrapper.MenuList[p1][2] == 0 then
				return Ag.IsEnabled(Wrapper.MenuList[p1][1])
			end
			
			if Wrapper.MenuList[p1][2] == 2 then
				local k1 = Ag.GetValue(Wrapper.MenuList[p1][1])
				if k1 == 0 then
					return false
				else
					return true
				end
			end
		end
	end
	if type(p1) == "number" then
		return Ag.IsEnabled(p1)
	end
end

-- Free function --
function Menu.GetOption()

end
--  // --

-- ReDeclare --
function NPC.GetUnitsInRadius(p1,p2,p3)
	return Entity.GetUnitsInRadius(p1,p2,p3)
end

function NPC.GetAbsOrigin(int)
	if int ~= 0 and int ~= nil then
		return Entity.GetAbsOrigin(int)
	end
end

function NPC.IsDormant(int)
	return Entity.IsDormant(int)
end

function Entity.IsAbility(p1)
	if p1 ~= nil and p1 ~= 0 then
		return Ag.IsAbility(p1)
	else
		return false
	end
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

function Entity.IsNPC(p1)
	if Entity.IsEntity(p1) then
		return Ag.IsNPC(p1)
	else
		return false
	end
end

function Entity.GetUnitsInRadius(p1, p2, p3)
	local Units = Ag.GetUnitsInRadius(p1, p2, p3)
	if Units ~= nil then
		return Units
	else
		return {}
	end
end

function Entity.IsHero(p1)
	if Entity.IsEntity(p1) then
		return Ag.IsHero(p1)
	else
		return false
	end
end

function NPC.GetHeroesInRadius(p1,p2,p3)
	return Entity.GetHeroesInRadius(p1,p2,p3)
end

function Heroes.InRadius(p1,p2,p3,p4)
	local FHero = Ag.InRadius(p1,p2,p3,p4)

	if FHero == nil then
		return {}
	else
		return FHero
	end
end

function Entity.IsSameTeam(p1, p2)
	if p1 ~= nil and p2 ~= nil and Entity.IsEntity(p1) and Entity.IsEntity(p2) then
		return Ag.IsSameTeam(p1,p2)
	else
		return false
	end
end
-- // --

function Ability.CastAbilityPosition(p1, p2)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_POSITION, nil, p2, p1, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_CURRENT_UNIT_ONLY, nil, false, false)
	return true
end

function Ability.GetRange(p1)
	return Ability.GetLevelSpecialValueFor(p1, "radius")
end


function Utils.SortQueue(tbl)
	if tbl~= nil and #tbl ~= 0 then
		local nametbl = {}
		for k, v in ipairs(tbl) do
		
		end
	end
end

---

function Config.ReadString(name, key, defValue)

	local f,err = io.open("lua\\config\\" .. name .. ".txt","w")
	if not f then
	  return nil,err
	end

	if f:read() then
		for line in f:lines() do
			local pos = string.find(line, key)
			
			if pos then
				Log.Write('Read '..'|'..string.sub(line, string.find(line, '=')))
				return string.sub(line, string.find(line, '='))
			end
		end
		f:close()
		return ""
	else
		f:close()
		return ""
	end
end

function Config.ReadInt(name, key, defValue)
--	Log.Write("ReadInt")
	return
end

function Config.ReadFloat(name, key, defValue)
	Log.Write("ReadFloat")
end

function Config.WriteInt(name, key, defValue)
	Log.Write("WriteInt")
end

function Config.WriteFloat(name, key, defValue)
	Log.Write("WriteFloat")
end


function Config.WriteString(name, key, defValue)
	local f,err = io.open("lua\\config\\" .. name .. ".txt","w")
	function WriteNewPar(file, k, v)
			file:seek("end")
			file:write(k .. "=" .. v)
			file:flush()
	end
	local exist = false
	if not f then
	  return nil,err
	end
	if f:read() then
		for line in f:lines() do
			local pos = string.find(line, key)
			if pos then
				exist = true
			end
		end
		if exist then
			line = key .. "=" .. defValue
			f:flush()
		else
			WriteNewPar(f, key, defValue)
		end
	else
		WriteNewPar(f, key, defValue)
	end
end


function Utils.OnUpdate()
	if Utils.time ~= 0 and Utils.time >= os.time() then
		local SetQueueList = QueueList
		QueueList = {}
		Utils.time = 0
		
		if #SetQueueList ~= 0 then
			for k, v in ipairs(SetQueueList) do
				if v.mode > 0 then
					if #v.items > 1 then
						Wrapper.MenuList[v.cur] = {Menu.AddOptionCombo(v.path, v.name, v.items, 0), 2}
					--	Log.Write('Num = ' .. v.cur ..' Name = ' .. v.name .. ' mode ' .. 2)
					else
						if v.fmax ~= 0 and v.fmax ~= v.fmin then
							Wrapper.MenuList[v.cur] = {Menu.AddOptionSlider(v.path, v.name, v.fmin, v.fmax, v.fdef), 1}
					--		Log.Write('Num = ' .. v.cur ..' Name = ' .. v.name .. ' mode ' .. 1)
						end
					end
				else
					Wrapper.MenuList[v.cur] = {Menu.AddOptionBool(v.path, v.name, false), 0}
					--Log.Write('Num = ' .. v.cur ..' Name = ' .. v.name .. ' mode ' .. 0)
				end
			end
			Menu.LoadSettings()
		end
	end
end


return Utils