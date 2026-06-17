Descends dans cette tâche : ouvre-lui une session tmux à elle, sous la session courante, et bascule dedans pour la mener : $ARGUMENTS

`sidecar delegate` duplique la session courante — windows et conversation forkée, donc l'agent délégué hérite de tout ce qui vient d'être dit — la range **en enfant** de la session actuelle dans l'arbre de la TUI, lui remet une consigne de démarrage, et y bascule.

## Déroulé

1. **Vérifier le terrain.** La commande a besoin d'une session tmux courante ; sans elle, elle s'arrête et le dit. Regarder aussi `sidecar list` pour ne pas déléguer deux fois la même chose.

2. **Choisir le nom**, qui décide de l'emplacement. Un nom en `<dépôt>/<sujet>` vaut à la session son propre worktree sur une branche du même nom, dans `~/src/<dépôt>-<sujet>` : c'est ce qu'il faut pour une tâche qui touche au code, l'agent délégué travaillant alors sans marcher sur le dépôt principal. Dériver le sujet de la tâche en deux ou trois mots, en minuscules et séparés par des tirets. Une tâche de lecture ou d'analyse, qui n'écrit rien, peut se passer de worktree : lui donner un nom simple.

3. **Rédiger la consigne**, qui est le premier message de l'agent — pas une reformulation de la demande, mais ce qu'il lui faut pour travailler seul : ce qu'on attend de lui, où regarder, et à quoi ressemble un résultat fini. Il hérite de la conversation, donc inutile de recopier le contexte ; en revanche il ne verra plus l'écran, donc tout ce qui est implicite ici doit être dit là.

   Si la tâche produit du code ou de l'infrastructure, la consigne rappelle le protocole `rules/autonomous-task.md` : note de tâche du vault, checks du profil, commit et push de la branche, compte rendu. Le worktree, lui, est déjà donné par le nom.

4. **Lancer** :

   ```bash
   sidecar delegate --name "<dépôt>/<sujet>" "<la consigne>"
   ```

   tmux bascule alors sur la session créée, et l'utilisateur s'y retrouve devant la conversation forkée, déjà lancée sur la consigne. C'est voulu : on descend dans la tâche. Ajouter `--no-switch` seulement s'il a demandé à rester où il est.

5. **Rendre compte** en une ou deux phrases, avant la bascule : le nom de la session créée et son répertoire. Rappeler le chemin du retour — `prefix + f` puis la session parente, ou `tmux switch-client -t <parent>` — et que le suivi est passif : `sidecar list` marque « travaille » tant que claude n'a pas fini, mais rien ne préviendra à la fin.

## Ce qu'il ne faut pas faire

Ne pas déléguer une tâche qu'il serait plus rapide de faire ici : la duplication crée une session, un worktree et une branche, et l'agent délégué redécouvre seul ce qu'on sait déjà. Elle vaut pour ce qui est long, parallélisable, ou qui salirait le dépôt courant.

Ne pas inventer le nom du dépôt : c'est celui de la session courante, que `sidecar list` affiche.
