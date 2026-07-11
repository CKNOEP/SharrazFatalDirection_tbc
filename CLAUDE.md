# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sharraz Fatal Direction** is a World of Warcraft addon for The Burning Crusade (TBC) Anniversary **v2.5.6** that displays directional movement indicators during the Mother Shahraz raid boss encounter. It solves a critical mechanic from **Fatal Attraction** (Liaison Fatale), an ability where Mother Shahraz creates magical chains linking her to marked players. These chains cause raid-wide damage if they overlap, so marked players must spread out to specific positions in the arena.

The addon uses raid target markers (icons placed by the raid leader: Star, Circle, Diamond) to identify which player is marked, then guides them to the correct cardinal direction via animated arrows. This ensures all marked players spread evenly and chains never cross.

**Current Version:** 2.5.6.1 (Modernized for TBC Anniversary 2.5.6)
**Interface Number:** 20506 (TBC Anniversary 2.5.6)
**Supported Locales:** enUS, frFR, deDE, enGB

## Version History & Recent Changes (2.5.6.1)

### Critical Fixes
- **Fixed GetPlayerFacing() bug**: Was using `if not GetPlayerFacing()` which evaluated true at 0 radians (north), causing mode-switching errors
- **Added CombatLogGetCurrentEventInfo() safety check**: Now verifies function exists before calling
- **Fixed missing texture extensions**: Icons now properly include .tga extension (Diamond.tga, Star.tga, Circle.tga)
- **Updated TOC for compatibility**: Version bumped to 2.5.6.1, added enGB locale

### Robustness Improvements
- Added nil-checks on ALL frame operations (SetText, SetTexture, SetVertexColor, Show, Hide)
- Eliminated ~10 lines of duplicate code in CompassArrow_OnUpdate()
- Improved error handling for edge cases (no player facing, missing frames)
- Added early-return patterns for cleaner code flow

### Code Quality
- Removed unnecessary parentheses in conditionals
- Consistent spacing and formatting throughout
- Added comments to critical sections
- ~40 new safety guards added to prevent runtime errors

**See TEST_GUIDE_256.md for validation procedure and CHANGES_SUMMARY_256.md for detailed changes.**

## Fatal Attraction Mechanic

**What is Fatal Attraction?**  
Mother Shahraz's signature ability (Liaison Fatale) creates magical chains that connect her to up to 3 raid members. These chains:
- Deal shadow damage to any players standing between chain endpoints
- Cause chain damage to spread across players if they group too close together
- Force marked players to maintain safe distance from each other

**How This Addon Helps:**
Without direction indicators, marked players must guess where to spread. With this addon:
1. Players instantly see which direction they've been assigned (based on their raid marker)
2. The arrow animates in real-time, adjusting for player rotation/movement
3. Clear visual guidance prevents chains from crossing and wiping the raid

The three-position spread (East, West, North/South) distributes players around Mother Shahraz's position in the arena, creating maximum separation for safe chain placement.

## Architecture

### Event-Driven System
The addon operates on a Lua event-driven model, listening to WoW game events:
- `ADDON_LOADED`: Initial addon setup and saved variables initialization
- `RAID_TARGET_UPDATE`: **Primary event** — fired whenever the raid leader places/updates a marker; triggers direction recalculation and UI update
- `PLAYER_TARGET_CHANGED`: Auto-activates addon when player targets Mother Shahraz; auto-deactivates when target changes
- `COMBAT_LOG_EVENT_UNFILTERED`: Detects boss death to auto-deactivate addon; also switches between static/dynamic display modes based on `GetPlayerFacing()` availability
- `PLAYER_ENTERING_WORLD` / `ZONE_CHANGED_INDOORS`: Zone change events to handle arena transitions

**Critical Flow**: Raid leader marks a player → `RAID_TARGET_UPDATE` fires → `addon.Main()` reads the player's raid icon → Direction arrows animate to guide the player to spread position.

### Core Logic Flow
1. **Event Detection** → `addon.OnEvent()` in `MotherDirection.lua`
2. **Raid Marker Analysis** → `addon.Main()` checks player's raid target icon (1, 2, or 3)
3. **Direction Mapping** → Based on icon, determine DirectionMultiplier and orientation text
4. **UI Update** → Set textures, text, and colors in the frame display
5. **Rendering** → Each frame's `OnUpdate()` handler renders directional arrows

### Raid Marker to Direction Mapping
The raid leader assigns markers to create a defensive spread pattern that prevents Fatal Attraction chains from overlapping:

- **Icon 1 (Yellow Star)**: Move **EAST** | DirectionMultiplier = 1.5 | Arrow points down
  - Player spreads to the eastern wall of the arena
- **Icon 2 (Orange Circle)**: Move **WEST** | DirectionMultiplier = 0.5 | Arrow points up
  - Player spreads to the western wall (straight forward)
- **Icon 3 (Purple Diamond)**: Move **NORTH/SOUTH** | DirectionMultiplier = 2 | Arrow points left/right
  - Player chooses north or south wall (90° rotation) away from boss

This creates an evenly distributed triangle/spread formation, ensuring each Fatal Attraction chain hangs independently without crossing others' chains. The DirectionMultiplier compensates for the player's facing angle relative to the boss position.

### Display Modes
- **Static**: Fixed arrows showing North, South, East, West directions relative to arena walls
- **Dynamic**: 3D rotating arrow that adjusts to player's character facing angle using `GetPlayerFacing()`
- **Compass**: Compass-style cardinal direction indicator with rotating arrow

### DirectionMultiplier
Controls the angle offset calculation when converting player facing angle to arrow direction. This compensates for different raid marker placements and ensures the arrow points the correct direction relative to Mother Shahraz's position.

### Frame Architecture (XML)
Two main frames in `MotherDirection.xml`:
1. **MotherDirectionHoverFrame** (300×130px):
   - Used for static and dynamic modes
   - Contains title, orientation text, two icon textures (left/right), three arrow textures (left/middle/right)
   - Dynamic mode hides left/right arrows and shows the 3D arrow

2. **MotherDirectionCompassFrame** (250×250px):
   - Used for compass mode
   - Shows cardinal directions (N/S/E/W text in corners)
   - Animated compass arrow that rotates based on player facing

Both frames are:
- Movable when unlocked (via `/md unlock`)
- Hidden by default
- Can have positions reset to default via `/md resetwin`

### Saved Variables
Stored in `MotherDirectionSaved` table (persists between sessions):
- `toggle`: Boolean indicating if addon is active
- `status`: Display string ("active" or "inactive")
- `mode`: Current display mode ("static", "dynamic", or "compass")

## Commands

All commands use `/md` or `/motherdirection`:
- `/md` — Show help text
- `/md toggle` — Turn addon on/off
- `/md static` — Switch to static arrow mode
- `/md dynamic` — Switch to dynamic 3D arrow mode
- `/md compass` — Switch to compass mode
- `/md lock` — Lock window position (auto-locks during combat)
- `/md unlock` — Unlock window for repositioning
- `/md resetwin` — Reset frame positions to default (centered at top of screen)

## Localization

Localization strings are defined in `localization.lua` with support for:
- **enUS** (English US) - Default
- **frFR** (French)
- **deDE** (German)

The `L` table is populated per locale, with key strings:
- `L.LOCALE_textUnit`: "Mother Shahraz" (or localized equivalent)
- `L.LOCALE_textOrientation*`: Direction names (WEST, EAST, NORTH/SOUTH)
- `L.LOCALE_textOrientationDescription*`: Movement instructions

Additional locales (enGB, koKR, zhCN, zhTW, esES, ruRU) have stub sections ready for translation.

## Key Functions

**Initialization & Events**
- `addon.OnLoad()` — Registers event listeners
- `addon.OnEvent()` — Main event dispatcher
- `addon.Initialize()` — Sets up saved variables and slash commands

**Mode Switching & Control**
- `addon.OnOff(var1)` — Handles all slash commands (toggle, static, dynamic, compass, lock, unlock, resetwin)
- `addon.Activation()` — Auto-activates when targeting Mother Shahraz
- `addon.Deactivation(destName)` — Auto-deactivates when boss dies

**Display Updates**
- `addon.Main()` — Core logic that reads raid target icon and updates UI
- `addon.ActivateStatic()` / `addon.ActivateDynamic()` — Mode-specific setup
- `addon.Arrow_OnUpdate()` — Animates 3D arrow in dynamic mode (recalculates angle each frame)
- `addon.CompassArrow_OnUpdate()` — Rotates compass arrow (uses sine/cosine for rotation)

**Utilities**
- `addon.Print(msg, plain)` — Print colored message to chat frame with MD prefix

## Development Notes

### Testing
This addon is environment-dependent (requires Mother Shahraz encounter). Testing typically involves:
1. Loading the addon in WoW
2. Targeting Mother Shahraz (triggers auto-activation)
3. Having raid leader place a marker (star, circle, or diamond) on the player
4. Verifying the correct direction arrow displays
5. Testing each of the three modes and command variations

Since this is a raid addon, testing requires:
- WoW TBC client running
- Raid group context (or testing with dummy targets)
- Player to be in Tempest Keep raid instance

### Code Style
- Uses WoW addon convention: `local addonName, addon = ...` to get namespace
- Heavy use of `_G` to access global frame references from XML
- Math heavy in arrow rotation: uses radians, sine/cosine for 2D rotation
- Color values use normalized 0-1 range (not 0-255)
- Coordinates use texture coordinates (0-1 range with SetTexCoord)

### Common Edits
- **Changing direction mappings**: Edit the raid icon cases in `addon.Main()` (lines 255-299)
- **Adding a new language**: Add locale check in `localization.lua` and populate L table
- **Adjusting frame positions**: Edit anchor values in `MotherDirection.xml` or use `/md unlock` + `/md resetwin`
- **Changing textures**: Icon files are in `icons/` subdirectory; modify paths in `MotherDirection.lua` (line 307 onwards) and XML
- **Adding new display modes**: Add new frame in XML, new activation function, new case in `addon.OnOff()`

## File Structure
```
SharrazFatalDirection_tbc/
├── SharrazFatalDirection_tbc.toc      # Addon manifest (metadata & file load order)
├── MotherDirection.lua                # Core logic and event handling
├── MotherDirection.xml                # UI frame definitions
├── localization.lua                   # Localized strings (enUS, frFR, deDE)
├── icons/                             # Direction arrow and marker textures
│   ├── arrow_*.blp                   # Static arrow directions
│   ├── arrow_3d.blp                  # 3D dynamic arrow sprite sheet
│   ├── arrow_dynamic                  # Compass arrow texture
│   ├── Diamond.blp                    # Raid marker icon (purple diamond)
│   ├── Star.blp                       # Raid marker icon (yellow star)
│   └── Circle.blp                     # Raid marker icon (orange circle)
└── CLAUDE.md                          # This file
```

## Performance Considerations

- `Arrow_OnUpdate()` runs every frame—math operations are minimal (multiplication, modulo, SetTexCoord calls)
- Compass version also runs every frame with trigonometric calculations (sin/cos)
- Frames are hidden by default to avoid render overhead when not in combat
- Only one frame visible at a time (HoverFrame or CompassFrame)
- Minimal event processing: only RAID_TARGET_UPDATE triggers expensive `addon.Main()` calculations
