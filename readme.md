# Rapport : PFA

## Rapport de Projet : PFA
**Paulhiac Kaiji, Leroy Antonin**  
**2024-2025**

---

## Vue générale

Le rythme général du développement consistait à discuter de quoi faire pendant les séances de PFA organisées par le professeur, et de s’y mettre à coder quand on était arrivé chez soi.

Nous avons pendant très longtemps pas eu accès à une démo de ce qu’on programmait : cela n’était pas bon pour le moral, et on doutait fréquemment de ce qu’on écrivait.

L’objectif de notre projet n’était pas de créer un jeu vidéo avec un game-design intéressant, mais de créer un programme qui possède un code “intéressant” (l’aspect game-design du jeu a été quasi-négligé).

Malheureusement, pour des raisons personnelles, Leroy Antonin a eu très peu d'inputs sur le projet la majorité du temps (Antonin a pu y mettre plus de travail vers la dernière semaine) : la majorité du travail a été effectuée par Paulhiac Kaiji.

Il y eut aussi quelques frustrations sur le niveau de qualité pauvre de la communication entre nous : Antonin a souvent eu du mal à communiquer son avancée avec Kaiji.

Nous avions aussi créé un deuxième dépôt Git au lieu de mettre à jour le premier.

---

## Généralité sur la structure du code

Le projet est basé sur le TP3 se trouvant sur la page du professeur chargé du projet.

Le programme comporte en plus ces 3 systèmes :
- Système de dégât (“Destruction system”)
- Système d'IA (“IA system”)
- Système de physique naïve/très simple (“Physics system”)

Il comporte aussi quelques classes en plus, qui servent principalement à faire la démonstration de ces 3 systèmes :
- Les blocs
- 1 classe d’ennemi possédant une IA simpliste
- 1 joueur
- Des balles à tirer pour le joueur
- 1 classe “viseur” qui permet au joueur de viser où tirer ses balles

Plusieurs fichiers ont été retravaillés pour être adaptés à ce qu’on voulait faire : hormis le fichier `cst.ml`, `input.ml` et `game.ml`, `global.ml` a été assez lourdement retravaillé.

---

## Les 3 nouveaux systèmes

Nous allons discuter des 3 nouveaux systèmes :

### Physics

Très simpliste (voir absurde), le système de Physics se contente juste de faire chuter avec une vitesse croissante toutes les instances inscrites auprès d’elle.  
Elle utilise principalement 2 variables : `position` et `masse`.

### Destruction

Ce système se base sur les concepts de “Hurtbox” et “Hitbox” dans les jeux vidéo :
- **Hurtbox** : zone dans laquelle il faut taper pour infliger des dégâts
- **Hitbox** : zone qui inflige des dégâts quand une Hurtbox entre en contact avec

Cependant, si jamais les points de vie chutent à 0, ce n’est pas à ce système de gérer la “mort” de l’instance : c’est à d’autres systèmes de le faire dans notre programme. Généralement, c’est au système d’IA de gérer ça.

Chaque Hitbox possède une valeur fixe `damage` qui indique combien de dégâts elle inflige à une Hurtbox.  
Chaque Hurtbox possède une variable `healthPoint` qui diminue quand elle se prend des dégâts.

Chaque instance de Destruction possède obligatoirement une Hitbox et une Hurtbox.

Les instances de Destruction possèdent aussi :
- Une liste `protectedTag`
- Une constante `tag`
Une Hitbox ne peut pas infliger de dégâts à une Hurtbox possédant un `tag` se trouvant dans sa liste `protectedTag`.

Le système possède aussi deux variables `relativeHitbox` et `relativeHurtbox` (non utilisées) pour décaler la position des hitbox/hurtbox par rapport aux coordonnées de l’instance.

### IA

C’est le système le plus complexe ajouté :
- Chaque instance est munie d'une fonction `stateMachine` basée sur une variable `behavior` (entier) pour exécuter différents comportements :
  - Ex : un ennemi peut attaquer ou rester statique selon `behavior`
- Chaque instance IA possède un `id` unique pour l’identifier facilement.
- Une fonction `unregister` permet à une IA de se détruire proprement en se retirant de tous les systèmes.

---

## Instances des systèmes

### Player
- Fonctionne avec les systèmes : Physics, Collision, Destruction, Move, Draw
- Indestructible même si ses points de vie passent à zéro.
- Ses mouvements et son action de tir sont contrôlés par `input.ml`.
- Peut sauter.

### Drone
- Fonctionne avec : Destruction, Move, Draw, IA
- IA basique : approche du joueur s'il est proche, sinon reste statique.
- Peut être détruit et inflige des dégâts au contact.
- Ne possède pas de système de Collision.

### Bullet
- Fonctionne avec : Destruction, Move, Draw, IA
- IA utilisée pour gérer ses mouvements et sa destruction après un impact.
- Un timer global limite la fréquence de tir du joueur.

### Block
- Fonctionne avec : Collision, Draw
- Plateforme pour le joueur : il peut sauter dessus.

### Crosshair
- Fonctionne avec : Move, Draw
- Permet au joueur de viser avec son arme à feu.

---

## Fonctionnalités retirées

Un système de sauvegarde avait été prévu et développé, mais a été abandonné pour deux raisons :
- Absence d'une démo stable : pas envie de bâtir sur des bases incertaines.
- La structure actuelle du code rend le système de sauvegarde complexe à mettre en œuvre.

---

## Remarques

Le code pour créer les instances d’IA n’est pas très propre : beaucoup de variables inutiles dans les fichiers concernés.
