local Utility = require("scripts/Utility")
local ShadowFiend = {}
ShadowFiend.optionEnable = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend"}, "Enable", false)
ShadowFiend.optionKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Auto Raze Key", Enum.ButtonCode.KEY_Z)
ShadowFiend.optionEulKey = Menu.AddKeyOption({"Hero Specific", "Shadow Fiend"}, "Eul combo key", Enum.ButtonCode.KEY_F)
ShadowFiend.optionEnableBlink = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Blink", false)
ShadowFiend.optionEnablePhase = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Phase Boots", false)
ShadowFiend.optionEnableBkb = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "BKB", false)
ShadowFiend.optionEnableEblade = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Ethereal blade", false)
ShadowFiend.optionEnableHex = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Hex", false)
ShadowFiend.optionEnableOrchid = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Orchid", false)
ShadowFiend.optionEnableBlood = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Eul Combo"}, "Bloodthorn", false)
ShadowFiend.optionEnablePoopLinken = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Enable", false)
ShadowFiend.optionEnablePoopForce = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Force Staff", false)
ShadowFiend.optionEnablePoopHex = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Scythe of Vise", false)
ShadowFiend.optionEnablePoopPike = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Hurricane Pike", false)
ShadowFiend.optionEnablePoopDagon = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Dagon", false)
ShadowFiend.optionEnablePoopOrchid = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Orchid", false)
ShadowFiend.optionEnablePoopBlood = Menu.AddOptionBool({"Hero Specific", "Shadow Fiend", "Poop Linken"}, "Bloodthorn", false)
ShadowFiend.font = Renderer.LoadFont("Tahoma", 25, Enum.FontWeight.BOLD)
ShadowFiend.lastTick = 0
ShadowFiend.EbladeCasted = {}
ShadowFiend.cycloneDieTime = nil
ShadowFiend.Draw = false
LockTarget = false
enemy = nil
function ShadowFiend.OnUpdate()
  if not Menu.IsEnabled(ShadowFiend.optionEnable) or not Engine.IsInGame() or not Heroes.GetLocal() then return end
  local myHero = Heroes.GetLocal()
  if LockTarget == false then
    enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
  end
  if NPC.GetUnitName(myHero) ~= "npc_dota_hero_nevermore" then return end
  ShadowFiend.Combo(myHero, enemy)
end
function ShadowFiend.Combo(myHero, enemy)
  local razeShort = NPC.GetAbilityByIndex(myHero, 0)
  local razeMid = NPC.GetAbilityByIndex(myHero, 1)
  local razeLong = NPC.GetAbilityByIndex(myHero, 2)
  local requiem = NPC.GetAbility(myHero, "nevermore_requiem")
  local myMana = NPC.GetMana(myHero)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local eblade = NPC.GetItem(myHero, "item_ethereal_blade", true)
  local blink = NPC.GetItem(myHero, "item_blink", true)
  local eul = NPC.GetItem(myHero, "item_cyclone", true)
  local bkb = NPC.GetItem(myHero, "item_black_king_bar", true)
  local phase = NPC.GetItem(myHero, "item_phase_boots", true)
  if enemy then
    if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then LockTarget = false return end
    if requiem and Ability.IsCastable(requiem, myMana) then
      if Menu.IsKeyDown(ShadowFiend.optionEulKey) and Entity.GetHealth(enemy) > 0 then
        LockTarget = true
        if not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Utility.heroCanCastSpells(myHero, enemy) == true then
          if NPC.IsLinkensProtected(enemy) then
            ShadowFiend.PoopLinken(myHero, enemy, eul, requiem, myMana)
          end
          local possibleRange = 0.80 * NPC.GetMoveSpeed(myHero)
          if not NPC.IsEntityInRange(myHero, enemy, possibleRange) then
            if blink and not NPC.IsEntityInRange(myHero, enemy, possibleRange) and Ability.IsCastable(blink, 0) and Menu.IsEnabled(ShadowFiend.optionEnableBlink) and NPC.IsEntityInRange(myHero, enemy, 1175 + 0.75 * possibleRange) then
              Ability.CastPosition(blink, (Entity.GetAbsOrigin(enemy) + (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(enemy)):Normalized():Scaled(0.75 * possibleRange)))
              return
            else
              Utility.GenericMainAttack(myHero, "Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION", nil, Entity.GetAbsOrigin(enemy))
              return
            end
          end

          if blood and Menu.IsEnabled(ShadowFiend.optionEnableBlood) and Ability.IsCastable(blood, myMana) and Menu.IsEnabled(ShadowFiend.optionEnableBlood) then
            Ability.CastTarget(blood, enemy)
          end
          if orchid and Menu.IsEnabled(ShadowFiend.optionEnableOrchid) and Ability.IsCastable(orchid, myMana) and Menu.IsEnabled(ShadowFiend.optionEnableOrchid) then
            Ability.CastTarget(orchid, enemy)
          end
          if eblade and Menu.IsEnabled(ShadowFiend.optionEnableEblade) and Ability.IsCastable(eblade, myMana) and Menu.IsEnabled(ShadowFiend.optionEnableEblade) then
            Ability.CastTarget(eblade, enemy)
            ShadowFiend.EbladeCasted[enemy] = 1
          end
          if hex and Menu.IsEnabled(ShadowFiend.optionEnableHex) and Ability.IsCastable(hex, myMana) then
            Ability.CastTarget(hex, enemy)
          end
          if phase and Menu.IsEnabled(ShadowFiend.optionEnablePhase) and Ability.IsCastable(phase, myMana) then
            Ability.CastNoTarget(phase)
          end
          if bkb and Ability.IsCastable(bkb, myMana) and Menu.IsEnabled(ShadowFiend.optionEnableBkb) then
            Ability.CastNoTarget(bkb)
          end
          if Ability.IsCastable(eul, myMana) then
            if Menu.IsEnabled(ShadowFiend.optionEnableEblade) and ShadowFiend.EbladeCasted[enemy] and eblade then
              if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
                Ability.CastTarget(eul, enemy)
                ShadowFiend.cycloneDieTime = GameRules.GetGameTime() + 2.5
                ShadowFiend.EbladeCasted[enemy] = nil
              end
            else
              Ability.CastTarget(eul, enemy)
              ShadowFiend.enemy = enemy
              ShadowFiend.cycloneDieTime = GameRules.GetGameTime() + 2.5

            end
          end
          if NPC.HasModifier(enemy, "modifier_eul_cyclone") and ShadowFiend.cycloneDieTime then
            if not NPC.IsEntityInRange(myHero, enemy, 65) then
              Utility.GenericMainAttack(myHero, "Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION", nil, Entity.GetAbsOrigin(enemy))
              return
            else
              if ShadowFiend.cycloneDieTime - GameRules.GetGameTime() <= 1.67 then
                Ability.CastNoTarget(requiem)
                return
              end
            end
          end
        end
      else LockTarget = false
      end
    end

    if Menu.IsEnabled(ShadowFiend.optionEnable) and Entity.GetHealth(enemy) > 0 and Menu.IsKeyDown(ShadowFiend.optionKey) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
      if razeShort and Ability.IsCastable(razeShort, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(200)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = Utility.castPrediction(myHero, enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeShort) return
        end
      end
      if razeMid and Ability.IsCastable(razeMid, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(450)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = Utility.castPrediction(myHero, enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeMid) return
        end
      end
      if razeLong and Ability.IsCastable(razeLong, myMana) then
        local razePos = Entity.GetAbsOrigin(myHero) + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(700)
        local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
        local predictedPos = Utility.castPrediction(myHero, enemy, razePrediction)
        local disRazePOSpredictedPOS = (razePos - predictedPos):Length2D()
        if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
          Ability.CastNoTarget(razeLong) return
        end
      end
    end
  end
end
function ShadowFiend.PoopLinken(myHero, enemy, eul, requiem, myMana)
  if not Menu.IsEnabled(ShadowFiend.optionEnablePoopLinken) then return end
  local Force = NPC.GetItem(myHero, "item_force_staff", true)
  local pike = NPC.GetItem(myHero, "item_hurricane_pike", true)
  local orchid = NPC.GetItem(myHero, "item_orchid", true)
  local blood = NPC.GetItem(myHero, "item_bloodthorn", true)
  local hex = NPC.GetItem(myHero, "item_sheepstick", true)
  local dagon = NPC.GetItem(myHero, "item_dagon", true)
  if not dagon then
    for i = 2, 5 do
      dagon = NPC.GetItem(myHero, "item_dagon_" .. i, true)
      if dagon then break end
    end
  end

  if eul and requiem and Ability.IsCastable(requiem, myMana) then
    if Force and Menu.IsEnabled(ShadowFiend.optionEnablePoopForce) and Ability.IsCastable(Force, myMana) then
      Ability.CastTarget(Force, enemy)
      return
    end
    if pike and Menu.IsEnabled(ShadowFiend.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
      Ability.CastTarget(pike, enemy)
      return
    end
    if orchid and Menu.IsEnabled(ShadowFiend.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
      Ability.CastTarget(orchid, enemy)
      return
    end
    if blood and Menu.IsEnabled(ShadowFiend.optionEnablePoopBlood) and Ability.IsCastable(blood, myMana) then
      Ability.CastTarget(blood, enemy)
      return
    end
    if dagon and Menu.IsEnabled(ShadowFiend.optionEnablePoopDagon) and Ability.IsCastable(dagon, myMana) then
      Ability.CastTarget(dagon, enemy)
      return
    end
    if hex and Menu.IsEnabled(ShadowFiend.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
      Ability.CastTarget(hex, enemy)
      return
    end
  end
end
return ShadowFiend
