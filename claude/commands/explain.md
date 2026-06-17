Crée une note d'explication approfondie sur le sujet : $ARGUMENTS

## Ce que tu dois faire

1. **Détermine où ranger la note**
   - Si le sujet est transférable (concept tech, pattern, lib, outil) → `~/vault/Notes/<sujet>.md`
   - Si le sujet est spécifique au projet courant → `~/vault/projects/<projet>/<sujet>.md`

2. **Vérifie si une note existe déjà** sur ce sujet dans le vault. Si oui, mets-la à jour plutôt que d'en créer une nouvelle.

3. **Écris la note** avec :
   - Frontmatter Zettelkasten (`created`, `in` ou vide si global, `out`, `tags`)
   - Une explication claire et approfondie du sujet : définition, fonctionnement, cas d'usage, pièges courants
   - Une section **## Sujets connexes** listant 4-6 sujets liés avec une phrase d'explication pour chacun — utilise des liens `[[nom]]` vers des notes existantes si elles existent dans le vault
   - Une section **## Références** si des sources externes sont pertinentes

4. **Insère les liens** :
   - Si la note est globale (`Notes/`) et qu'un projet est en cours : ajoute un lien vers cette note depuis la section pertinente du fichier projet (ex: `decisions.md` ou le hub)
   - Si la note est dans un projet : ajoute-la dans le hub du projet (`<projet>.md`) dans les `out:` du frontmatter

5. **Confirme** en résumant : où la note a été créée/mise à jour, et quels liens ont été ajoutés.
