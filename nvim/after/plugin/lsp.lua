local Remap = require('ch1ffa.keymap')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap

local luasnip = require("luasnip")
-- autocomplete config
local cmp = require 'cmp'
local source_mapping = {
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  path = "[Path]",
  luasnip = "[Snippet]",
}
local lspkind = require("lspkind")

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.menu = source_mapping[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = "luasnip" },
    { name = "buffer" },
  }
}

local function config(_config)
  return vim.tbl_deep_extend("force", {
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(_, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      nnoremap("gd", function() vim.lsp.buf.definition() end)
      nnoremap("K", function() vim.lsp.buf.hover() end)
      nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
      nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
      nnoremap("[d", function() vim.diagnostic.goto_next() end)
      nnoremap("]d", function() vim.diagnostic.goto_prev() end)
      vnoremap("<M-CR>", function() vim.lsp.buf.range_code_action() end)
      nnoremap("<M-CR>", function() vim.lsp.buf.code_action() end)
      nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
      nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
      inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
    end,
  }, _config or {})
end

-- omnisharp lsp config
local omnisharp_bin = "/Users/ch1ffa/.local/omnisharp/OmniSharp" 
require'lspconfig'.omnisharp.setup(config({
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) }
}))

require("lspconfig").rust_analyzer.setup(config({
  cmd = { "rustup", "run", "stable", "rust-analyzer" }

  require("lspconfig").tsserver.setup(config())

  require("lspconfig").relay_lsp.setup(config({
    auto_start_compiler = true,
  }))

  require("luasnip.loaders.from_vscode").lazy_load()
