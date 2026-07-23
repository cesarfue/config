---
name: obsidian-management
description: >-
  Organisation et rangement du vault Obsidian (~/vault) : où placer une note, structurer un
  dossier projet (hub + sous-dossiers par type), déplacer/ranger les notes, décider où vivent
  les décisions (ADR en repo vs decisions/ local) et le suivi des tâches (Obsidian vs Jira),
  créer/renommer/archiver des notes. À utiliser dès qu'on range le vault, qu'on crée un dossier
  de projet, qu'on déplace des notes en masse, ou qu'on se demande « où va cette note / cette
  décision / cette tâche ? ». Ne PAS utiliser pour le contenu métier d'une note (ça, c'est le
  travail projet) — seulement pour sa place et l'hygiène du vault.
---

# Gestion du vault Obsidian

Le vault vit dans `~/vault`. Ce skill décrit **où** ranger les choses et **comment** réorganiser
sans casser. Le layout always-on est rappelé dans le `CLAUDE.md` global ; ici, le détail.

## Layout par projet

À la racine d'un dossier projet, **seule la note-hub** ; tout le reste est rangé dans un
sous-dossier **par type**.

```
~/vault/
  projects/<projet>/
    <projet>.md          ← note-hub, SEUL fichier à la racine (nom = dossier)
    tasks/               ← une note par tâche/ticket
    decisions/           ← ADR/arbitrages : un choix tranché (ou explicitement à trancher), contexte + options + décision
    etudes/              ← exploratoire : analyses, comparatifs, POC, mesures, investigations, preuves, notes d'apprentissage, fiches doc externe (fournisseur…)
    plans/               ← feuilles de route et specs séquencées (quoi, dans quel ordre)
    presentations/       ← supports destinés à être présentés (decks, plans de slides)
  Notes/                 ← connaissance globale, transférable, à plat
  Journal/ Templates/ Excalidraw/   ← existant de l'utilisateur — NE PAS toucher
```

Les sous-dossiers de type ne sont créés **que s'ils ont du contenu** (pas de dossier vide).
`archive` est un **tag**, pas un dossier.

## Où va une note ?

- **Transférable** (fait technique, pattern, recette, usage de lib, indépendant d'un projet) → `Notes/<sujet>.md`.
- **Spécifique à un projet** → `projects/<projet>/<type>/` selon le type ci-dessus. En cas de doute entre `etudes/` (comprendre) et `decisions/` (trancher) : si l'objet est un choix, c'est `decisions/`.
- **Ambigu / cross-projet** → laisser où c'est et **demander** avant de déplacer. Sous-classer plutôt que déplacer à tort.

## Note-hub — modèle à respecter

Une note-hub uniforme, stable (pas un journal). Modèle :

```markdown
---
created: <date d'origine>
tags: [<projet>]
aliases: [<Nom affiché>]   # si le nom de fichier diffère du nom d'affichage
---

# <Nom affiché>

<Un paragraphe d'overview : ce qu'est le projet, la stack, les repos liés.>

## Décisions
<voir la règle « Décisions » ci-dessous>

## Tâches
<voir la règle « Suivi des tâches » ci-dessous>

## Notes du projet
​```dataview
LIST
FROM "projects/<projet>"
WHERE file.name != this.file.name AND !contains(file.folder, "/tasks")
​```
```

**Dataview par dossier, pas par tag** : on interroge `FROM "projects/<projet>"` (le rangement
strict par dossier suffit), on ne dépend pas d'un tag posé sur chaque note.

## Décisions — où elles vivent

La décision vit **là où est la source de vérité du projet** :

- **Projet adossé à un repo avec ADR** (accoreboot, accoreboot-infra : `docs/adr/`) → les ADR
  versionnés dans le repo font foi. Le vault **ne duplique pas** : la section Décisions du hub
  **pointe** vers `docs/adr/`. Les analyses locales pré-ADR peuvent vivre dans `decisions/`, mais
  jamais une copie canonique des ADR.
- **Projet perso sans repo** → `decisions/` dans le vault (une note par décision, datée, le
  *pourquoi* pas seulement le *quoi*).

## Suivi des tâches — deux régimes (source de vérité)

- **Projet perso (pas de Jira)** → **Obsidian est la source de vérité**. Les tâches vivent dans le
  vault (`tasks/` et/ou cases obsidian-tasks) ; le hub agrège les tâches ouvertes via un bloc
  `tasks`. Claude les maintient (discipline TODO).
- **Gros projet adossé à Jira (préfixe ACR-…, board Jira)** → **Jira est la source de vérité,
  Obsidian suit**. Le hub ne tient **aucun backlog ni checklist recopiant Jira** (anti-pattern).
  Les notes de `tasks/` sont des **notes de travail par ticket** (contexte, analyse) qui
  **référencent** le ticket (ID + lien Jira), sans porter le statut. Le hub pointe vers Jira et
  liste les notes locales via Dataview. Un item non ticketisé se met dans une note « à ticketiser »
  de `tasks/`, pas dans le hub.

Repère : un projet est « Jira-backé » s'il a un préfixe de ticket et un board ; sinon natif-Obsidian.

## Réorganiser sans rien casser (méthode)

- **Liens sûrs au déplacement** : Obsidian résout les `[[wikilinks]]` par **nom de fichier**
  (`alwaysUpdateLinks` activé, format wikilink) → déplacer une note ne casse pas ses liens tant
  que le nom reste **unique**. Ne pas renommer en même temps qu'on déplace. Si un renommage est
  nécessaire (ex. hub aligné sur `<projet>.md`), ajouter un `aliases:` avec l'ancien nom pour que
  les `[[ancien nom]]` continuent de résoudre.
- **Classer sur le contenu, pas le titre** : lire la note avant de trancher son type. Sur un gros
  lot, déléguer le tri de lecture à un agent (`Explore`) puis exécuter les déplacements.
- **Garde-fou sur les lots** : construire la liste, compter, n'exécuter le `mv` que si le total est
  dans une plage attendue (évite un glob qui a mal matché). Après coup, vérifier que la racine ne
  contient que le hub.
- **git du vault** : la plupart des notes ne sont **pas** suivies par git → `mv` de fichiers
  classique (`git mv` échoue sur les non-suivis). **Ne pas commiter le vault** : l'utilisateur le
  synchronise via Obsidian.
- **zsh** : variables non quotées non découpées, et un glob sans correspondance lève une erreur →
  préférer des tableaux et `find … -name` aux boucles `for f in *.glob`.

## Frontmatter (style Zettelkasten, comme les notes existantes)

```yaml
---
created: YYYY-MM-DD
in: "[[<projet>]]"     # note non-hub : pointer vers le hub
tags: [<projet>]
---
```

## Anti-patterns

- Laisser des notes à la racine du dossier projet (hors hub) → tout ranger par type.
- Un hub qui devient un journal / un backlog manuel recopiant Jira → le hub reste stable et
  renvoie à la source de vérité (Jira, ADR).
- Déplacer un lot sur le seul titre, sans lire le contenu → mauvais classement.
- Recopier/maintenir dans Obsidian des décisions qui ont déjà leurs ADR en repo → dérive.
- Renommer une note en la déplaçant sans poser d'alias → lien cassé.
- Toucher `Journal/`, `Templates/`, `Excalidraw/` ; commiter le vault à la place de l'utilisateur.
