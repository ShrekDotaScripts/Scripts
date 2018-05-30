local Utility = require("scripts/Utility")
local clinkz = {}
clinkz.optionEnable = Menu.AddOptionBool({"Hero Specific", "Clinkz"}, "Enable", false)
clinkz.optionKey = Menu.AddKeyOption({"Hero Specific", "Clinkz"}, "Combo Key", Enum.ButtonCode.KEY_Z)
clinkz.optionEnableLockTarget = Menu.AddOptionBool({"Hero Specific", "Clinkz"}, "Target Locker", false)
clinkz.optionEnableBlood = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Bloodthorn", false)
clinkz.optionEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Orchid", false)
clinkz.optionEnableNullifier = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Nullifier", false)
clinkz.optionEnableDiffusal = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Diffusal Blade", false)
clinkz.optionEnableHex = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Hex", false)
clinkz.optionEnableBkb = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Bkb", false)
clinkz.optionEnableSolar = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Solar Crest", false)
clinkz.optionEnableCourage = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Combo"}, "Medallion of Courage", false)
clinkz.optionEnablePoopLinkens = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Enable", false)
clinkz.optionEnablePoopForce = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Force Staff", false)
clinkz.optionEnablePoopDiffusal = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Diffusal Blade", false)
clinkz.optionEnablePoopBlood = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Bloodthorn", false)
clinkz.optionEnablePoopOrchid = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Orchid", false)
clinkz.optionEnablePoopEul = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Eul", false)
clinkz.optionEnablePoopHex = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Hex", false)
clinkz.optionEnablePoopPike = Menu.AddOptionBool({"Hero Specific", "Clinkz", "Poop Linken"}, "Hurricane Pike", false)
LockTarget = false
enemy = nil
function clinkz.OnUpdate()
  if not Menu.IsEnabled(clinkz.optionEnable) or not Engine.IsInGame() or not Heroes.GetLocal() then return end
  local myHero = Heroes.GetLocal()
  if NPC.GetUnitName(myHero) ~= "npc_dota_hero_clinkz" then return end
  if LockTarget == false then
    enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
  end
  clinkz.Combo(myHero, enemy)
end
function clinkz.Combo(myHero, enemy)
  local myMana = NPC.GetMana(myHero)
  local strafe = NPC.GetAbilityByIndex(myHero, 0)
  local arrows = NPC.GetAbilityByIndex(myHero, 1)
  local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local solar = NPC.GetItem(myHero, "item_solar_crest", true)
  local courage = NPC.GetItem(myHero, "item_medallion_of_courage", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local nullifier = NPC.GetItem(myHero, "item_nullifier", true)
  local diffusal = NPC.GetItem(myHero, "item_diffusal_blade", true)
  if enemy then
    if Menu.IsEnabled(clinkz.optionEnableLockTarget) then LockTarget = true end
    if Menu.IsKeyDown(clinkz.optionKey) and Entity.GetHealth(enemy) > 0 and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasModifier(enemy, "modifier_dark_willow_shadow_realm_buff") then
      local attackRange = NPC.GetAttackRange(myHero)
      if NPC.IsEntityInRange(myHero, enemy, attackRange) then
        if Utility.heroCanCastSpells(myHero, enemy) == true then
          if strafe and Ability.IsCastable(strafe, myMana) then
            Ability.CastNoTarget(strafe)
          end
          if Ability.GetAutoCastState(arrows) == false and AutoCasted == false then
            Ability.ToggleMod(arrows)
            AutoCasted = true
          end
        end
        if Utility.heroCanCastItems(myHero, enemy) == true then
          if NPC.IsLinkensProtected(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            clinkz.PoopLinken(myHero, enemy)
          end
          if diffusal and not NPC.HasModifier(enemy, "modifier_item_diffusal_blade_slow") and Menu.IsEnabled(clinkz.optionEnableDiffusal) and Ability.IsCastable(diffusal,myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(diffusal, enemy)
          end 
          if blood and not NPC.HasModifier(enemy, "modifier_bloodthorn_debuff") and Menu.IsEnabled(clinkz.optionEnableBlood) and Ability.IsCastable(blood, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(blood, enemy)
          end
          if orchid and not NPC.HasModifier(enemy, "modifier_orchid_malevolence_debuff") and Menu.IsEnabled(clinkz.optionEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(orchid, enemy)
          end
          if bkb and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Menu.IsEnabled(clinkz.optionEnableBkb) and Ability.IsCastable(bkb, myMana) then
            Ability.CastNoTarget(bkb)
          end
          if hex and not NPC.HasModifier(enemy, "modifier_sheepstick_debuff") and Menu.IsEnabled(clinkz.optionEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            Ability.CastTarget(hex, enemy)
          end
          if nullifier and not NPC.HasModifier(enemy, "modifier_item_nullifier_mute") and Menu.IsEnabled(clinkz.optionEnableNullifier) and Ability.IsCastable(nullifier, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
            if NPC.GetItem(enemy, "item_aeon_disk", true) then
              if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") and not Ability.IsReady(NPC.GetItem(enemy, "item_aeon_disk", true)) then
                 Ability.CastTarget(nullifier,enemy)
              end
            else
              Ability.CastTarget(nullifier,enemy) 
            end 
          end
          if courage and not NPC.HasModifier(enemy, "modifier_item_medallion_of_courage_armor_reduction") and Menu.IsEnabled(clinkz.optionEnableCourage) and Ability.IsCastable(courage, myMana) then
            Ability.CastTarget(courage, enemy)
          end
          if solar and not NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_reduction") and Menu.IsEnabled(clinkz.optionEnableSolar) and Ability.IsCastable(solar, myMana) then
            Ability.CastTarget(solar, enemy)
          end
        end
        Player.AttackTarget(Players.GetLocal(), Heroes.GetLocal(), enemy)
      end
    else
      LockTarget = false
      AutoCasted = false
    end
  end
end
function clinkz.PoopLinken(myHero, enemy)
  local diffusal = NPC.GetItem(myHero, "item_diffusal_blade", true)
  local eul = NPC.GetItem(myHero, "item_cyclone", true)
  local force = NPC.GetItem(myHero, "item_force_staff", true)
  local pike = NPC.GetItem(myHero, "item_hurricane_pike", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local myMana = NPC.GetMana(myHero)
  if diffusal and Menu.IsEnabled(clinkz.optionEnablePoopDiffusal) and Ability.IsCastable(diffusal, myMana) then
    Ability.CastTarget(diffusal,enemy)
    return
  end 
  if eul and Menu.IsEnabled(clinkz.optionEnablePoopEul) and Ability.IsCastable(eul, myMana) then
    Ability.CastTarget(eul, enemy)
    return
  end
  if force and NPC.IsEntityInRange(myHero, enemy, 750) and Menu.IsEnabled(clinkz.optionEnablePoopForce) and Ability.IsCastable(force, myMana) then
    Ability.CastTarget(force, enemy)
    return
  end
  if pike and NPC.IsEntityInRange(myHero, enemy, 400) and Menu.IsEnabled(clinkz.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
    Ability.CastTarget(pike, enemy)
    return
  end
  if orchid and Menu.IsEnabled(clinkz.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
    Ability.CastTarget(orchid, enemy)
    return
  end
  if blood and Menu.IsEnabled(clinkz.optionEnablePoopBlood) and Ability.IsCastable(blood, myMana) then
    Ability.CastTarget(blood, enemy)
    return
  end
  if hex and Menu.IsEnabled(clinkz.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
    Ability.CastTarget(hex, enemy)
    return
  end
end
return clinkz