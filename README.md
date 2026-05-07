<a href="https://dotfyle.com/rtuszik/koalavim"><img src="https://dotfyle.com/rtuszik/koalavim/badges/plugins?style=for-the-badge" /></a>

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

### Overwrites

If you would like to make any changes while still tracking this repo, any overrides and additions should be done through `lua/local/`.
This directory is automatically read if it exists.

## Plugins

<!-- PLUGINS:START -->

Total: **70** plugins

| Plugin | Link |
|--------|------|
| `akinsho/bufferline.nvim` | [GitHub](https://github.com/akinsho/bufferline.nvim) |
| `antonk52/bad-practices.nvim` | [GitHub](https://github.com/antonk52/bad-practices.nvim) |
| `aserowy/tmux.nvim` | [GitHub](https://github.com/aserowy/tmux.nvim) |
| `axsaucedo/neovim-power-mode` | [GitHub](https://github.com/axsaucedo/neovim-power-mode) |
| `b0o/schemastore.nvim` | [GitHub](https://github.com/b0o/schemastore.nvim) |
| `blumaa/ohne-accidents.nvim` | [GitHub](https://github.com/blumaa/ohne-accidents.nvim) |
| `catppuccin/nvim` | [GitHub](https://github.com/catppuccin/nvim) |
| `christoomey/vim-tmux-navigator` | [GitHub](https://github.com/christoomey/vim-tmux-navigator) |
| `dmtrKovalenko/fff.nvim` | [GitHub](https://github.com/dmtrKovalenko/fff.nvim) |
| `dtormoen/neural-open.nvim` | [GitHub](https://github.com/dtormoen/neural-open.nvim) |
| `echasnovski/mini.nvim` | [GitHub](https://github.com/echasnovski/mini.nvim) |
| `EdenEast/nightfox.nvim` | [GitHub](https://github.com/EdenEast/nightfox.nvim) |
| `esmuellert/vscode-diff.nvim` | [GitHub](https://github.com/esmuellert/vscode-diff.nvim) |
| `folke/edgy.nvim` | [GitHub](https://github.com/folke/edgy.nvim) |
| `folke/lazy.nvim` | [GitHub](https://github.com/folke/lazy.nvim) |
| `folke/lazydev.nvim` | [GitHub](https://github.com/folke/lazydev.nvim) |
| `folke/noice.nvim` | [GitHub](https://github.com/folke/noice.nvim) |
| `folke/snacks.nvim` | [GitHub](https://github.com/folke/snacks.nvim) |
| `folke/todo-comments.nvim` | [GitHub](https://github.com/folke/todo-comments.nvim) |
| `folke/tokyonight.nvim` | [GitHub](https://github.com/folke/tokyonight.nvim) |
| `folke/trouble.nvim` | [GitHub](https://github.com/folke/trouble.nvim) |
| `folke/ts-comments.nvim` | [GitHub](https://github.com/folke/ts-comments.nvim) |
| `folke/which-key.nvim` | [GitHub](https://github.com/folke/which-key.nvim) |
| `giuxtaposition/blink-cmp-copilot` | [GitHub](https://github.com/giuxtaposition/blink-cmp-copilot) |
| `h4ckm1n-dev/kube-utils-nvim` | [GitHub](https://github.com/h4ckm1n-dev/kube-utils-nvim) |
| `hrsh7th/nvim-cmp` | [GitHub](https://github.com/hrsh7th/nvim-cmp) |
| `iamcco/markdown-preview.nvim` | [GitHub](https://github.com/iamcco/markdown-preview.nvim) |
| `ibhagwan/fzf-lua` | [GitHub](https://github.com/ibhagwan/fzf-lua) |
| `j-hui/fidget.nvim` | [GitHub](https://github.com/j-hui/fidget.nvim) |
| `jiaoshijie/undotree` | [GitHub](https://github.com/jiaoshijie/undotree) |
| `kawre/neotab.nvim` | [GitHub](https://github.com/kawre/neotab.nvim) |
| `kdheepak/lazygit.nvim` | [GitHub](https://github.com/kdheepak/lazygit.nvim) |
| `lewis6991/gitsigns.nvim` | [GitHub](https://github.com/lewis6991/gitsigns.nvim) |
| `MartelleV/kaimandres.nvim` | [GitHub](https://github.com/MartelleV/kaimandres.nvim) |
| `mfussenegger/nvim-lint` | [GitHub](https://github.com/mfussenegger/nvim-lint) |
| `Mofiqul/dracula.nvim` | [GitHub](https://github.com/Mofiqul/dracula.nvim) |
| `mslvx/obscure.nvim` | [GitHub](https://github.com/mslvx/obscure.nvim) |
| `mtendekuyokwa19/stoics.nvim` | [GitHub](https://github.com/mtendekuyokwa19/stoics.nvim) |
| `MunifTanjim/nui.nvim` | [GitHub](https://github.com/MunifTanjim/nui.nvim) |
| `NeogitOrg/neogit` | [GitHub](https://github.com/NeogitOrg/neogit) |
| `neovim/nvim-lspconfig` | [GitHub](https://github.com/neovim/nvim-lspconfig) |
| `nvim-lua/plenary.nvim` | [GitHub](https://github.com/nvim-lua/plenary.nvim) |
| `nvim-lualine/lualine.nvim` | [GitHub](https://github.com/nvim-lualine/lualine.nvim) |
| `nvim-mini/mini.ai` | [GitHub](https://github.com/nvim-mini/mini.ai) |
| `nvim-neo-tree/neo-tree.nvim` | [GitHub](https://github.com/nvim-neo-tree/neo-tree.nvim) |
| `nvim-tree/nvim-web-devicons` | [GitHub](https://github.com/nvim-tree/nvim-web-devicons) |
| `nvim-treesitter/nvim-treesitter` | [GitHub](https://github.com/nvim-treesitter/nvim-treesitter) |
| `nvim-treesitter/nvim-treesitter-context` | [GitHub](https://github.com/nvim-treesitter/nvim-treesitter-context) |
| `olimorris/onedarkpro.nvim` | [GitHub](https://github.com/olimorris/onedarkpro.nvim) |
| `prismatic-koi/nvim-sops` | [GitHub](https://github.com/prismatic-koi/nvim-sops) |
| `qvalentin/helm-ls.nvim` | [GitHub](https://github.com/qvalentin/helm-ls.nvim) |
| `rebelot/kanagawa.nvim` | [GitHub](https://github.com/rebelot/kanagawa.nvim) |
| `rose-pine/neovim` | [GitHub](https://github.com/rose-pine/neovim) |
| `rtuszik/nvim-remove-comments` | [GitHub](https://github.com/rtuszik/nvim-remove-comments) |
| `saghen/blink.cmp` | [GitHub](https://github.com/saghen/blink.cmp) |
| `sindrets/diffview.nvim` | [GitHub](https://github.com/sindrets/diffview.nvim) |
| `Sonya-sama/kawaii.nvim` | [GitHub](https://github.com/Sonya-sama/kawaii.nvim) |
| `sponkurtus2/angelic.nvim` | [GitHub](https://github.com/sponkurtus2/angelic.nvim) |
| `stevearc/conform.nvim` | [GitHub](https://github.com/stevearc/conform.nvim) |
| `szymonwilczek/vim-be-better` | [GitHub](https://github.com/szymonwilczek/vim-be-better) |
| `ThePrimeagen/vim-be-good` | [GitHub](https://github.com/ThePrimeagen/vim-be-good) |
| `tris203/precognition.nvim` | [GitHub](https://github.com/tris203/precognition.nvim) |
| `uhs-robert/oasis.nvim` | [GitHub](https://github.com/uhs-robert/oasis.nvim) |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | [GitHub](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) |
| `williamboman/mason-lspconfig.nvim` | [GitHub](https://github.com/williamboman/mason-lspconfig.nvim) |
| `williamboman/mason.nvim` | [GitHub](https://github.com/williamboman/mason.nvim) |
| `windwp/nvim-ts-autotag` | [GitHub](https://github.com/windwp/nvim-ts-autotag) |
| `yazeed1s/oh-lucy.nvim` | [GitHub](https://github.com/yazeed1s/oh-lucy.nvim) |
| `zaldih/themery.nvim` | [GitHub](https://github.com/zaldih/themery.nvim) |
| `zbirenbaum/copilot.lua` | [GitHub](https://github.com/zbirenbaum/copilot.lua) |

<!-- PLUGINS:END -->

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
