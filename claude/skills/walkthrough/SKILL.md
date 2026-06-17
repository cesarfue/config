---
name: walkthrough
description: >-
  Préparer une visite guidée des changements qu'on vient de faire, déroulée dans la régie Neovim
  (regie.nvim) : la caméra se pose sur chaque passage, un commentaire s'affiche au-dessus, et
  l'utilisateur avance à son rythme. À utiliser quand il demande « fais-moi un walkthrough », « montre-
  moi ce que t'as changé », « explique-moi le diff », ou lance /walkthrough. Écrit un scénario JSON que
  le plugin lit ; ne modifie aucun fichier du dépôt. Ne PAS utiliser pour une revue de code (voir
  `reviewer`), ni pour documenter durablement (voir `doc`).
---

# Visite guidée des changements

Ce skill produit un **scénario** que `regie.nvim` déroule : une suite d'étapes, chacune désignant un
passage du code et portant le commentaire qui l'explique. L'utilisateur ouvre la visite par
`<leader>vg` (ou `:RegieWalk`), avance avec `suiv`/`préc`, et la clôt par `⏭`.

L'intérêt n'est pas de résumer le diff — `git diff` le fait déjà — mais de le rendre **lisible dans
l'ordre où on l'expliquerait à voix haute**, en montrant le code plutôt qu'en le paraphrasant.

## Ce que le lecteur voit

Pour chaque étape : le fichier s'ouvre dans la scène, la vue défile jusqu'au passage visé, la ligne se
surligne, et le commentaire apparaît en lignes virtuelles juste au-dessus. La barre du panneau affiche
`🎬 <titre> — étape 3/8`.

## Marche à suivre

### 1. Établir le périmètre

Demander au besoin, sinon déduire du contexte de la conversation. Par ordre de préférence :

- ce qui vient d'être fait dans ce tour, si la tâche est fraîche ;
- `git diff` (modifications non commitées) ;
- `git diff <base>..HEAD` pour une branche entière, la base étant `git merge-base HEAD main`.

Lire le diff réel. Ne jamais bâtir une visite de mémoire : les numéros de ligne, les noms et les
signatures doivent venir du code tel qu'il est sur le disque.

### 2. Choisir l'ordre

C'est le cœur du travail, et ce que le diff ne donne pas. **L'ordre n'est ni celui des fichiers, ni
celui où on les a touchés.** Il suit l'explication :

1. le changement qui porte l'intention — celui dont tous les autres découlent ;
2. le mécanisme qui le rend correct, s'il n'est pas évident (un discriminant, une garde, un ordre
   d'appel) ;
3. les conséquences : appelants adaptés, doublure alignée, configuration ajustée ;
4. ce qui a été retiré et pourquoi, quand la suppression est le fait marquant ;
5. la trace : test qui l'atteste, documentation mise à jour.

Sauter ce qui ne s'explique pas : renommages mécaniques, reformatages, imports. Une visite de trois
étapes justes vaut mieux qu'une de douze exhaustive. Au-delà de huit, l'attention se perd : regrouper
ou renoncer.

### 3. Écrire les commentaires

Registre du skill `style-reponse`, **registre documentaire** : le lecteur relit ce texte des jours plus
tard sans le contexte de la conversation. Donc pas de « comme tu l'as demandé », pas de « j'ai
ajouté », pas de narration de la découverte.

Deux à quatre phrases par étape, en prose. Dire ce que le passage fait et **pourquoi il est ainsi**,
non ce que le code dit déjà — une étape qui paraphrase sa ligne est une étape perdue. Nommer les
valeurs et les mécanismes exacts. Quand un choix a un coût ou une limite, le dire à l'étape où il se
voit.

### 4. Écrire le scénario

Dans `<dossier git commun>/regie/walkthrough/<nom>.json`, le dossier git commun étant celui que rend
`git rev-parse --path-format=absolute --git-common-dir` — le `.git` du dépôt principal, y compris
interrogé depuis un arbre lié. Le scénario est ainsi partagé par tous les arbres de travail du dépôt
et ne peut pas entrer dans un commit.

```bash
mkdir -p "$(git rev-parse --path-format=absolute --git-common-dir)/regie/walkthrough"
```

**Le nom du fichier est l'identifiant de la visite, et il est à choisir.** Un dépôt en porte
plusieurs — une par pull request ou par sujet — et elles coexistent. Prendre un slug court en
kebab-case, tiré du ticket ou de la branche quand il y en a un (`acr-537-silences`,
`pr-42-notes-de-relecture`), du sujet sinon (`visite-guidee`). **Ne jamais écrire par-dessus le
scénario d'un autre sujet** : lister l'existant avant d'écrire, et ne réutiliser un nom que pour
refaire la même visite.

```bash
ls "$(git rev-parse --path-format=absolute --git-common-dir)/regie/walkthrough/"
```

```json
{
  "titre": "Le périmètre des arbres de travail",
  "branche": "feat/worktrees",
  "pr": "#42",
  "etapes": [
    {
      "fichier": "lua/regie/sessions.lua",
      "ancre": "local ou = git(racine,",
      "texte": "Le discriminant tient en une ligne : --git-dir et --git-common-dir sont égaux dans le répertoire principal, et diffèrent dans un arbre lié, où le premier vaut <commun>/worktrees/<nom>."
    },
    {
      "fichier": "README.md",
      "ancre": "## Limites",
      "texte": "La limite assumée : depuis un arbre lié, les autres arbres restent invisibles."
    }
  ]
}
```

| Champ | Rôle |
|---|---|
| `titre` | nom de la visite, affiché dans la barre ; un groupe nominal court |
| `branche` | facultatif : la branche que la visite explique ; le sélecteur met en tête celle de l'arbre courant |
| `pr` | facultatif : la pull request, sous la forme `#42` ou son URL |
| `etapes[].fichier` | chemin **relatif à la racine du dépôt** ; un chemin absolu désigne un arbre de travail précis et cesse d'être valable ailleurs |
| `etapes[].ancre` | **chaîne littérale** cherchée dans le fichier ; omise, la vue se pose en tête |
| `etapes[].texte` | le commentaire ; les retours à la ligne sont conservés |

L'ancre est une chaîne, jamais un numéro de ligne : les lignes bougent au commit suivant, un nom de
fonction ou une signature survit. La recherche est littérale et sans échappement — prendre un fragment
distinctif et **unique** dans le fichier, vérifié par `grep -c`. Si le fragment apparaît plusieurs fois,
l'allonger jusqu'à ce qu'il soit unique ; la première correspondance gagne sinon, et ce n'est pas
toujours la bonne.

Écrire ce fichier avec l'outil `Write` (jamais par le shell : l'utilisateur suit les modifications en
direct depuis Neovim).

### 5. Rendre la main

Annoncer en une ou deux lignes le titre, le nombre d'étapes, et comment ouvrir : `<leader>vg`, ou
`:RegieWalk <nom>` quand le dépôt porte plusieurs visites — sans nom, `<leader>vg` propose la liste.
Ne pas dérouler le contenu des étapes dans la réponse — ce serait faire le walkthrough dans le
terminal, ce que la visite est précisément là pour éviter.

## Vérifications avant de rendre la main

- Chaque `fichier` existe : `test -f`.
- Chaque `fichier` est relatif à la racine du dépôt, jamais absolu.
- Chaque `ancre` est présente et unique : `grep -c -F '<ancre>' <fichier>` rend `1`.
- Le JSON est valide : `python3 -m json.tool <chemin>`.
- Le nom du fichier n'écrase pas une visite existante qui portait un autre sujet.

Une ancre introuvable n'empêche pas la visite — la vue se pose en tête de fichier et le plugin
avertit — mais c'est une étape ratée, et elle se voit.

## Pièges

- **Paraphraser le code.** « Cette fonction renvoie les racines du dépôt » n'apprend rien à qui lit la
  ligne juste en dessous. Dire pourquoi elle les renvoie ainsi.
- **Suivre l'ordre des fichiers.** Un diff alphabétique commence rarement par l'essentiel.
- **Une ancre trop courte.** `function` ou `return` apparaissent partout ; la première correspondance
  emmène la caméra ailleurs.
- **Tout couvrir.** Les changements mécaniques n'ont pas d'étape.
- **Écrire dans l'arbre de travail.** Le scénario vit sous `.git`, jamais à côté du code : c'est un
  propos sur le code, et rien de ce qui est sous `.git` ne peut finir dans un commit.
- **Écraser la visite d'une autre PR.** Le dossier en contient plusieurs ; le nom du fichier les
  distingue. Lister avant d'écrire.
- **Des chemins absolus dans les étapes.** Ils pointent l'arbre de travail où la visite a été
  préparée ; cet arbre est souvent supprimé une fois la PR fusionnée, et la visite ne montre plus
  rien.
