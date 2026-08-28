Écris le récap quotidien de ma journée dans mon vault Obsidian, de façon autonome (exécution cron de fin de journée). Applique la règle « Journal — daily, weekly, monthly » du CLAUDE.md global et la section « Journal » du skill obsidian-management.

1. Rassemble l'activité du jour :
   - Commits du jour dans les repos de `~/src` : pour chaque dossier `~/src/*/` qui est un repo git, `git -C <repo> log --oneline --since=05:00 --author=cesar --all`. Ignore les repos sans commit du jour.
   - Notes du vault modifiées aujourd'hui : `find ~/vault -name '*.md' -newermt "$(date +%F) 00:00" -not -path '*/.obsidian/*'`. Lis celles qui semblent porter du travail du jour (tasks, etudes, decisions).

2. Écris la note `~/vault/Journal/Daily/<YYYY>/<YYYY-MM>/<YYYY-MM-DD>.md` pour le **jour courant** :
   - Si elle n'existe pas : crée-la sur le modèle de `Templates/Daily.md`, en remplissant à la main la ligne de navigation (`⬅ [[<veille>]] | [[<lendemain>]] ➡`) — ne recopie aucune balise Templater `<% %>`.
   - Si elle existe : complète-la sans supprimer ni réécrire ce qui s'y trouve (l'utilisateur a pu y noter des choses).
   - Sous `## Notes` : **6 bullets maximum**, une ligne par sujet, chaque bullet renvoyant par `[[lien]]` vers la note projet qui porte le détail. Ne recopie jamais le détail dans la daily.
   - S'il n'y a aucune activité détectable, écris une seule ligne « Pas d'activité notable détectée. » — ne remplis pas pour remplir.

3. Ne commit rien (ni dans le vault, ni ailleurs). Ne modifie aucun fichier hors de la note daily du jour.
