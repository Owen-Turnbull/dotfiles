return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>fs", "<cmd>AutoSession search<CR>", desc = "Session search" },
	},
	opts = {
		enabled = false,
		cwd_change_handling = false,
		auto_create = false,
		auto_restore = false,
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
		pre_restore_cmds = {
			function()
				require("config.preview_buffer").set_restoring(true)
			end,
		},
		post_restore_cmds = {
			function()
				local preview_buffer = require("config.preview_buffer")
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					-- restored background buffers aren't loaded until first
					-- displayed, but buffer-local vars still work on them
					if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
						preview_buffer.cancel_preview(buf)
					end
				end
				preview_buffer.set_restoring(false)
			end,
		},
		session_lens = {
			picker = "telescope",
			mappings = {
				delete_session = { { "i", "n" }, "<C-d>" },
			},
			theme_conf = {
				prompt_title = "Session Search (<C-d> to delete)",
			},
		},
	},
}
