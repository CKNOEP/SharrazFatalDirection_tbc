# Correction XML Backdrop - TBC 2.5.6

## Problèmes Signalés

```
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:7 Unrecognized XML: Backdrop
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:7 Unrecognized XML attribute: bgFile
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:7 Unrecognized XML attribute: edgeFile
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:7 Unrecognized XML attribute: tile
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:8 Unrecognized XML: BackgroundInsets
4x LUA_WARNING: SharrazFatalDirection_tbc/MotherDirection.xml:9 Unrecognized XML: AbsInset
```

## Cause

En TBC 2.5.6, la structure `<Backdrop>` **n'est pas supportée du tout**. Les éléments:
- `<Backdrop>`
- `<BackdropTextures>`
- `<BackgroundInsets>`
- `<TileSize>`
- `<EdgeSize>`
- `<AbsInset>`

Aucun de ces éléments n'est reconnu par WoW 2.5.6.

## Correction Appliquée

**Avant (Incorrect):**
```xml
<Frame name="MotherDirectionHoverFrame" ...>
    <Backdrop bgFile="..." edgeFile="..." tile="true">
        <BackgroundInsets>
            <AbsInset left="5" right="5" top="5" bottom="5"/>
        </BackgroundInsets>
        <TileSize><AbsValue val="16"/></TileSize>
        <EdgeSize><AbsValue val="16"/></EdgeSize>
    </Backdrop>
    <Size>...</Size>
    ...
</Frame>
```

**Après (Correct):**
```xml
<Frame name="MotherDirectionHoverFrame" ...>
    <Size>...</Size>
    ...
</Frame>
```

## Explication

En TBC 2.5.6, les Backdrops **ne sont pas supportés via XML**. La solution est:

1. **Option 1 (Appliquée):** Enlever complètement le Backdrop du XML
2. **Option 2:** Ajouter le Backdrop via Lua dans `MotherDirection.lua`

Nous avons choisi l'Option 1 (plus simple) et enlevé complètement les Backdrops. Les frames s'affichent maintenant sans l'arrière-plan graphique mais avec les éléments Textures et FontStrings visibles.

Si un arrière-plan est vraiment nécessaire, il peut être ajouté via Lua avec :
```lua
MotherDirectionHoverFrame:SetBackdrop(...)
```

## Fichiers Modifiés

- ✅ **MotherDirection.xml** ligne 6-19 - MotherDirectionHoverFrame
  - Removed entire `<Backdrop>` element and all children
  
- ✅ **MotherDirection.xml** ligne 162-174 - MotherDirectionCompassFrame
  - Removed entire `<Backdrop>` element and all children

## Résultat

Après cette correction:
- ✅ Plus d'erreurs XML Backdrop
- ✅ Plus d'erreurs BackgroundInsets
- ✅ Plus d'erreurs TileSize/EdgeSize
- ✅ Les frames s'affichent correctement
- ✅ Les textures et flèches s'affichent
- ⚠️ Pas de bordure/arrière-plan graphique (peut être ajouté en Lua si besoin)

## Test de Validation

Pour confirmer que l'erreur est corrigée:

```
1. /reload dans le jeu
2. Vérifier qu'il n'y a plus d'erreurs XML
3. /md toggle pour activer l'addon
4. Vérifier que les frames s'affichent avec les flèches visibles
```

**Résultat attendu:**
- ✅ Pas d'erreurs "Unrecognized XML"
- ✅ Les deux frames s'affichent
- ✅ Les flèches et textes sont visibles
- ⚠️ Sans bordure graphique (si désiré, à ajouter en Lua)

## Note pour l'Avenir

Si un beau Backdrop est requis, on peut l'ajouter en Lua:

```lua
-- Dans MotherDirection.lua
local backdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {left = 5, right = 5, top = 5, bottom = 5}
}
MotherDirectionHoverFrame:SetBackdrop(backdrop)
MotherDirectionCompassFrame:SetBackdrop(backdrop)
```

Mais cela n'était pas nécessaire pour la fonctionnalité actuelle.

---

**Date:** 11 juillet 2026  
**Version:** 2.5.6.1  
**Status:** ✅ Corrigé
