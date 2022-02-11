local addonName, addon = ...
local DirectionMultiplier = 2
local L = addon.L

MotherDirectionSaved = {}
local MDlocked, showMD, icon
local MD_ADDON_DIR = "Interface\\AddOns\\"..addonName.."\\icons\\"
local textOrientation
local textOrientationDecription
local textureIconLeft
local textureIconRight
local textureArrowLeft
local textureArrowMiddle
local textureArrowRight

local label = "|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: %s"
function addon.Print(msg,plain)
	local out = plain and msg or format(label,msg)
	local chatFrame = (SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME)
	chatFrame:AddMessage(out)
end

function addon.OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	addon.Print("Loaded /md to configure")
end

function addon.OnEvent(self, event, ...)
	local arg1 = ...
	if (event == "ADDON_LOADED") and arg1 == addonName then
		addon.Initialize()
	end
	if (event == "RAID_TARGET_UPDATE") then
		addon.Main()
	end
	if (event == "PLAYER_TARGET_CHANGED") then
		addon.Activation()
	end
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _,subEvent,_,srcGUID,srcName,_,_,dstGUID,dstName = CombatLogGetCurrentEventInfo()
		if (subEvent == "UNIT_DIED") then
			addon.Deactivation(dstName)
		end
		
		if not GetPlayerFacing() then
			MotherDirectionSaved.mode = "static"
			addon.ActivateStatic()
		else
			MotherDirectionSaved.mode = "dynamic"
			addon.ActivateDynamic()
		end
	
	end
end

function addon.Initialize()

	if (MotherDirectionSaved.toggle == nil) then
		MotherDirectionSaved.toggle = false
	end

	if (MotherDirectionSaved.status == nil) then
		MotherDirectionSaved.status = "|cffcc0000inactive|r"
	end
	
	if (MotherDirectionSaved.mode == nil) then
		MotherDirectionSaved.mode = "dynamic"
	end
	if not GetPlayerFacing() then
	MotherDirectionSaved.mode = "static"
	else
	MotherDirectionSaved.mode = "dynamic"
	end
	
	MDlocked = true
	MotherDirectionHoverFrame.isLocked = true
	MotherDirectionCompassFrame.isLocked = true
	
	MotherDirectionTextCompassNorth:SetText(L.LOCALE_textNorth)
	MotherDirectionTextCompassSouth:SetText(L.LOCALE_textSouth)
	MotherDirectionTextCompassWest:SetText(L.LOCALE_textWest)
	MotherDirectionTextCompassEast:SetText(L.LOCALE_textEast)
	
	addon.Main()
	
	addon.Print("Addon is ["..MotherDirectionSaved.status.."]")
	
	if (MotherDirectionSaved.mode == "static") then
		addon.ActivateStatic()
		addon.Print("Mode is [|cffb2b299"..MotherDirectionSaved.mode.."|r]")
	elseif (MotherDirectionSaved.mode == "dynamic") then
		addon.ActivateDynamic()
		addon.Print("Mode is [|cff9f7fff"..MotherDirectionSaved.mode.."|r]")
	elseif (MotherDirectionSaved.mode == "compass") then
		addon.Print("Mode is [|cffffcc00"..MotherDirectionSaved.mode.."|r]")
	end
	
	SlashCmdList["MDTOOGLE"]=addon.OnOff
	SLASH_MDTOOGLE1="/md"
	SLASH_MDTOOGLE2="/motherdirection"

end

function addon.OnOff(var1)
	if (var1 == "toggle") then
		if (MotherDirectionSaved.toggle) then
			MotherDirectionSaved.toggle = false
			MotherDirectionSaved.status = "|cffcc0000inactive|r"
			MotherDirectionHoverFrame:Hide()
			MotherDirectionCompassFrame:Hide()
			MDlocked = true
			MotherDirectionHoverFrame.isLocked = true
			MotherDirectionCompassFrame.isLocked = true
		else
			MotherDirectionSaved.toggle = true
			MotherDirectionSaved.status = "|cff00ff00active|r"
			addon.Main()
		end
		addon.Print("Addon is now ["..MotherDirectionSaved.status.."]")
	elseif (var1 == "static") then
		if not ( MotherDirectionSaved.mode == "static") then
			MotherDirectionSaved.mode = "static"
			addon.ActivateStatic()
			MotherDirectionCompassFrame:Hide()
			if (showMD) then
				MotherDirectionHoverFrame:Show()
			end
			addon.Print("Mode changed to [|cffb2b299"..MotherDirectionSaved.mode.."|r]")
		else
			addon.Print("Already in |cffb2b299static|r mode")
		end
	elseif (var1 == "dynamic") then
		if not (MotherDirectionSaved.mode == "dynamic") then
			MotherDirectionSaved.mode = "dynamic"
			addon.ActivateDynamic()
			MotherDirectionCompassFrame:Hide()
			if (showMD) then
				MotherDirectionHoverFrame:Show()
			end
			addon.Print("Mode changed to [|cff9f7fff"..MotherDirectionSaved.mode.."|r]")
		else
			addon.Print("Already in |cff9f7fffdynamic|r mode")
		end
	elseif (var1 == "compass") then
		if not (MotherDirectionSaved.mode == "compass") then
			MotherDirectionSaved.mode = "compass"
			MotherDirectionHoverFrame:Hide()
			if (showMD) then
				MotherDirectionCompassFrame:Show()
			end
			addon.Print("Mode changed to [|cffffcc00"..MotherDirectionSaved.mode.."|r]")
		else
			addon.Print("Already in |cffffcc00compass|r mode")
		end
	elseif (var1 == "unlock") then
		if (MotherDirectionSaved.toggle) then
			if (MDlocked) then
				MDlocked = false
				MotherDirectionHoverFrame.isLocked = false
				MotherDirectionCompassFrame.isLocked = false
				MotherDirectionHoverFrame:Show()
				MotherDirectionCompassFrame:Show()
				addon.Print("Windows unlocked")
			else
				addon.Print("Already locked")
			end
		else
			addon.Print("Can't unlock while addon is |cffcc0000inactive|r")
		end
	elseif (var1 == "resetwin") then
		MotherDirectionHoverFrame:ClearAllPoints()
		MotherDirectionCompassFrame:ClearAllPoints()
		MotherDirectionHoverFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
		MotherDirectionCompassFrame:SetPoint("CENTER", UIParent, "CENTER", 50, 200)
		addon.Print("Window's resetted")
	elseif  (var1 == "lock") then
		if (not MDlocked) then
			addon.Main()
		else
			addon.Print("Already locked")
		end			
	else 
		addon.Print("rebuild by lancestre (Sulfuron/EU)")
		addon.Print("Addon is ["..MotherDirectionSaved.status.."]")
		if (MotherDirectionSaved.mode == "static") then
			addon.Print("Mode is [|cffb2b299"..MotherDirectionSaved.mode.."|r]")
		elseif (MotherDirectionSaved.mode == "dynamic") then
			addon.Print("Mode is [|cff9f7fff"..MotherDirectionSaved.mode.."|r]")
		elseif (MotherDirectionSaved.mode == "compass") then	
			addon.Print("Mode is [|cffffcc00"..MotherDirectionSaved.mode.."|r]")
		end	
		addon.Print(" - \"/md\" or \"/motherdirection\" to show this message",true)
		addon.Print(" - \"/md toggle\" to turn the addon [|cff00ff00on|r] / [|cffcc0000off|r]",true)
		addon.Print(" - \"/md static\" switches the addon in |cffb2b299static|r mode",true)
		addon.Print(" - \"/md dynamic\" switches the addon in |cff9f7fffdynamic|r mode",true)
		addon.Print(" - \"/md compass\" switches the addon in |cffffcc00compass|r mode",true)
		addon.Print(" - \"/md \[lock\|unlock\]\" locks\/unlocks the MD window's",true)
		addon.Print(" - \"/md resetwin\" sets the MD windows's to default position",true)
	end
end

function addon.Activation()
	if (UnitName("target") == L.LOCALE_textUnit) then
		if (not UnitIsDeadOrGhost("target")) and (not MotherDirectionSaved.toggle) then
			addon.OnOff("toggle")
		end
	end
end

function addon.Deactivation(destName)
	if (destName == L.LOCALE_textUnit) and (MotherDirectionSaved.toggle) then
		addon.OnOff("toggle")
	end
end

function addon.ActivateStatic()
	MotherDirectionTextOrientationDecription:Show()
	MotherDirectionArrowLeft:Show()
	MotherDirectionArrowMiddle:Show()
	MotherDirectionArrowRight:Show()
	MotherDirection3DArrow:Hide()
end

function addon.ActivateDynamic()
	MotherDirectionTextOrientationDecription:Show()
	MotherDirectionArrowLeft:Hide()
	MotherDirectionArrowMiddle:Hide()
	MotherDirectionArrowRight:Hide()
	if GetPlayerFacing() then
	MotherDirection3DArrow:Show()
	else
	MotherDirection3DArrow:Hide()
	end
		
end

function addon.Main()
	if (MotherDirectionSaved.toggle) then
	
		--lock all Windows on Action
		if (not MDlocked) then
			MDlocked = true
			MotherDirectionHoverFrame.isLocked = true
			MotherDirectionCompassFrame.isLocked = true
			addon.Print("Windows locked")
		end
	
		icon=GetRaidTargetIndex("player")
		
		if (icon == 3) then--2 -> Purple Diamond
			DirectionMultiplier = 2 --Everytime North .. need to go Shahraz Room again to do this better
			textOrientation = L.LOCALE_textOrientationNorthSouth
			textOrientationDecription = L.LOCALE_textOrientationDescriptionNorthSouth
			textureIconLeft = "Diamond"
			textureIconRight = "Diamond"
			textureArrowLeft = "arrow_left.blp"
			textureArrowMiddle = "arrow_stop.blp"
			textureArrowRight = "arrow_right.blp"
			MotherDirectionTextCompassNorth:SetTextColor(1, 0, 0, 2)
			MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassSouth:SetTextColor(1, 0, 0, 1)
			MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2)
			showMD=true
		elseif (icon == 1) then --Yellow Star
			DirectionMultiplier = 1.5
			textOrientation = L.LOCALE_textOrientationEast
			textOrientationDecription = L.LOCALE_textOrientationDescriptionEast
			textureIconLeft = "Star"
			textureIconRight = "Star"
			textureArrowLeft = "arrow_down.blp"
			textureArrowMiddle = "arrow_down.blp"
			textureArrowRight = "arrow_down.blp"
			MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassEast:SetTextColor(1, 0, 0, 1)
			showMD=true
		elseif (icon == 2) then -- Orange Circle
			DirectionMultiplier = 0.5
			textOrientation = L.LOCALE_textOrientationWest
			textOrientationDecription = L.LOCALE_textOrientationDescriptionWest
			textureIconLeft = "Circle"
			textureIconRight = "Circle"
			textureArrowLeft = "arrow_up"
			textureArrowMiddle = "arrow_up"
			textureArrowRight = "arrow_up"
			MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassWest:SetTextColor(1, 0, 0, 1)
			MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2)
			MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2)
			showMD=true
		elseif (icon == nil) then
			showMD=false
		end
		
		if (showMD) then
			MotherDirectionTextOriention:SetText(textOrientation)
			MotherDirectionTextOrientationDecription:SetText(textOrientationDecription)
			MotherDirectionIconLeft:SetTexture(MD_ADDON_DIR..textureIconLeft)
			MotherDirectionIconRight:SetTexture(MD_ADDON_DIR..textureIconRight)
			MotherDirectionArrowMiddle:SetTexture(MD_ADDON_DIR..textureArrowMiddle)
			MotherDirectionArrowLeft:SetTexture(MD_ADDON_DIR..textureArrowLeft)
			MotherDirectionArrowRight:SetTexture(MD_ADDON_DIR..textureArrowRight)
			if (MotherDirectionSaved.mode == "static") or (MotherDirectionSaved.mode == "dynamic") then
				MotherDirectionHoverFrame:Show()
				MotherDirectionCompassFrame:Hide()
			elseif (MotherDirectionSaved.mode == "compass") then
				MotherDirectionHoverFrame:Hide()
				MotherDirectionCompassFrame:Show()
			end
		else
			MotherDirectionHoverFrame:Hide()
			MotherDirectionCompassFrame:Hide()
		end
	end
end

local DrawRadians
local ActualHeading = 0
local Sin, Cos
local direction , facing
local pi = math.pi
local pi2 = pi * 2

function addon.Arrow_OnUpdate(self, elapsed)
	local piOffset = math.pi * DirectionMultiplier

	if GetPlayerFacing() then
		direction = -1*GetPlayerFacing() - piOffset
		facing = GetPlayerFacing()
	else
		direction =  piOffset
		facing = 3
	end

	local val = (direction*54/math.pi + 108) % 108
	local col, row = math.floor(val % 9), math.floor(val / 9)
	
	MotherDirection3DArrow:SetTexCoord(col*56/512, (col+1)*56/512, row*42/512, (row+1)*42/512)
	
	if (DirectionMultiplier == 2 or DirectionMultiplier == 1) then
		if ( ((facing > pi * 1.5) and (facing < pi * 2)) or ((facing > 0) and (facing < pi * 0.5)) ) then
			DirectionMultiplier = 2
		else 
			DirectionMultiplier = 1
		end
	end
	
	--print ("row:",row)
	if (row == 0 or row == 11 ) then
		MotherDirection3DArrow:SetVertexColor(0.2,1,0.2,1)
	elseif (row == 1 or row == 2 or row == 9 or row == 10) then
		MotherDirection3DArrow:SetVertexColor(1,1,0,1)
	else
		MotherDirection3DArrow:SetVertexColor(1,0,0,1)
	end
	
end

--------------

function addon.CompassArrow_OnUpdate()
	
	if GetPlayerFacing() then
		local ActualHeading = pi2 - GetPlayerFacing()
		else
		local ActualHeading = pi2 - 1 
	end
	
	if GetPlayerFacing() then
	local ActualHeading = pi2 - GetPlayerFacing()
	else
	local ActualHeading = pi2 - 1
	end
	
	local piOffset = pi * 0.25
	
	local DrawRadians = ActualHeading + piOffset
	
	local Sin = math.sin(DrawRadians)
	local Cos = math.cos(DrawRadians)
		 
	MotherDirectionCompassArrow:SetTexCoord(0.5+Sin, 0.5-Cos,
		 0.5+Cos, 0.5+Sin,
		 0.5-Cos, 0.5-Sin,
		 0.5-Sin, 0.5+Cos)
end

_G[addonName] = addon