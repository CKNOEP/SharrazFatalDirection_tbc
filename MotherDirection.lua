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
local playerFacingAvailable = GetPlayerFacing ~= nil

local label = "|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: %s"

function addon.Print(msg, plain)
	local out = plain and msg or string.format(label, msg)
	local chatFrame = (SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME)
	if chatFrame then
		chatFrame:AddMessage(out)
	end
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
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if CombatLogGetCurrentEventInfo then
			local _, subEvent, _, srcGUID, srcName, _, _, dstGUID, dstName = CombatLogGetCurrentEventInfo()
			if subEvent == "UNIT_DIED" then
				addon.Deactivation(dstName)
			end
		end

		-- Update mode based on player facing availability
		if playerFacingAvailable and GetPlayerFacing() ~= nil then
			MotherDirectionSaved.mode = "dynamic"
			addon.ActivateDynamic()
		else
			MotherDirectionSaved.mode = "static"
			addon.ActivateStatic()
		end
	end
end

function addon.Initialize()
	if MotherDirectionSaved.toggle == nil then
		MotherDirectionSaved.toggle = false
	end

	if MotherDirectionSaved.status == nil then
		MotherDirectionSaved.status = "|cffcc0000inactive|r"
	end

	if MotherDirectionSaved.mode == nil then
		MotherDirectionSaved.mode = "dynamic"
	end

	-- Set mode based on player facing availability
	if playerFacingAvailable and GetPlayerFacing() ~= nil then
		MotherDirectionSaved.mode = "dynamic"
	else
		MotherDirectionSaved.mode = "static"
	end
	
	MDlocked = true
	if MotherDirectionHoverFrame then MotherDirectionHoverFrame.isLocked = true end
	if MotherDirectionCompassFrame then MotherDirectionCompassFrame.isLocked = true end

	-- Set compass cardinal directions
	if MotherDirectionTextCompassNorth then MotherDirectionTextCompassNorth:SetText(L.LOCALE_textNorth) end
	if MotherDirectionTextCompassSouth then MotherDirectionTextCompassSouth:SetText(L.LOCALE_textSouth) end
	if MotherDirectionTextCompassWest then MotherDirectionTextCompassWest:SetText(L.LOCALE_textWest) end
	if MotherDirectionTextCompassEast then MotherDirectionTextCompassEast:SetText(L.LOCALE_textEast) end
	
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

	-- Register slash commands for TBC 2.5.6
	local function HandleMDCommand(msg, editBox)
		addon.OnOff(msg)
	end

	SlashCmdList["MDTOGGLE"] = HandleMDCommand
	SLASH_MDTOGGLE1 = "/md"
	SLASH_MDTOGGLE2 = "/motherdirection"

end

function addon.OnOff(var1)
	-- Normaliser les entrées (TBC 2.5.6 peut modifier les arguments)
	var1 = tostring(var1):lower():trim()

	if (var1 == "toggle" or var1 == "toogle") then
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
	elseif var1 == "static" then
		if not (MotherDirectionSaved.mode == "static") then
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
	elseif var1 == "dynamic" then
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
	elseif var1 == "compass" then
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
	elseif var1 == "unlock" then
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
	elseif var1 == "resetwin" then
		MotherDirectionHoverFrame:ClearAllPoints()
		MotherDirectionCompassFrame:ClearAllPoints()
		MotherDirectionHoverFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
		MotherDirectionCompassFrame:SetPoint("CENTER", UIParent, "CENTER", 50, 200)
		addon.Print("Window's resetted")
	elseif var1 == "lock" then
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
	if MotherDirectionTextOrientationDecription then
		MotherDirectionTextOrientationDecription:Show()
	end
	if MotherDirectionArrowLeft then MotherDirectionArrowLeft:Hide() end
	if MotherDirectionArrowMiddle then MotherDirectionArrowMiddle:Hide() end
	if MotherDirectionArrowRight then MotherDirectionArrowRight:Hide() end

	if playerFacingAvailable and MotherDirection3DArrow then
		if GetPlayerFacing() ~= nil then
			MotherDirection3DArrow:Show()
		else
			MotherDirection3DArrow:Hide()
		end
	end
end

function addon.Main()
	if not MotherDirectionSaved.toggle then return end

	-- Lock all windows during action
	if not MDlocked then
		MDlocked = true
		if MotherDirectionHoverFrame then MotherDirectionHoverFrame.isLocked = true end
		if MotherDirectionCompassFrame then MotherDirectionCompassFrame.isLocked = true end
		addon.Print("Windows locked")
	end

	icon = GetRaidTargetIndex("player")
		
		if icon == 3 then  -- Purple Diamond
			DirectionMultiplier = 2
			textOrientation = L.LOCALE_textOrientationNorthSouth
			textOrientationDecription = L.LOCALE_textOrientationDescriptionNorthSouth
			textureIconLeft = "Diamond.tga"
			textureIconRight = "Diamond.tga"
			textureArrowLeft = "arrow_left.blp"
			textureArrowMiddle = "arrow_stop.blp"
			textureArrowRight = "arrow_right.blp"
			if MotherDirectionTextCompassNorth then MotherDirectionTextCompassNorth:SetTextColor(1, 0, 0, 1) end
			if MotherDirectionTextCompassWest then MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassSouth then MotherDirectionTextCompassSouth:SetTextColor(1, 0, 0, 1) end
			if MotherDirectionTextCompassEast then MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			showMD = true
		elseif icon == 1 then  -- Yellow Star
			DirectionMultiplier = 1.5
			textOrientation = L.LOCALE_textOrientationEast
			textOrientationDecription = L.LOCALE_textOrientationDescriptionEast
			textureIconLeft = "Star.tga"
			textureIconRight = "Star.tga"
			textureArrowLeft = "arrow_down.blp"
			textureArrowMiddle = "arrow_down.blp"
			textureArrowRight = "arrow_down.blp"
			if MotherDirectionTextCompassNorth then MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassWest then MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassSouth then MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassEast then MotherDirectionTextCompassEast:SetTextColor(1, 0, 0, 1) end
			showMD = true
		elseif icon == 2 then  -- Orange Circle
			DirectionMultiplier = 0.5
			textOrientation = L.LOCALE_textOrientationWest
			textOrientationDecription = L.LOCALE_textOrientationDescriptionWest
			textureIconLeft = "Circle.tga"
			textureIconRight = "Circle.tga"
			textureArrowLeft = "arrow_up.blp"
			textureArrowMiddle = "arrow_up.blp"
			textureArrowRight = "arrow_up.blp"
			if MotherDirectionTextCompassNorth then MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassWest then MotherDirectionTextCompassWest:SetTextColor(1, 0, 0, 1) end
			if MotherDirectionTextCompassSouth then MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			if MotherDirectionTextCompassEast then MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2) end
			showMD = true
		else
			showMD = false
		end
		
	if showMD then
		-- Update direction text and description
		if MotherDirectionTextOriention then
			MotherDirectionTextOriention:SetText(textOrientation)
		end
		if MotherDirectionTextOrientationDecription then
			MotherDirectionTextOrientationDecription:SetText(textOrientationDecription)
		end

		-- Update icon textures
		if MotherDirectionIconLeft then
			MotherDirectionIconLeft:SetTexture(MD_ADDON_DIR .. textureIconLeft)
		end
		if MotherDirectionIconRight then
			MotherDirectionIconRight:SetTexture(MD_ADDON_DIR .. textureIconRight)
		end

		-- Update arrow textures
		if MotherDirectionArrowMiddle then MotherDirectionArrowMiddle:SetTexture(MD_ADDON_DIR .. textureArrowMiddle) end
		if MotherDirectionArrowLeft then MotherDirectionArrowLeft:SetTexture(MD_ADDON_DIR .. textureArrowLeft) end
		if MotherDirectionArrowRight then MotherDirectionArrowRight:SetTexture(MD_ADDON_DIR .. textureArrowRight) end

		-- Show appropriate frame based on mode
		if MotherDirectionSaved.mode == "static" or MotherDirectionSaved.mode == "dynamic" then
			if MotherDirectionHoverFrame then MotherDirectionHoverFrame:Show() end
			if MotherDirectionCompassFrame then MotherDirectionCompassFrame:Hide() end
		elseif MotherDirectionSaved.mode == "compass" then
			if MotherDirectionHoverFrame then MotherDirectionHoverFrame:Hide() end
			if MotherDirectionCompassFrame then MotherDirectionCompassFrame:Show() end
		end
	else
		-- No marker on player, hide all frames
		if MotherDirectionHoverFrame then MotherDirectionHoverFrame:Hide() end
		if MotherDirectionCompassFrame then MotherDirectionCompassFrame:Hide() end
	end
end

local DrawRadians
local ActualHeading = 0
local Sin, Cos
local direction , facing
local pi = math.pi
local pi2 = pi * 2

function addon.Arrow_OnUpdate(self, elapsed)
	if not MotherDirection3DArrow or not playerFacingAvailable then return end

	local facing = GetPlayerFacing()
	local piOffset = math.pi * DirectionMultiplier
	local direction

	if facing ~= nil then
		direction = facing - piOffset
		facing = facing
	else
		direction = piOffset
		facing = 3
	end

	local val = (direction * 54 / math.pi + 108) % 108
	local col = math.floor(val % 9)
	local row = math.floor(val / 9)

	if MotherDirection3DArrow then
		MotherDirection3DArrow:SetTexCoord(col * 56 / 512, (col + 1) * 56 / 512, row * 42 / 512, (row + 1) * 42 / 512)

		-- Adjust direction multiplier for north/south markers
		if DirectionMultiplier == 2 or DirectionMultiplier == 1 then
			local pi = math.pi
			if ((facing > pi * 1.5) and (facing < pi * 2)) or ((facing > 0) and (facing < pi * 0.5)) then
				DirectionMultiplier = 2
			else
				DirectionMultiplier = 1
			end
		end

		-- Color code based on direction (green=good, yellow=ok, red=bad)
		if row == 0 or row == 11 then
			MotherDirection3DArrow:SetVertexColor(0.2, 1, 0.2, 1)  -- Green: correct direction
		elseif row == 1 or row == 2 or row == 9 or row == 10 then
			MotherDirection3DArrow:SetVertexColor(1, 1, 0, 1)     -- Yellow: near direction
		else
			MotherDirection3DArrow:SetVertexColor(1, 0, 0, 1)     -- Red: wrong direction
		end
	end
end

--------------

function addon.CompassArrow_OnUpdate()
	if not MotherDirectionCompassArrow or not playerFacingAvailable then return end

	local facing = GetPlayerFacing()

	-- Calculate heading: convert player facing to compass heading
	if facing ~= nil then
		ActualHeading = pi2 - facing
	else
		ActualHeading = pi2 - 1
	end

	local piOffset = pi * 0.25
	DrawRadians = ActualHeading + piOffset

	Sin = math.sin(DrawRadians)
	Cos = math.cos(DrawRadians)

	-- Update texture coordinates to rotate arrow
	MotherDirectionCompassArrow:SetTexCoord(
		0.5 + Sin, 0.5 - Cos,
		0.5 + Cos, 0.5 + Sin,
		0.5 - Cos, 0.5 - Sin,
		0.5 - Sin, 0.5 + Cos
	)
end

_G[addonName] = addon
