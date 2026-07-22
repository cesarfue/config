---
name: product-owner
description: >-
  Utilisé quand on définit ensemble une tâche à confier à un agent. Génère les specs
  et critères d'acceptance comme un PO, et crée la note de tâche dans le vault.
  À invoquer AVANT de lancer l'agent.
---

# Product Owner — Définition de tâche

Quand l'utilisateur décrit une fonctionnalité ou un bug à corriger, applique ce protocole avant de créer la note de tâche.

## 1. Comprendre l'intention

Reformule en une phrase ce que l'utilisateur veut vraiment obtenir (résultat final, pas implémentation). Valide avec lui si c'est flou.

## 2. Rédiger la note de tâche

Crée `~/vault/projects/<project>/tasks/<slug>.md` avec les sections suivantes :

```markdown
# <Titre de la tâche>

## Contexte

Pourquoi cette tâche existe, ce qu'elle touche dans le produit.

## User story

En tant que [utilisateur], quand [situation], je veux [action] afin de [bénéfice].

## Specs

Liste numérotée des comportements attendus. Chaque item doit être vérifiable :
- précis sur l'entrée et la sortie observables
- couvre les cas nominaux ET les cas limites prévisibles
- indique les valeurs par défaut si pertinent

## Hors scope

Ce que l'agent ne doit PAS toucher ou implémenter dans cette tâche.

## Definition of done

Checklist que l'agent coche avant de se déclarer terminé :
- [ ] Les comportements décrits dans les Specs sont implémentés
- [ ] Les tests couvrent les cas clés (si applicable)
- [ ] Les checks du profil passent (cf. `rules/autonomous-task.md`)
- [ ] Le code est commité et la branche poussée
- [ ] Ce compte rendu est rempli

## Compte rendu

*(rempli par l'agent à la fin)*

- Fichiers modifiés :
- Décisions prises :
- Écarts par rapport aux specs :
- Résultats CI :
```

## 3. Mettre à jour tasks.md

Ajouter dans `tasks.md` :
```
- [ ] <Description courte> #<project> → [[tasks/<slug>]]
```

## 4. Briefer l'agent

Dans le prompt de l'agent :
- Donner le chemin exact de la note de tâche
- Lui rappeler qu'il doit remplir la section `## Compte rendu` avant de finir
- Lui rappeler le protocole `rules/autonomous-task.md` (worktree + branche depuis
  `origin/main`, checks du profil du repo — code ou infra, commit, push branche). Le bloc
  de protocole à copier dans le prompt est fourni en fin de `autonomous-task.md`.

## Principes PO à garder en tête

- **Valeur d'abord** : chaque spec doit répondre à un besoin réel, pas à une hypothèse technique.
- **Pas d'over-spec** : ne pas décrire l'implémentation, décrire l'effet observable.
- **Hors scope explicite** : ce qui n'est pas dans la note ne sera pas fait. Mieux vaut trop préciser que trop vague.
- **DoD vérifiable** : si l'agent ne peut pas cocher un critère objectivement, reformuler.

---

## Points de vigilance par domaine

Selon ce que touche la tâche, certains domaines méritent une checklist dédiée dans les
specs. L'authentification en est un exemple type ; en ajouter d'autres au besoin.

### Authentification — checklist obligatoire

Dès qu'une tâche touche à l'auth, les specs DOIVENT couvrir ces points explicitement. Si l'un manque, demander à l'utilisateur avant de rédiger.

**Persistence**
- [ ] Reload page (F5) → utilisateur toujours connecté
- [ ] Fermer/rouvrir l'onglet → utilisateur toujours connecté
- [ ] Token expiré → redirection vers login propre (pas d'écran blanc/erreur)

**Méthodes de connexion — toujours demander à l'utilisateur :**
- Quels providers OAuth (Google, GitHub…) ?
- Auth email + mot de passe ? Si oui : register + login + reset password ?
- Accès anonyme autorisé ou tout protégé ?

**Flows à vérifier end-to-end :**
- Utilisateur non connecté → redirigé vers login (pas de flash de contenu)
- Connexion réussie → redirigé vers la page d'origine
- Après login → les features protégées fonctionnent (ex : sauvegarder une annonce, accéder à son profil)
- Déconnexion → token supprimé, redirect login

**À mettre dans le DoD (pas optionnel) :**
- [ ] Testé : login → reload → toujours connecté
- [ ] Testé : feature protégée (ex : save) fonctionne après login
- [ ] Testé : utilisateur non connecté → redirigé, pas d'erreur 401 silencieuse
