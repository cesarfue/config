---
name: obsidian-management
description: >-
  Organisation et rangement du vault Obsidian (~/vault) : où placer une note, regrouper
  les notes d'un projet dans son dossier, déplacer les tâches, décider où vivent les
  décisions (ADR en repo vs decisions.md local), créer/renommer/archiver des notes. À
  utiliser dès qu'on range le vault, qu'on crée un dossier de projet, qu'on déplace des
  notes en masse, ou qu'on se demande « où va cette note / cette décision ? ». Ne PAS
  utiliser pour le contenu métier d'une note (ça, c'est le travail projet) — seulement
  pour sa place et l'hygiène du vault.
---

# Gestion du vault Obsidian

Le vault vit dans `~/vault`. Ce skill décrit **où** ranger les choses et **comment**
réorganiser sans casser. Le layout always-on est rappelé dans le `CLAUDE.md` global ;
ici, le workflow détaillé.

## Layout par projet

```
~/vault/
  projects/<projet>/
    <projet>.md            ← note hub (point d'entrée du projet)
    decisions.md           ← décisions — SEULEMENT si le projet n'a pas d'ADR en repo (voir plus bas)
    Taches/<nom_tache>.md  ← une note par tâche/ticket
    <sujet>.md             ← notes thématiques/référence, à la racine du dossier projet
  Notes/                   ← connaissance globale, transférable, à plat
  Journal/ Templates/ Excalidraw/   ← existant de l'utilisateur — NE PAS toucher
```

## Où va une note ?

- **Transférable** (fait technique, pattern, recette, usage de lib, indépendant d'un projet) → `Notes/<sujet>.md`.
- **Spécifique à un projet** → `projects/<projet>/`.
  - **Tâche / ticket** (préfixe `ACR-`, `EP-`, `CP-`, `DEP-`, ou une action datée) → `projects/<projet>/Taches/`.
  - **Note thématique / référence / plan / archi** → à la racine `projects/<projet>/`.
  - **Note pivot** du projet → `projects/<projet>/<projet>.md` (overview + liens Dataview + requête des tâches).
- **Ambigu / cross-projet** (touche deux projets, ou incertain) → laisser où c'est et **demander** à l'utilisateur avant de déplacer. Sous-classer plutôt que déplacer à tort.

## Décisions : ADR en repo vs decisions.md local (règle importante)

Les décisions vivent **là où est la source de vérité du projet** :

- **Projet adossé à un repo avec des ADR** (cas d'accoreboot : `docs/adr/`, ~79 ADR ; et accoreboot-infra : `docs/adr/`, ~31 ADR) → les décisions sont les **ADR versionnés dans le repo**, partagés avec l'équipe. Obsidian **ne duplique pas** : pas de `decisions.md` canonique dans le dossier projet ; la note hub **pointe** vers `docs/adr/` du repo. Dupliquer crée de la dérive et viole la doctrine « le repo possède ses spécificités ».
- **Projet perso sans repo/ADR** → `projects/<projet>/decisions.md` local dans le vault est le bon foyer (entrées datées, append-only, le *pourquoi* pas seulement le *quoi*).

En clair : ne jamais recopier les ADR d'un repo dans le vault. Pour un projet perso, le vault EST la mémoire des décisions.

## Réorganiser sans rien casser (méthode)

- **Les liens sont sûrs au déplacement** : Obsidian résout les `[[wikilinks]]` par **nom de fichier** (`alwaysUpdateLinks` activé, format wikilink). Déplacer une note ne casse pas ses liens **tant que le nom reste unique** — ne pas renommer en même temps qu'on déplace.
- **Classer avant de bouger** : lire le **contenu** de la note (pas seulement le titre) pour trancher projet/thème/tâche. Sur un gros lot, déléguer le tri de lecture à un agent (`Explore`) puis exécuter les déplacements.
- **Garde-fou sur les lots** : construire la liste des fichiers à déplacer, en compter le total, et n'exécuter le `mv` que si le compte est dans une plage attendue (évite un déplacement massif sur un glob qui a mal matché).
- **git du vault** : la plupart des notes de `Notes/` ne sont **pas** suivies par git → utiliser un `mv` de fichiers classique (le `git mv` échoue sur les fichiers non suivis). **Ne pas commiter le vault** : l'utilisateur le synchronise via Obsidian.
- **zsh** : les variables non quotées ne sont pas découpées et un glob sans correspondance lève une erreur — préférer des tableaux et `find … -name` aux boucles `for f in *.glob`.

## Frontmatter (comme les notes existantes, style Zettelkasten)

```yaml
---
created: YYYY-MM-DD
in: "[[<projet>]]"     # pour une note projet, pointer vers le hub
tags: [<projet>]
---
```

## Anti-patterns

- Déplacer un lot sur le seul titre, sans lire le contenu → mauvais classement, notes perdues.
- Recopier/maintenir dans Obsidian des décisions qui ont déjà leurs ADR en repo → dérive garantie.
- Renommer une note en la déplaçant → risque de casser un lien par nom.
- Toucher `Journal/`, `Templates/`, `Excalidraw/`.
- Commiter le vault à la place de l'utilisateur.
