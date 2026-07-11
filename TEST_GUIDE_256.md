# Guide de Test - Sharraz Fatal Direction TBC 2.5.6

## Préparation

### 1. Installation
```
1. Placer le dossier SharrazFatalDirection_tbc dans:
   World of Warcraft/_anniversary_/Interface/AddOns/
   
2. Vérifier que le TOC contient:
   ## Interface: 20506  (TBC Anniversary 2.5.6)
   
3. Vérifier que la structure est correcte:
   SharrazFatalDirection_tbc/
   ├── SharrazFatalDirection_tbc.toc
   ├── MotherDirection.lua
   ├── MotherDirection.xml
   ├── localization.lua
   └── icons/
   
3. Lancer WoW TBC Anniversary 2.5.6
```

### 2. Vérification Initiale
```
/reload                          # Recharger les addons
/md                              # Voir les commandes disponibles
```

**Résultat attendu:**
```
Sharraz Fatal Direction: Loaded /md to configure
Addon is [inactive]
Mode is [dynamic]
```

## Tests Fonctionnels

### TEST 1: Chargement et Commandes de Base
**Étapes:**
1. `/md toggle` → Activer l'addon
2. `/md` → Afficher l'aide
3. `/md toggle` → Désactiver l'addon

**Résultats attendus:**
- ✅ Message "Addon is now [active]" au toggle ON
- ✅ Message "Addon is now [inactive]" au toggle OFF
- ✅ Message d'aide apparaît avec toutes les commandes
- ✅ Pas d'erreurs dans la console

---

### TEST 2: Auto-Activation sur Mother Shahraz
**Lieu:** Tempest Keep (Raid Chamber)
**Étapes:**
1. Aller près de Mother Shahraz
2. Target Mother Shahraz (clic ou `/target Mother Shahraz`)
3. Vérifier l'activation automatique

**Résultats attendus:**
- ✅ Addon s'active automatiquement quand target = Mother Shahraz
- ✅ Addon se désactive quand target change ou boss meurt
- ✅ Pas d'erreurs lua

---

### TEST 3: Mode STATIC (Flèches Fixes)
**Étapes:**
1. `/md toggle` → Activer
2. `/md static` → Passer en mode static
3. Demander raid leader de marquer avec les 3 icônes:
   - ⭐ Star (Étoile jaune) → Direction: **EAST**
   - 🔵 Circle (Cercle orange) → Direction: **WEST**
   - 💎 Diamond (Diamant violet) → Direction: **NORTH/SOUTH**

**Résultats attendus par marqueur:**

**Icon 1 (Star):**
- ✅ Affiche: "EAST"
- ✅ Description: "(Turn 180 degree)" ou variante locale
- ✅ Flèche du milieu pointe vers bas (down)
- ✅ Deux icônes stars à gauche et droite
- ✅ Compass: East en rouge, autres grisés

**Icon 2 (Circle):**
- ✅ Affiche: "WEST"
- ✅ Description: "(Just straightforward)" ou variante locale
- ✅ Flèche du milieu pointe vers haut (up)
- ✅ Deux icônes circles à gauche et droite
- ✅ Compass: West en rouge, autres grisés

**Icon 3 (Diamond):**
- ✅ Affiche: "NORTH / SOUTH"
- ✅ Description: "(90 degree - towards next wall)" ou variante locale
- ✅ Flèches gauche/droite pointent correctement (left/stop/right)
- ✅ Deux icônes diamonds à gauche et droite
- ✅ Compass: North en rouge, autres grisés

---

### TEST 4: Mode DYNAMIC (Flèche 3D Rotative)
**Étapes:**
1. `/md dynamic` → Passer en mode dynamic
2. Placer des marqueurs (icônes) sur le joueur
3. Pivoter le personnage dans toutes les directions (8 directions cardinales)
4. Vérifier que la flèche 3D se met à jour en temps réel

**Résultats attendus:**
- ✅ Flèche rotative apparaît (grande, au milieu de la fenêtre)
- ✅ Flèche s'oriente correctement selon la direction à suivre
- ✅ Couleur change avec la direction:
  - 🟢 Vert = direction correcte (good)
  - 🟡 Jaune = proche de la bonne direction (ok)
  - 🔴 Rouge = mauvaise direction (bad)
- ✅ Mise à jour fluide lors de la rotation
- ✅ Performance: pas de lag perceptible

---

### TEST 5: Mode COMPASS (Boussole)
**Étapes:**
1. `/md compass` → Passer en mode compass
2. Placer des marqueurs sur le joueur
3. Pivoter le personnage lentement dans toutes les directions
4. Observer la flèche qui tourne au centre de la boussole

**Résultats attendus:**
- ✅ Fenêtre de boussole apparaît (250x250 carrée)
- ✅ Lettres cardinales (N/S/E/W) positionnées correctement
- ✅ Flèche centrale tourne correctement
- ✅ Flèche s'oriente selon direction de mouvement demandée
- ✅ Direction cible en rouge, autres en gris

---

### TEST 6: Positionnement des Fenêtres
**Étapes:**
1. `/md unlock` → Déverrouiller les fenêtres
2. Glisser chaque fenêtre à de nouvelles positions
3. Vérifier que les positions se sauvegardent
4. `/reload` → Recharger
5. Vérifier que les positions sont restaurées

**Résultats attendus:**
- ✅ Fenêtres draggable au clic-glisser
- ✅ Positions sauvegardées dans SavedVariables
- ✅ Positions restaurées après /reload
- ✅ `/md resetwin` remet aux positions par défaut

**Positions par défaut:**
- HoverFrame: CENTER, +0, +200
- CompassFrame: CENTER, +50, +200

---

### TEST 7: Commandes Lock/Unlock
**Étapes:**
1. `/md unlock` → Déverrouiller
2. Essayer de déplacer les fenêtres
3. `/md lock` → Verrouiller
4. Essayer de déplacer (ne doit pas bouger)

**Résultats attendus:**
- ✅ Unlock message: "Windows unlocked"
- ✅ Windows draggable après unlock
- ✅ Lock message: "Windows locked"
- ✅ Windows non-draggable après lock
- ✅ Verrouillage automatique pendant combat

---

### TEST 8: Changement de Mode
**Étapes:**
1. `/md static` → Mode static
2. Vérifier message confirmation
3. `/md dynamic` → Mode dynamic
4. Vérifier message confirmation
5. `/md compass` → Mode compass
6. Placer marqueurs entre chaque mode

**Résultats attendus:**
- ✅ Mode change immédiatement
- ✅ Message de confirmation avec couleur appropriée:
  - Static: |cffb2b299 (gris)
  - Dynamic: |cff9f7fff (violet)
  - Compass: |cffffcc00 (jaune)
- ✅ Fenêtre switch correct lors du mode change
- ✅ Les flèches s'affichent correctement pour le mode

---

### TEST 9: Multilingue
**Étapes:**
1. Changer la langue du client WoW à Français:
   - Paramètres → Account → Language: Français (frFR)
   - Redémarrer WoW
2. Charger l'addon avec `/md`
3. Vérifier les textes en français
4. Tester avec Allemand (deDE) si possible

**Résultats attendus - Français:**
- ✅ "Mère Shahraz" au lieu de "Mother Shahraz"
- ✅ "EST" au lieu de "EAST"
- ✅ "OUEST" au lieu de "WEST"
- ✅ "NORD / SUD" au lieu de "NORTH / SOUTH"
- ✅ Descriptions en français

**Résultats attendus - Allemand:**
- ✅ "Mutter Shahraz"
- ✅ "WESTEN", "OSTEN", etc.

---

### TEST 10: Situation de Raid Réelle
**Lieu:** Mother Shahraz en raid
**Étapes:**
1. Former un groupe/raid de 5+ joueurs
2. Engager le combat contre Mother Shahraz
3. Raid leader marque 3 joueurs avec les 3 icônes
4. Attendre la mécanique Fatal Attraction
5. Les joueurs marqués suivent les flèches de l'addon
6. Vérifier que les chaînes ne se croisent pas

**Résultats attendus:**
- ✅ Addon détecte automatiquement la mécanique
- ✅ Flèches guident correctement les joueurs
- ✅ Les 3 chaînes se forment sans se croiser
- ✅ Pas de dégâts non-planifiés du à des chaînes croisées
- ✅ Aucun crash ou erreur lua
- ✅ Performance acceptable en raid (pas de lag)

---

## Tests de Sécurité

### TEST 11: Pas d'Erreurs Lua
**Étapes:**
1. Activer l'affichage des erreurs:
   - `/run SetCVar("scriptErrors", 1)`
2. Exécuter tous les tests précédents
3. Observer la console pour les erreurs

**Résultats attendus:**
- ✅ Aucune erreur Lua
- ✅ Aucun warning
- ✅ Console propre

---

### TEST 12: Accès API Valides
**Étapes:**
1. Vérifier dans le code que toutes les API sont 2.5.6 compatible
2. Tester les API clés:
   - GetPlayerFacing() → doit retourner une valeur ou nil
   - GetRaidTargetIndex("player") → doit retourner 1-8 ou nil
   - CombatLogGetCurrentEventInfo() → doit être disponible

**Résultats attendus:**
- ✅ Pas d'appels à des API supprimées
- ✅ Pas d'erreurs "unknown global"
- ✅ Toutes les fonctions répondent correctement

---

## Checklist de Validation

### Avant le déploiement final

- [ ] TEST 1: Chargement et commandes de base - PASS
- [ ] TEST 2: Auto-activation sur Mother Shahraz - PASS
- [ ] TEST 3: Mode STATIC avec les 3 icônes - PASS
- [ ] TEST 4: Mode DYNAMIC avec rotation - PASS
- [ ] TEST 5: Mode COMPASS avec rotation - PASS
- [ ] TEST 6: Positionnement et sauvegarde - PASS
- [ ] TEST 7: Lock/Unlock des fenêtres - PASS
- [ ] TEST 8: Changement de mode - PASS
- [ ] TEST 9: Multilingue (frFR, deDE au minimum) - PASS
- [ ] TEST 10: Raid réelle avec Mother Shahraz - PASS
- [ ] TEST 11: Aucune erreur Lua - PASS
- [ ] TEST 12: Accès API valides - PASS

**Status Final:** ✅ READY FOR RELEASE

---

## Résolution de Problèmes

### Addon n'apparaît pas
**Solution:**
```
1. Vérifier que le dossier est dans le bon répertoire
2. Vérifier que SharrazFatalDirection_tbc.toc existe
3. /reload et vérifier la liste des addons chargés
```

### Fenêtres ne s'affichent pas
**Solution:**
```
1. `/md toggle` pour activer l'addon
2. Cibler Mother Shahraz pour auto-activation
3. Demander raid leader de marquer le joueur
4. Vérifier `/md resetwin` pour positionner les fenêtres
```

### Flèches pointent mauvaise direction
**Solution:**
```
1. Vérifier le mode (static/dynamic/compass)
2. Vérifier le marqueur correct (star=east, circle=west, diamond=ns)
3. En mode dynamic: s'assurer que GetPlayerFacing() fonctionne
4. Tester en changeant de mode
```

### Erreurs Lua
**Solution:**
```
1. Vérifier la version de l'addon (doit être 2.5.6.1 minimum)
2. Vérifier le TOC (interface: 20504)
3. Chercher les erreurs: /script LoadAddOn("SharrazFatalDirection_tbc")
4. Consulter les logs pour les détails
```

---

## Performance

**Cibles:**
- FPS stable en raid: >30 FPS minimum
- OnUpdate() pas plus de 0.5ms par frame (60 FPS = 16.6ms par frame)
- Pas d'allocations mémoire inutiles
- Pas de freezes lors du changement de mode

**Comment tester:**
```
/run SetCVar("GraphicsAPI", "OpenGL")  -- Forcer OpenGL pour meilleure perf
/fps                                    -- Afficher FPS
```

---

## Feedback

Si vous trouvez des bugs ou des améliorations possibles, notez:
- Le numéro du test qui a échoué
- Les étapes précises pour reproduire
- Le message d'erreur exact
- Votre version de WoW et votre locale
