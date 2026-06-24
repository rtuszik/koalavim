-- LuaSnip snippets for YAML.
-- Loaded by ~/.config/nvim/lua/plugins/tools/snippets.lua via from_lua.

local parse = require("luasnip").parser.parse_snippet

return {
    parse(
        "kustomization",
        [[
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ${1}.yaml
]]
    ),
}
