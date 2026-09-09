# Commentaires dans le code — n'en écrire aucun

Décidé le 2026-09-08, après constat sur `regie.nvim` : 796 lignes de commentaire sur 3897,
soit 20 % du dépôt, et 34 % dans le fichier écrit le jour même. Formulation de
l'utilisateur : « y'a beaucoup trop de commentaires quand t'écris du code », « qu'on voit
pour que t'arrêtes d'en mettre partout pendant le dev ».

## La règle

Le code que j'écris ne porte **que** des annotations exploitées par l'outillage :

- Lua : `---@param`, `---@return`, `---@type`, `---@class`, `---@field`
- Python : annotations de type dans la signature
- TypeScript : les types eux-mêmes, JSDoc `@param` si le projet en dépend
- Terraform / OpenTofu : `description` des variables et sorties

Tout le reste ne s'écrit pas :

- pas de phrase de doc au-dessus d'une fonction, même d'une ligne
- pas de prologue de module expliquant son rôle
- pas de commentaire dans le corps d'une fonction, même pour un choix subtil
- pas de commentaire en fin de ligne
- pas de bandeau de séparation (`-- ----------`, `# ======`)
- pas de `TODO`, `FIXME`, `NOTE` laissés derrière

## Le pourquoi

Un commentaire que j'écris explique presque toujours le **passage d'un état à un autre** :
pourquoi cette approche plutôt qu'une autre, quel piège a été évité, ce que faisait la
version précédente. Cela intéresse le relecteur du diff, sur le moment, et encombre
définitivement celui qui lira le fichier ensuite. Le volume finit par recouvrir le code,
qui est la seule source dont l'exactitude est garantie.

## Où va ce que j'aurais commenté

Par ordre de préférence :

1. **Dans le code lui-même** : un nom de variable ou de fonction qui dit ce que le
   commentaire aurait dit, une fonction extraite dont le nom porte l'intention.
2. **Une note de régie** — `regie-note` (cf. skill `regie-note`) : affichée à côté du
   passage dans Neovim, jamais enregistrée dans le fichier, masquable.
3. **Le corps du message de commit** : le mécanisme, l'alternative écartée, le piège.
4. **Le vault** : `~/vault/projects/<projet>/decisions/` ou un ADR du dépôt, pour ce qui
   engage l'architecture.
5. **Le compte rendu de tâche** : la section `## Compte rendu` de la note de tâche.

## Portée

S'applique au code que j'écris ou modifie, dans tous les projets.

Ne s'applique pas :

- aux commentaires **déjà présents** dans un fichier que je touche pour autre chose : je
  les laisse en place, je ne fais pas de nettoyage non demandé
- à un dépôt dont le `CLAUDE.md` exige explicitement des commentaires
- aux fichiers de configuration où le commentaire est le seul moyen de documenter une
  valeur (`.tmux.conf`, `sshd_config`) — et là encore, une ligne suffit. **Le critère est
  qu'il n'existe aucun autre endroit** : pas de message de commit qui les accompagne, pas
  de note de tâche, pas de test qui les nomme. Un fichier édité à la main sur une machine
  remplit ce critère ; un artefact **versionné** n'y répond presque jamais, puisqu'il
  arrive avec son commit.

  ⚠️ **Le code d'infrastructure n'est PAS un fichier de configuration au sens de cette
  exception.** Playbooks Ansible, gabarits Jinja, `defaults/main.yml` d'un rôle,
  `prometheus.yml`, `docker-compose*.yml`, YAML de règles d'alerte : ce sont des
  artefacts versionnés, dont le *pourquoi* a trois autres domiciles — le message de
  commit, la note de tâche, et le libellé d'un test qui verrouille la propriété. Mesuré
  le 2026-09-09 sur deux tâches d'affilée : 7 lignes de prose puis 30 (réduites à 11), en
  qualifiant de « fichiers de configuration » cinq artefacts de ce genre. L'exception
  nommait deux exemples et non un critère, donc elle s'est étendue par analogie — et dans
  un dépôt d'infra, tout ressemble à un fichier de configuration.
- aux livrables documentaires (README, ADR, runbook), qui relèvent du registre
  documentaire de `skills/style-reponse`

## Si un commentaire me paraît indispensable

Le signaler dans la réponse plutôt que de l'écrire : « ce passage mérite une explication,
je la mets en note de régie / dans le commit — dis-moi si tu la veux dans le fichier ». La
décision d'en mettre un dans le code appartient à l'utilisateur, pas à moi. **« Une ligne
seulement » n'est pas une exception que je m'accorde** : le 2026-09-08, une heure après la
règle, j'ai écrit une ligne dans une action composite et trois dans un Makefile en me
disant qu'elles étaient indispensables. Elles ne l'étaient pas plus que les autres.

Le signalement se fait **avant** le commit, pas après : le contrôle de la dernière section
interdit de committer tant qu'il sort une ligne. Signaler après coup laisse l'utilisateur
devant un fait accompli, ce qui n'est plus une décision.

## Un commentaire existant que mon changement rend faux

Le cas qui m'a fait rechuter : je modifie du code sous un commentaire pré-existant, et ce
commentaire devient faux (« stdlib seule » alors que le test exige désormais jinja2). Le
réflexe était de le **réécrire** — donc d'écrire de la prose. La règle : **le supprimer, ou
le réduire au fait devenu vrai en une ligne, jamais l'allonger**. L'explication du
changement va dans le message de commit, qui est fait pour ça.

## Contrôle impératif avant chaque commit

```sh
git diff --cached -U0 | grep -E '^\+\s*(#|//|/\*|\*\s|"""|<!--)' | grep -vE '#!|shellcheck|noqa|type: ignore|eslint|pragma|---@'
```

Doit rendre **zéro ligne**. Une ligne qui sort est un commentaire que j'ai ajouté : la
retirer avant de committer, et mettre son contenu dans le message de commit si c'est un
fait qui compte. Ce contrôle vaut pour tout langage, Makefile, YAML de workflow et
définitions compris.

**Une sortie non vide interdit le commit.** Deux issues seulement : retirer les lignes, ou
s'arrêter et demander — jamais committer puis signaler l'écart dans la réponse. Committer
d'abord retire à l'utilisateur la décision que la section précédente lui réserve, et
transforme une règle impérative en question ouverte que le diff a déjà tranchée. Vécu le
2026-09-09 sur deux commits consécutifs : le contrôle a bien été lancé, il a rendu 7 puis
11 lignes, et les deux commits sont partis quand même, l'écart étant mentionné après coup.
Un contrôle sans conséquence n'est pas un garde-fou, c'est une mesure.

⚠️ **Ne pas se fier au style du fichier qu'on édite, et ne pas croire que
`karpathy-guidelines` l'exige.** Son « match existing style » porte sur les conventions de
nommage, d'indentation et d'idiome — pas sur la densité de commentaires, que cette règle
tranche seule. Le piège est réel : dans un dépôt dont les gabarits portent trente lignes
d'explication par bloc, écrire sans prose donne l'impression de produire un corps
étranger. C'est le résultat attendu, et la seconde des deux tâches du 2026-09-09 a été
quatre fois pire que la première précisément pour avoir cédé à cette pression.

⚠️ **Le motif est fragile aux ancres commençant par un tiret.** `grep -F "- alert: X"`
prend son motif pour une option et rend 0, donc « absent » pour ce qui est présent :
écrire `grep -c -F -- "$motif"`. Constaté en vérifiant les ancres d'un walkthrough le
2026-09-09.
