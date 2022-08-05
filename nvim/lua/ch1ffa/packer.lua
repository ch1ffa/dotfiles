vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use { 'ch1ffa/nvim-lspconfig', branch = 'relay' }
  use 'hrsh7th/nvim-cmp'
  use 'onsails/lspkind-nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'
  use 'saadparwaiz1/cmp_luasnip'
  use("nvim-treesitter/nvim-treesitter", {
    run = ":TSUpdate"
  })
  use {
    'TimUntersberger/neogit', 
    requires = {
      'nvim-lua/plenary.nvim', 
      'sindrets/diffview.nvim'
    }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use { 'terrortylor/nvim-comment' }
  use { 'akinsho/toggleterm.nvim' }
end)

