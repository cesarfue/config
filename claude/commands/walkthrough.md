Prépare une visite guidée des changements, déroulée dans la régie Neovim : $ARGUMENTS

Invoque le skill `walkthrough` et suis-le de bout en bout. En résumé :

1. **Périmètre** — ce qui vient d'être fait dans ce tour, sinon `git diff`, sinon la branche entière
   (`git merge-base HEAD main`). Lire le diff réel : jamais de visite bâtie de mémoire.
2. **Ordre** — celui de l'explication, pas celui des fichiers : l'intention d'abord, puis le mécanisme
   qui la rend correcte, puis les conséquences, puis la trace. Sauter le mécanique (renommages,
   reformatages, imports). Trois étapes justes valent mieux que douze exhaustives ; au-delà de huit,
   regrouper.
3. **Commentaires** — registre documentaire de `style-reponse` : le lecteur y revient sans le contexte
   de la conversation. Deux à quatre phrases, en prose, qui disent *pourquoi* le passage est ainsi. Ne
   pas paraphraser la ligne qu'on montre.
4. **Scénario** — écrire (outil `Write`, jamais le shell) dans
   `<dossier git commun>/regie/walkthrough/<nom>.json`, le dossier git commun étant celui que rend
   `git rev-parse --path-format=absolute --git-common-dir`. Le nom du fichier identifie la visite :
   un dépôt en porte plusieurs, une par PR ou par sujet — lister l'existant avant d'écrire et ne
   jamais écraser celle d'un autre sujet. Le scénario porte `titre`, `branche` et `pr` facultatifs,
   puis des étapes à `fichier` (relatif à la racine du dépôt, jamais absolu), `ancre` (chaîne
   littérale, distinctive et **unique**) et `texte`.
5. **Vérifier** — chaque fichier existe, chaque ancre rend `1` à `grep -c -F`, le JSON est valide
   (`python3 -m json.tool`), et le nom retenu n'écrase pas une visite existante.
6. **Rendre la main** en une ou deux lignes : titre, nombre d'étapes, `<leader>vg` pour ouvrir (ou
   `:RegieWalk <nom>` quand le dépôt en porte plusieurs). Ne pas dérouler les étapes dans la réponse
   — ce serait faire le walkthrough dans le terminal.

Sans argument, prendre les changements du tour en cours ; avec un argument, l'interpréter comme le
périmètre demandé (un fichier, une branche, un sujet).
