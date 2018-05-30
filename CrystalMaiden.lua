--Author: spiregor
local CrystalMaiden = {}

CrystalMaiden.optionKey = Menu.AddKeyOption({"Hero Specific","Crystal Maiden"},"Combo Key",Enum.ButtonCode.KEY_D)
CrystalMaiden.optionEnable = Menu.AddOption({"Hero Specific","Crystal Maiden"},"Enabled","Enable Or Disable Crystal Maiden Combo Script")

CrystalMaiden.optionEnableBKB = Menu.AddOption({"Hero Specific","Crystal Maiden"},"Use Black King Bar","Enable Or Disable use Black King Bar in Combo")


function CrystalMaiden.OnUpdate()
    if not Menu.IsEnabled(CrystalMaiden.optionEnable) then return true end
	if Menu.IsKeyDown(CrystalMaiden.optionKey)then
    CrystalMaiden.Combo()
	end
end

function CrystalMaiden.Combo()
if not Menu.IsKeyDown(CrystalMaiden.optionKey) then return end
	local myHero = Heroes.GetLocal()
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_crystal_maiden" then return end
    local MousePos = Input.GetWorldCursorPos()
	local myMana = NPC.GetMana(myHero)
	local heroPos = Entity.GetAbsOrigin(myHero)
	--local hero = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
--Ability
   --local CrystalNove = NPC.GetAbility(myHero, "crystal_maiden_crystal_nova")
   --local FrostBite = NPC.GetAbility(myHero, "crystal_maiden_frostbite")
   local Freez = NPC.GetAbility(myHero, "crystal_maiden_freezing_field")
--Items
   local Dagger  = NPC.GetItem(myHero, "item_blink", true)
   local BKB  = NPC.GetItem(myHero, "item_black_king_bar", true)
   local Glimmer  = NPC.GetItem(myHero, "item_glimmer_cape", true)
   local Discord  = NPC.GetItem(myHero, "item_veil_of_discord", true)
   local Shiva  = NPC.GetItem(myHero, "item_shivas_guard", true)
   local ShadowBlade  = NPC.GetItem(myHero, "item_invis_sword", true)
   local SilverEdge  = NPC.GetItem(myHero, "item_silver_edge", true)   

   if Menu.IsEnabled(CrystalMaiden.optionEnable) and Ability.IsCastable(Freez, myMana) and NPC.IsPositionInRange(myHero, MousePos, 1200 + NPC.GetCastRangeBonus(myHero)) then
	 if Dagger and Ability.IsCastable(Dagger, 0) and not NPC.IsPositionInRange(myHero, MousePos,400,0) then Ability.CastPosition(Dagger, MousePos) return end
	 if BKB and Ability.IsCastable(BKB, 0) and Menu.IsEnabled(CrystalMaiden.optionEnableBKB) then Ability.CastNoTarget(BKB) return end
	 if Discord and Ability.IsCastable(Discord, myMana) then Ability.CastPosition(Discord, heroPos) return end
	 if Shiva and Ability.IsCastable(Shiva, myMana) then Ability.CastNoTarget(Shiva) return end
	 if Glimmer and Ability.IsCastable(Glimmer, myMana) then Ability.CastTarget(Glimmer, myHero) return end
	 if ShadowBlade and Ability.IsCastable(ShadowBlade, myMana) then Ability.CastNoTarget(ShadowBlade) return end
	 if SilverEdge and Ability.IsCastable(SilverEdge, myMana) then Ability.CastNoTarget(SilverEdge) return end
	 if Freez and Ability.IsCastable(Freez, myMana) then Ability.CastNoTarget(Freez) return end
	 end
end
return CrystalMaiden	