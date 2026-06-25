# Neovim Cheatsheet

A comprehensive reference for all keymaps, commands, and features in this Neovim setup.

---

## 📋 Quick Navigation
- [Basic Keymaps](#basic-keymaps)
- [Editing Keymaps](#editing-keymaps)
- [Terminal Keymaps](#terminal-keymaps--command-mode)
- [Plugin Commands](#plugin-commands)
- [Custom Functions](#custom-functions)
- [Editor Settings](#editor-settings)
- [Installed Tools & Formatters](#installed-tools--formatters)

---

## Basic Keymaps

### Quick Operations
| Keymap | Mode | Action |
|--------|------|--------|
| `jj` | Insert | Exit insert mode |
| `<C-y>` | Normal | Copy entire file to clipboard |
| `<leader>H` | Normal | Unhighlight search results |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Exit without saving |
| `<leader>wq` | Normal | Save & Exit |
| `gf` | Normal | Edit file under cursor (create if not found) |
| `<` | Normal | Decrease indentation |
| `>` | Normal | Increase indentation |
| `<` | Visual | Decrease indentation (keep selection) |
| `>` | Visual | Increase indentation (keep selection) |

---

## Editing Keymaps

### GNU Readline-style Navigation

#### Insert Mode

**Navigation:**
| Keymap | Action |
|--------|--------|
| `<C-a>` | Move to start of line |
| `<C-e>` | Move to end of line |
| `<C-f>` | Move forward one character |
| `<C-b>` | Move backward one character |
| `<M-f>` or `<M-Right>` | Move forward one word |
| `<M-b>` or `<M-Left>` | Move backward one word |

**Deletion:**
| Keymap | Action |
|--------|--------|
| `<C-d>` | Delete character under cursor |
| `<M-d>` | Delete word after cursor |
| `<C-w>` | Delete word before cursor |
| `<C-u>` | Delete from cursor to start of line |
| `<C-k>` | Delete from cursor to end of line |
| `<C-z>` | Undo |

#### Command Mode

**Navigation:**
| Keymap | Action |
|--------|--------|
| `<C-a>` | Move to start of line |
| `<C-e>` | Move to end of line |
| `<C-f>` | Move forward one character |
| `<C-b>` | Move backward one character |
| `<M-f>` or `<M-Right>` | Move forward one word |
| `<M-b>` or `<M-Left>` | Move backward one word |

**Deletion:**
| Keymap | Action |
|--------|--------|
| `<C-d>` | Delete character under cursor |
| `<C-z>` | Undo |

---

## Terminal / Command Mode

### Compilation
| Keymap | Command | Action |
|--------|---------|--------|
| `<F5>` | `:lua Compile()` | Compile current file |

Supports file types:
- **Python:** `python3 filename`
- **C:** `tcc -run filename`
- **Lua:** `lua filename`
- **R Markdown:** `Rscript -e "rmarkdown::render('filename', output_format = 'pdf_document')"`

---

## Plugin Commands

### 🔍 Telescope (File Finder & Search)
| Command | Keymap | Action |
|---------|--------|--------|
| `Telescope find_files` | `<leader>ff` | Find files |
| `Telescope oldfiles` | `<leader>fo` | Recent files |
| `Telescope live_grep` | `<leader>fw` | Find word |
| `Telescope marks` | `<leader>ma` | Bookmarks |

### 🎨 Theme & UI
| Command | Keymap | Action |
|---------|--------|--------|
| `:lua require('nvchad.themes').open()` | `<leader>th` | Open theme selector |
| `NvCheatsheet` | `<leader>ch` | Show NvChad cheatsheet |

### 📁 File Tree (NvimTree)
Automatically loaded. Default keybindings from NvChad.

### 📝 Code Runner
| Command | Keymap | Action |
|---------|--------|--------|
| `RunFile` | `<leader>cf` | Run current file |
| `RunFile tab` | `<leader>rft` | Run file in new tab |
| `RunProject` | `<leader>rp` | Run project |
| `RunClose` | `<leader>rc` | Close runner |
| `CRFiletype` | `<leader>crf` | Configure runner for filetype |
| `CRProjects` | `<leader>crp` | Configure project runner |

**Supported Filetypes:**
- Python, Java, Rust, C, C++, TypeScript

### 🧪 CompetiTest (Competitive Programming)
| Command | Keymap | Action |
|---------|--------|--------|
| `CompetiTest run` | `<leader>cr` | Run test cases |
| `CompetiTest show_ui` | `<leader>cs` | Show test UI |
| `CompetiTest receive testcases` | `<leader>ct` | Receive testcases (from Codeforces, etc.) |
| `CompetiTest add_testcase` | `<leader>cma` | Add testcase |
| `CompetiTest edit_testcase` | `<leader>cme` | Edit testcase |
| `CompetiTest delete_testcase` | `<leader>cmd` | Delete testcase |

**Supported Languages:** C, C++, Python, Rust, Java

**Configuration:**
- Compile directory: Current directory
- Test cases directory: `./testcases`
- Input format: `<filename>_input_<testnum>.txt`
- Output format: `<filename>_output_<testnum>.txt`

### 📊 Markdown & Quarto
| Command | Action |
|---------|--------|
| `PeekOpen` | Open markdown preview (live) |
| `PeekClose` | Close markdown preview |

**Render Markdown Features:**
- Heading rendering with icons
- Full-width heading backgrounds
- Custom heading styles (6 levels)

**Quarto Features:**
- Code chunk execution (Python, R, Bash, Julia, C)
- YAML header support
- LSP completion in code chunks
- Runner integration (Slime, Molten, Iron)

### 🎵 CSV Support
CSV files are automatically syntax highlighted and can be navigated with standard vim commands.

### ✏️ Formatting & Linting
- `conform.nvim`: Automatic code formatting
- Trigger with LSP format command or custom keybindings (configured per filetype)

---

## Custom Functions

### `Compile()`
**Keymap:** `<F5>`

Compiles and runs files based on filetype. Shows timing info for interpreted languages.

**Output Messages:**
- ✓ Compilation successful!
- ✗ Compilation failed

**Supported Files:**
| Filetype | Command |
|----------|---------|
| `python` | `python3 filename` (with timing) |
| `c` | `tcc -run filename` (with timing) |
| `lua` | `lua filename` (with timing) |
| `rmd` | `Rscript -e "rmarkdown::render(...)"` |

---

## Editor Settings

### Editor Behavior
| Setting | Value | Purpose |
|---------|-------|---------|
| `cursorlineopt` | `both` | Show cursor line & column |
| `relativenumber` | `true` | Show relative line numbers |
| `tabstop` | `4` | Tab width visualization |
| `expandtab` | `false` | Use actual tabs (not spaces) |
| `shiftwidth` | `4` | Indent width |
| `smartindent` | `true` | Smart automatic indentation |
| `softtabstop` | `4` | Soft tab stop |
| `numberwidth` | `4` | Line number column width |
| `wrap` | `false` | Don't wrap long lines |
| `list` | `true` | Show invisible characters |
| `spell` | `true` | Enable spell checking |
| `scrolloff` | `16` | Keep 16 lines visible above/below cursor |
| `sidescrolloff` | `8` | Keep 8 chars visible left/right |
| `foldmethod` | `marker` | Fold using `{{{ }}}` markers |

### Spell Checking
- **Spell file:** `~/.config/nvim/spell/en.utf-8.add`
- **Auto-enabled for:** markdown, text files
- **Text width (markdown/text):** 80 characters

### Display Settings
| Setting | Value |
|---------|-------|
| Theme | `ayu_dark` |
| Transparency | Disabled |
| Tab character | `│ ` |
| Trailing spaces | Visible as `·` |

---

## Language Server Protocol (LSP)

### Enabled Language Servers
| Server | Language | Features |
|--------|----------|----------|
| `html` | HTML | Formatting, completion, diagnostics |
| `cssls` | CSS | Formatting, completion, diagnostics |
| `clangd` | C/C++ | Smart completion, clang-tidy |
| `luals` | Lua | Formatting, completion, diagnostics |
| `biome` | JavaScript/TypeScript | Linting, formatting |
| `gopls` | Go | Formatting, completion, diagnostics |
| `ruff` | Python | Linting, formatting |
| `prismals` | Prisma | Schema validation, completion |
| `rust-analyzer` | Rust | Full IDE-like features |
| `taplo` | TOML | Schema validation |
| `jdtls` | Java | Full IDE-like features |

### clangd Configuration
- **Header insertion:** Use IWYU (Include What You Use)
- **Clang-tidy:** Enabled for linting
- **Header decorators:** Disabled

---

## Code Formatting

### Formatters by Language
| Language | Formatters |
|----------|-----------|
| C/C++ | `clang-format` (if `.cformat` exists) |
| Python | `ruff_format` + `isort` (or `autoflake` + `isort` + `black`) |
| JavaScript/TypeScript | `biome` + `biome-organize-imports` |
| Go | `golines`, `goimports`, `gofmt`, `gofumpt` |
| Rust | `rustfmt` (with hard tabs) |
| HTML | `prettier` |
| CSS | `prettier` |
| JSON | `biome` |
| Lua | `stylua` |
| Markdown | `prettier` |
| Prisma | `prisma format` |
| SQL | `sleek` |
| Shell | `shfmt` |
| Haskell | `fourmolu` |
| Typst | `prettypst` |

### Formatter Options
- **Prettier:** Print width: 80, Use tabs
- **Prettier (Markdown):** Print width: 80, 2 spaces, prose wrap enabled
- **Rustfmt:** Hard tabs enabled
- **Prettypst:** OTBS style

---

## Installed Tools & Mason Packages

### Development Tools
| Tool | Purpose |
|------|---------|
| `autoflake` | Remove unused imports (Python) |
| `black` | Code formatter (Python) |
| `clangd` | C/C++ language server |
| `css-lsp` | CSS language server |
| `goimports` | Go import formatter |
| `golines` | Go line formatter |
| `gopls` | Go language server |
| `html-lsp` | HTML language server |
| `isort` | Python import sorter |
| `lua-language-server` | Lua language server |
| `prettier` | Multi-language formatter |
| `python-lsp-server` | Python language server |
| `stylua` | Lua code formatter |

---

## NvChad Integration

This setup uses **NvChad v2.5** as the base framework, which provides:

- Dashboard with quick access buttons
- Pre-configured LSP setup
- Telescope integration
- Status line with minimal theme
- Base46 theme system
- Default keymaps and commands

### NvChad Default Keymaps
- Most editing keymaps are inherited from NvChad defaults
- Custom mappings are defined in `mappings.lua`
- Plugins are managed with Lazy.nvim

---

## Treesitter Syntax Highlighting

### Installed Parsers
- `css`
- `go`
- `html`
- `lua`
- `rust`
- `vim`
- `vimdoc`

---

## Tips & Tricks

### Quick File Operations
1. **Create new file:** `gf` on a filename reference to create it
2. **Copy entire file:** `<C-y>` in normal mode
3. **Quick save:** `<leader>w`

### Code Execution
1. **Compile & run:** Press `<F5>`
2. **Run with code_runner:** `<leader>cf`
3. **Run tests (competitive):** `<leader>cr`

### Navigation
- Use `<C-a>` and `<C-e>` in insert mode for readline-like navigation
- Alt+arrow keys work for word-by-word navigation in command mode

### Formatting
- Most filetypes auto-format based on formatter configuration
- Use LSP format command for LSP-based formatting

### Spelling
- Enabled by default for all files
- Add words to `~/.config/nvim/spell/en.utf-8.add`

---

## File Structure Reference

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lazy-lock.json          # Locked plugin versions
├── lua/
│   ├── mappings.lua        # All custom keybindings
│   ├── options.lua         # Editor settings
│   ├── func.lua            # Custom functions (Compile())
│   ├── aucmds.lua          # Old autocommands
│   ├── autocmds.lua        # Autocommands
│   ├── chadrc.lua          # NvChad configuration
│   ├── lazy-conf.lua       # Lazy.nvim configuration
│   ├── plugin/             # Plugin configurations
│   │   ├── lsp.lua         # LSP servers
│   │   ├── conform.lua     # Code formatting
│   │   ├── treesitter.lua  # Syntax highlighting
│   │   ├── coderunner.lua  # Code runner
│   │   ├── competitest.lua # Competitive testing
│   │   ├── quarto.lua      # Quarto/notebook support
│   │   ├── markdown.lua    # Markdown rendering
│   │   ├── peek.lua        # Markdown preview
│   │   └── ...
│   └── configs/            # Configuration modules
├── snippets/               # Snippet definitions
└── CHEATSHEET.md          # This file
```

---

## Customization

### Add New Keymaps
Edit `lua/mappings.lua` and follow the pattern:
```lua
map("mode", "keymap", "action", { desc = "Description" })
```

### Add New Plugins
Create a file in `lua/plugin/pluginname.lua` and return a Lazy.nvim spec.

### Change Formatter Options
Edit `lua/plugin/conform.lua` to modify formatter arguments.

### Add Language Server
Edit `lua/plugin/lsp.lua` and add to the `servers` table.

---

**Last Updated:** 2026-05-05
