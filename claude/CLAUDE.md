# Global instructions

These rules apply to every project. They are imperative — not suggestions.

## Knowledge base — Obsidian vault

Location: `~/vault`

Use the vault as the single source of project knowledge and TODOs across all projects.

### Layout

```
~/vault/
  projects/<project>/         ← one folder per project
    <project>.md              ← hub note (entry point)
    decisions.md              ← append-only, dated entries
    tasks.md                  ← TODO list (obsidian-tasks plugin syntax)
    <topic>.md                ← created on demand when a topic earns its own page
  Notes/                      ← global knowledge, shared across projects
    <topic>.md                ← flat, no sub-folders
  Journal/                    ← user's existing time-based notes — do not touch
  Templates/                  ← user's existing — do not touch
```

No `raw/` folder. No sub-folders inside `Notes/`. Inside each project folder, flat.

### Where a piece of knowledge goes

The test: *"if I started a new project tomorrow, would I want this note?"*

- Yes (transferable: tech facts, patterns, recipes, lib usage) → `Notes/<topic>.md`
- No (specific to one project: decisions, scope, state, why-here) → `projects/<project>/...`

Project notes link to global notes, never the reverse.

### Frontmatter (use Zettelkasten template fields, like existing notes)

```yaml
---
created: YYYY-MM-DD
in: [[<project>]]      # for project notes, point to the hub
out:                   # outgoing links worth indexing
tags: [<project>]      # for project notes
---
```

### Hub note

Each `projects/<project>/<project>.md` is the project's entry point. Contains:
- One-paragraph project overview
- Dataview list of related notes (`FROM #<project>`)
- Tasks query showing open items (`tags include #<project>`)
- Link to `decisions.md`, `tasks.md`

### When to promote a topic to its own note

A section in `decisions.md` / `tasks.md` / any existing note becomes its own file when:
- It grows beyond ~3-4 paragraphs, OR
- It gets backlinked from 2+ places

Until then, stay in the parent file. Don't pre-create empty topic notes.

## TODO discipline — imperative

**You must maintain `projects/<project>/tasks.md` for every project you touch.**

- Open the file at the start of a session and read existing tasks.
- Add a task whenever the user mentions something to do later, a known follow-up, or a deferred fix.
- Mark tasks done (`- [x]`) the moment they're completed — not "at the end of the session", not "later".
- Use obsidian-tasks syntax: `- [ ] Task description #<project> 📅 YYYY-MM-DD` (due date optional).
- If a task no longer makes sense, delete it or note why it was dropped — never leave stale items.

This is non-negotiable. If you forget, the user has to remember everything, which defeats the whole setup.

## Writing notes — you write, the user reads

The user does not maintain these notes. You do.

- After a decision: append to `decisions.md` with date + the *why* (not just the what).
- After completing a non-trivial feature: update the relevant topic note, or create one if it doesn't exist.
- When you learn something transferable (a Prisma quirk, a Vite pattern, a Docker gotcha): write/update the corresponding note in `Notes/`.
- Periodically (every few exchanges of a long session): re-read the hub, check for stale links, reconcile contradictions.

## Memory vs vault

Behavior memory at `~/.claude/projects/<encoded>/memory/` is separate from the vault. It stores:
- User preferences ("don't use emojis", "prefer X pattern")
- Feedback corrections ("I rejected this approach last time")
- Anything about *how* to collaborate

These never go in the vault — they're private and auto-loaded each session.

The vault stores *what* you're working on. The memory stores *how* you work with the user.

## When in doubt

If a piece of information could be useful in a future session but doesn't clearly fit anywhere, default to `projects/<project>/<topic>.md` and link it from the hub. Better one extra note than lost context.

## Behavioral rules

Specific rules live in `~/.claude/rules/`. Reference them here by topic.

- [Commits et utilisation git](rules/git-commits.md)
- [Implémentation](rules/implementation.md)
- [Style de réponse](skills/style-reponse/SKILL.md)

## Self-updating rules — imperative

When the user corrects my behavior, points out something I'm doing wrong, or gives explicit guidance on how to work together: **immediately** write or update the relevant rule in `~/.claude/rules/` and reference it here. Do not wait to be asked. This applies even mid-task — save the rule, then continue.
