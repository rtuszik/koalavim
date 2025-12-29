# KoalaVim

Opinionated Neovim config with sensible defaults.

Contains a lot of rewrites of [LazyVim](https://github.com/LazyVim/LazyVim) custom config.

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Requirements

- nvim
- fzf
- ripgrep
- fd
- bat
- delta
- lazygit
- stylua
- node

Install using

```bash
brew bundle
```

## Use

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

```bash
git clone https://github.com/rtuszik/koalavim.git ~/.config/nvim
```

```bash
nvim
```

Alternatively, if you just want to try it out:

```bash
git clone https://github.com/rtuszik/koalavim.git ~/.config/koalavim
```

```bash
NVIM_APPNAME=koalavim nvim
```

## Plugins

_This list only mentions some of the plugins. Check the files to see all._

- [lazy.nvim](https://github.com/folke/lazy.nvim) - plugin manager
- [snacks.nvim](https://github.com/folke/snacks.nvim) - dashboard, terminal, notifications
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) - fuzzy finder
- [blink.cmp](https://github.com/Saghen/blink.cmp) - completion
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - AI completion
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP
- [conform.nvim](https://github.com/stevearc/conform.nvim) - formatting
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - syntax highlighting
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - file explorer
- [trouble.nvim](https://github.com/folke/trouble.nvim) - diagnostics
- [noice.nvim](https://github.com/folke/noice.nvim) - UI
- [which-key.nvim](https://github.com/folke/which-key.nvim) - keybind hints
- [themery.nvim](https://github.com/zaldih/themery.nvim) - theme switcher
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - git signs in gutter
- [undotree](https://github.com/jiaoshijie/undotree) - undo history
- [vscode-diff.nvim](https://github.com/esmuellert/vscode-diff.nvim) - diff viewer
- [precognition.nvim](https://github.com/tris203/precognition.nvim) - vim motion hints
- [vim-be-good](https://github.com/ThePrimeagen/vim-be-good) - vim practice game

### Git

Currently, koalavim contains two plugins related to git interfaces.

- [lazygit-nvim](https://github.com/kdheepak/lazygit.nvim)

This plugin provides integration with the external `lazygit` tui, which is included in the Brewfile.

- [neogit](https://github.com/NeogitOrg/neogit)

This is a native git interface plugin which works with buffers and is much more text-based than lazygit.

## Keymaps

Leader key is `Space`.

Use `<leader>sk` to search all keymaps, or press `<leader>` and wait for which-key.

**Find**
| Key | Action |
|-----|--------|
| `<leader><space>` | find files |
| `<leader>/` | live grep |
| `<leader>fb` | find buffers |
| `<leader>fn` | new file |

**Buffers**
| Key | Action |
|-----|--------|
| `<S-h>` | previous buffer |
| `<S-l>` | next buffer |
| `<leader>bd` | delete buffer |
| `<leader>bo` | delete other buffers |
| `<leader>bb` | switch to other buffer |

**Windows**
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | navigate windows |
| `<leader>-` | split below |
| `<leader>\|` | split right |
| `<leader>wd` | delete window |
| `<leader>wm` | maximize window |

**Code**
| Key | Action |
|-----|--------|
| `<leader>cf` | format |
| `<leader>ca` | code action |
| `<leader>cr` | rename |
| `<leader>cd` | line diagnostics |
| `<leader>rc` | remove comments |
| `gd` | goto definition |
| `gr` | references |
| `K` | hover |

**Git**
| Key | Action |
|-----|--------|
| `<leader>gg` | lazygit |
| `<leader>ng` | neogit |
| `<leader>gb` | git blame line |
| `<leader>gl` | git log |
| `<leader>gf` | git file history |
| `<leader>gB` | git browse |

**Diagnostics**
| Key | Action |
|-----|--------|
| `<leader>xx` | trouble diagnostics |
| `<leader>xX` | buffer diagnostics |
| `<leader>xl` | location list |
| `<leader>xq` | quickfix list |
| `]d` / `[d` | next/prev diagnostic |
| `]e` / `[e` | next/prev error |

**UI**
| Key | Action |
|-----|--------|
| `<leader>e` | file explorer |
| `<leader>ut` | theme switcher |
| `<leader>n` | notifications |
| `<leader>uz` | zen mode |
| `<leader>uf` | toggle format |
| `<leader>ud` | toggle diagnostics |
| `<leader>uh` | toggle inlay hints |

**Terminal**
| Key | Action |
|-----|--------|
| `<C-/>` | floating terminal |
| `<leader>ft` | terminal (root) |
| `<leader>fT` | terminal (cwd) |

**Other**
| Key | Action |
|-----|--------|
| `<leader>u` | undo tree |
| `<leader>cp` | markdown preview |
| `<leader>l` | lazy plugin manager |
| `<A-j>` / `<A-k>` | move lines |
