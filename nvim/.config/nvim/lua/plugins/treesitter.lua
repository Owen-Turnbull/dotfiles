--[[
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
}
--]]

--[[
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate'
}
--]]
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
      install_dir = vim.fn.stdpath('data') .. '/site'
    }

    require('nvim-treesitter').install { 'python', 'lua', 'typescript', 'markdown', 'markdown_inline', 'elixir', 'heex', 'cpp' }:wait(30000)

      -- Enable features per language: highlighting, folds, and indentation
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'python', 'lua', 'typescript', 'markdown', 'elixir', 'heex', 'cpp' },
      callback = function()
        -- Enable syntax highlighting
        vim.treesitter.start()
        
        -- Enable folds based on Treesitter
        -- jvim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'
        
        -- Enable Treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}

--return {}
