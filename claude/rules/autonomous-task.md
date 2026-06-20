# Tâches autonomes — protocole obligatoire

S'applique dès que l'utilisateur confie une tâche en autonomie. Impératif, non-négociable.

---

## Ordre des étapes

```
note de tâche → fetch main → worktree → dev + tests → /simplify → /code-review → COMMIT → CI local → merge → push → cleanup → compte rendu dans la note
```

---

## 0. Note de tâche dans le vault — avant tout

Avant de confier la tâche à l'agent, créer une note dans `~/vault/projects/alaboardage/tasks/` :

```
~/vault/projects/alaboardage/tasks/<slug>.md
```

La note contient :
- **Contexte** : pourquoi cette tâche, ce qu'elle touche
- **Specs** : ce que l'agent doit faire, point par point
- **Definition of done** : critères vérifiables que l'agent doit cocher avant de se déclarer terminé
- **Section vide `## Compte rendu`** : l'agent y écrit son bilan à la fin

L'agent reçoit le chemin de la note dans son prompt et a l'obligation d'y écrire le compte rendu (fichiers modifiés, décisions prises, écarts par rapport aux specs, tests lancés).

Ajouter aussi un item dans `~/vault/projects/alaboardage/tasks.md` qui pointe vers la note :
```
- [ ] <Description courte> #alaboardage → [[tasks/<slug>]]
```

---

## 1. Mettre main à jour avant tout

```bash
git fetch origin
git merge origin/main   # depuis le checkout principal
```

Sans remote : sauter le fetch. Cela minimise les conflits de rebase plus tard.

## 2. Créer le worktree depuis main frais

```bash
git worktree add ../alaboardage-<nom> -b <nom-branche> main
```

- Nom de branche : `feat/…`, `fix/…`, `chore/…` selon le sujet
- **Tout le travail se fait dans ce worktree** — jamais dans le checkout principal
- Vérification : `git status` doit montrer les fichiers modifiés dans le worktree, pas dans le checkout principal

## 3. Dev + tests

- Écrire les tests **pendant** ou **avant** l'implémentation
- Backend : `npm test -- --testPathIgnorePatterns=test/scrapers --passWithNoTests`
- Frontend : rien à tester pour l'instant (svelte-check s'en charge)
- **Les tests doivent passer avant de continuer**

## 4. /simplify puis /code-review

```
/simplify   → appliquer TOUS les retours
/code-review → appliquer TOUS les retours
```

Si un retour est inapplicable ou contradictoire : noter pourquoi et continuer.

## 5. COMMIT — étape critique, ne pas sauter

```bash
git add -A
git diff --cached --stat   # vérifier visuellement ce qui part
git commit -m "feat(scope): description courte"
```

**Ne jamais arriver à l'étape 6 sans avoir commité.** C'est l'étape que les agents ratent le plus souvent.

## 6. CI locale avant merge

```bash
./scripts/ci-local.sh
```

Si ça échoue : corriger, re-commiter (pas amender), relancer. Ne pas merger si le script échoue.

## 7. Merge sur main + push + cleanup

```bash
# Rebase si main a avancé pendant le dev
git rebase main   # depuis le worktree

# Merge depuis le checkout principal
git checkout main     # ou : rester dans le worktree et merger en remote
git merge --no-ff <nom-branche>
git push origin main

# Cleanup
git worktree remove ../alaboardage-<nom>
git branch -d <nom-branche>
```

**Push inclus** — la CI GitHub tourne comme filet de sécurité.

## 8. Compte rendu dans la note

L'agent écrit le bilan dans la section `## Compte rendu` de la note créée à l'étape 0 :
- Fichiers créés / modifiés / supprimés
- Décisions prises et pourquoi
- Écarts par rapport aux specs (si aucun : l'indiquer)
- Résultats des tests et du CI

Marquer ensuite l'item dans `tasks.md` comme `- [x]`.

---

## Cas particulier : branche existante sans worktree

Si le code est déjà sur une branche (ex: travaux en cours de la session) :

```
/simplify → /code-review → commit → ci-local.sh → merge main → push
```

Pas de worktree à créer. Pas de rebase. Merger directement.

---

## Anti-patterns à éviter

- Modifier des fichiers dans le checkout principal en croyant être dans le worktree → toujours vérifier `pwd`
- Faire le commit APRÈS le merge → trop tard, les changements se perdent
- Sauter `ci-local.sh` parce que "les tests passaient avant" → le script est rapide, toujours le lancer
- Baser le worktree sur la branche courante plutôt que `main` → divergence garantie
