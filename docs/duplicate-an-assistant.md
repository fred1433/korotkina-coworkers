# Make a new assistant from an existing one

Each assistant is one folder with one text file, `SKILL.md`. To make a new one (for example for engraving or appraisal requests), copy a folder and change four things.

## 1. Copy the folder

Copy `korotkina-coworkers/skills/repair-inquiries/` and rename the copy, for example `engraving-inquiries/`. Use lowercase letters, numbers and hyphens only.

## 2. Change the name and the description (top of the file)

```markdown
---
name: engraving-inquiries
description: Draft a reply to a client who asks about engraving a piece at Alina Korotkina Fine Jewelry. Use when a message mentions engraving, initials, a date or a quote inside a ring.
---
```

- `name` must be exactly the folder name.
- `description` is what Claude reads to decide when to use the assistant. Say the situation and the words a client would use. Up to 1,024 characters.

## 3. Change the facts it may rely on

Replace the list under "What you may rely on" with facts from your own site or your own words, and nothing else. For engraving, the services page offers names, dates, initials or a short quote added to any piece. Keep the "Never" list: no prices, no dates, no availability, no invented policies.

## 4. Change the output

Keep the two-part output (a short reply for the client, a note for you) or change it. Say the length you want and how to sign off.

## 5. Package and add it

- One assistant: zip the folder itself (not its contents), so the archive holds `engraving-inquiries/SKILL.md`, then upload under **Customize > Skills**.
- With the others: put the folder in `skills/`, raise `version` in `.claude-plugin/plugin.json`, zip the plugin folder, upload under **Customize > Plugins**.

Sources (12 October 2026): [Create custom skills](https://claude.com/docs/skills/how-to), [Plugin structure and testing](https://claude.com/docs/plugins/build).

Then try it on two or three real messages, including a difficult one (an urgent request, an unclear piece). If Claude does not pick it, make the description more specific.
