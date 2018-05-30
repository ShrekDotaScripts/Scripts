local Zeus = {}

Zeus.IsToggled = Menu.AddOptionBool({"Hero Specific","Zeus"}, "AutoUlt", false)
Zeus.Modifiers = {[0] = "modifier_medusa_stone_gaze_stone",[1] = "modifier_winter_wyvern_winters_curse",[2] = "modifier_templar_assassin_refraction_absorb",[3] = "modifier_nyx_assassin_spiked_carapace" }

function Zeus.OnUpdate()
	local hero = Heroes.GetLocal()
	if not hero or not Menu.IsEnabled(Zeus.IsToggled) or not Entity.IsAlive(hero) or NPC.GetUnitName(hero) ~= "npc_dota_hero_zuus" or NPC.HasState(hero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return end
	local ult = NPC.GetAbility(hero, "zuus_thundergods_wrath")
	if not ult or not Ability.IsReady(ult) or not Ability.IsCastable(ult, Ability.GetManaCost(ult))  then return end
	local target = Zeus.FindTarget(hero, ult)
	if not target then return end
	Ability.CastNoTarget(ult)
end

function Zeus.FindTarget(me, ult)	
	local entities = Heroes.GetAll()
	for index, enemyhero in pairs(entities) do
		if not Entity.IsSameTeam(me, enemyhero) and not NPC.IsIllusion(enemyhero) and NPC.IsVisible(enemyhero) and Entity.IsAlive(enemyhero) and Zeus.IsHasGuard(enemyhero) == "nil" then
			local amplf = 0
			if NPC.GetItem(me, "item_kaya", true) then
				amplf = 0.1
			end
			local totaldmg = Zeus.GetDamageDagon(me,enemyhero,Ability.GetLevelSpecialValueFor(ult, "damage"))
			if Entity.GetHealth(enemyhero) < totaldmg then return enemyhero end
		end
	end
end

function Zeus.GetDamageDagon(mynpc,target,dmg)
	if not mynpc or not target then return end
	local BuffDmg = 0
	BuffDmg = Hero.GetIntellectTotal(mynpc) * 0.0855
	if NPC.GetItem(mynpc, "item_kaya", true) then 
		BuffDmg = BuffDmg + 10 
	end
	local totaldomage = (dmg * NPC.GetMagicalArmorDamageMultiplier(target)) * (BuffDmg/100+1)
	local mana_shield = NPC.GetAbility(target, "medusa_mana_shield")
	if mana_shield and Ability.GetToggleState(mana_shield) then
			totaldomage = totaldomage * 0.4
	end
	if NPC.HasModifier(target,"modifier_ursa_enrage") then
		totaldomage = totaldomage * 0.2
	end
	local bristleback = NPC.GetAbility(target, "bristleback_bristleback")
	if bristleback and Ability.GetLevel(bristleback) ~= 0 then
		totaldomage = totaldomage * (1 - Ability.GetLevelSpecialValueFor(bristleback,"back_damage_reduction")/100)
	end
	return totaldomage
end

function Zeus.IsHasGuard(npc)
	local guarditis = "nil"
	if 	NPC.HasState(npc,Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or 
		NPC.HasState(npc,Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) or
		NPC.HasModifier(npc,"modifier_medusa_stone_gaze_stone") or
		NPC.HasModifier(npc,"modifier_winter_wyvern_winters_curse") or
		NPC.HasModifier(npc,"modifier_templar_assassin_refraction_absorb") or
		NPC.HasModifier(npc,"modifier_nyx_assassin_spiked_carapace") or
		NPC.HasModifier(npc,"modifier_abaddon_borrowed_time") or
		NPC.HasModifier(npc,"modifier_item_aeon_disk_buff") or
		NPC.HasModifier(npc,"modifier_special_bonus_spell_block") then
			guarditis = "Immune"
	end
	if NPC.HasModifier(npc,"modifier_legion_commander_duel") then
		local duel = NPC.GetAbility(npc, "legion_commander_duel")
		if duel then
			if NPC.HasModifier(npc, "modifier_item_ultimate_scepter") or NPC.HasModifier(npc, "modifier_item_ultimate_scepter_consumed") then
				guarditis = "Immune"
			end
		else
			for _,hero in pairs(Heroes.GetAll()) do
				if hero ~= nil and hero ~= 0 and NPCs.Contains(hero) and not Entity.IsSameTeam(hero,npc) and NPC.HasModifier(hero,"modifier_legion_commander_duel") then
					local dueltarget = NPC.GetAbility(hero, "legion_commander_duel")
					if dueltarget then
						if NPC.HasModifier(hero, "modifier_item_ultimate_scepter") or NPC.HasModifier(hero, "modifier_item_ultimate_scepter_consumed") then
							guarditis = "Immune"
						end
					end
				end
			end
		end
	end
	local aeon_disk = NPC.GetItem(npc, "item_aeon_disk")
	if aeon_disk and Ability.IsReady(aeon_disk) then guarditis = "Immune" end
	return guarditis
end

return Zeus
