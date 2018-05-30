local a1 = {}

local ParticleList = {};
local NeedDestroy = {}
local AbilityConnect = require "scripts/settings/Abils";
local AbilityList = AbilityConnect:Get();
local Weigth, Height = Renderer.GetScreenSize();
local cachedIcons = {}
local LocalHero = Heroes.GetLocal();
local Font = Renderer.LoadFont("Tahoma", 12, Enum.FontWeight.BOLD);


function a1.InsertParticle( particle )
	for k,v in pairs(particle) do
	--	Log.Write(tostring(k)..'|'..tostring(v))
	end
	for k,v in pairs(AbilityList) do
		if particle.name == v.name then
			local NewParticle = {
				index = particle.index,
                name = v.name,
                msg = v.msg,
				shortname = v.shortName,
				entity = particle.entity or nil,
				ability = v.ability or nil,
				pos = nil,
                endTime = os.clock() + v.duration,
			}
			table.insert(ParticleList, NewParticle)

		    return true
		end
	end
	
	return false
end

function a1.UpdateParticle( particle )
	if #ParticleList > 0 then
		for k,v in pairs(ParticleList) do
			if v.index == particle.index then
				if v.name == "teleport_end" and particle.entity ~= nil then
					ParticleList[k-1].entity = particle.entity
					ParticleList[k].entity = particle.entity
				end
				if v.pos == nil then
					v.pos = particle.position
				end
				if v.entity == nil and particle.entity ~= nil then
					v.entity = particle.entity
				end
			end
		end
	end
end

function a1.DestroyQueueParticle( particle )
	table.insert(NeedDestroy, particle.index)
end

function a1.OnParticleCreate( particle )
	a1.InsertParticle( particle )

end

function a1.OnParticleUpdate( particle )
if particle.controlPoint ~= 0 then return end
	a1.UpdateParticle( particle )

end

function a1.OnParticleDestroy( particle )
if particle == nil then return end
	a1.DestroyQueueParticle( particle )

end

function a1.OnParticleUpdateEntity( particle )
if particle.controlPoint ~= 0 and particle.entity == nil then return end
	a1.UpdateParticle( particle )
end

function a1.OnUpdate() 
	if #NeedDestroy > 0 then
		for _,l in pairs(NeedDestroy) do
			for k,v in pairs(ParticleList) do
				if v.index == l then
					ParticleList[k].endTime = os.clock()
				end
			end
			table.remove(NeedDestroy, _)
		end
	end
end

function a1.OnDraw()			
	if #ParticleList > 0 then
		for k,v in pairs(ParticleList) do
			local timeLeft = v.endTime - os.clock()
		
			if timeLeft < 0 then
				table.remove(ParticleList, k)
			else
				if v.entity ~= nil and v.entity ~= 0 and v.pos ~= nil then
					if NPC.IsVisible(v.entity) ~= true or v.name == "teleport_end" or v.name == "teleport_start" then
						if Entity.IsSameTeam(LocalHero,v.entity) then return end;
						local shortname = tostring(NPC.GetUnitName(v.entity))
						local IsHero = string.find(shortname, "npc_dota_hero_")
						if IsHero ~= nil then
							shortname = string.sub(shortname,string.len("npc_dota_hero_") + 1)
							local imageHandle = cachedIcons[shortname]
							if imageHandle == nil then
								imageHandle = Renderer.LoadImage("~/CustomUI/miniheroes/" .. shortname .. ".png");
								cachedIcons[shortname] = imageHandle
							end
							local x, y, onScreen = Renderer.WorldToScreen(v.pos)
							if onScreen then
								Renderer.SetDrawColor(230, 230, 250, 200)
								Renderer.DrawImage (cachedIcons[shortname], x, y, 24, 24)
							end	
							
							if v.name == "teleport_end" then
								MiniMap.DrawHeroIcon(NPC.GetUnitName(v.entity), v.pos, 50, 205, 50, 255, 800)
							end
							
							if v.name == "teleport_start" then
								MiniMap.DrawHeroIcon(NPC.GetUnitName(v.entity), v.pos, 72, 61, 139, 250, 800)
							end
							
							if v.name ~= "teleport_end" and v.name ~= "teleport_start" then
								MiniMap.DrawHeroIcon(NPC.GetUnitName(v.entity), v.pos, 250, 140, 125, 255, 600)
							end
						end
					end
				else
					if v.pos ~= nil then
						local x, y, onScreen = Renderer.WorldToScreen(v.pos)
						if onScreen then
							Renderer.SetDrawColor(255, 90, 100, 255)
							MiniMap.DrawCircle(v.pos,255, 215, 185, 150)
							if tostring(v.ability) ~= '' then
								Renderer.DrawText (Font, x, y, tostring(v.ability) , 0)
							else
								Renderer.DrawText (Font, x, y, tostring(v.shortname) , 0)
							end
						end	
					end
				end
			end
		end
	end

end

return a1