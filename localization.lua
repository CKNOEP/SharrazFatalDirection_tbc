local addonName, addon = ...
local L = {}
addon.L = L

L.LOCALE_textOrientationWest = "WEST";
L.LOCALE_textOrientationDescriptionWest = "\(Just straightforward\)";
L.LOCALE_textOrientationEast = "EAST";
L.LOCALE_textOrientationDescriptionEast = "(Turn 180 degree\)";
L.LOCALE_textOrientationNorthSouth = "NORTH \/ SOUTH";
L.LOCALE_textOrientationDescriptionNorthSouth = "\(90 degree - towards next wall";
L.LOCALE_textNorth = "NORTH";
L.LOCALE_textSouth = "SOUTH";
L.LOCALE_textWest = "WEST";
L.LOCALE_textEast = "EAST";
L.LOCALE_textUnit = "Mother Shahraz";

if (GetLocale() == "frFR") then
	L.LOCALE_textOrientationWest = "EST";
	L.LOCALE_textOrientationDescriptionWest = "\(Juste tout droit\)";
	L.LOCALE_textOrientationEast = "OUEST";
	L.LOCALE_textOrientationDescriptionEast = "(Tourner à 180 degrés - demi tour\)";
	L.LOCALE_textOrientationNorthSouth = "NORD \/ SUD";
	L.LOCALE_textOrientationDescriptionNorthSouth = "\(90 degrés - contre le mur le plus proche\)";
	L.LOCALE_textNorth = "NORD";
	L.LOCALE_textSouth = "SUD";
	L.LOCALE_textWest = "OUEST";
	L.LOCALE_textEast = "EST";
	L.LOCALE_textUnit = "Mère Shahraz";
end

if (GetLocale() == "deDE") then
	L.LOCALE_textOrientationWest = "WESTEN";
	L.LOCALE_textOrientationDescriptionWest = "\(Einfach geradeaus\)";
	L.LOCALE_textOrientationEast = "OSTEN";
	L.LOCALE_textOrientationDescriptionEast = "(180 Grad drehen\)";
	L.LOCALE_textOrientationNorthSouth = "NORDEN \/ S\195\156DEN";
	L.LOCALE_textOrientationDescriptionNorthSouth = "\(90 Grad - gegen n\195\164chste Wand\)";
	L.LOCALE_textNorth = "NORD";
	L.LOCALE_textSouth = "S\195\156D";
	L.LOCALE_textWest = "WEST";
	L.LOCALE_textEast = " OST";
	L.LOCALE_textUnit = "Mutter Shahraz";
end

if (GetLocale() == "enGB") then

end
		
if (GetLocale() == "koKR") then

end
	
if (GetLocale() == "zhCN") then

end
	
if (GetLocale() == "zhTW") then

end

if (GetLocale() == "esES") then

end
		
if (GetLocale() == "ruRU") then

end
