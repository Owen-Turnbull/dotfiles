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
		{
			"<leader>fn",
			function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = { "function", "method" },
				})
			end,
			desc = "Telescope function symbols (current file)",
		},
		{
			"<leader>fN",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols({
					symbols = { "function", "method" },
				})
			end,
			desc = "Telescope function symbols (workspace)",
		},
	},
	config = function()
		local actions = require('telescope.actions')
		local action_state = require('telescope.actions.state')

		-- <C-t> opens the selection in the currently focused window (like
		-- default <CR>), but pins the buffer we're leaving as permanent, so
		-- the old file keeps its own barbar tab instead of being unlisted.
		-- The newly opened buffer stays an ordinary disposable preview.
		local function select_edit_pinned(prompt_bufnr)
			local picker = action_state.get_current_picker(prompt_bufnr)
			require("config.preview_buffer").cancel_preview(picker.original_bufnr)
			actions.select_default(prompt_bufnr)
		end

		require('telescope').setup({
			defaults = {
				mappings = {
					i = { ["<C-t>"] = select_edit_pinned },
					n = { ["<C-t>"] = select_edit_pinned },
				},
			},
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
