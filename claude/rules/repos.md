# Repos — profil et politique de PR

Référencé par `rules/autonomous-task.md`. Deux tables éditables à la main.
Pour autoriser un repo à faible risque, ajouter une ligne dans l'allowlist ci-dessous.

Le repo se reconnaît par le **nom du dossier** ou un **motif d'URL de remote**
(`git remote get-url origin`).

---

## 1. Profil par repo (optionnel)

Sert à l'étape 4 de `autonomous-task.md`. Si un repo n'est pas listé, le profil est
**auto-détecté** : présence de `*.tf` / `*.tofu` / `ansible/` ⇒ `infra`, sinon `code`.
Ne lister ici que les cas où l'auto-détection se trompe (table vide par défaut).

| Repo (nom ou motif) | Profil        |
|---------------------|---------------|
| _(exemple)_ un-repo | `code`/`infra` |

## 2. Allowlist « PR auto »

Repos où l'agent ouvre la PR **directement** après le push (étape 7). Tout repo **absent**
de cette liste : l'agent s'arrête au push et propose la commande `gh pr create` sans
l'exécuter. Par prudence, **aucun repo d'infra ne devrait figurer ici**.

| Repo (nom ou motif) | Raison            |
|---------------------|-------------------|
| _(exemple)_ mon-repo-perso | repo perso, faible risque |

<!--
Pour autoriser un repo : ajouter une ligne avec son nom de dossier (ou un motif
présent dans l'URL du remote, ex. `github.com/<moi>/`). Retirer la ligne pour révoquer.
-->

## 3. Merge direct, sans PR

Repos où la revue par pull request n'a pas d'objet — un seul contributeur, aucun relecteur à
attendre. Après les checks du profil, la branche est fusionnée dans `main` en avance rapide, `main`
est poussé, et la branche est supprimée localement comme à distance. Le travail passe toujours par
une branche : elle isole les checks, et son absence de PR ne dispense d'aucun d'eux.

| Repo (nom ou motif) | Raison |
|---------------------|--------|
| regie.nvim | repo perso, seul contributeur |
| sidecar | repo perso, seul contributeur |
| alaboardage | repo perso, seul contributeur |

## 4. Revue allégée — pas de `/simplify` ni de `/code-review`

Repos où l'étape 4 du protocole `autonomous-task.md` se réduit à la CI locale : le lint, les tests et
le typecheck du dépôt tournent comme partout, mais les cycles de revue par agents sont supprimés.
Le motif est le rapport entre le coût de la revue et l'enjeu du dépôt — un projet solo, sans
relecteur ni contrainte de production partagée, où quatre agents sur un diff de neuf lignes coûtent
plus que ce qu'ils rapportent.

Le reste du protocole ne change pas : branche depuis `origin/main`, contrôle de commentaires avant
le commit, commit et push systématiques, compte rendu dans la note de tâche.

| Repo (nom ou motif) | Raison |
|---------------------|--------|
| alaboardage | projet solo, demande explicite du 2026-09-15 |
