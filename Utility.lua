local Utility = {}
Utility.lastAttackTime2 = 0
Utility.LastTarget = nil
Utility.lastAttackTime2 = 0
function Utility.castPrediction(myHero, enemy, adjustmentVariable)

  if not myHero then return end
  if not enemy then return end

  local enemyRotation = Entity.GetRotation(enemy):GetVectors()
  enemyRotation:SetZ(0)
  local enemyOrigin = NPC.GetAbsOrigin(enemy)
  enemyOrigin:SetZ(0)

  if enemyRotation and enemyOrigin then
    if not NPC.IsRunning(enemy) then
      return enemyOrigin
    else return enemyOrigin:__add(enemyRotation:Normalized():Scaled(Utility.GetMoveSpeed(enemy) * adjustmentVariable))
    end
  end
end
function Utility.heroCanCastSpells(myHero, enemy)

  if not myHero then return false end
  if not Entity.IsAlive(myHero) then return false end

  if NPC.IsSilenced(myHero) then return false end
  if NPC.IsStunned(myHero) then return false end
  if NPC.HasModifier(myHero, "modifier_bashed") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
  if NPC.HasModifier(myHero, "modifier_eul_cyclone") then return false end
  if NPC.HasModifier(myHero, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_demon_disruption") then return false end
  if NPC.HasModifier(myHero, "modifier_invoker_tornado") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end
  if NPC.HasModifier(myHero, "modifier_legion_commander_duel") then return false end
  if NPC.HasModifier(myHero, "modifier_axe_berserkers_call") then return false end
  if NPC.HasModifier(myHero, "modifier_winter_wyvern_winters_curse") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_fiends_grip") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_nightmare") then return false end
  if NPC.HasModifier(myHero, "modifier_faceless_void_chronosphere_freeze") then return false end
  if NPC.HasModifier(myHero, "modifier_enigma_black_hole_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_magnataur_reverse_polarity") then return false end
  if NPC.HasModifier(myHero, "modifier_pudge_dismember") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_shaman_shackles") then return false end
  if NPC.HasModifier(myHero, "modifier_techies_stasis_trap_stunned") then return false end
  if NPC.HasModifier(myHero, "modifier_storm_spirit_electric_vortex_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_tidehunter_ravage") then return false end
  if NPC.HasModifier(myHero, "modifier_windrunner_shackle_shot") then return false end
  if NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then return false end

  if enemy then
    if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") then return false end
  end

  return true
end
function Utility.isHeroChannelling(myHero)

  if not myHero then return true end

  if NPC.IsChannellingAbility(myHero) then return true end
  if NPC.HasModifier(myHero, "modifier_teleporting") then return true end

  return false

end
function Utility.lastHitGetAttackerCount(myHero, target)

  if not myHero then return 0 end
  if not target then return 0 end

  local count = 0
  for i, v in pairs(Utility.lastHitCreepHPPrediction) do
    if i and Entity.IsNPC(i) and Entity.IsAlive(i) then
      if i == target then
        local temp = {}
        for k, l in ipairs(v) do
          if not Utility.utilityIsInTable(temp, l[3]) and GameRules.GetGameTime() > l[1] then
            table.insert(temp, l[3])
          end
        end
        count = #temp or 0
      end
    end
  end

  return count

end
function Utility.utilityIsInTable(table, arg)

  if not table then return false end
  if not arg then return false end
  if next(table) == nil then return false end

  for i, v in pairs(table) do
    if i == arg then
      return true
    end
    if type(v) ~= 'table' and v == arg then
      return true
    end
  end

  return false

end
function Utility.IsHeroInvisible(myHero)

  if not myHero then return false end
  if not Entity.IsAlive(myHero) then return false end

  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return true end
  if NPC.HasModifier(myHero, "modifier_invoker_ghost_walk_self") then return true end
  if NPC.HasAbility(myHero, "invoker_ghost_walk") then
    if Ability.SecondsSinceLastUse(NPC.GetAbility(myHero, "invoker_ghost_walk")) > - 1 and Ability.SecondsSinceLastUse(NPC.GetAbility(myHero, "invoker_ghost_walk")) < 1 then
      return true
    end
  end

  if NPC.HasItem(myHero, "item_invis_sword", true) then
    if Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_invis_sword", true)) > - 1 and Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_invis_sword", true)) < 1 then
      return true
    end
  end
  if NPC.HasItem(myHero, "item_silver_edge", true) then
    if Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_silver_edge", true)) > - 1 and Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_silver_edge", true)) < 1 then
      return true
    end
  end

  return false

end
function Utility.heroCanCastItems(myHero)

  if not myHero then return false end
  if not Entity.IsAlive(myHero) then return false end

  if NPC.IsStunned(myHero) then return false end
  if NPC.HasModifier(myHero, "modifier_bashed") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end
  if NPC.HasModifier(myHero, "modifier_eul_cyclone") then return false end
  if NPC.HasModifier(myHero, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_demon_disruption") then return false end
  if NPC.HasModifier(myHero, "modifier_invoker_tornado") then return false end
  if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end
  if NPC.HasModifier(myHero, "modifier_legion_commander_duel") then return false end
  if NPC.HasModifier(myHero, "modifier_axe_berserkers_call") then return false end
  if NPC.HasModifier(myHero, "modifier_winter_wyvern_winters_curse") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_fiends_grip") then return false end
  if NPC.HasModifier(myHero, "modifier_bane_nightmare") then return false end
  if NPC.HasModifier(myHero, "modifier_faceless_void_chronosphere_freeze") then return false end
  if NPC.HasModifier(myHero, "modifier_enigma_black_hole_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_magnataur_reverse_polarity") then return false end
  if NPC.HasModifier(myHero, "modifier_pudge_dismember") then return false end
  if NPC.HasModifier(myHero, "modifier_shadow_shaman_shackles") then return false end
  if NPC.HasModifier(myHero, "modifier_techies_stasis_trap_stunned") then return false end
  if NPC.HasModifier(myHero, "modifier_storm_spirit_electric_vortex_pull") then return false end
  if NPC.HasModifier(myHero, "modifier_tidehunter_ravage") then return false end
  if NPC.HasModifier(myHero, "modifier_windrunner_shackle_shot") then return false end
  if NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then return false end

  return true
end
function Utility.IsInAbilityPhase(myHero)

  if not myHero then return false end

  local myAbilities = {}

  for i = 0, 10 do
    local ability = NPC.GetAbilityByIndex(myHero, i)
    if ability and Entity.IsAbility(ability) and Ability.GetLevel(ability) > 0 then
      table.insert(myAbilities, ability)
    end
  end

  if #myAbilities < 1 then return false end

  for _, v in ipairs(myAbilities) do
    if v then
      if Ability.IsInAbilityPhase(v) then
        return true
      end
    end
  end

  return false

end
function Utility.GenericMainAttack(myHero, attackType, target, position)

  if not myHero then return end
  if not target and not position then return end

  if Utility.isHeroChannelling(myHero) == true then return end
  if Utility.heroCanCastItems(myHero) == false then return end
  if Utility.IsInAbilityPhase(myHero) == true then return end
  Utility.GenericAttackIssuer(attackType, target, position, myHero)

end
function Utility.GenericAttackIssuer(attackType, target, position, npc)

  if not npc then return end
  if not target and not position then return end
  if os.clock() - Utility.lastAttackTime2 < 0.5 then return end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET" then
    if target ~= nil then
      if target ~= Utility.LastTarget then
        Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, target, Vector(0, 0, 0), ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
        Utility.LastTarget = target
      end
    end
  end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE" then
    if position ~= nil then
      if not NPC.IsAttacking(npc) or not NPC.IsRunning(npc) then
        if position:__tostring() ~= Utility.LastTarget then
          Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE, target, position, ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
          Utility.LastTarget = position:__tostring()
        end
      end
    end
  end

  if attackType == "Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION" then
    if position ~= nil then
      if position:__tostring() ~= Utility.LastTarget then
        Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, target, position, ability, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, npc)
        Utility.LastTarget = position:__tostring()
      end
    end
  end

  if target ~= nil then
    if target == Utility.LastTarget then
      if not NPC.IsAttacking(npc) then
        Utility.LastTarget = nil
        Utility.lastAttackTime2 = os.clock()
        return
      end
    end
  end

  if position ~= nil then
    if position:__tostring() == Utility.LastTarget then
      if not NPC.IsRunning(npc) then
        Utility.LastTarget = nil
        Utility.lastAttackTime2 = os.clock()
        return
      end
    end
  end
end
function Utility.GetMoveSpeed(enemy)

  if not enemy then return end

  local base_speed = NPC.GetBaseSpeed(enemy)
  local bonus_speed = NPC.GetMoveSpeed(enemy) - NPC.GetBaseSpeed(enemy)
  local modifierHex
  local modSheep = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
  local modLionVoodoo = NPC.GetModifier(enemy, "modifier_lion_voodoo")
  local modShamanVoodoo = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")

  if modSheep then
    modifierHex = modSheep
  end
  if modLionVoodoo then
    modifierHex = modLionVoodoo
  end
  if modShamanVoodoo then
    modifierHex = modShamanVoodoo
  end

  if modifierHex then
    if math.max(Modifier.GetDieTime(modifierHex) - GameRules.GetGameTime(), 0) > 0 then
      return 140 + bonus_speed
    end
  end

  if NPC.HasModifier(enemy, "modifier_invoker_ice_wall_slow_debuff") then
    return 100
  end

  if NPC.HasModifier(enemy, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(enemy, "modifier_invoker_cold_snap") then
    return (base_speed + bonus_speed) * 0.5
  end

  if NPC.HasModifier(enemy, "modifier_spirit_breaker_charge_of_darkness") then
    local chargeAbility = NPC.GetAbility(enemy, "spirit_breaker_charge_of_darkness")
    if chargeAbility then
      local specialAbility = NPC.GetAbility(enemy, "special_bonus_unique_spirit_breaker_2")
      if specialAbility then
        if Ability.GetLevel(specialAbility) < 1 then
          return Ability.GetLevel(chargeAbility) * 50 + 550
        else
          return Ability.GetLevel(chargeAbility) * 50 + 1050
        end
      end
    end
  end

  return base_speed + bonus_speed
end
return Utility
