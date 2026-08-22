return {}
--[[
return {
	"olimorris/codecompanion.nvim",
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
		},
	},
}
--]]

--[[
return {
	"olimorris/codecompanion.nvim",
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "codecompanion" },
			config = function()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "markdown",
					callback = function()
						vim.treesitter.start(0, "markdown")
					end,
				})
				require("render-markdown").setup({
					latex = { enabled = false },
					html = { enabled = false },
				})
			end,
		},
	},
}
--]]
