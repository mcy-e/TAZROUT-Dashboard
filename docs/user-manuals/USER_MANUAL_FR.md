# Tazrout Dashboard — Manuel d'utilisation
**Version 2.0 | Système de surveillance d'irrigation intelligente**

---

## Qu'est-ce que Tazrout ?

Tazrout est une application de bureau qui vous permet de surveiller et contrôler votre système d'irrigation intelligente en temps réel. Elle affiche les données des capteurs de vos zones agricoles, les décisions d'irrigation générées par l'IA, et vous permet de gérer les paramètres du système — le tout depuis un seul écran.

L'application fonctionne sur votre ordinateur local et communique directement avec vos appareils de terrain via votre réseau local. Aucune connexion internet n'est requise.

---

## Démarrage

Lorsque vous ouvrez l'application, l'**écran Accueil** se charge automatiquement. La barre latérale gauche affiche le menu de navigation. Cliquez sur un élément pour changer d'écran. Cliquez sur l'icône menu (☰) en haut de la barre latérale pour la réduire ou l'agrandir.

---

## Écrans

### 1. Accueil

Le tableau de bord principal. Affiche une vue d'ensemble en direct de votre système.

**Contrôles système (haut gauche)**
- **REDÉMARRER** — Redémarre le système. Une boîte de dialogue de confirmation apparaît avant l'exécution. L'icône tourne pendant le redémarrage.
- **ARRÊTER** — Éteint le système. Nécessite également une confirmation.

**Carte de bienvenue (haut centre)**
- Affiche l'état de santé du système. Lorsque toutes les zones fonctionnent normalement, une icône verte et le message "Bon retour !" s'affichent.
- Si une zone se déconnecte ou qu'une lecture critique est détectée, l'icône passe à l'orange et le message se met à jour.

**Le saviez-vous ? (haut droite)**
- Affiche un fait agricole. La valeur en pourcentage est mise en évidence en vert.

**Moniteur de performance (bas gauche)**
- Affiche les données des capteurs en quatre mini-graphiques :
  - **Débit d'eau** — pourcentage de débit actuel
  - **Humidité du sol** — humidité en g/m³
  - **Température** — température actuelle en °C
  - **Humidité de l'air** — pourcentage d'humidité
- Survolez une sous-carte pour la mettre en évidence.

**Horloge (bas droite, haut)**
- Horloge analogique en direct avec affichage numérique en dessous.

**Calendrier (bas droite, bas)**
- Affiche la date du jour.

---

### 2. Zones

Affiche toutes vos zones agricoles sous forme de cartes en grille à 3 colonnes.

**Carte réduite** — affiche le nom de la zone et un symbole décoratif. Cliquez sur **AFFICHER LES STATS** pour développer.

**Carte développée** affiche :
- **État de l'appareil** — EN LIGNE (vert) ou HORS LIGNE (rouge)
- **T : C°** — température actuelle
- **M : g/m³** — humidité du sol
- **Eau : %** — niveau d'eau
- **État de la vanne** — OUVERTE (goutte bleue) ou FERMÉE (cadenas)
- Cliquez sur **MASQUER LES STATS** pour réduire.

Les zones en ligne ont une bordure verte en haut. Les zones hors ligne ont une bordure rouge.

---

### 3. Analytiques

Affiche les données historiques et les décisions de l'IA.

**Dernière décision IA** — l'action la plus récente prise par le moteur d'IA.

**Observation** — quelque chose que l'IA a détecté dans les données des capteurs.

**Recommandation** — une action pratique suggérée pour l'agriculteur.

**Graphique d'utilisation de l'eau** — graphique à barres de la consommation d'eau. Basculez entre Jour / Mois / Année.

**Journal des décisions** — tableau de toutes les décisions IA. Filtrez par : Tout / Irrigation / Alertes / Conseils.

**Statistiques environnementales** — graphique linéaire montrant la température (rouge) et l'humidité (bleu) dans le temps.

**Consommation par zone** — graphique à barres empilées par zone. Basculez entre Jour / Semaine / Mois.

---

### 4. Contrôle d'urgence

Utilisez cet écran pour surveiller les états des appareils et déclencher un arrêt d'urgence.

**Grille d'état des zones** — affiche toutes les zones avec des badges EN LIGNE (point vert) ou HORS LIGNE (point rouge).

**Bouton d'arrêt d'urgence**
- Grand bouton rouge en bas de l'écran : **A R R Ê T  D ' U R G E N C E**
- Une boîte de dialogue de confirmation apparaît avant l'envoi du signal d'arrêt.
- **N'appuyez sur ce bouton qu'en cas de véritable urgence.**

L'élément Urgence dans la barre latérale affiche un point rouge lorsqu'une zone est hors ligne.

---

### 5. Paramètres

**Paramètres d'affichage**
| Paramètre | Options |
|---|---|
| Langue | EN / FR / AR |
| Thème | Clair / Sombre |
| Taille de police | Petit / Moyen / Grand |
| Format de date | JJ/MM/AAAA / MM/JJ/AAAA / AAAA-MM-JJ |
| Format d'heure | 24H / 12H |

**Paramètres système**
| Paramètre | Options |
|---|---|
| Économie d'énergie | Activé / Désactivé |
| Minuterie de veille automatique | 5 / 10 / 15 / 30 minutes / Jamais |
| Animations UI | Activé / Désactivé |

**Paramètres de notification**
| Paramètre | Options |
|---|---|
| Alertes sonores | Activé / Désactivé |

- **Réinitialiser** — remet tous les paramètres aux valeurs d'usine.
- **Appliquer les paramètres** — enregistre et applique immédiatement tous les changements.

---

### 6. Centre d'aide

**Système hors ligne ?** — Vérifiez l'alimentation de la passerelle et la connexion au réseau local.

**Lectures erratiques ?** — Un étalonnage du capteur peut être nécessaire. Inspectez la zone concernée.

**Données non synchronisées ?** — Vérifiez votre réseau local. Les données se mettront à jour une fois la connexion rétablie.

**Accès refusé ?** — Contactez votre administrateur système.

**Obtenir de l'aide** — Ouvre une carte de contact avec un code QR, un site web d'assistance et un numéro de téléphone. Cliquez sur × ou en dehors de la carte pour fermer.

---

### 7. Manuel utilisateur

Affiche la documentation dans l'application. La version et la date de dernière mise à jour sont affichées en bas.

---

## Notifications

Les notifications apparaissent depuis le coin supérieur droit de l'écran.

- **Bordure orange** — alerte capteur (zone hors ligne ou lecture critique)
- **Bordure bleue** — décision IA (irrigation déclenchée automatiquement)

Les notifications disparaissent automatiquement après 5 secondes. Cliquez sur × pour fermer manuellement.

---

## Mode veille

Si aucun mouvement de souris ou toucher n'est détecté pendant la durée définie dans Paramètres > Minuterie de veille, l'écran s'assombrit. Bouger la souris ou toucher l'écran le réveille immédiatement.

---

## Thème et langue

Allez dans **Paramètres → modifiez le réglage → Appliquer les paramètres**. Le thème et la langue s'appliquent immédiatement lorsque vous appuyez sur Appliquer.
