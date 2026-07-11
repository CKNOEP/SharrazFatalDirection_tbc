# Interface Number Update - TBC 2.5.6

## Changement Effectué

**Avant:** `## Interface: 20504`  
**Après:** `## Interface: 20506`  
**Raison:** Compatibilité avec TBC Anniversary 2.5.6

## Explication

### Numérotation WoW Interface
- **20504** = TBC (The Burning Crusade) vanilla/classique
- **20506** = TBC Anniversary 2.5.6 (version actuelle du serveur anniversaire)

### Pourquoi Changer?

L'addon ne sera **pas chargé** si le numéro d'interface ne correspond pas à la version de WoW installée.

- Si vous jouez sur **TBC Anniversary 2.5.6** → Utilisez **20506** ✅
- Si vous jouez sur **TBC Classic vanilla** → Utilisez **20504** (non applicable ici)

### Impact

✅ L'addon sera maintenant correctement détecté et chargé par WoW 2.5.6  
✅ Pas d'autres changements de code requis  
✅ Tous les fichiers code restent identiques  

### Vérification

Après le changement, vérifiez:

```bash
grep "Interface:" SharrazFatalDirection_tbc.toc
# Résultat attendu: ## Interface: 20506
```

Dans le jeu:
```
/addon list | grep -i sharraz
# Devrait afficher l'addon comme chargé
```

## Fichiers Affectés

- ✅ **SharrazFatalDirection_tbc.toc** - Mis à jour
- ✅ **CLAUDE.md** - Mis à jour avec le numéro
- ✅ **TEST_GUIDE_256.md** - Mis à jour dans la section Installation

## Références

Pour trouver le numéro d'interface correct pour votre version:
- TBC Anniversary: Vérifier le site officiel du serveur
- WoW Classic: Consulter la documentation Blizzard
- Addons: Vérifier WowInterface ou CurseForge

**Note:** Si vous versionnez cet addon pour différentes versions de WoW, vous devrez maintenir plusieurs versions du TOC avec les bons numéros d'interface.

---

**Date:** 11 juillet 2026  
**Version:** 2.5.6.1  
**Status:** ✅ Complété
