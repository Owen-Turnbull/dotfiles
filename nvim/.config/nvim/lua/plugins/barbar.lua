require("config.preview_buffer").setup({})
vim.keymap.set("n", "<A-f>", function()
	require("config.preview_buffer").cancel_preview()
end, { noremap = true, silent = true, desc = "Keep buffer as permanent tab" })

return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }
			map("n", "<A-h>", "<Cmd>BufferPrevious<CR>", opts)
			map("n", "<A-l>", "<Cmd>BufferNext<CR>", opts)
			map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
			map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
			map("n", "<A-d>", "<Cmd>BufferClose<CR>", opts)
			map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
		end,
		opts = {
			icons = {
				pinned = { button = '', filename = true },
			},
		},
		version = "^1.0.0",
},
}
