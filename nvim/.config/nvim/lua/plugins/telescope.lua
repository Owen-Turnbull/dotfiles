return {
	"nvim-telescope/telescope.nvim",
  branch = "master",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope live grep",
		},
		{
			"<leader>fG",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "Telescope git status",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope buffers",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Telescope help tags",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Telescope diagnostics",
		},
	},
	config = function()
		require('telescope').setup({
			pickers = {
				find_files = {
					hidden = true,      -- Show hidden files
					follow = true,      -- Follow symlinks
					-- no_ignore = true, -- Uncomment to also show .gitignore'd files
				},
			},
		})
	end,
}
