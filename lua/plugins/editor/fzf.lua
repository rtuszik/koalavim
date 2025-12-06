local function get_root()
    -- Common project markers, ordered by priority
    local markers = {
        -- VCS
        ".git",
        "Makefile",
        "package.json",
        "tsconfig.json",
        "pyproject.toml",
        "requirements.txt",
        ".venv",
        "Cargo.toml",
        "go.mod",
        "build.gradle",
        "Gemfile",
        "composer.json",
        ".editorconfig",
    }

    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path ~= "" then
        local root = vim.fs.root(buf_path, markers)
        if root then
            return root
        end
    end

    local cwd_root = vim.fs.root(vim.uv.cwd(), markers)
    if cwd_root then
        return cwd_root
    end

    return vim.uv.cwd()
end

return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        opts = function()
            local fzf = require "fzf-lua"
            local config = fzf.config
            local actions = fzf.actions

            -- Quickfix
            config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
            config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
            config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
            config.defaults.keymap.fzf["ctrl-x"] = "jump"
            config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
            config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
            config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
            config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

            -- Trouble integration
            local has_trouble = require("lazy.core.config").plugins["trouble.nvim"] ~= nil
            if has_trouble then
                config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
            end

            local img_previewer
            for _, v in ipairs {
                { cmd = "ueberzug", args = {} },
                { cmd = "chafa", args = { "{file}", "--format=symbols" } },
                { cmd = "viu", args = { "-b" } },
            } do
                if vim.fn.executable(v.cmd) == 1 then
                    img_previewer = vim.list_extend({ v.cmd }, v.args)
                    break
                end
            end

            return {
                "default-title",
                fzf_colors = true,
                fzf_opts = { ["--no-scrollbar"] = true },
                defaults = { formatter = "path.dirname_first" },
                previewers = {
                    builtin = {
                        extensions = {
                            ["png"] = img_previewer,
                            ["jpg"] = img_previewer,
                            ["jpeg"] = img_previewer,
                            ["gif"] = img_previewer,
                            ["webp"] = img_previewer,
                        },
                        ueberzug_scaler = "fit_contain",
                    },
                },
                winopts = {
                    width = 0.8,
                    height = 0.8,
                    row = 0.5,
                    col = 0.5,
                    preview = { scrollchars = { "┃", "" } },
                },
                files = {
                    cwd_prompt = false,
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
                grep = {
                    actions = {
                        ["alt-i"] = { actions.toggle_ignore },
                        ["alt-h"] = { actions.toggle_hidden },
                    },
                },
                lsp = {
                    code_actions = {
                        previewer = vim.fn.executable "delta" == 1 and "codeaction_native" or nil,
                    },
                },
            }
        end,
        config = function(_, opts)
            if opts[1] == "default-title" then
                local function fix(t)
                    t.prompt = t.prompt ~= nil and " " or nil
                    for _, v in pairs(t) do
                        if type(v) == "table" then
                            fix(v)
                        end
                    end
                    return t
                end
                opts = vim.tbl_deep_extend("force", fix(require "fzf-lua.profiles.default-title"), opts)
                opts[1] = nil
            end
            require("fzf-lua").setup(opts)
        end,
        keys = {
            { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
            { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
            { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
            {
                "<leader>/",
                function()
                    require("fzf-lua").live_grep { cwd = get_root() }
                end,
                desc = "Grep (Root Dir)",
            },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            {
                "<leader><space>",
                function()
                    require("fzf-lua").files { cwd = get_root() }
                end,
                desc = "Find Files (Root Dir)",
            },
            -- find
            { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
            {
                "<leader>fc",
                function()
                    require("fzf-lua").files { cwd = vim.fn.stdpath "config" }
                end,
                desc = "Find Config File",
            },
            {
                "<leader>ff",
                function()
                    require("fzf-lua").files { cwd = get_root() }
                end,
                desc = "Find Files (Root Dir)",
            },
            { "<leader>fF", "<cmd>FzfLua files<cr>", desc = "Find Files (cwd)" },
            { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
            -- git
            { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
            { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (hunks)" },
            { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
            { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
            -- search
            { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
            { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
            { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
            { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
            { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
            {
                "<leader>sg",
                function()
                    require("fzf-lua").live_grep { cwd = get_root() }
                end,
                desc = "Grep (Root Dir)",
            },
            { "<leader>sG", "<cmd>FzfLua live_grep<cr>", desc = "Grep (cwd)" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
            { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
            { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
            { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
            { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
            { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
            { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
            { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Goto Symbol" },
            { "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
            {
                "<leader>sw",
                function()
                    require("fzf-lua").grep_cword { cwd = get_root() }
                end,
                desc = "Word (Root Dir)",
            },
            {
                "<leader>sw",
                function()
                    require("fzf-lua").grep_visual { cwd = get_root() }
                end,
                mode = "x",
                desc = "Selection (Root Dir)",
            },
            { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
        },
    },

    {
        "folke/todo-comments.nvim",
        optional = true,
        keys = {
            {
                "<leader>st",
                function()
                    require("todo-comments.fzf").todo()
                end,
                desc = "Todo",
            },
            {
                "<leader>sT",
                function()
                    require("todo-comments.fzf").todo { keywords = { "TODO", "FIX", "FIXME" } }
                end,
                desc = "Todo/Fix/Fixme",
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                ["*"] = {
                    keys = {
                        {
                            "gd",
                            "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
                            desc = "Goto Definition",
                            has = "definition",
                        },
                        { "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>", desc = "References", nowait = true },
                        { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
                        { "gy", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
                    },
                },
            },
        },
    },
}
