return {
  'mikesmithgh/kitty-scrollback.nvim',
  enabled = true,
  lazy = true,
  cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
  event = { 'User KittyScrollbackLaunch' },
  version = '^6.0.0',
  config = function()
    require('kitty-scrollback').setup()
  end,
}
