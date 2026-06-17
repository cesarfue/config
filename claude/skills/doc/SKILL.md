---
name: doc
description: >-
  Documenter un terme, un concept ou une notion dans le vault Obsidian (~/vault/Notes) sous forme de
  note atomique de référence. À utiliser dès que l'utilisateur demande « documente X », « ajoute de la
  doc sur X », ou lance /doc. S'appuie sur le skill obsidian-management pour le placement, écrit en
  français (style-reponse), et rattache la note au bon set thématique (tag + MOC). Ne PAS utiliser pour
  de la doc spécifique à un projet (ça va dans projects/<projet>/etudes/) ni pour du contenu métier.
---

# Documenter un terme / une notion

Ce skill produit une **note de référence** pérenne sur un terme ou un concept transférable, rangée
dans `~/vault/Notes/`, cohérente avec les sets de doc thématiques existants (voir le pattern « Set de
doc thématique » du skill `obsidian-management`).

Principe : l'utilisateur lit, je écris. La note doit être **auto-suffisante** et compréhensible du
premier coup, sans que l'utilisateur ait à redemander « ça veut dire quoi ? ».

**Différence avec le skill `cours`** : `doc` = note de **référence courte** sur un terme d'un domaine
déjà suivi, insérée dans un set (tag + MOC). Pour **apprendre de zéro un gros sujet inconnu** (note
pédagogique longue et autoportante), c'est le skill `cours`, pas celui-ci.

## Déroulé

### 1. Placement (via `obsidian-management`)

- **Connaissance transférable** (concept tech, théorie, notion réutilisable) → `~/vault/Notes/<terme>.md`, à plat. C'est le cas par défaut pour /doc.
- **Spécifique à un projet** → `projects/<projet>/etudes/` — et là on sort de ce skill (c'est du travail projet).
- En cas de doute sur la place, consulter `obsidian-management`.

### 2. Ne pas dupliquer

Chercher si une note existe déjà sur ce terme (nom de fichier proche, tag, recherche plein texte).
Si oui : **mettre à jour** la note existante plutôt qu'en créer une seconde. Si le terme est un
sous-concept très proche d'une note existante (granularité **hybride**), l'ajouter **dans** cette
note plutôt que d'en créer une micro-note isolée.

### 3. Rattacher au set thématique (tag + MOC)

- Identifier le **thème** du terme (musique, etc.) et son **tag** (`#music`, `#<theme>`).
- S'il existe déjà une **note MOC** pour ce thème (`<Thème> (MOC).md`) : mettre le tag sur la nouvelle
  note, pointer `out: "[[<Thème> (MOC)]]"`, et **ajouter la note dans le MOC** (dans la bonne section).
- S'il n'existe pas encore de set/MOC pour ce thème et qu'on n'a qu'une note isolée : pas de MOC
  obligatoire ; le créer seulement si un vrai ensemble se dessine (≥ ~3 notes du même thème). Le
  signaler à l'utilisateur.

### 4. Écrire la note

Format (cohérent avec le set thématique) :

```markdown
---
created: <aujourd'hui, YYYY-MM-DD>
out: "[[<Thème> (MOC)]]"      # si la note appartient à un set ; sinon laisser vide
tags: [<theme>]
---

# <Terme>

<Définition en UNE phrase, en langage simple.>

<Explication en prose : ce que c'est, comment ça marche, à quoi ça sert, les pièges. Jargon
expliqué au passage. Tableaux quand ça clarifie (ex. comparer des variantes).>

## En pratique          ← quand un geste concret dans un outil s'applique (ex. Ableton)
<les manips concrètes>

## Voir aussi
[[note liée]] · [[autre note liée]]
```

Règles de contenu :
- **Français**, prose, ton calme et neutre (skill `style-reponse`). Pas de listes à puces empilées à la place d'explications.
- **Jargon toujours explicité.** L'utilisateur peut être débutant sur le sujet.
- **Ton référence, neutre** : pas de couleur « goût perso » de l'utilisateur (styles, préférences) sauf s'il le demande explicitement. Une doc reste vraie hors de son contexte du moment.
- **Honnêteté factuelle** (règle globale) : ne rien inventer. Si un fait n'est pas sûr (nom exact d'un réglage, comportement d'un outil), le vérifier ou le marquer comme à confirmer plutôt que l'affirmer.
- **Nom de fichier = terme nu** (`ADSR.md`, `Passe-haut.md`) pour le quick-switcher. Granularité **hybride** : regrouper les sous-concepts très proches dans une même note.
- **Inter-liens `[[...]]`** vers les notes voisines du set, et section finale `## Voir aussi`.

### 5. Câbler les liens dans les deux sens

- Ajouter l'entrée dans le **MOC** (section adéquate, une ligne de description).
- Depuis 1-2 notes voisines très liées, ajouter un `[[lien]]` vers la nouvelle note quand c'est naturel (ex. depuis `## Voir aussi`).

### 6. Vérifier et confirmer

- Vérifier qu'**aucun lien `[[...]]` n'est mort** (chaque cible existe comme fichier `.md`).
- Ne **pas** commiter le vault (l'utilisateur synchronise via Obsidian).
- Confirmer brièvement : note créée/mise à jour + où, et liens ajoutés (MOC, voisines).

## Anti-patterns

- Créer une note qui duplique un concept déjà documenté → mettre à jour l'existante.
- Multiplier les micro-notes pour des sous-concepts inséparables → granularité hybride.
- Oublier d'ajouter la note au MOC → elle devient introuvable par l'index.
- Frontmatter cassé (regex qui avale les retours à la ligne) → vérifier le YAML après une manip en masse.
- Injecter le contexte/goût du moment dans une note de référence.
