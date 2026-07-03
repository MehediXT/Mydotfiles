# Neovim Setup

This file documents the current Neovim configuration in this workspace.

## Overview

- Base: NvChad v2.5
- Plugin manager: lazy.nvim
- Main config entry: `init.lua`
- User config files: `lua/chadrc.lua`, `lua/options.lua`, `lua/mappings.lua`, `lua/aucmds.lua`, `lua/func.lua`
- Main goal: a coding-focused setup for C++, Rust, Python, Lua, web files, markdown, Quarto, and competitive programming

## Theme and UI

### Active theme
- Base46 theme: `tokyodark`
- Transparency: disabled
- Statusline theme: `minimal`
- Telescope style: `bordered`
- Completion UI: icons enabled, lspkind text enabled

### Theme overrides
`lua/chadrc.lua` also defines highlight overrides for:
- comments, types, booleans, numbers
- NvDash UI groups
- Treesitter groups such as `@type`, `@function`, `@module`, `@keyword`, `@operator`, and punctuation groups

### Dashboard
- NvDash loads on startup
- Custom ASCII header
- Custom buttons for:
  - Find file
  - Recent files
  - Live grep
  - Bookmarks
  - Theme selector
  - Cheatsheet

## Core plugin stack

### Editor core
- `NvChad/NvChad`
- `nvchad/base46`
- `nvchad/ui`
- `nvim-lua/plenary.nvim`
- `nvzone/volt`
- `nvzone/menu`
- `nvzone/minty`
- `nvim-tree/nvim-web-devicons`

### File navigation
- `nvim-tree/nvim-tree.lua`

### Searching and picker
- Telescope is provided through NvChad defaults

### Treesitter
- `nvim-treesitter/nvim-treesitter`
- Parsers installed for:
  - bash
  - c
  - cpp
  - css
  - html
  - htmldjango
  - javascript
  - lua
  - markdown
  - python
  - rust
  - toml
  - typescript
  - vim
  - vimdoc
- Highlight and indentation enabled
- Treesitter is started on FileType
- Custom C++ query overrides live in `after/queries/cpp/highlights.scm`

### LSP
- `neovim/nvim-lspconfig`
- Servers enabled:
  - `html`
  - `cssls`
  - `clangd`
  - `lua_ls`
  - `biome`
  - `gopls`
  - `ruff`
  - `prismals`
  - `taplo`
  - `jdtls`
- `clangd` is configured with:
  - `--header-insertion=iwyu`
  - `--header-insertion-decorators=0`
  - `--clang-tidy`
- clangd semantic tokens are disabled so Treesitter can control syntax coloring more cleanly in C/C++

### Completion
- `nvchad.blink.lazyspec` is imported

### Git and lint UI
- `lewis6991/gitsigns.nvim` via NvChad defaults
- `folke/which-key.nvim` via NvChad defaults

### Formatting
- `stevearc/conform.nvim`
- Formatters by filetype:
  - C: conditional `clang-format` when a `.cformat` file exists
  - C++: `clang-format`
  - CSS: `prettier`
  - Go: `golines`, `goimports`, `gofmt`, `gofumpt`
  - Haskell: `fourmolu`
  - Prisma: `prisma_format`
  - HTML: `prettier`
  - JavaScript / React: `biome` + `biome-organize-imports`
  - TypeScript / React: `biome` + `biome-organize-imports`
  - JSON: `biome`
  - Lua: `stylua`
  - Markdown and R Markdown: `prettier_md`
  - Python: `ruff_format` + `isort` when available, otherwise `autoflake` + `isort` + `black`
  - Rust: `rustfmt` with `hard_tabs=true`
  - SQL: `sleek`
  - Shell: `shfmt`
  - Typst: `prettypst`

### Code quality / tidy
- `mcauley-penney/tidy.nvim`
- Enabled on save
- Diff buffers are excluded

## Language-specific tooling

### C and C++
- `clangd` LSP
- `clang-format` formatter
- `code_runner.nvim` support
- `competitest.nvim` support
- Treesitter C++ highlight overrides

### Rust
- `rustaceanvim`
- `rustfmt` formatter
- `code_runner.nvim` support
- `competitest.nvim` support

### Python
- `ruff` LSP
- `black`, `isort`, `autoflake` format path
- `code_runner.nvim` support
- `competitest.nvim` support

### Java
- `jdtls`
- `code_runner.nvim` support
- `competitest.nvim` support

### Web and markup
- HTML, CSS, JavaScript, TypeScript, JSON, markdown, and Quarto support
- `render-markdown.nvim` for markdown rendering
- `peek.nvim` for markdown preview
- `quarto-nvim` for Quarto documents
- `nabla.nvim` for markdown/TeX math rendering
- `typst-preview.nvim` for Typst

### CSV
- `csvview.nvim`
- Field navigation and text objects are mapped for CSV files

## AI and assistance

### Copilot
- `github/copilot.vim`
- Insert mode accept mapping: `<C-y>`
- Tab mapping is disabled for Copilot

### CodeCompanion
- `olimorris/codecompanion.nvim`
- Chat, actions, and inline prompts are mapped to:
  - `<leader>cc`
  - `<leader>ca`
  - `<leader>ci`
- Default adapter: Ollama
- Default model: `qwen2.5:latest`

## Competitive programming

### CompetiTest
- `xeluxee/competitest.nvim`
- Popup runner UI
- Supports C, C++, Python, Rust, and Java
- Uses `./testcases`
- C++ compile flags include:
  - `-std=c++17`
  - `-Wall`
  - `-Wextra`
  - `-Wshadow`
  - `-DONPC`

### Code runner
- `CRAG666/code_runner.nvim`
- Runner commands are configured for:
  - Java
  - Python
  - TypeScript
  - Rust
  - C
- Runner terminal opens vertically

## Keymaps

### Basic editing
- `jj`: exit insert mode
- `<C-y>`: accept Copilot suggestion
- `<leader>w`: save
- `<leader>q`: quit without saving
- `<leader>wq`: save and quit
- `<leader>H`: clear search highlight
- `gf`: open file under cursor

### File and search
- `<leader>ff`: find files
- `<leader>fo`: recent files
- `<leader>fw`: live grep
- `<leader>ma`: marks
- `<leader>th`: open theme selector
- `<leader>ch`: open cheatsheet

### Runner and testing
- `<leader>cf`: run current file
- `<leader>rft`: run file in a new tab
- `<leader>rp`: run project
- `<leader>rc`: stop runner
- `<leader>crf`: configure runner for filetype
- `<leader>crp`: configure project runner
- `<leader>cr`: run CompetiTest
- `<leader>cs`: show CompetiTest UI
- `<leader>ct`: receive testcases
- `<leader>cma`: add testcase
- `<leader>cme`: edit testcase
- `<leader>cmd`: delete testcase

### Markdown and preview
- `PeekOpen`: open markdown preview
- `PeekClose`: close markdown preview

### Build helper
- `<F5>`: compile and run current file through `Compile()`

## Editor behavior

- Relative numbers enabled
- `tabstop = 4`
- `shiftwidth = 4`
- `softtabstop = 4`
- `expandtab = false`
- `wrap = false`
- `scrolloff = 16`
- `sidescrolloff = 8`
- `spell = true`
- `foldmethod = marker`
- Visible whitespace enabled

## Installed external tools

Configured through Mason and plugin integrations:
- `autoflake`
- `black`
- `clangd`
- `css-lsp`
- `goimports`
- `golines`
- `gopls`
- `html-lsp`
- `isort`
- `lua-language-server`
- `prettier`
- `python-lsp-server`
- `stylua`

## Notes

- The active theme is defined in `lua/chadrc.lua`.
- The theme plugin file exists, but Catppuccin is currently disabled in the plugin spec.
- This setup is tuned for code editing first, with extra support for markdown, Quarto, Typst, CSV, and competitive programming workflows.
