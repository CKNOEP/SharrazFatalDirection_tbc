# 📚 Index Complet de la Documentation

**Sharraz Fatal Direction TBC 2.5.6.1**

---

## 🎯 Par Rôle/Cas d'Usage

### 👤 JE SUIS UN UTILISATEUR FINAL
**Objectif:** Installer et utiliser l'addon

**Lire dans cet ordre:**
1. **README_MODERNIZATION.txt** ← START HERE (5 min)
   - Quick Start pour utilisateurs
   - Commandes et utilisation basique
   
2. **TEST_GUIDE_256.md** → Section "Préparation" + "Tests Fonctionnels 1-2"
   - Comment installer
   - Vérifier que ça fonctionne
   
3. **CLAUDE.md** → Sections "Commands" et "Display Modes"
   - Toutes les commandes disponibles
   - Explication des 3 modes

**Besoin d'aide?**
- Problème d'installation → TEST_GUIDE_256.md → "Résolution de Problèmes"
- Commande oubliée → `/md` dans le jeu
- Question technique → CLAUDE.md

---

### 🛠️ JE SUIS UN TESTEUR QA/RAID LEADER
**Objectif:** Valider que l'addon fonctionne correctement

**Lire dans cet ordre:**
1. **README_MODERNIZATION.txt** ← START HERE (5 min)
   - Vue d'ensemble des changements
   - Ce qui a été corrigé
   
2. **TEST_GUIDE_256.md** ← GUIDE COMPLET (60 min pour tous les tests)
   - Tous les 14 tests détaillés
   - Résultats attendus pour chaque test
   - Checklist de validation
   
3. **MODERNIZATION_COMPLETE.md** → Sections "Validation" et "Points Positifs"
   - Ce qui a été testé
   - Statistiques de qualité

**Processus de test:**
1. Lire TEST_GUIDE_256.md en entier
2. Exécuter les tests 1-2 (Installation et base)
3. Exécuter les tests 3-9 (Fonctionnalités)
4. Exécuter les tests 10-12 (Raid réelle + Sécurité)
5. Remplir la checklist finale
6. Reportez "PASS" ou "FAIL" pour chaque test

---

### 👨‍💻 JE SUIS UN DÉVELOPPEUR WoW
**Objectif:** Comprendre, modifier et améliorer le code

**Lire dans cet ordre:**
1. **CLAUDE.md** ← START HERE (30 min)
   - Architecture générale
   - Explications des fichiers
   - Vue d'ensemble du projet
   
2. **MODERNIZATION_COMPLETE.md** → Sections "Problèmes Résolus" + "Fichiers Modifiés"
   - Quels bugs ont été corrigés
   - Détail de chaque changement
   - Justifications techniques (60 min)
   
3. **WOW_256_COMPATIBILITY_ANALYSIS.md** → Sections "Status APIs" + "Changements Recommandés"
   - Quelles APIs sont disponibles
   - Changements depuis anciennes versions
   - Restrictions Blizzard 2.5.6 (30 min)
   
4. **CHANGES_SUMMARY_256.md** → Sections "Statistiques" + "Notes de Développement"
   - Résumé des changements
   - Patterns de code
   - Emplacements des modifications courantes (20 min)
   
5. **TEST_GUIDE_256.md** → Section "Tests de Sécurité" 11-12
   - Vérifier l'intégrité du code
   - Valider les API calls (20 min)

**Points d'entrée du code:**
- Logique principale: `MotherDirection.lua:addon.Main()`
- Événements: `MotherDirection.lua:addon.OnEvent()`
- Render 3D: `MotherDirection.lua:addon.Arrow_OnUpdate()`
- Commandes: `MotherDirection.lua:addon.OnOff()`

**Avant de modifier:**
- Vérifier TEST_GUIDE_256.md pour les tests affectés
- Mettre à jour les nil-checks
- Tester avec la checklist complète

---

### 🏗️ JE VEUX AJOUTER UNE NOUVELLE MÉCANIQUE/BOSS
**Objectif:** Étendre l'addon à d'autres contenus

**Lire dans cet ordre:**
1. **CLAUDE.md** → Sections "Architecture" + "Raid Marker to Direction Mapping"
   - Comprendre le système actuel
   - Comment les icônes mappent aux directions (30 min)
   
2. **MODERNIZATION_COMPLETE.md** → Section "Fichiers Modifiés" + "MotherDirection.lua"
   - Voir l'implémentation détaillée (60 min)
   
3. **WOW_256_COMPATIBILITY_ANALYSIS.md** → Sections "APIs CONFIRMÉES STABLES"
   - Confirmer que les APIs pour la nouvelle mécanique existent (20 min)

**Étapes d'implémentation:**
1. Créer une nouvelle fonction `addon.NewBossMechanic()`
2. Dupliquer la logique de `addon.Main()` adaptée à votre boss
3. Ajouter la détection du nouveau boss (TARGET_CHANGED event)
4. Écrire les tests correspondants (TEST_GUIDE_256.md format)
5. Documenter les changements dans CHANGES_SUMMARY_256.md

---

## 📖 Par Document

### 1. **README_MODERNIZATION.txt** ⭐ START HERE
**Durée:** 5 minutes  
**Public:** Tous  
**Contenu:**
- Vue d'ensemble des changements
- Quick start utilisateurs et développeurs
- Problèmes résolus
- Statistiques

**Quand le lire:** Première étape pour tout le monde

---

### 2. **CLAUDE.md** ⭐ RÉFÉRENCE ARCHITECTURE
**Durée:** 30 minutes  
**Public:** Utilisateurs avancés, Développeurs  
**Contenu:**
- Description générale du projet
- Mécanique Fatal Attraction expliquée
- Architecture détaillée
- Fonctions clés du code
- Liste des commandes
- Structure des fichiers

**Quand le lire:** Pour comprendre comment ça marche

---

### 3. **TEST_GUIDE_256.md** ⭐ VALIDATION COMPLÈTE
**Durée:** 60-90 minutes pour tous les tests  
**Public:** Testeurs QA, Raid Leaders, Développeurs  
**Contenu:**
- 12 tests fonctionnels détaillés
- 2 tests de sécurité
- Checklist de validation
- Résolution de problèmes
- Performance targets
- Feedback guidelines

**Sections par type:**
- Installation → Tests 1-2
- Fonctionnalités → Tests 3-9
- Raid réelle → Test 10
- Sécurité → Tests 11-12
- Troubleshooting → Dernière section

**Quand le lire:** Avant chaque test, après modifications de code

---

### 4. **MODERNIZATION_COMPLETE.md** ⭐ DOCUMENTATION TECHNIQUE
**Durée:** 120 minutes (complète)  
**Public:** Développeurs, Architectes  
**Contenu:**
- Résumé exécutif (5 min)
- Bugs résolus avec exemples de code (30 min)
- Améliorations de robustesse (30 min)
- Optimisations (15 min)
- Fichiers modifiés avec diff détaillé (30 min)
- Statistiques de qualité (5 min)
- Plan d'action futur (5 min)

**À lire par section:** Ne pas lire tout d'un coup, consulter par besoin

**Quand le lire:** Pour comprendre les détails techniques des changements

---

### 5. **CHANGES_SUMMARY_256.md**
**Durée:** 20 minutes  
**Public:** Développeurs, Testeurs  
**Contenu:**
- Résumé par priorité (haute/moyenne/basse)
- Fichiers affectés
- Conclusion et next steps

**Quand le lire:** Pour une vue rapide des changements

---

### 6. **WOW_256_COMPATIBILITY_ANALYSIS.md**
**Durée:** 30 minutes  
**Public:** Développeurs WoW  
**Contenu:**
- Status de chaque API utilisée
- Changements d'API par rapport aux versions antérieures
- Restrictions Blizzard 2.5.6
- Problèmes d'implémentation identifiés
- Changements recommandés par priorité

**Quand le lire:** Avant d'ajouter ou modifier des API calls

---

### 7. **DOCUMENTATION_INDEX.md** (CE FICHIER)
**Durée:** 10 minutes  
**Public:** Tous  
**Contenu:**
- Index et guide de navigation
- Par rôle/cas d'usage
- Par document
- Matrice de priorité
- Feuille de route

**Quand le lire:** Toujours premier → pour savoir quoi lire ensuite

---

## 🗺️ Matrice de Navigation

| Je veux... | Lire | Puis | Durée |
|-----------|------|------|-------|
| Installer et utiliser | README_MODERNIZATION.txt | TEST_GUIDE_256.md Tests 1-2 | 15 min |
| Utiliser les 3 modes | CLAUDE.md "Commands" | TEST_GUIDE_256.md Tests 3-5 | 30 min |
| Tester complètement | README_MODERNIZATION.txt | TEST_GUIDE_256.md Tous | 90 min |
| Comprendre l'architecture | CLAUDE.md | MODERNIZATION_COMPLETE.md | 90 min |
| Modifier le code | CLAUDE.md | MODERNIZATION_COMPLETE.md | 120 min |
| Ajouter une mécanique | CLAUDE.md | MODERNIZATION_COMPLETE.md + Code | 240 min |
| Vérifier la compatibilité 2.5.6 | WOW_256_COMPATIBILITY_ANALYSIS.md | - | 30 min |
| Déboguer un problème | TEST_GUIDE_256.md Troubleshooting | MODERNIZATION_COMPLETE.md | 30-60 min |

---

## 🎯 Roadmap de Lecture par Rôle

### 👤 Utilisateur Final
```
1. README_MODERNIZATION.txt           (5 min) ✅
2. TEST_GUIDE_256.md "Préparation"    (10 min) ✅
3. Lancer le jeu et tester            (15 min) ✅
4. Garder CLAUDE.md comme référence   (offline)

TOTAL: 30 minutes
```

### 🧪 QA/Testeur
```
1. README_MODERNIZATION.txt           (5 min)
2. TEST_GUIDE_256.md (complet)        (90 min)  ← CRITICAL
3. MODERNIZATION_COMPLETE.md (résumé) (10 min)
4. Exécuter tous les tests            (120 min)

TOTAL: 225 minutes (~4 heures)
```

### 👨‍💻 Développeur WoW
```
1. README_MODERNIZATION.txt           (5 min)
2. CLAUDE.md (complet)                (30 min)
3. MODERNIZATION_COMPLETE.md          (60 min)  ← CRITICAL
4. WOW_256_COMPATIBILITY_ANALYSIS.md  (30 min)
5. Code source + TEST_GUIDE_256.md    (60+ min)

TOTAL: 185+ minutes (~3 heures)
```

### 🏗️ Architect/Futur Développeur
```
1. README_MODERNIZATION.txt           (5 min)
2. CLAUDE.md (complet)                (30 min)
3. MODERNIZATION_COMPLETE.md (complet)(120 min) ← CRITICAL
4. WOW_256_COMPATIBILITY_ANALYSIS.md  (30 min)
5. Code source étudié en détail       (120+ min)
6. TEST_GUIDE_256.md (complet)        (90 min)

TOTAL: 395+ minutes (~7 heures)
```

---

## 🔄 Flux de Travail

### Pour un Nouveau Développeur
```
README_MODERNIZATION.txt
        ↓
CLAUDE.md (architecture)
        ↓
MODERNIZATION_COMPLETE.md (détails)
        ↓
Code source (MotherDirection.lua)
        ↓
TEST_GUIDE_256.md (validation)
```

### Pour une Modification de Code
```
Identifier la modification requise
        ↓
Lire section pertinente de CLAUDE.md
        ↓
Vérifier WOW_256_COMPATIBILITY_ANALYSIS.md
        ↓
Lire section pertinente de MODERNIZATION_COMPLETE.md
        ↓
Modifier le code
        ↓
Exécuter TEST_GUIDE_256.md section pertinente
        ↓
Commit avec documentation
```

### Pour un Rapport de Bug
```
Exécuter TEST_GUIDE_256.md
        ↓
Identifier quel test échoue
        ↓
Noter numéro du test + étapes + résultat attendu
        ↓
Créer issue avec:
   - Numéro du test
   - Étapes précises
   - Résultat obtenu
   - Version WoW et locale
```

---

## 📋 Priorités de Lecture

### HAUTE PRIORITÉ (Obligatoire)
- [x] README_MODERNIZATION.txt
- [x] CLAUDE.md (architecture)
- [x] TEST_GUIDE_256.md (pour testeurs/devs)

### MOYENNE PRIORITÉ (Fortement Recommandé)
- [x] MODERNIZATION_COMPLETE.md
- [x] CHANGES_SUMMARY_256.md

### BASSE PRIORITÉ (Référence)
- [x] WOW_256_COMPATIBILITY_ANALYSIS.md (pour devs WoW)
- [x] DOCUMENTATION_INDEX.md (ce fichier)

---

## 🆘 Besoin d'Aide?

### Question d'Installation
→ TEST_GUIDE_256.md → "Préparation" + "Résolution de Problèmes"

### Question d'Utilisation
→ CLAUDE.md → "Commands" + "Display Modes"

### Question Technique
→ MODERNIZATION_COMPLETE.md + CLAUDE.md architecture

### Question de Compatibility 2.5.6
→ WOW_256_COMPATIBILITY_ANALYSIS.md

### Besoin de Tester
→ TEST_GUIDE_256.md (tous les tests)

### Besoin de Déboguer
→ TEST_GUIDE_256.md → "Résolution de Problèmes"

---

## ✅ Checklist: Suis-je Prêt?

### Pour Utiliser l'Addon
- [ ] J'ai lu README_MODERNIZATION.txt
- [ ] J'ai installé l'addon correctement
- [ ] J'ai exécuté `/md` pour voir les commandes
- [ ] Je sais comment changer de mode (static/dynamic/compass)

### Pour Tester
- [ ] J'ai lu TEST_GUIDE_256.md complètement
- [ ] J'ai une copie de la checklist
- [ ] J'ai accès au jeu WoW TBC 2.5.6
- [ ] Je suis prêt à exécuter les 14 tests

### Pour Développer
- [ ] J'ai lu CLAUDE.md complètement
- [ ] J'ai lu MODERNIZATION_COMPLETE.md section pertinente
- [ ] J'ai consulté WOW_256_COMPATIBILITY_ANALYSIS.md
- [ ] J'ai compris la structure du code
- [ ] Je sais quels tests exécuter après modification

---

## 🎓 Ressources Supplémentaires

### Documentation Interne
- `CLAUDE.md` - Architecture générale
- `TEST_GUIDE_256.md` - Procédures de test
- Tous les fichiers de documentation du projet

### Code Source
- `MotherDirection.lua` - Logique principale
- `MotherDirection.xml` - Définition UI
- `localization.lua` - Textes multilingues

### Fichiers Créés pour 2.5.6
- `MODERNIZATION_COMPLETE.md` - Doc technique
- `CHANGES_SUMMARY_256.md` - Résumé changements
- `WOW_256_COMPATIBILITY_ANALYSIS.md` - Analyse API
- `README_MODERNIZATION.txt` - Guide rapide
- `TEST_GUIDE_256.md` - Procédures de test
- `DOCUMENTATION_INDEX.md` - Ce fichier!

---

**Version:** 2.5.6.1  
**Status:** ✅ Modernisation Complète  
**Dernière mise à jour:** 11 juillet 2026

---

*Besoin d'aide? Commencez par le document correspondant à votre rôle ci-dessus!*
