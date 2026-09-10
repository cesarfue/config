---
name: regie-note
description: >-
  Poser une note de relecture sur un passage de code, affichée dans la régie Neovim (regie.nvim) au
  lieu d'être écrite dans le fichier. À utiliser pendant qu'on code, quand on a quelque chose à dire
  sur un changement qui n'a pas à rester dans le dépôt : un piège évité, un compromis, une contrainte
  externe, une raison qui ne se lit pas dans le code. Remplace le commentaire de diff, pas le
  commentaire durable. Ne PAS utiliser pour un parcours commenté préparé après coup (voir
  `walkthrough`), ni pour une revue (voir `reviewer`), ni pour documenter durablement (voir `doc`).
---

# Notes de relecture

Une note est un propos sur un changement, affiché **à côté** du code par `regie.nvim` — en lignes
virtuelles au-dessus du passage — et jamais écrit dedans. Elle ne fait pas partie du texte du
fichier, ne peut pas être enregistrée, n'entre dans aucun commit, et l'utilisateur la masque d'un
geste (`<leader>vc`).

Elle existe pour un motif précis : le commentaire qui explique le **passage d'un état à un autre**
n'a rien à faire dans le dépôt. Il intéresse le relecteur du diff, maintenant, et encombre celui qui
lira le fichier dans six mois. Faute d'un autre endroit pour le mettre, un agent le met dans le code
— d'où la densité de commentaires qu'il produit. Les notes sont cet autre endroit.

## La ligne de partage

Elle est nette et il faut s'y tenir, sans quoi le dispositif ne sert à rien.

**Reste dans le code** — le *pourquoi* durable, celui dont a besoin quelqu'un qui lit le fichier sans
avoir vu le diff : la raison d'un choix qui paraît étrange, un piège que le prochain reproduirait, une
contrainte que le code seul ne dit pas. Ces commentaires-là sont utiles et ne bougent pas.

**Va en note** — tout ce qui parle du changement lui-même : ce qui a été essayé avant, ce que
l'ancienne version faisait de faux, pourquoi cette approche plutôt qu'une autre également valable, ce
qui reste à vérifier, ce dont on n'est pas sûr. Rien de cela ne survit utilement au diff.

Le test : *cette phrase aurait-elle encore un sens dans le fichier une fois le commit ancien ?* Non →
c'est une note.

## Poser une note

Une commande par note, depuis le répertoire de travail :

```bash
regie-note <fichier> "<texte>"
regie-note <fichier> "<ancre>" "<texte>"
```

Sans ancre, la note s'accroche au dernier changement que la régie connaisse sur ce fichier : c'est le
cas normal juste après une édition, et il n'y a donc rien à écrire pour désigner l'endroit. L'ancre
explicite sert à annoter autre chose que le dernier changement — c'est une **chaîne littérale** du
fichier (nom de fonction, signature, ligne caractéristique), pas un numéro de ligne.

Le chemin est relatif au répertoire de travail ou absolu. Le texte peut être multiligne ; les
apostrophes, guillemets et accents passent sans précaution particulière.

`regie-note --clear` efface toutes les notes du répertoire, `--clear <fichier>` celles d'un fichier.
Utile au début d'une tâche pour ne pas mêler ses notes à celles de la précédente.

## Quand se taire

Une note n'est jamais obligatoire, et une note qui paraphrase le code est pire que rien : elle occupe
de la place à l'écran et fait douter du reste. Pas de note pour dire qu'une fonction ajoutée ajoute
une fonction, ni pour annoncer un renommage qui se voit.

Compter en dizaines de mots, pas en paragraphes. Sur une tâche ordinaire, deux à cinq notes suffisent ;
au-delà d'une dizaine, c'est le signe qu'on commente au lieu de choisir.

## Ce qui n'a pas besoin d'être vérifié

La commande est silencieuse si la régie n'est pas ouverte, et rend 0 dans tous les cas où l'on n'a
rien pu poser. Inutile donc de vérifier qu'elle a marché, ni de prévenir l'utilisateur qu'une note a
peut-être été perdue : ce n'est pas un livrable, c'est un propos de passage.

## Où vit la commande

`~/.local/bin/regie-note`, un lien vers `~/src/regie.nvim/bin/regie-note`. Elle est donc dans le
`PATH` et s'appelle par son nom seul.
