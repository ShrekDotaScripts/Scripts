local AutoDisable = {}

-- ToDo  list --
--
-- Spectre
-- Pangolier - pangolier_swashbuckler
-- Wisp
-- Puck - puck_illusory_orb_blink_out 
-- Storm Spirit
-- Nyx Assasin - nyx_assassin_vendetta_msg
-- Huskar - huskar_life_break_cast
-- Faceless Void - faceless_void_time_walk_slow
-- Pudge - pudge_meathook_impact
-- Baratrum - spirit_breaker_charge_start
-- Check Talents Lion
-- Furion Teleport end
--
-- /Todo list --

AutoDisable.MenuPath = {"Utility", "Auto Disabler"}
AutoDisable.MEnabled = Menu.AddOptionBool(AutoDisable.MenuPath, "Enabled", false)

AutoDisable.LocalHero = nil
AutoDisable.Items = {}
AutoDisable.Abilities = {}
AutoDisable.Both = {}

local PreDangerParticleList = {}
local DangerParticleList = {}
local ToUpdateParticleList = {}

AutoDisable.InitiationParticle = {
	"blink_dagger_end", 
	"phantom_assassin_phantom_strike_end",
	"antimage_blink_end",	
	"queen_blink_end"
}

AutoDisable.DisableItems = {
	"item_orchid",
	"item_bloodthorn",
	"item_sheepstick",
	"item_cyclone",
	"item_abyssal_blade"
}

AutoDisable.DisableSkills = {
	{"npc_dota_hero_lion", "lion_voodoo"},
	{"npc_dota_hero_pudge", "pudge_dismember"},
	{"npc_dota_hero_puck", "puck_waning_rift"},
	{"npc_dota_hero_shadow_shaman", "shadow_shaman_voodoo"},
	{"npc_dota_hero_dragon_knight", "dragon_knight_dragon_tail"},
	{"npc_dota_hero_rubick", "rubick_telekinesis"},
	{"npc_dota_hero_skywrath_mage", "skywrath_mage_ancient_seal"}
}

AutoDisable.DangerSkills = {
	{"npc_dota_hero_axe", "axe_berserkers_call"},
	{"npc_dota_hero_tidehunter", "tidehunter_ravage"},
	{"npc_dota_hero_enigma", "enigma_black_hole"},
	{"npc_dota_hero_magnataur", "magnataur_reverse_polarity"},
	{"npc_dota_hero_legion_commander", "legion_commander_duel"},
	{"npc_dota_hero_beastmaster", "beastmaster_primal_roar"},
	{"npc_dota_hero_treant", "treant_overgrowth"},
	{"npc_dota_hero_faceless_void", "faceless_void_chronosphere"},
	{"npc_dota_hero_batrider", "batrider_flaming_lasso"},
	{"npc_dota_hero_dark_seer", "dark_seer_wall_of_replica"},
	{"npc_dota_hero_slardar", "slardar_slithereen_crush"},
	{"npc_dota_hero_queenofpain", "queenofpain_sonic_wave"},
	{"npc_dota_hero_centaur", "centaur_hoof_stomp"},
	{"npc_dota_hero_sven", "sven_storm_bolt"},
	{"npc_dota_hero_bane", "bane_fiends_grip"},
	{"npc_dota_hero_pudge", "pudge_dismember"},
	{"npc_dota_hero_crystal_maiden", "crystal_maiden_freezing_field"}
}

function AutoDisable.InsertParticle(p1)
	for k,v in pairs(AutoDisable.InitiationParticle) do
		if p1.name == v then
			local NewParticle = {
				index  = p1.index,
				name = v,
				entity = p1.entity or nil,
				pos = nil,
			}
			if string.find(NewParticle.name, "_end") ~= nil then
				table.insert(PreDangerParticleList, NewParticle)
			else
				table.insert(DangerParticleList, NewParticle)
			end
			
		    return true
		end
	end
	
	return false
end

function AutoDisable.UpdateParticle()
	if #PreDangerParticleList > 0 then
		for _,j in pairs(ToUpdateParticleList) do
			for k,v in pairs(PreDangerParticleList) do
				if v.index - 1 == j.index then
					if v.pos == nil then
						v.pos = j.position
					end
				end

				if v.index == j.index then					
					if v.entity == nil and j.entity ~= nil then
						v.entity = j.entity
					end
				end
				if (v.entity) ~= nil then
					table.insert(DangerParticleList, v)
					table.remove(PreDangerParticleList, k)
					table.remove(ToUpdateParticleList, _)
				end
			end
		end
	end
end

function AutoDisable.OnParticleCreate(p1)
	if p1 == (nil or 0) then return end
	AutoDisable.InsertParticle(p1)
end

function AutoDisable.OnParticleUpdate(p1)
	if p1.controlPoint ~= 0 then return end
	table.insert(ToUpdateParticleList, p1)
end

function AutoDisable.GetAbilities()
	local p1 = {}
	local p2 = NPC.GetUnitName(AutoDisable.LocalHero)
	for _, v in pairs(AutoDisable.DisableSkills) do
		if v[1] == p2 then
			local abil = NPC.GetAbility(AutoDisable.LocalHero, v[2])
			
			if abil ~= (0 and nil) and Ability.IsReady(abil) then
				table.insert(p1, {abil, Ability.GetCastPoint(abil)})
			end
		end
	end
	AutoDisable.Abilities = {}
	AutoDisable.Abilities = p1
end

function AutoDisable.GetItems()
	local p1 = {}
	for _, v in pairs(AutoDisable.DisableItems) do
		local item = NPC.GetItem(AutoDisable.LocalHero, v, true)
		
		if item ~= (0 and nil) and Ability.IsReady(item) then
			table.insert(p1, {item, Ability.GetCastPoint(item)})
		end
	end
	AutoDisable.Items = {}
	AutoDisable.Items = p1
end

function AutoDisable.GetFAbil()
	local p1 ={}
	for k,v in pairs(AutoDisable.Items) do
		table.insert(p1,v)
	end
	
	for k,v in pairs(AutoDisable.Abilities) do
		table.insert(p1,v)
	end
	
	AutoDisable.Both = {}
	AutoDisable.Both = p1
end

function AutoDisable.CheckCustom(p1)
	if p1 == 33554440 or p1 == 134217864 then
		return true
	else
		return false
	end
end

function AutoDisable.OnUpdate()
	AutoDisable.LocalHero = Heroes.GetLocal()
	if AutoDisable.LocalHero == nil or Menu.IsEnabled(AutoDisable.MEnabled) ~= true then return end
	
	AutoDisable.GetItems()
	AutoDisable.GetAbilities()
	AutoDisable.GetFAbil()
	
	AutoDisable.UpdateParticle()
	
	-- Партиклы --
	if #DangerParticleList > 0 then
		for _,v in pairs(DangerParticleList) do
			if v.entity ~= nil and v.entity ~= 0 then
				if #AutoDisable.Both > 0 then
					for h,j in pairs(AutoDisable.Both) do	
						local l1 = Ability.GetCastRange(j[1])
						local l2 = Ability.GetRange(j[1])
						
						if l1 == 0 then l0 = l2 else l0 = l1 end
						if NPC.IsVisible(v.entity) and NPC.IsEntityInRange(AutoDisable.LocalHero, v.entity, l0) and not Entity.IsSameTeam(AutoDisable.LocalHero, v.entity) then
							
							local k1 = Ability.GetBehavior(j[1])

							if k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET then
								Ability.CastNoTarget(j[1], false)
							elseif k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT then
								Ability.CastPosition(j[1], Entity.GetAbsOrigin(v.entity), false)
							elseif k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or AutoDisable.CheckCustom(k1) then
								Ability.CastTarget(j[1], v.entity, false) 
							end
							
							table.remove(DangerParticleList, _)
							return 0
						end	
					end	
				end
				table.remove(DangerParticleList, _)
				return 0
			end
		end
	end
	-- /Партиклы --
	-- Абилки --
	local FHeroes = Heroes.GetAll()
	for _,v in pairs(FHeroes) do
		if v and Entity.IsHero(v) and Entity.IsAlive(v) and not Entity.IsSameTeam(AutoDisable.LocalHero, v) and not Entity.IsDormant(v) and not NPC.IsIllusion(v) then
			for i,k in pairs(AutoDisable.DangerSkills) do
				if NPC.GetUnitName(v) == k[1] then
					local p1 = NPC.GetAbility(v, k[2])
					if p1 ~= (nil or 0) and Ability.IsInAbilityPhase(p1) then
						local p2 = Ability.GetCastPoint(p1)
						if #AutoDisable.Both > 0 then
							for h,j in pairs(AutoDisable.Both) do
								local l1 = Ability.GetCastRange(j[1])
								local l2 = Ability.GetRange(j[1])
								if l1 == 0 then l0 = l2 else l0 = l1 end
								if NPC.IsEntityInRange(AutoDisable.LocalHero, v, l0) and p2 > j[2] then
									local k1 = Ability.GetBehavior(j[1])
									
									if k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET then
										Ability.CastNoTarget(j[1], false)
										return 
									elseif k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT then
										Ability.CastPosition(j[1], Entity.GetAbsOrigin(v), false)
										return 
									elseif k1 == Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or AutoDisable.CheckCustom(k1) then
										Ability.CastTarget(j[1], v, false)
										return 
									end									
									
									
								end
							end
						end
					end
				end
			end		
		end
	end
	-- /Абилки --
end

return AutoDisable