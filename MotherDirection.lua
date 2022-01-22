local DirectionMultiplier = 2;
local playerModel;

MotherDirectionSaved = {};

function md_OnLoad(self)
	--print ("self",self:GetName())
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("RAID_TARGET_UPDATE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	print ("Mother Sharraz Fatal Attraction Direction Loaded /md to configure")
end

function md_OnEvent(event)
	--if event then print ("event",event) end
	if (event == "VARIABLES_LOADED") then
		md_Initialize();
	end
	if (event == "RAID_TARGET_UPDATE") then
		md_Main();
	end
	if (event == "PLAYER_TARGET_CHANGED") then
		md_Activation();
	end
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if (arg2 == "UNIT_DIED") then
			md_Deactivation(arg7);
		end
	end
end

function md_Initialize()

	if (MotherDirectionSaved.toggle == nil) then
		MotherDirectionSaved.toggle = false;
	end

	if (MotherDirectionSaved.status == nil) then
		MotherDirectionSaved.status = "|cffcc0000inactive|r";
	end
	
	if (MotherDirectionSaved.mode == nil) then
		MotherDirectionSaved.mode = "dynamic";
	end
	
	MDlocked = true;
	MotherDirectionHoverFrame.isLocked = true;
	MotherDirectionCompassFrame.isLocked = true;
	
	MotherDirectionTextCompassNorth:SetText(LOCALE_textNorth);
	MotherDirectionTextCompassSouth:SetText(LOCALE_textSouth);
	MotherDirectionTextCompassWest:SetText(LOCALE_textWest);
	MotherDirectionTextCompassEast:SetText(LOCALE_textEast);
	textUnit = LOCALE_textUnit;
	
	md_Main();
	
	ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Addon is ["..MotherDirectionSaved.status.."]");
	
	if (MotherDirectionSaved.mode == "static") then
		md_ActivateStatic();
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cffb2b299"..MotherDirectionSaved.mode.."|r]");		
	elseif (MotherDirectionSaved.mode == "dynamic") then
		md_ActivateDynamic();
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cff9f7fff"..MotherDirectionSaved.mode.."|r]");
	elseif (MotherDirectionSaved.mode == "compass") then
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cffffcc00"..MotherDirectionSaved.mode.."|r]");
	end
	
	SlashCmdList["MDTOOGLE"]=md_OnOff;
	SLASH_MDTOOGLE1="/md";
	SLASH_MDTOOGLE2="/motherdirection";
	
	if not playerModel then
		local t = { Minimap:GetChildren() }
		print("t",t)
		for i = #t, 1, -1 do
			local v = t[i]
			print (v:GetObjectType(), v:GetName(),v:GetObjectType())
			if v:GetObjectType() == "Model" and not v:GetName() then
				playerModel = v
				print (playerModel:GetName())
				break
			end
		end
	end
	
end

function md_OnOff(var1)
	if (var1 == "toggle") then
		if (MotherDirectionSaved.toggle) then
			MotherDirectionSaved.toggle = false;
			MotherDirectionSaved.status = "|cffcc0000inactive|r";
			MotherDirectionHoverFrame:Hide();
			MotherDirectionCompassFrame:Hide();
			MDlocked = true;
			MotherDirectionHoverFrame.isLocked = true;
			MotherDirectionCompassFrame.isLocked = true;
		else
			MotherDirectionSaved.toggle = true;
			MotherDirectionSaved.status = "|cff00ff00active|r";
			md_Main();
		end
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Addon is now ["..MotherDirectionSaved.status.."]");
	elseif (var1 == "static") then
		if not ( MotherDirectionSaved.mode == "static") then
			MotherDirectionSaved.mode = "static";
			md_ActivateStatic();
			MotherDirectionCompassFrame:Hide();
			if (showMD) then
				MotherDirectionHoverFrame:Show();
			end
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode changed to [|cffb2b299"..MotherDirectionSaved.mode.."|r]");
		else
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Already in |cffb2b299static|r mode");
		end
	elseif (var1 == "dynamic") then
		if not (MotherDirectionSaved.mode == "dynamic") then
			MotherDirectionSaved.mode = "dynamic";
			md_ActivateDynamic();
			MotherDirectionCompassFrame:Hide();
			if (showMD) then
				MotherDirectionHoverFrame:Show();
			end
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode changed to [|cff9f7fff"..MotherDirectionSaved.mode.."|r]");
		else
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Already in |cff9f7fffdynamic|r mode");
		end
	elseif (var1 == "compass") then
		if not (MotherDirectionSaved.mode == "compass") then
			MotherDirectionSaved.mode = "compass";
			MotherDirectionHoverFrame:Hide();
			if (showMD) then
				MotherDirectionCompassFrame:Show();
			end
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode changed to [|cffffcc00"..MotherDirectionSaved.mode.."|r]");
		else
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Already in |cffffcc00compass|r mode");
		end
	elseif (var1 == "unlock") then
		if (MotherDirectionSaved.toggle) then
			if (MDlocked) then
				MDlocked = false;
				MotherDirectionHoverFrame.isLocked = false;
				MotherDirectionCompassFrame.isLocked = false;
				MotherDirectionHoverFrame:Show();
				MotherDirectionCompassFrame:Show();
				ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Windows unlocked");
			else
				ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Already locked");
			end
		else
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Can't unlock while addon is |cffcc0000inactive|r");
		end
	elseif (var1 == "resetwin") then
		MotherDirectionHoverFrame:ClearAllPoints();
		MotherDirectionCompassFrame:ClearAllPoints();
		MotherDirectionHoverFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		MotherDirectionCompassFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Window's resetted");
	elseif  (var1 == "lock") then
		if (not MDlocked) then
			md_Main();
		else
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Already locked");
		end			
	else 
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r rebuild by lancestre (Sulfuron/EU)");
		ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Addon is ["..MotherDirectionSaved.status.."]");
		if (MotherDirectionSaved.mode == "static") then
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cffb2b299"..MotherDirectionSaved.mode.."|r]");		
		elseif (MotherDirectionSaved.mode == "dynamic") then
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cff9f7fff"..MotherDirectionSaved.mode.."|r]");
		elseif (MotherDirectionSaved.mode == "compass") then	
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Mode is [|cffffcc00"..MotherDirectionSaved.mode.."|r]");
		end	
		ChatFrame1:AddMessage(" - \"/md\" or \"/motherdirection\" to show this message");
		ChatFrame1:AddMessage(" - \"/md toggle\" to turn the addon [|cff00ff00on|r] / [|cffcc0000off|r]");
		ChatFrame1:AddMessage(" - \"/md static\" switches the addon in |cffb2b299static|r mode");
		ChatFrame1:AddMessage(" - \"/md dynamic\" switches the addon in |cff9f7fffdynamic|r mode");
		ChatFrame1:AddMessage(" - \"/md compass\" switches the addon in |cffffcc00compass|r mode");
		ChatFrame1:AddMessage(" - \"/md \[lock\|unlock\]\" locks\/unlocks the MD window's");
		ChatFrame1:AddMessage(" - \"/md resetwin\" sets the MD windows's to default position");
	end
end

function md_Activation()
	if (UnitName("target") == textUnit) then
		if (not UnitIsDeadOrGhost("target")) and (not MotherDirectionSaved.toggle) then
			md_OnOff("toggle");
		end
	end
end

function md_Deactivation(destName)
	if (destName == textUnit) and (MotherDirectionSaved.toggle) then
		md_OnOff("toggle");
	end
end

function md_ActivateStatic()
	MotherDirectionTextOrientationDecription:Show();
	MotherDirectionArrowLeft:Show();
	MotherDirectionArrowMiddle:Show();
	MotherDirectionArrowRight:Show();
	MotherDirection3DArrow:Hide();
end

function md_ActivateDynamic()
	MotherDirectionTextOrientationDecription:Hide();
	MotherDirectionArrowLeft:Hide();
	MotherDirectionArrowMiddle:Hide();
	MotherDirectionArrowRight:Hide();
	MotherDirection3DArrow:Show();
end

function md_Main()
	

	if (MotherDirectionSaved.toggle) then
	
		--lock all Windows on Action
		if (not MDlocked) then
			MDlocked = true;
			MotherDirectionHoverFrame.isLocked = true;
			MotherDirectionCompassFrame.isLocked = true;
			ChatFrame1:AddMessage("|cff990000M|r|cff6699ffother|r|cff990000D|r|cff6699ffirection|r: Windows locked");
		end
	
		icon=GetRaidTargetIndex("player");
		
		MD_ADDON_DIR = "Interface\\AddOns\\SharrazFatalDirection_tbc\\icons\\";
		
		if (icon == 3) then--2 -> Purple Diamond
			DirectionMultiplier = 2; --Evertime North .. need to go Shahraz Room again to do this better
			textOrientation = LOCALE_textOrientationNorthSouth;
			textOrientationDecription = LOCALE_textOrientationDescriptionNorthSouth;
			textureIconLeft = "Diamond";
			textureIconRight = "Diamond";
			textureArrowLeft = "arrow_left.blp";
			textureArrowMiddle = "arrow_stop.blp";
			textureArrowRight = "arrow_right.blp";
			MotherDirectionTextCompassNorth:SetTextColor(1, 0, 0, 2);
			MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassSouth:SetTextColor(1, 0, 0, 1);
			MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2);
			showMD=true;
		elseif (icon == 1) then --Yellow Star
			DirectionMultiplier = 0.5;
			textOrientation = LOCALE_textOrientationEast;
			textOrientationDecription = LOCALE_textOrientationDescriptionEast;
			textureIconLeft = "Star";
			textureIconRight = "Star";
			textureArrowLeft = "arrow_down.blp";
			textureArrowMiddle = "arrow_down.blp";
			textureArrowRight = "arrow_down.blp";
			MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassWest:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassEast:SetTextColor(1, 0, 0, 1);
			showMD=true;
		elseif (icon == 2) then -- Orange Circle
			DirectionMultiplier = 1.5;
			textOrientation = LOCALE_textOrientationWest;
			textOrientationDecription = LOCALE_textOrientationDescriptionWest;
			textureIconLeft = "Circle";
			textureIconRight = "Circle";
			textureArrowLeft = "arrow_up";
			textureArrowMiddle = "arrow_up";
			textureArrowRight = "arrow_up";
			MotherDirectionTextCompassNorth:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassWest:SetTextColor(1, 0, 0, 1);
			MotherDirectionTextCompassSouth:SetTextColor(0.8, 0.8, 0.8, 0.2);
			MotherDirectionTextCompassEast:SetTextColor(0.8, 0.8, 0.8, 0.2);
			showMD=true;
		elseif (icon == nil) then
			showMD=false;
		end
		
		if (showMD) then
			MotherDirectionTextOriention:SetText(textOrientation);
			MotherDirectionTextOrientationDecription:SetText(textOrientationDecription);
			MotherDirectionIconLeft:SetTexture(MD_ADDON_DIR..textureIconLeft);
			MotherDirectionIconRight:SetTexture(MD_ADDON_DIR..textureIconRight);
			MotherDirectionArrowMiddle:SetTexture(MD_ADDON_DIR..textureArrowMiddle);
			MotherDirectionArrowLeft:SetTexture(MD_ADDON_DIR..textureArrowLeft);
			MotherDirectionArrowRight:SetTexture(MD_ADDON_DIR..textureArrowRight);
			if (MotherDirectionSaved.mode == "static") or (MotherDirectionSaved.mode == "dynamic") then
				MotherDirectionHoverFrame:Show();
				MotherDirectionCompassFrame:Hide();
			elseif (MotherDirectionSaved.mode == "compass") then
				MotherDirectionHoverFrame:Hide();
				MotherDirectionCompassFrame:Show();
			end
		else
			MotherDirectionHoverFrame:Hide();
			MotherDirectionCompassFrame:Hide();
		end
	end
end

local DrawRadians;
local ActualHeading = 0;
local Sin, Cos
local direction , facing
local pi = math.pi;
local pi2 = pi * 2;

function md_3DArrow_OnUpdate()
	--print ("DirectionMultiplier",DirectionMultiplier, GetPlayerFacing())
	local piOffset = math.pi * DirectionMultiplier;
	--local direction = -playerModel:GetFacing() - piOffset;
	if GetPlayerFacing() then
		direction = -1*GetPlayerFacing() - piOffset;
		else
		direction =  piOffset;
	end
	
	if GetPlayerFacing() then
		facing = GetPlayerFacing();
		else
		facing = 3
	end

	
	--print ("dir",direction, piOffset)
	local val = (direction*54/math.pi + 108) % 108;
	local col, row = math.floor(val % 9), math.floor(val / 9);
	
	MotherDirection3DArrow:SetTexCoord(col*56/512, (col+1)*56/512, row*42/512, (row+1)*42/512);
	
	if (DirectionMultiplier == 2 or DirectionMultiplier == 1) then
		if ( ((facing > pi * 1.5) and (facing < pi * 2)) or ((facing > 0) and (facing < pi * 0.5)) ) then
			DirectionMultiplier = 2;
		else 
			DirectionMultiplier = 1;
		end
	end
	
	if (row == 0 or row == 11 ) then
		MotherDirection3DArrow:SetVertexColor(0.2,1,0.2,1);
	elseif (row == 1 or row == 2 or row == 9 or row == 10) then
		MotherDirection3DArrow:SetVertexColor(1,1,0,1);
	else
		MotherDirection3DArrow:SetVertexColor(1,0,0,1);
	end
	
end

function md_CompassArrow_OnUpdate()
	--local ActualHeading = pi2 - playerModel:GetFacing();
	if GetPlayerFacing() then
	local ActualHeading = pi2 - GetPlayerFacing()
	else
	local ActualHeading = pi2 - GetPlayerFacing()
	end
	
	local piOffset = pi * 0.25;
	
	local DrawRadians = ActualHeading + piOffset;
	
	local Sin = math.sin(DrawRadians);
	local Cos = math.cos(DrawRadians);
		 
	MotherDirectionCompassArrow:SetTexCoord(0.5+Sin, 0.5-Cos,
		 0.5+Cos, 0.5+Sin,
		 0.5-Cos, 0.5-Sin,
		 0.5-Sin, 0.5+Cos);

end