# Chrome DevTools MCP

[Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) gives Jarvis browser control — navigate pages, take screenshots, click elements, fill forms, run JavaScript, inspect network requests, and run Lighthouse audits.

**Prerequisites:** Node.js v20.19+ (run Node setup first), Chrome browser installed.

## Steps

### 1. Resolve the full npx path

This avoids the PATH issue where MCP servers can't find `npx` at runtime:

```bash
NPX_PATH=$(which npx)
echo "npx is at: $NPX_PATH"
```

If this returns empty, Node isn't installed properly — go back to Node setup.

### 2. Install the MCP server

```bash
claude mcp add chrome-devtools --scope user -- "$NPX_PATH" chrome-devtools-mcp@latest
```

User scope — available in every Claude Code project, not just Jarvis.

### 3. Tell the user to restart Claude Code

> I've added the Chrome DevTools MCP server. For it to load, you'll need to restart Claude Code.
>
> Just close this session and open a new one. When you come back, I'll be able to control your browser — take screenshots, navigate pages, fill out forms, and more.

### 4. Verify (after restart)

After the user restarts, test by asking Claude to take a screenshot of any URL. If a browser launches and a screenshot comes back, it's working.

---

## Available Tools

### Input Automation
| Tool | What it does |
|------|-------------|
| `click` | Click an element on the page |
| `drag` | Drag from one point to another |
| `fill` | Fill a single input field |
| `fill_form` | Fill multiple form fields at once |
| `handle_dialog` | Accept/dismiss browser dialogs |
| `hover` | Hover over an element |
| `press_key` | Press a keyboard key |
| `type_text` | Type text character by character |
| `upload_file` | Upload a file to a file input |

### Navigation
| Tool | What it does |
|------|-------------|
| `navigate_page` | Go to a URL |
| `new_page` | Open a new tab |
| `close_page` | Close a tab |
| `list_pages` | List all open tabs |
| `select_page` | Switch to a specific tab |
| `wait_for` | Wait for an element or condition |

### Observation
| Tool | What it does |
|------|-------------|
| `take_screenshot` | Screenshot the current page |
| `take_snapshot` | Get the DOM snapshot (accessibility tree) |
| `evaluate_script` | Run JavaScript on the page |
| `list_console_messages` | List console output |
| `get_console_message` | Get a specific console message |

### Network
| Tool | What it does |
|------|-------------|
| `list_network_requests` | List all network requests |
| `get_network_request` | Get details of a specific request |

### Performance
| Tool | What it does |
|------|-------------|
| `performance_start_trace` | Start recording a performance trace |
| `performance_stop_trace` | Stop recording and get results |
| `performance_analyze_insight` | Analyze trace insights |
| `take_memory_snapshot` | Capture heap snapshot |
| `lighthouse_audit` | Run a Lighthouse performance audit |

### Emulation
| Tool | What it does |
|------|-------------|
| `emulate` | Emulate a device (mobile, tablet, etc.) |
| `resize_page` | Change viewport size |

## Configuration Options

These can be passed as additional args when adding the MCP:

```bash
claude mcp add chrome-devtools --scope user -- "$(which npx)" chrome-devtools-mcp@latest --headless --isolated
```

| Flag | What it does |
|------|-------------|
| `--headless` | Run Chrome without a visible window |
| `--isolated` | Use temporary profile, auto-cleaned |
| `--viewport 1280x720` | Set initial viewport size |
| `--channel canary` | Use Chrome Canary instead of stable |
| `--no-usage-statistics` | Disable Google usage metrics |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| MCP not loading | Restart Claude Code after `claude mcp add` |
| "npx not found" at runtime | Re-add with full path: `claude mcp add chrome-devtools --scope user -- "$(which npx)" chrome-devtools-mcp@latest` |
| Chrome doesn't launch | Make sure Chrome is installed and up to date |
| Tools not appearing | Run `claude mcp list` to verify it's registered |
| Timeout errors | Chrome may be slow to start — try `--headless` for faster startup |
