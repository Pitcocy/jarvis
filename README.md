# Jarvis

A Claude Code personal assistant starter kit for marketers. Folder structure, memory, skills and hooks, ready to go.

## Install (Claude desktop app, no terminal)

1. Install the Claude desktop app and sign in (Pro or Max plan).
2. Create an empty folder called `jarvis`, open it in the **Code** tab, and send:

   > Download Jarvis into this folder by running `curl -fsSL https://codeload.github.com/Pitcocy/jarvis/tar.gz/main | tar -xz --strip-components=1`. Then tell me to restart the app.

3. Quit and reopen the Claude app in the same folder, then run `/setup-jarvis`. It installs everything else (Node.js, git, GitHub CLI) and backs your folder up to a private GitHub repo.
4. Run `/get-to-know-me`.

Already comfortable with GitHub? Use **Use this template** (private) and clone it instead of step 2. `/setup-jarvis` handles the rest.
