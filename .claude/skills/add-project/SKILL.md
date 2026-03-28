---
name: add-project
description: Add a new internal project to Jarvis — creates the folder structure, CLAUDE.md, and registers it in the root index.
disable-model-invocation: true
---

# Add Project

Set up a new internal project — things that aren't tied to a specific client (your own marketing, side projects, business initiatives).

For client work, use `/add-client` instead.

## Step 1: Gather Project Info

Ask the user about the project:

- **Project name** — what do they call it?
- **What it is** — one paragraph: what's the goal, what does it involve?
- **Status** — just starting? In progress? On hold?
- **Deadlines** — any hard dates?
- **Key people** — anyone else involved? (names, emails, roles)
- **Linked to a client?** — sometimes a project serves a client but lives separately. If so, note which client.

Keep it light. Not everything needs all fields.

## Step 2: Create the Folder Structure

Use the project name (lowercase, hyphens for spaces) as the folder name.

```
projects/{project-name}/
├── CLAUDE.md           # Project context
└── notes/              # Meeting notes, research, planning docs
```

Create the directories:

```bash
mkdir -p projects/{project-name}/notes
```

## Step 3: Write the Project's CLAUDE.md

```markdown
# {Project Name}

## Overview
{What this project is, the goal}

## Status
{Current status, what's been done, what's next}

## Deadlines
{Any hard dates — or "No fixed deadline"}

## Key People
{Anyone involved — names, roles, emails if relevant}

## Notes
- Planning docs and meeting notes go in `notes/`
```

## Step 4: Update the Root CLAUDE.md

Add a one-liner to the "Clients & Projects" section in the root CLAUDE.md. If the section doesn't exist yet, create it.

Format:
```markdown
- **{Project Name}** — `projects/{project-name}/` — {one-line summary}
```

## Step 5: Confirm

Tell the user:

> {Project Name} is set up. When you work on it, `cd projects/{project-name}/` — Jarvis loads the project context automatically.
>
> All your skills, hooks, and memory still work from the project folder.
