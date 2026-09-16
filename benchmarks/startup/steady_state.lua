-- Keep first-run package downloads out of startup measurements. The benchmark
-- prepares the one parser used by its file scenario separately.
package.preload["mason-lspconfig.features.ensure_installed"] = function()
    return function() end
end

package.preload["nvim-treesitter"] = function()
    local paths = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)
    assert(paths[1], "Unable to locate nvim-treesitter")
    local module = assert(loadfile(paths[1]))()
    module.install = function() end
    return module
end

-- The workflow also copies this file into local.plugins so old base revisions
-- without optional-import handling can start with the same disabled fixture.
return {
    {
        name = "koalavim-benchmark-placeholder",
        dir = vim.fn.stdpath "config",
        enabled = false,
    },
}
