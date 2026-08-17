# Wayscriber quick guide

Wayscriber starts as a background daemon when Hyprland starts.

## Global Hyprland shortcuts

| Shortcut | Action |
| --- | --- |
| `Super+Shift+A` | Show or hide Wayscriber |
| `Super+Ctrl+A` | Toggle light passthrough (interact with apps underneath) |

Run `hyprctl reload` once after changing these files. On later logins, the
daemon starts automatically. To start it immediately in the current session,
run `wayscriber --daemon` once.

## Essential overlay shortcuts

These work while the Wayscriber overlay has keyboard focus.

| Shortcut | Action |
| --- | --- |
| Mouse drag | Draw with the current tool |
| `F` / `H` / `D` | Pen / highlighter / eraser |
| `V` | Select tool |
| `T` / `N` | Text / sticky note |
| `R G B Y O P W K` | Pick a color |
| `+` / `-` | Increase / decrease tool thickness |
| `Ctrl+Z` / `Ctrl+Shift+Z` | Undo / redo |
| `E` | Clear the current canvas |
| `Ctrl+Shift+F` | Freeze or unfreeze the screen |
| `Ctrl+W` / `Ctrl+B` | Whiteboard / blackboard |
| `Ctrl+Shift+T` | Return to transparent overlay |
| `F2` | Cycle full, compact, and hidden toolbar |
| `F1` | Full shortcut help |
| `Shift+F1` | Quick reference |
| `Ctrl+K` | Search the command palette |
| `Escape` | Hide the overlay |

Light passthrough lets the drawing stay visible while clicks and keys reach the
application below. Use the global `Super+Ctrl+A` shortcut to get back out of it;
the overlay cannot reliably receive its own `F6` shortcut in passthrough mode.

## Capturing annotations

| Shortcut | Action |
| --- | --- |
| `Ctrl+C` | Copy the full screen to the clipboard |
| `Ctrl+S` | Save the full screen as PNG |
| `Ctrl+Shift+C` | Select a region and copy it |
| `Ctrl+Shift+S` | Select a region and save it |
| `Ctrl+Alt+O` | Open the most recent capture folder |

`grim`, `slurp`, and `wl-copy` are already installed on this machine.

## Useful commands

```bash
wayscriber --daemon              # start the background daemon
wayscriber --daemon-toggle       # show/hide from a terminal
wayscriber --active              # one-shot mode if the daemon is not running
wayscriber --session-info        # inspect persisted session data
wayscriber --clear-tool-state    # reset tools but preserve boards/history
wayscriber --clear-session       # delete saved boards (destructive)
```

Configuration lives at `~/.config/wayscriber/config.toml`. Wayscriber stores
generated UI/session state separately under `~/.local/share/wayscriber/`.
