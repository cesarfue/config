---
name: ai-optimizer
description: >-
  À utiliser dès qu'une étape du workflow a été oubliée ou mal faite — qu'un agent délégué n'ait
  pas fait ce qu'il devait, ou que je rate moi-même une étape. Couvre toutes les surfaces :
  tâche autonome (branche/worktree/commit/push/PR), checks de profil code/infra, revue,
  définition de tâche, commits, ET le rangement/management du vault Obsidian (note mal rangée,
  hub qui dérive, décision dupliquée, mauvais régime de suivi de tâches). Analyse la cause racine
  et patche la surface de workflow concernée (protocole, skill, rule ou CLAUDE.md) pour que ça ne
  se reproduise pas. Ne PAS utiliser pour corriger un bug métier — seulement pour combler une
  lacune du workflow lui-même.
---

# AI Optimizer — combler les lacunes du workflow

Invoqué quand une étape du workflow a été ratée (par un sous-agent ou par moi-même). Objectif :
identifier la cause racine et **patcher la bonne surface de workflow** pour que l'erreur ne se
répète pas. Le principe : un échec n'est jamais « la faute de l'agent », c'est une spec ambiguë ou
une étape mal placée dans le workflow — donc c'est le workflow qu'on corrige.

## Carte des surfaces — quoi patcher selon la lacune

| Lacune constatée | Surface à patcher |
|---|---|
| Tâche autonome : branche/worktree, base `origin/main`, commit, push, PR, compte rendu | `rules/autonomous-task.md` |
| Checks de profil — code (`/simplify`, revue, CI locale) ou infra (validate/`plan`/scan/sécurité) | `rules/autonomous-task.md` (commandes concrètes → `CLAUDE.md` du repo) |
| Politique de PR / profil (code vs infra) d'un repo | `rules/repos.md` |
| Rangement du vault, modèle de hub, types de dossier, décisions ADR-vs-local, régimes de tâches Obsidian/Jira | `skills/obsidian-management/SKILL.md` |
| Cycle simplify + revue | `skills/reviewer/SKILL.md` |
| Définition d'une tâche / note de tâche | `skills/product-owner/SKILL.md` |
| Messages de commit, posture d'implémentation | `rules/git-commits.md`, `rules/implementation.md` |
| Fait transverse always-on, ou règle qui peut surgir n'importe où | `CLAUDE.md` |

**Règle de placement** : patcher la surface **la plus spécifique** qui possède l'étape ratée. Ne
pas dupliquer une même règle dans plusieurs surfaces. Ne remonter au `CLAUDE.md` que si le retour
peut surgir partout (sinon il reste dans la surface concernée).

## Déclencheurs typiques

**Tâche autonome / code / infra**
- Agent n'a pas commité, ou n'a pas poussé sa branche
- A travaillé dans le checkout principal au lieu du worktree
- Checks du profil non lancés (tests/CI côté code ; validate/`plan`/scan côté infra)
- Compte rendu non rempli dans la note de tâche ; commit fait après un merge
- Étape de génération/build propre à la stack oubliée (codegen, install de deps)
- **Infra** : `plan` non joint, `apply`/`up`/`down` lancé en autonomie, secret committé en clair, scan sécurité non exécuté

**Management du vault Obsidian**
- Note laissée à la racine d'un dossier projet, ou rangée dans le mauvais type
- Hub transformé en journal ou en backlog recopiant Jira (au lieu de rester stable + renvoyer à la source de vérité)
- Décision dupliquée dans le vault alors que l'ADR du repo fait foi
- Tâches suivies dans Obsidian alors que Jira fait foi (ou l'inverse pour un projet perso)
- Lien cassé après un déplacement/renommage sans alias

## Protocole

### 1. Identifier l'étape ratée
Depuis la note de tâche (`~/vault/projects/<projet>/tasks/<slug>.md`, section `## Compte rendu`),
le compte rendu de l'agent, le `git log`/`git status`, ou l'échange en cours. Déterminer : quelle
étape a été ratée, et pourquoi (formulation ambiguë, étape manquante, ordre incorrect, oubli).

### 2. Diagnostiquer l'anti-pattern
Localiser la surface concernée via la carte ci-dessus, puis comparer aux anti-patterns qu'elle
liste déjà. Déjà documenté → l'étape est insuffisamment contraignante. Nouveau → à documenter.

### 3. Patcher la bonne surface
Dans l'artefact désigné par la carte :
- Renforcer la formulation de l'étape défaillante (plus explicite).
- Ajouter le nouvel anti-pattern dans sa section dédiée.
- Rendre la vérification **impérative** avec une commande concrète quand c'est possible
  (`git diff --cached --stat`, `ls projects/<projet>/*.md` doit renvoyer 1 seul fichier, etc.).

### 4. Tracer le correctif
Les skills/rules sont versionnés dans `~/.config`. Committer le patch avec un message clair
(`refactor(claude): …` / `chore(claude): …`) — le commit **est** le journal d'amélioration. Ne pas
pousser (l'utilisateur pousse).

### 5. Nettoyer les résidus
Changements non commités qui traînent (checkout principal, worktree) : vérifier `git status` et
`git worktree list`, commiter/stasher proprement, ne rien supprimer sans comprendre l'origine.

## Principes

- **Ne pas blâmer** : un agent qui rate une étape révèle une spec ambiguë ou une étape mal placée.
- **Chaque échec = une amélioration** : l'optimizer n'est utile que s'il modifie une surface.
- **Vérifications concrètes > recommandations vagues** : une commande à lancer vaut mieux que « vérifier que… ».
- **Surface la plus spécifique** : corriger là où vit l'étape, sans dupliquer ailleurs.
- **Démarcation avec `capitalize`** (skill accopilot) : `capitalize` pérennise des *feedbacks récurrents* en les remontant sur une échelle de fiabilité ; `ai-optimizer` vise une *étape de workflow ratée* et patche la surface qui la porte. Complémentaires, pas redondants.
