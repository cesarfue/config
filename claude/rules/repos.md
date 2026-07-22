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
