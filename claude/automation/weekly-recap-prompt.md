Écris le récap hebdomadaire de ma semaine dans mon vault Obsidian, de façon autonome (exécution cron du jeudi en fin de journée). Applique la règle « Journal — daily, weekly, monthly » du CLAUDE.md global et la section « Journal » du skill obsidian-management.

1. Détermine la semaine ISO courante (`date +%G-W%V`) et son lundi.

2. Lis les dailies de la semaine (du lundi à aujourd'hui) dans `~/vault/Journal/Daily/`, et si besoin les notes projet qu'elles référencent, pour dégager les gros sujets de la semaine.

3. Écris la note `~/vault/Journal/Weekly/<GGGG>/<GGGG-W##>.md` :
   - Si elle n'existe pas : crée-la sur le modèle de `Templates/Weekly.md`, en remplissant à la main le frontmatter (`created` = date du lundi, `mois: "YYYY-MM"` **entre guillemets** = mois du lundi), la navigation vers les semaines adjacentes, et le bloc Dataview `## Dailies` avec les dates du lundi et du dimanche en dur — ne recopie aucune balise Templater `<% %>`.
   - Si elle existe : complète-la sans casser le frontmatter ni supprimer le contenu existant.
   - `sujets:` : des libellés courts et lisibles de 2-4 mots, entre guillemets (ex. `"Contrat d'API PRR"`), pas des slugs. Regarde les 2-3 weeklies précédentes et réutilise le même libellé quand un chantier continue.
   - `## Gros sujets` : 3-5 bullets d'une ligne chacun.

4. Ne commit rien. Ne modifie aucun fichier hors de la note weekly de la semaine.
