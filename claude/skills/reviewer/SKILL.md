---
name: reviewer
description: >-
  Lance un cycle simplify + code-review sur les commits non reviewés depuis le
  dernier marqueur dans le vault. Lit la portée, spawn un agent background,
  met à jour le marqueur après le commit.
---

# Reviewer — cycle simplify + code-review

## Déclenchement

Quand l'utilisateur tape `/reviewer`, exécuter ce protocole dans l'ordre.

---

## 1. Lire la portée

Lire `~/vault/projects/<project>/code-review.md` pour récupérer le hash du dernier commit reviewé.

```bash
git log <hash>..HEAD --oneline
git diff <hash>..HEAD --name-only -- ':!package-lock.json' ':!*.json'
```

Si aucun commit depuis le marqueur ET aucun changement non commité → répondre "Rien à reviewer depuis `<hash>`" et s'arrêter.

Si des changements existent (commités ou non), continuer.

---

## 2. Construire le prompt de l'agent

Le prompt doit contenir :
- La liste des fichiers à reviewer (output du `git diff --name-only` ci-dessus + fichiers non commités)
- Le diff complet si < 500 lignes, sinon la liste des fichiers uniquement
- Les instructions des deux passes ci-dessous (copier-coller les sections "Passe 1" et "Passe 2")

### Passe 1 — Simplification

Lire chaque fichier du périmètre. Appliquer :

- **Supprimer le code mort** : variables inutilisées, imports non utilisés, branches mortes
- **Réduire la verbosité** : logique exprimable en moins de lignes sans perte de lisibilité
- **Pas d'abstraction prématurée** : supprimer helpers/wrappers qui n'apportent rien vs appel direct
- **Commentaires** : supprimer ceux qui décrivent *ce que* fait le code. Garder uniquement ceux qui expliquent *pourquoi* (contrainte cachée, workaround)
- **Ne pas ajouter de features**, ne pas renommer l'interface publique, ne pas casser les types

Appliquer les modifications avec Edit. En cas de doute, ne pas toucher.

### Passe 2 — Code Review

Relire les mêmes fichiers après simplification. Chercher et corriger :

**Bugs / correctness**
- Logique incorrecte, conditions manquantes
- Race conditions, async/await mal utilisé
- Edge cases non gérés pouvant provoquer une erreur en prod

**Sécurité**
- Routes non protégées qui devraient l'être
- Données d'un utilisateur accessibles par un autre (filtre `userId` manquant)
- Validation d'input absente aux frontières (body, query params)

**Idioms du stack**
- Les idioms du stack **du repo courant** : patterns incorrects, anti-patterns propres au
  framework, appels sous-optimaux. S'appuyer sur le `CLAUDE.md` / les conventions du repo
  pour savoir ce qui est idiomatique ici (backend, frontend, ORM, réactivité, gestion
  d'erreur aux frontières, typage).

Pour chaque correction non-triviale, écrire une ligne dans `/tmp/review-notes.md` :
`[fichier:ligne] — problème + correction`

### Commit

```bash
git add <fichiers modifiés>
git diff --cached --stat
git commit -m "refactor: simplify and code-review pass — <périmètre en 3 mots>"
```

Pas de `Co-Authored-By`. Ne pas merger sur main.

Écrire dans `/tmp/review-notes.md` un résumé : fichiers modifiés, problèmes trouvés, fichiers inchangés.

---

## 3. Lancer l'agent en background

```
Agent(description="simplify + code-review", run_in_background=True, prompt=<prompt construit>)
```

---

## 4. Mettre à jour le marqueur après notification

Quand l'agent termine, lire `/tmp/review-notes.md` puis :

1. Récupérer le nouveau HEAD : `git log --oneline -1`
2. Mettre à jour `~/vault/projects/<project>/code-review.md` :
   - Remplacer le hash dans "Dernier commit reviewé"
   - Ajouter une ligne dans le tableau Historique : `| <date> | <ancien hash> | <nouveau hash> | <résumé> |`

---

## Contraintes globales

- Ne jamais toucher aux fichiers sensibles ou générés déclarés par le repo : migrations,
  schéma de base, lockfiles, specs/tests, manifestes de dépendances, configs de lint
- Ne pas modifier l'interface publique des modules (routes, DTO/types publics, exports)
- Le commit se fait sur la branche courante, jamais sur main directement
