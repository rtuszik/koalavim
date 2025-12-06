return {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VimEnter", -- load early enough to hijack netrw on startup
    init = function()
        -- Disable netrw so Neo-tree takes over directory buffers
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- If Neovim is started with a directory argument, open Neo-tree there
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
                    vim.cmd.cd(vim.fn.argv(0))
                    vim.schedule(function()
                        require("neo-tree.command").execute {
                            toggle = false,
                            dir = vim.uv.cwd(),
                        }
                    end)
                end
            end,
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
        {
            "<leader>fe",
            function()
                require("neo-tree.command").execute {
                    toggle = true,
                    dir = vim.fs.root(0, ".git") or vim.uv.cwd(),
                }
            end,
            desc = "Explorer NeoTree (Root Dir)",
        },
        {
            "<leader>fE",
            function()
                require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() }
            end,
            desc = "Explorer NeoTree (cwd)",
        },
        { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
        { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
        {
            "<leader>ge",
            function()
                require("neo-tree.command").execute { source = "git_status", toggle = true }
            end,
            desc = "Git Explorer",
        },
        {
            "<leader>be",
            function()
                require("neo-tree.command").execute { source = "buffers", toggle = true }
            end,
            desc = "Buffer Explorer",
        },
    },
    deactivate = function()
        vim.cmd [[Neotree close]]
    end,
    opts = {
        sources = { "filesystem", "buffers", "git_status" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        popup_border_style = "rounded",
        use_popups_for_input = false,
        filesystem = {
            hijack_netrw_behavior = "disabled",
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            filtered_items = {
                visible = true,
                always_show = {
                    ".gitignore",
                    ".github",
                },
                always_show_by_pattern = { -- uses glob style patterns
                    ".env*",
                },
            },
            renderers = {
                file = {
                    { "icon" },
                    { "name", use_git_status_colors = true },
                    { "diagnostics" },
                    { "git_status", highlight = "NeoTreeDimText" },
                },
            },
        },
        window = {
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["<space>"] = "none",
                ["Y"] = {
                    function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    desc = "Copy Path to Clipboard",
                },
                ["O"] = {
                    function(state)
                        require("lazy.util").open(state.tree:get_node().path, { system = true })
                    end,
                    desc = "Open with System Application",
                },
                ["P"] = { "toggle_preview", config = { use_float = false } },
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            git_status = {
                symbols = {
                    unstaged = "󰄱",
                    staged = "󰱒",
                },
            },
        },
    },
    config = function(_, opts)
        local function on_move(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
        end

        local events = require "neo-tree.events"
        opts.event_handlers = opts.event_handlers or {}
        vim.list_extend(opts.event_handlers, {
            { event = events.FILE_MOVED, handler = on_move },
            { event = events.FILE_RENAMED, handler = on_move },
        })
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end,
}
