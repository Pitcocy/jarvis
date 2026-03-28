# Node.js & npm Setup

Several MCP servers require Node.js. Check if it's installed and at the right version.

## Steps

**1. Check Node.js**

```bash
node --version 2>/dev/null
```

- If not found → install: `brew install node`
- If found but below v20.19 → upgrade: `brew upgrade node`
- If v20.19+ → skip

**2. Verify npm**

npm comes with Node. Confirm:

```bash
npm --version 2>/dev/null
```

If missing (rare), run `brew install node` again.

**3. Verify npx and note its full path**

npx comes with Node but we need its absolute path for MCP servers (avoids PATH issues at runtime):

```bash
which npx
```

Remember this path — it's used when installing MCP servers. If `which npx` returns nothing, try `brew link node` or reinstall Node.
