# Tâches autonomes — protocole obligatoire

S'applique dès que l'utilisateur confie une tâche en autonomie, que je la réalise
moi-même ou que je la délègue à un sous-agent. Impératif, non-négociable.

Le protocole est **unique** ; seuls les *checks* changent selon le **profil du repo**
(code applicatif ou infrastructure). Les commandes concrètes (gestionnaire de paquets,
outil IaC, script de CI…) ne sont **jamais** codées ici : elles vivent dans le
`CLAUDE.md` du repo concerné. Ce fichier décrit la mécanique, pas la stack.

---

## Ordre des étapes

```
note de tâche → origin/main frais → worktree + branche → dev → checks du profil
→ COMMIT → push branche → PR (conditionnelle, cf. repos.md) → compte rendu → cleanup
```

Point d'arrêt : l'agent va **toujours** jusqu'au commit et au push de sa branche.
Il **n'y a jamais** de merge automatique sur `main`, ni d'`apply` d'infra automatique.
L'ouverture de la PR dépend du repo (voir étape 7).

---

## 0. Note de tâche dans le vault — avant tout

Avant de confier la tâche, créer une note :

```
~/vault/projects/<projet>/tasks/<slug>.md
```

`<projet>` = nom du repo/projet courant. La note contient :

- **Contexte** : pourquoi cette tâche, ce qu'elle touche
- **Specs** : ce que l'agent doit faire, point par point, vérifiable
- **Definition of done** : critères que l'agent coche avant de se déclarer terminé
- **Section vide `## Compte rendu`** : l'agent y écrit son bilan à la fin

Le skill `product-owner` produit cette note proprement — l'utiliser quand on cadre la tâche ensemble.

L'agent reçoit le chemin de la note dans son prompt et a **l'obligation** d'y écrire
le compte rendu (fichiers modifiés, décisions prises, écarts par rapport aux specs,
résultats des checks).

Puis inscrire la tâche **selon le régime de suivi du projet** (cf. `skills/obsidian-management`) :

- **Projet adossé à Jira** (accoreboot, accoreboot-infra, pivot) : le ticket **est** l'inscription.
  Vérifier qu'il existe, qu'il est dans le bon état, et le citer dans la note. **Ne pas** créer de
  case à cocher ni de fichier d'index dans le vault : ce serait un second backlog qui divergerait du
  premier. Une tâche sans ticket va dans la note « Reliquats hors Jira — à ticketiser », jamais
  dans le hub.
- **Projet perso sans Jira** : Obsidian fait foi. La case à cocher vit **dans la note de tâche
  elle-même**, placée juste sous son titre ; le bloc `tasks` du hub l'agrège. **Aucun fichier
  d'index** à la racine du dossier projet, qui n'accueille que le hub — le rangement appartient au
  skill `obsidian-management` (« Layout par projet »), ce protocole ne le redit pas :

  ```
  - [ ] <Description courte> #<projet>
  ```

---

## 1. Mettre `origin/main` à jour

```bash
git fetch origin
git merge origin/main   # depuis le checkout principal
```

Sans remote : sauter le fetch. Cela minimise les conflits de rebase plus tard.

## 2. Créer le worktree et la branche depuis `origin/main`

```bash
git worktree add ../<projet>-<nom> -b <type>/<nom-branche> origin/main
```

- Type de branche : `feat/`, `fix/`, `chore/`, `refactor/` (Conventional Commits ;
  préfixe ticket du projet si connu, **jamais inventé**).
- Base **explicitement `origin/main`**, jamais la branche courante.
- **Tout le travail se fait dans ce worktree** — jamais dans le checkout principal.
  Vérifier avec `pwd` et `git status`.

En **mode délégué**, l'orchestrateur lance l'agent avec le tool `Agent` en
`isolation: "worktree"` (worktree jeté depuis un `main` à jour, nettoyé automatiquement)
et `run_in_background: true` pour une tâche longue. Le bloc à insérer dans le prompt de
l'agent est donné en fin de fichier.

**Modèle du sous-agent — expliciter, ne jamais hériter en silence.** Par défaut, lancer
les agents délégués avec `model: "opus"`. Quand la session principale tourne sur un
modèle de tier supérieur (Fable/Mythos), l'héritage implicite fait payer ce tier à
chaque sous-agent : c'est un choix de coût qui doit être **explicite**. Fable pour un
sous-agent uniquement si la tâche est critique ou à forte charge de réflexion
(algorithme délicat, design ambigu, revue de sécurité pointue) — et le mentionner à
l'utilisateur au lancement. Les agents de lecture légère (Explore, recherche) peuvent
descendre à `sonnet`.

Pour **compléter une PR existante** : `git switch <branche-existante>` au lieu de créer
une branche (voir le cas particulier en fin de fichier).

## 3. Développement

- Coder via le skill `karpathy-guidelines` (changements chirurgicaux, pas
  d'over-engineering, hypothèses explicites, critères de succès vérifiables).
  L'invoquer réellement, ne pas se contenter d'en avoir connaissance.
- Écrire les tests **pendant** ou **avant** l'implémentation quand le profil s'y prête.

## 4. Checks du profil — aiguillage

Déterminer le profil du repo :

1. Le consulter dans `rules/repos.md` s'il y est déclaré.
2. Sinon, auto-détecter : présence de `*.tf` / `*.tofu` / `main.tf` / d'un dossier
   `ansible/` ⇒ **profil infra** ; sinon **profil code**.

Puis appliquer **les checks du profil correspondant**. Traiter TOUS les retours des
revues (corriger, ou justifier explicitement pourquoi on les écarte). La tâche n'est pas
finie tant qu'un finding bloquant subsiste. Montrer la sortie des commandes comme preuve ;
ne jamais déclarer « vert » un check non exécuté — si une infra/un secret manque, le dire
et lister ce qui reste à valider.

### Profil « code applicatif »

```
karpathy-guidelines (dev) → /simplify → /code-review → CI locale du repo
```

- `/simplify` : nettoyer le diff (complexité accidentelle, over-engineering) sans changer
  le comportement ni élargir le périmètre — **avant** la revue, pour qu'elle porte sur la
  correctness et non sur du bruit.
- `/code-review` : revue du diff courant, chaque finding traité. Si le repo définit sa
  propre commande de revue (ex. `/review-pr` sur accoreboot), utiliser celle-ci à la
  place — le repo fait autorité sur l'outil concret, cf. son `CLAUDE.md`.
- **CI locale du repo** : lancer les vérifications que reproduit la CI distante (lint,
  format, typecheck, tests, build…). Les **commandes exactes sont dans le `CLAUDE.md` du
  repo**, pas ici. Tout doit passer avant le commit.

Avant de lancer `/simplify` et `/code-review`, consulter la table « Revue allégée » de
`rules/repos.md` : les repos qui y figurent sautent ces deux cycles et s'en tiennent à la CI
locale. Un projet solo n'amortit pas quatre agents de revue sur un diff de quelques lignes.

### Profil « infrastructure »

```
karpathy-guidelines + addendum infra (dev) → validate/fmt/lint → plan conforme
→ scan statique → revue de sécurité
```

**Addendum infra au codage** (en plus de karpathy-guidelines) :

- Idempotence : rejouer ne doit rien casser ni recréer inutilement.
- Moindre privilège : IAM/rôles/permissions au plus juste, jamais de `*` par confort.
- **Aucun secret en clair** : secrets via SOPS/age (ou le mécanisme du repo), fichiers
  chiffrés committés, jamais de valeur sensible dans le code ou l'état.
- Modules/rôles réutilisables plutôt que du copier-coller.
- **`plan` avant tout ; jamais d'`apply` automatique.** L'application en réel est une
  décision humaine. En pratique, l'agent s'en tient à `plan` et aux checks ; il ne lance
  **jamais** de cible qui applique ou détruit — y compris les raccourcis locaux en
  `-auto-approve` (`make apply`, `make up`, `make down`, `make destroy`, `terraform/tofu apply`).

**Les 4 checks** (commandes exactes dans le `CLAUDE.md` du repo d'infra) :

1. **validate + fmt + lint** : `terraform`/`tofu validate`, `fmt -check`, `ansible-lint`.
2. **`plan` conforme à l'intention** : générer le plan et vérifier qu'il correspond à ce
   qui est attendu — pas de `destroy`/recreate inattendu, pas de ressource orpheline, pas
   de dérive silencieuse. **Joindre le plan (ou son résumé) au compte rendu** de la note.
3. **Scan statique IaC** : `tfsec` / `checkov` / `trivy config` sur le code d'infra.
4. **Revue de sécurité dédiée** : secrets exposés, permissions trop larges, exposition
   réseau, drift. Via `/security-review` ou un prompt de revue centré sécurité.

## 5. COMMIT — étape critique, ne pas sauter

```bash
git add -A
git diff --cached --stat   # vérifier visuellement ce qui part
git commit -m "<type>(<scope>): description courte"
```

Pas de trailer `Co-Authored-By` (cf. `rules/git-commits.md`).
**Entre l'indexation et le commit, passer le contrôle de `rules/commentaires-de-code.md`**
(§ « Contrôle impératif avant chaque commit ») : une sortie non vide interdit le commit,
et les deux seules issues sont de retirer les lignes ou de s'arrêter et demander.
**Ne jamais passer à l'étape suivante sans avoir commité.** C'est l'étape que les agents
ratent le plus souvent. Préférer plusieurs petits commits logiques à un gros dump.

## 6. Push de la branche

```bash
git push -u origin <type>/<nom-branche>
```

Systématique, quel que soit le repo. On ne pousse **jamais** sur `main` directement.

## 7. PR — conditionnelle (cf. `rules/repos.md`)

Consulter l'allowlist « PR auto » de `rules/repos.md` :

- **Repo dans l'allowlist** (perso / faible risque) : ouvrir la PR directement.
  ```bash
  gh pr create --fill --base main
  ```
- **Repo absent de l'allowlist** (défaut, repos à risque, toute l'infra) : **ne pas**
  ouvrir la PR. Afficher la commande `gh pr create` prête à coller et laisser
  l'utilisateur décider.

Aucun merge automatique dans les deux cas.

**Le corps de la PR est un document, pas un message de chat.** Il relève du registre
documentaire du skill `style-reponse` : son lecteur est un relecteur qui n'a pas suivi
la conversation. Donc pas de narration de la découverte (« ce que la revue a changé »,
« le point de départ »), pas de méta-commentaire, pas d'emphase rhétorique, pas de
« je ». Le fond ne bouge pas — noms exacts, chiffres, mécanisme, sorties de commande,
écarts assumés et leur motif. Invoquer réellement `style-reponse` avant de rédiger, ne
pas se fier au souvenir qu'on en a. Même exigence pour le corps des messages de commit.

⚠️ `gh pr create --fill` reprend le dernier message de commit : sur une branche à
plusieurs commits, le résultat ne décrit qu'une partie du lot. Rédiger le corps
(`--body-file`) dès que la branche porte plus d'un commit.

⚠️ `gh pr edit` échoue sur les dépôts liés à un projet classique GitHub, avec une erreur
GraphQL (`repository.pullRequest.projectCards`) et **sans** modifier la PR. Vérifier le
résultat, ou passer directement par REST :
```bash
gh api -X PATCH repos/:owner/:repo/pulls/<n> -F body=@corps.md
```

## 8. Compte rendu dans la note + cleanup

Écrire le bilan dans `## Compte rendu` de la note (étape 0) :

- Fichiers créés / modifiés / supprimés
- Décisions prises et pourquoi
- Écarts par rapport aux specs (si aucun : l'indiquer)
- Résultats des checks du profil (et, en infra, le résumé du `plan`)
- Nom de la branche, et lien de PR si ouverte

Puis **réconcilier les notes que la tâche a périmées** — pas seulement écrire la sienne. Une tâche
qui retient une option, renomme une ressource ou abandonne une topologie rend fausses les notes de
plan et de cadrage qui décrivaient l'état antérieur : `grep -rl` sur le terme mort dans
`~/vault/projects/<projet>/`, puis traitement selon la méthode du skill `obsidian-management`
(« Réconcilier une note périmée par une décision »). Ce point est **dans** le compte rendu : dire
quelles notes ont été corrigées, ou qu'aucune ne l'était.

Clore la tâche selon le régime (cf. étape 0) : **transition du ticket Jira** pour un projet
adossé à Jira — et n'y déclarer terminé que ce que la definition of done couvre réellement, sinon
sortir le reste dans un ticket dédié plutôt que de fermer sur un périmètre plus étroit ;
`- [x]` sur la case de la note de tâche pour un projet perso. Puis nettoyer le worktree si plus utile :

```bash
git worktree remove ../<projet>-<nom>
```

---

## Cas particulier : compléter une branche/PR existante (sans worktree)

Si le code est déjà sur une branche dédiée :

```
dev → checks du profil → commit → push → (PR déjà ouverte : rien à faire de plus)
```

Pas de worktree à créer, pas de base à recalculer.

---

## Bloc à insérer dans le prompt d'un sous-agent (mode délégué)

```text
## Protocole de travail (obligatoire)
1. WORKTREE : travaille entièrement dans ton worktree isolé, jamais dans le repo principal
   (vérifie avec `pwd`).
2. BRANCHE : ton worktree est basé sur `origin/main`. Ta branche est déjà créée ; sinon :
     git switch -c <type>/<nom-branche> origin/main
3. NOTE DE TÂCHE : lis la note <chemin> ; tu DOIS remplir sa section `## Compte rendu`
   avant de te déclarer terminé.
4. DEV : utilise le skill `karpathy-guidelines` pour tout le code. Invoque-le réellement.
   Profil infra : ajoute l'addendum infra (idempotence, moindre privilège, aucun secret
   en clair, `plan` avant tout, jamais d'`apply`).
   LIVRABLE DOCUMENTAIRE (runbook, ADR, doc de dépôt, README, note de référence) : lis
   d'abord `~/.claude/skills/style-reponse/SKILL.md` en entier et applique sa section
   « Le registre documentaire » — pas de narration, pas d'emphase, pas d'étiquette codée,
   des phrases. Une liste de contraintes de forme dans le prompt ne remplace pas le skill.
5. CHECKS DU PROFIL :
   - Code : `/simplify` puis `/code-review` (traite chaque retour), puis la CI locale du
     repo (commandes dans son CLAUDE.md). Montre la sortie.
   - Infra : validate+fmt+lint, `plan` vérifié conforme (joins-le au compte rendu), scan
     statique (tfsec/checkov/trivy), revue de sécurité. Montre la sortie.
6. COMMIT : `git add -A` ; `git diff --cached --stat` ; le contrôle de commentaires de
   `rules/commentaires-de-code.md`, qui doit rendre ZÉRO ligne et interdit le commit
   sinon ; puis commit. Jamais sur `main`, pas de Co-Authored-By.
7. PUSH : pousse ta branche (`git push -u origin <branche>`). N'ouvre PAS de PR toi-même —
   l'orchestrateur décide selon repos.md.
8. RAPPORT : dans `## Compte rendu` — fichiers, décisions, écarts, résultats des checks,
   nom de branche. Dis aussi quelles notes du vault ta tâche a rendues fausses (option
   abandonnée, ressource renommée) et comment tu les as traitées, ou qu'aucune ne l'était.
   Sur un projet perso, coche la case en tête de ta note de tâche. Sur un projet Jira, ne coche
   aucune case dans le vault : le ticket fait foi.
```

Un agent **purement lecture** (Explore, recherche, résumé, audit read-only) n'est PAS
concerné : ni worktree, ni branche, ni checks.

---

## Anti-patterns à éviter

- Modifier des fichiers dans le checkout principal en croyant être dans le worktree
  → toujours vérifier `pwd`.
- Faire le commit APRÈS le merge → trop tard, les changements se perdent.
- Baser le worktree sur la branche courante plutôt que `origin/main` → divergence garantie.
- Sauter les checks du profil parce que « ça passait avant » → toujours les relancer.
- Prétendre un check « vert » sans l'avoir exécuté → montrer la sortie, ou dire ce qui
  n'a pas pu tourner.
- **Infra** : lancer `apply`/`destroy` en autonomie, directement ou via un raccourci
  `-auto-approve` (`make apply`/`up`/`down`/`destroy`, `terraform apply`, `tofu apply`)
  → interdit, c'est une décision humaine.
- **Infra** : committer un secret en clair, ou un plan/état contenant des valeurs sensibles.
- Ouvrir une PR sur un repo hors allowlist → s'arrêter au push et proposer la commande.
- Rédiger le corps d'une PR (ou d'un commit) au registre du chat — récit de la découverte,
  gras d'insistance, « ce que la revue a corrigé » → c'est un document lu par quelqu'un qui
  n'a pas suivi l'échange ; appliquer le registre documentaire de `style-reponse`.
- Créer un fichier d'index de tâches (`tasks.md`, `TODO.md`) à la racine d'un dossier projet du
  vault → contredit le layout, qui n'y admet que le hub, et fait vivre un second backlog à côté du
  bloc `tasks` du hub. La case vit dans la note de tâche ; vérifier avec
  `ls ~/vault/projects/<projet>/*.md`, qui doit renvoyer le seul `<projet>.md`.
- Lancer des sous-agents sur Fable par héritage silencieux du modèle de session → coût
  injustifié ; expliciter `model: "opus"` (défaut), Fable réservé aux tâches critiques /
  à forte réflexion, sur décision explicite.
- Committer alors que le contrôle de commentaires de `rules/commentaires-de-code.md` sort
  des lignes, en signalant l'écart dans la réponse → l'utilisateur reçoit un fait accompli
  au lieu d'une décision. Le contrôle est bloquant : retirer, ou s'arrêter et demander.
  Vécu deux fois d'affilée le 2026-09-09, la seconde tâche étant quatre fois pire que la
  première — la pression du style d'un dépôt très commenté ne s'atténue pas d'elle-même.
