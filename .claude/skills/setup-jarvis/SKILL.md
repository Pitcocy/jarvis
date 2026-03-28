---
name: setup-jarvis
description: Set up the Jarvis folder structure — creates all directories, template files, and workspace scaffolding. Run this first.
disable-model-invocation: true
---

# Jarvis Setup

Create the full Jarvis workspace by running the scaffold script:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/scaffold.sh
```

After the script runs, verify the structure was created by listing the top-level directories.

Then tell the user:

1. What was created (brief summary — don't list every file)
2. That the template CLAUDE.md and SOUL.md are functional but generic
3. **They should now run `/get-to-know-me`** — this is where Claude learns who they are and personalizes everything
4. After personalization, every new conversation will know who they are, remember what they worked on, and write in their voice

Keep it short and encouraging. They just took the first step.
