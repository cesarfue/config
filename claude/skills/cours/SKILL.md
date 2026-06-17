---
name: cours
description: >-
  Produire un « cours » dans le vault Obsidian : une note pédagogique autoportante pour apprendre de
  zéro un sujet vaste ou inconnu (pas juste un terme). À utiliser quand l'utilisateur dit « fais-moi un
  cours sur X », « explique-moi X en profondeur », « je n'y connais rien à X », ou lance /cours.
  S'appuie sur obsidian-management pour le placement, écrit en français (style-reponse), progressif et
  illustré. Pour une note de RÉFÉRENCE courte sur un terme d'un domaine déjà suivi (tag + MOC),
  utiliser plutôt le skill `doc`.
---

# Faire un cours sur un sujet

Ce skill produit une note **pédagogique et autoportante** pour **apprendre un sujet de zéro** —
typiquement un gros sujet que l'utilisateur ne connaît pas encore. Objectif : qu'après lecture il ait
une compréhension solide et structurée, sans prérequis supposés.

**Différence avec le skill `doc`** :
- `cours` = **apprendre un sujet vaste et inconnu**. Note longue, progressive, illustrée, autoportante.
- `doc` = **note de référence courte** sur un terme précis d'un domaine déjà suivi, insérée dans un set (tag + MOC).

Si le « sujet » demandé est en réalité un terme atomique d'un set existant → basculer sur `doc`.

## Déroulé

### 1. Placement (via `obsidian-management`)

- **Sujet transférable** → `~/vault/Notes/<sujet>.md` (à plat).
- **Sujet propre à un projet** → `projects/<projet>/etudes/<sujet>.md` (une note d'apprentissage est une *étude*), avec `in: "[[<projet>]]"` et un lien depuis le hub.
- Doute sur la place → consulter `obsidian-management`.

### 2. Ne pas dupliquer

Si une note existe déjà sur le sujet, l'**étendre / mettre à jour** plutôt qu'en créer une seconde.

### 3. Écrire le cours

Frontmatter :

```yaml
---
created: <aujourd'hui, YYYY-MM-DD>
in: "[[<projet>]]"     # seulement si note projet
out:                   # liens sortants notables
tags: [<sujet ou thème>]
---
```

Corps, structuré du général au précis :

- **# \<Sujet\>**
- **De quoi il s'agit** — une phrase, puis un court paragraphe qui pose l'idée générale en langage simple.
- **Les fondations** — les prérequis minimaux, *expliqués* (jamais supposés acquis).
- **Comment ça marche** — le cœur, décomposé en sections `##` progressives, avec des **analogies** et des **exemples concrets**. Chaque terme technique expliqué au passage.
- **À quoi ça sert** — cas d'usage.
- **Pièges courants** — erreurs de débutant, malentendus fréquents.
- **## Voir aussi** — `[[liens]]` vers les notes liées du vault.
- **## Références** — sources externes fiables (livres, docs, vidéos) si pertinent.

Règles de contenu :
- **Français**, prose, ton calme et pédagogique (skill `style-reponse`). Le lecteur part de zéro : rien n'est supposé acquis.
- **Jargon systématiquement expliqué** ; privilégier analogies et exemples.
- **Approfondi** : un cours peut être long. Mieux vaut complet et clair que ramassé.
- **Honnêteté factuelle** (règle globale) : ne rien inventer ; marquer ce qui est incertain plutôt que de l'affirmer.
- **Autoportant** : pas de formule qui suppose le contexte du moment.
- Nom de fichier = nom du sujet, lisible.

### 4. Câbler les liens

- Note globale + projet en cours : ajouter un lien vers elle depuis la note projet pertinente.
- Note projet : l'ajouter au hub (`out:` du frontmatter ou section Notes).
- Relier aux notes existantes du vault via `[[...]]` et la section `## Voir aussi`.

### 5. Vérifier et confirmer

- Aucun lien `[[...]]` mort (chaque cible existe).
- Ne **pas** commiter le vault (l'utilisateur synchronise via Obsidian).
- Confirmer : où la note a été créée/mise à jour, et quels liens ajoutés.

## Anti-patterns

- Traiter un simple terme d'un set suivi comme un « cours » → c'est `doc`.
- Supposer des prérequis chez le lecteur → tout expliquer depuis la base.
- Note ramassée qui suppose le contexte → un cours doit être autoportant.
- Frontmatter cassé après une manip en masse → vérifier le YAML.
