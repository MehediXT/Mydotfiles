# dwm & Neovim keybindings

Reference for the bindings configured in this repository. NvChad defaults below
were checked against the locally installed NvChad; they can change after updates.

- **Super** = Windows key (`Mod4`); **Alt** = `Mod1`.
- **Neovim leader** = `Space`. Press sequences such as `Space f f` one key at a time.
- `Ctrl`, `Alt`, and `Shift` combinations are held together. Uppercase letters
  in Neovim sequences are case-sensitive: `Space H` means `Space`, then `Shift+h`.
- Neovim modes: **N** = Normal, **I** = Insert, **V** = Visual,
  **T** = Terminal, **C** = Command-line, **O** = Operator-pending.

## dwm

Source: [config.h](suckless/dwm/config.h), with behavior checked in
[dwm.c](suckless/dwm/dwm.c). These bindings apply when running a build using this config.

### Applications & session

| Shortcut | Action |
| --- | --- |
| `Super+d` | Open application launcher (`dmenu_run`) |
| `Super+Enter` | Open terminal (`st`) |
| `Super+w` | Open browser through `dwm-browser --new-window` |
| `Super+e` | Open file manager (`thunar`) |
| `Super+n` | Open Neovim in `st` |
| `Super+m` | Open VLC |
| `Super+p` | Open Gwenview |
| `Super+Shift+h` | Open `htop` in `st` |
| `Super+Shift+l` | Lock screen (`~/.local/bin/dwm-lock`) |
| `Super+Shift+p` | Open power menu (`dwm-power-menu`) |
| `Super+Ctrl+Shift+q` | Restart dwm |
| `Super+Shift+Backspace` | Quit dwm |
| `Super+Ctrl+Backslash` | Reload dwm colors from the X resource database |

### Windows & layouts

| Shortcut | Action |
| --- | --- |
| `Super+j` / `Super+k` | Focus next / previous window in the visible stack |
| `Super+Shift+j` / `Super+Shift+k` | Move focused window forward / backward in the stack |
| `Super+Space` | Promote focused tiled window to master; if already master, promote the next tiled window |
| `Super+Ctrl+Enter` | Focus master, or return to the previously marked window when master is focused (requires at most one master) |
| `Super+h` / `Super+l` | Shrink / grow master area by 5 percentage points |
| `Super+Shift+i` | Increase number of master windows |
| `Super+Ctrl+i` | Decrease number of master windows |
| `Super+t` | Tiled layout |
| `Super+Shift+m` | Monocle layout |
| `Super+s` | Spiral layout |
| `Super+Shift+t` | Dwindle layout |
| `Super+Ctrl+Space` | Toggle between the two most recently selected layouts |
| `Super+Shift+Space` | Toggle floating for focused window |
| `Super+f` | Toggle fullscreen for focused window |
| `Super+Ctrl+Shift+s` | Toggle sticky window (visible across tags) |
| `Super+q` | Close focused window |
| `Super+Shift+q` | Close all other visible windows on the selected monitor |

### Tags & monitors

Replace `1–9` with a tag number.

| Shortcut | Action |
| --- | --- |
| `Super+1–9` | View tag |
| `Super+Ctrl+1–9` | Add / remove tag from current view |
| `Super+Shift+1–9` | Assign focused window to tag |
| `Super+Ctrl+Shift+1–9` | Toggle tag assignment for focused window |
| `Super+Tab` | Switch to previous tag view |
| `Super+0` | View all tags |
| `Super+Shift+0` | Assign focused window to all tags |
| `Super+Ctrl+]` | Focus previous monitor |
| `Super+Ctrl+[` | Focus next monitor |
| `Super+Shift+]` | Send focused window to previous monitor |
| `Super+Shift+[` | Send focused window to next monitor |

### Gaps

| Shortcut | Action |
| --- | --- |
| `Super+-` / `Super+=` | Decrease / increase all gaps by 3 pixels |
| `Super+Shift+=` | Toggle gaps |
| `Super+Shift+-` | Restore default gaps |
| `Super+Alt+i` / `Super+Alt+Shift+i` | Increase / decrease inner gaps by 1 pixel |
| `Super+Alt+o` / `Super+Alt+Shift+o` | Increase / decrease outer gaps by 1 pixel |
| `Super+Alt+6` / `Super+Alt+Shift+6` | Increase / decrease horizontal inner gaps by 1 pixel |
| `Super+Alt+7` / `Super+Alt+Shift+7` | Increase / decrease vertical inner gaps by 1 pixel |
| `Super+Alt+8` / `Super+Alt+Shift+8` | Increase / decrease horizontal outer gaps by 1 pixel |
| `Super+Alt+9` / `Super+Alt+Shift+9` | Increase / decrease vertical outer gaps by 1 pixel |

Default gaps: inner horizontal/vertical = **20/20 px**; outer horizontal/vertical = **20/30 px**.

### Bar

| Shortcut | Action |
| --- | --- |
| `Super+Shift+b` | Toggle entire bar |
| `Super+Ctrl+t` | Toggle window title |
| `Super+Ctrl+s` | Toggle status text |
| `Super+Ctrl+Shift+t` | Toggle tags |
| `Super+Ctrl+e` | Swap bar foreground/background colors for tags and window title |
| `Super+Ctrl+r` | Toggle layout indicator |
| `Super+Ctrl+f` | Toggle floating indicator |

### Screenshots, volume & playback

| Shortcut | Action |
| --- | --- |
| `F6`, `Super+Shift+s`, or `Ctrl+Alt+s` | Save region screenshot (`dwm-screenshot region`) |
| `Print`, `Super+F1`, or `Ctrl+Alt+Shift+s` | Save full screenshot (`dwm-screenshot full`) |
| `Super+F6` | Raise volume by 5% |
| `Super+F5` | Lower volume by 5% |
| `Super+F4` or `Super+Backslash` | Toggle audio mute |
| `Super+]` | Raise volume by 5%, capped at 100% |
| `Super+[` | Lower volume by 5% |
| `Super+F11` | Play / pause (`playerctl`) |
| `Super+F10` / `Super+F12` | Previous / next track |

### Mouse

| Gesture | Action |
| --- | --- |
| `Super+Left drag` on window | Move window |
| `Super+Right drag` on window | Resize window |
| `Super+Middle click` on window | Restore default gaps |
| `Super+Scroll up/down` on window | Increase / decrease all gaps by 1 pixel |
| Left click tag | View tag |
| Right click tag | Toggle tag in current view |
| `Super+Left click` tag | Assign focused window to tag |
| `Super+Right click` tag | Toggle tag assignment for focused window |
| Middle click window title | Promote window to master |
| Middle click desktop | Toggle bar |
| Click / scroll status text | Send button action to `dwmblocks` (depends on its configuration) |
| `Shift+Left click` status text | Send action 6 to `dwmblocks` |
| `Shift+Right click` status text | Edit `~/.local/src/dwmblocks/blocks.h` in Neovim |

Although the config defines applications for middle-clicked tags, no active
tag middle-click binding invokes them.

## Neovim

Sources: [init.lua](.config/nvim/init.lua),
[mappings.lua](.config/nvim/lua/mappings.lua),
[aucmds.lua](.config/nvim/lua/aucmds.lua), and
[plugin configs](.config/nvim/lua/plugins). This section covers custom bindings,
inherited NvChad mappings, and selected useful plugin defaults.

### Editing, files & buffers

| Shortcut | Mode | Action |
| --- | --- | --- |
| `jj` | I | Leave Insert mode |
| `Space w` or `Ctrl+s` | N | Save file |
| `Space q` | N | Quit current window (`:q`) |
| `Space w q` | N | Save and quit current window (`:wq`) |
| `Ctrl+y` | N | Yank entire buffer into unnamed register and return to saved cursor position |
| `Ctrl+c` | N | Copy entire file to system clipboard (`+` register) |
| `Space H` or `Esc` | N | Clear search highlighting |
| `gf` | N | Edit filename under cursor, including a new file if it does not exist |
| `<` / `>` | N | Unindent / indent current line |
| `<` / `>` | V | Unindent / indent selection and keep it selected |
| `Space /` | N / V | Toggle comment on line / selection |
| `Space f m` | N / V | Format using Conform, with LSP fallback |
| `Space n` | N | Toggle absolute line numbers |
| `Space r n` | N | Toggle relative line numbers |
| `Space b` | N | New empty buffer |
| `Tab` / `Shift+Tab` | N | Next / previous buffer (NvChad tabufline) |
| `Space x` | N | Close buffer (NvChad tabufline) |
| `Space c h` | N | Open NvChad cheatsheet |
| `Space w K` | N | Show all mappings in WhichKey |
| `Space w k` | N | Prompt for a mapping prefix to inspect in WhichKey |

`Space w` shares a prefix with `Space w q` and several NvChad mappings,
so saving can wait for the mapping timeout while Neovim checks for more keys.

### Windows & terminals

| Shortcut | Mode | Action |
| --- | --- | --- |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` | N / T | Focus left / lower / upper / right window; leaves Terminal mode first |
| `Ctrl+h` / `Ctrl+l` | I | Move one character left / right |
| `Ctrl+j` / `Ctrl+k` | I | Move down / up (completion can override `Ctrl+k`; see below) |
| `Space h` | N | New horizontal terminal |
| `Space v` | N | New vertical terminal |
| `Alt+h` | N / T | Toggle horizontal terminal |
| `Alt+v` | N / T | Toggle vertical terminal |
| `Alt+i` | N / T | Toggle floating terminal |
| `Ctrl+x` | T | Leave Terminal mode |
| `Space p t` | N | Pick a hidden terminal with Telescope |

### Search & file tree

| Shortcut | Mode | Action |
| --- | --- | --- |
| `Space f f` | N | Find files |
| `Space f a` | N | Find files including hidden/ignored files and following symlinks |
| `Space f w` | N | Search text across files (live grep) |
| `Space f z` | N | Fuzzy search current buffer |
| `Space f b` | N | Find open buffers |
| `Space f o` | N | Find recently opened files |
| `Space f h` | N | Search help tags |
| `Space m a` | N | Find marks |
| `Space c m` | N | Browse Git commits |
| `Space g t` | N | Browse Git status |
| `Space t h` | N | Open theme picker |
| `Ctrl+n` | N | Toggle file tree |
| `Space e` | N | Focus file tree; overridden by diagnostics in LSP buffers |

Useful defaults **inside the file tree**:

| Shortcut | Action |
| --- | --- |
| `Enter` or `o` | Open file / expand directory |
| `Ctrl+v` / `Ctrl+x` / `Ctrl+t` | Open in vertical split / horizontal split / new tab |
| `Tab` | Preview file |
| `a` | Create file or directory |
| `r` | Rename |
| `d` / `D` | Delete / move to trash |
| `c` / `x` / `p` | Copy / cut / paste |
| `y` / `Y` / `gy` | Copy filename / relative path / absolute path |
| `H` / `I` | Toggle hidden files / Git-ignored files |
| `R` | Refresh tree |
| `-` | Change tree root to parent directory |
| `W` / `E` | Collapse / expand all directories |
| `q` | Close tree |
| `g?` | Show tree keybindings |

### LSP & diagnostics

These mappings apply in buffers with an attached language server.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `gd` / `gD` | N | Go to definition / declaration |
| `Space D` | N | Go to type definition |
| `K` | N | Hover documentation |
| `gr` | N | Find references |
| `Space r a` | N | Rename symbol with NvChad renamer |
| `Space c a` | N | LSP code actions (overrides CodeCompanion in this mode/buffer) |
| `Space e` | N | Show line diagnostics (overrides file-tree focus) |
| `[d` / `]d` | N | Previous / next diagnostic, with floating detail |
| `Space d s` | N | Put diagnostics in location list (global mapping) |
| `Space w a` / `Space w r` | N | Add / remove workspace folder |
| `Space w l` | N | List workspace folders |

### Insert & command-line navigation

| Shortcut | Mode | Action |
| --- | --- | --- |
| `Ctrl+a` / `Ctrl+e` | I / C | Start / end of line |
| `Ctrl+b` / `Ctrl+f` | I / C | Move one character backward / forward |
| `Alt+b` or `Alt+Left` | I / C | Move backward one word |
| `Alt+f` or `Alt+Right` | I / C | Move forward one word |
| `Ctrl+d` | I / C | Delete character under cursor |
| `Alt+d` | I | Delete forward using `dw` |
| `Ctrl+w` | I | Delete backward using `db` |
| `Ctrl+u` | I | Delete to start of line using `d0` |
| `Ctrl+z` | I | Undo via one Normal-mode command |

The config also maps Command-line `Ctrl+z` to `<C-o>u`; that is an
Insert-mode undo sequence and should not be relied on for command-line undo.
Blink completion can take over some of these keys while its UI is active.

### Completion & AI

Configured Blink completion uses the `default` preset with custom Enter/Tab behavior.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `Ctrl+Space` | I | Show completion / show documentation / hide documentation |
| `Tab` / `Shift+Tab` | I | Next / previous completion item, then snippet jump, then fallback |
| `Enter` | I | Accept deliberately selected completion; otherwise insert newline |
| `Ctrl+n` / `Ctrl+p` or `Down` / `Up` | I | Next / previous completion item |
| `Ctrl+e` | I | Cancel completion, otherwise fallback |
| `Ctrl+b` / `Ctrl+f` | I | Scroll completion documentation up / down, otherwise fallback |
| `Ctrl+k` | I | Show / hide signature help, otherwise fallback |
| `Ctrl+y` | I | Copilot accept mapping; Blink also uses this key for completion acceptance (see notes below) |
| `Space c c` | N / V | Toggle CodeCompanion chat |
| `Space c a` | N / V | CodeCompanion actions; Normal mode is overridden in LSP buffers |
| `Space c i` | N / V | Inline CodeCompanion prompt |

CodeCompanion is configured to use local Ollama with `qwen2.5:latest`.

### Compile, run & competitive programming

| Shortcut | Mode | Action |
| --- | --- | --- |
| `F5` | N | Save if modified, then compile/run interactively in a bottom terminal |
| `F6` or `Space c r` | N | Run CompetiTest testcases |
| `F8` | N | Insert CP template in buffers matching `*/cp/*.cpp` |
| `Space c s` | N | Show CompetiTest UI |
| `Space c t` | N | Receive CompetiTest testcases |
| `Space c m a` | N | Add testcase |
| `Space c m e` | N | Edit testcase |
| `Space c m d` | N | Delete testcase |
| `Space c f` | N | Run file with code_runner |
| `Space r f t` | N | Run file in a tab with code_runner |
| `Space r p` | N | Run project with code_runner |
| `Space r c` | N | Close code_runner output |
| `Space c r f` | N | Open code_runner filetype configuration |
| `Space c r p` | N | Open code_runner project configuration |

`F5` supports C, C++, Python, Lua, and Java. C/C++/Python runs report time and
memory. `F8` reads the adjacent `cp/template.cpp` next to the Neovim config
directory. CompetiTest and code_runner mappings load for C, C++, Python, Rust,
and Java buffers. Their shared prefixes (`Space c r`, `Space c m`) can introduce
a mapping timeout before a shorter binding runs.

Insert-mode shortcuts from `aucmds.lua` (defined globally):

| Typed text | Expansion |
| --- | --- |
| `cin` | `cin >> ` |
| `vin` | Insert an integer length, input statement, integer vector, and input loop |
| `vi` | Abbreviation for `vector<int>` |
| `vvi` | Abbreviation for `vector<vector<int>>` |
| `pb` | Abbreviation for `push_back(` |
| `pob` | Abbreviation for `pop_back(` |

Abbreviations expand when followed by a delimiter such as a space.

### CSV buffers

CsvView is enabled automatically for `*.csv` files.

| Shortcut | Mode | Action |
| --- | --- | --- |
| `Tab` / `Shift+Tab` | N / V | Next / previous field end |
| `Enter` / `Shift+Enter` | N / V | Next / previous row |
| `if` / `af` | O / V | Inner / outer field text object (for example, `dif` or `vaf`) |

### Overlaps & checking a binding

- **dwm grabs `F6` globally for region screenshots.** Use `Space c r` to run
  CompetiTest while using this dwm config.
- **`Space e` and `Space c a` change in LSP buffers.** Use `Ctrl+n` to toggle
  the file tree; use `:NvimTreeFocus` or `:CodeCompanionActions` for direct access.
- **Insert `Ctrl+y` is assigned by both Copilot and Blink.** The effective
  mapping depends on loading and completion state; `Tab`, then `Enter`, is the
  configured way to select and accept a completion explicitly.
- **CSV and file-tree buffer mappings override global keys**, including `Tab`.

Inspect a mapping in its actual buffer/mode with `:verbose nmap <leader>e`,
`:verbose nmap <F6>`, or `:verbose imap <C-y>`. Use `:verbose cmap <C-z>`
for the Command-line mapping, and `Space c h` for the NvChad cheatsheet.
