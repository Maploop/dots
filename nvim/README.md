# Nord Neovim

A standalone LazyVim configuration with Nord, Neo-tree, Snacks picker, and
Blink completion. It uses standard Neovim directories and has no Omarchy
runtime dependency. Desktop theme changes do not change the editor theme.

## Setup

Place this directory at `~/.config/nvim` (or `$XDG_CONFIG_HOME/nvim`) and run
`nvim`. The first launch installs lazy.nvim and the configured plugins using
Git; it needs internet access. The lockfile records the retained plugin versions;
use `:Lazy restore` to restore those versions on another machine.

Requirements:

- Neovim 0.11.2 or newer with LuaJIT, and Git 2.19 or newer.
- A terminal with true color support; a Nerd Font for UI icons.
- `ripgrep` and `fd` for searching and finding files.
- A C compiler and `tree-sitter` CLI for Treesitter parsers.
- Optional: `lazygit` for the Git UI, and `wl-clipboard` for Wayland clipboard access.

Use `:Mason` for language servers and formatters, `:Lazy` for plugins,
`:LazyExtras` for language integrations, and `:checkhealth` to diagnose missing
tools. Plugin updates are checked silently; `:Lazy update` applies them and may
change upstream behavior or mappings.

## Keybindings

The existing LazyVim mappings and Neo-tree integration are preserved. Leader is
**Space**; local leader is **backslash**. Press Space and wait for which-key, or
use `:map` to inspect mappings. Filetype and LSP mappings appear when applicable.

| Keys | Action |
| --- | --- |
| `Space e` / `Space E` | Explorer at project root / current directory |
| `Space Space` | Find files at project root |
| `Space /` | Search at project root |
| `Space ,` | Switch buffers |
| `Shift h` / `Shift l` | Previous / next buffer |
| `Ctrl h/j/k/l` | Move between windows |
| `Space gg` | LazyGit at project root |
| `Space cf` | Format |
| `Space cr` | Rename symbol (with LSP support) |
| `Space qq` | Quit all |

## Configuration

- `init.lua`: leader keys and startup.
- `lua/config/lazy.lua`: plugin manager bootstrap and LazyVim imports.
- `lua/config/options.lua`: editor preferences; absolute line numbers.
- `lua/config/keymaps.lua`: place for personal mapping overrides.
- `lua/config/autocmds.lua`: place for personal autocmds.
- `lua/config/remote_clipboard.lua`: clipboard support for SSH, tmux, and Herdr.
- `lua/plugins/theme.lua`: Nord for the editor and status line, with an opaque background.
- `lua/plugins/editor.lua`: disabled scrolling animations and news alerts.
- `lazyvim.json`: enabled extras, including the existing Neo-tree integration.
- `lazy-lock.json`: plugin versions.

Remote sessions copy using OSC 52. When Wayland clipboard tools are available,
copies also reach the local clipboard and pastes use it. Otherwise, pasting
requires OSC 52 query support in the terminal or tmux. Set
`vim.g.remote_clipboard_osc52 = false` before clipboard setup to disable OSC 52
copy emission. Ordinary local sessions use Neovim's default clipboard provider.

The theme file is a regular local file. There are no desktop theme watchers,
external theme symlinks, or transparency scripts. Nord supplies the background
colors; terminal window opacity remains a terminal setting.
