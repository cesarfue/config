---
name: ai-optimizer
description: >-
  Utilisé en fin de tâche quand un agent a rencontré des problèmes : fichiers non commités,
  tests non passés, mauvais répertoire, CI ratée, etc. Analyse les patterns d'échec et met
  à jour le harness (autonomous-task.md) pour éviter que le même problème se répète.
---

# AI Optimizer — Amélioration du harness agent

Invoqué quand un agent a terminé une tâche en laissant des problèmes. Objectif : identifier la cause racine et patcher le protocole.

## Déclencheurs typiques

- Agent n'a pas commité ses changements, ou n'a pas poussé sa branche
- Agent a travaillé dans le checkout principal au lieu du worktree
- Checks du profil non lancés (tests/CI côté code ; validate/plan/scan côté infra)
- Agent n'a pas rempli le compte rendu dans la note de tâche
- Commit fait après un merge (trop tard)
- Étape de génération/build propre à la stack oubliée (ex. codegen, install de deps)
- **Profil infra** : `plan` non joint au compte rendu, `apply` lancé en autonomie,
  secret committé en clair, scan de sécurité (tfsec/checkov/trivy) non exécuté

## Protocole

### 1. Identifier le problème

Lire la note de tâche (`~/vault/projects/<project>/tasks/<slug>.md`) section `## Compte rendu`. Si vide ou incomplète, inférer depuis le git log et le git status.

Identifier :
- Quelle étape du protocole a été ratée ?
- Pourquoi ? (formulation ambiguë, étape manquante, ordre incorrect, oubli documenté ?)

### 2. Diagnostiquer l'anti-pattern

Comparer avec les anti-patterns listés dans `~/.config/claude/rules/autonomous-task.md`. Si le problème est déjà documenté → l'étape correspondante est insuffisamment contraignante. Si nouveau → nouveau pattern à documenter.

### 3. Patcher le harness

Modifier `~/.config/claude/rules/autonomous-task.md` :
- Renforcer la formulation de l'étape défaillante (plus explicite, vérification concrète)
- Ajouter le nouvel anti-pattern dans la section dédiée
- Si une vérification peut être rendue impérative (commande à lancer, output à vérifier) : l'ajouter en bloc de code

### 4. Documenter dans le vault

Ajouter une entrée dans `~/vault/projects/<project>/decisions.md` :
```
## <date> — Harness : <problème rencontré>

<Description du problème, quelle tâche, quel agent>
<Cause racine>
<Fix appliqué dans autonomous-task.md>
```

### 5. Nettoyer si nécessaire

Si des changements non commités traînent dans le checkout principal ou un worktree :
- Vérifier avec `git status` et `git worktree list`
- Commiter ou stasher proprement
- Ne pas supprimer sans comprendre l'origine

## Principes

- **Ne pas blâmer** : un agent qui rate une étape, c'est une spec ambiguë ou une étape mal placée.
- **Chaque échec = une amélioration** : l'optimizer n'est utile que s'il modifie le harness.
- **Vérifications concrètes > recommandations vagues** : `git diff --cached --stat` vaut mieux que "vérifier que le commit est fait".
