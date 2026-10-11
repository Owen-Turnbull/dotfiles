vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-- In nvim, you have a window, and at the bottom it displays the current buffer you hvae open. If you have two windows open, it highlights the one you're currently focused on and kind of blurs out the others. I have a transparent background on for my nvim, and the functionality I want is to have the background of these little sections to always be colored in, while the text itself (the names of the buffers, etc) to stlil have the blur/highlighted functionality in tact
-- ADD THIS BLOCK HERE:
-- Set solid background for window bars (the area showing buffer names)
-- Replace '#1e1e2e' with your actual terminal background color
local solid_bg = { bg = '#000000' }
vim.api.nvim_set_hl(0, 'WinBar', solid_bg)
vim.api.nvim_set_hl(0, 'WinBarNC', solid_bg)

-- Remove background from text so dimming effect works
local no_bg = { bg = 'NONE' }
vim.api.nvim_set_hl(0, 'WinBarNC', no_bg)
-- END OF ADDED BLOCK

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- CONFIGURABLE: Different preferences for different workspaces
vim.opt.wrap = false

-- Enable wrap only for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

--
--
--
-- Print the line number in front of each line
vim.o.number = true
vim.opt.conceallevel = 2

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

--CODE FOR TOGGLING LINE NUMBER COLORS
-- Save original highlight colors (do this once when Neovim starts)
local original_colors = {}

local function save_original_colors()
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr' })
  local cursor_line_nr = vim.api.nvim_get_hl(0, { name = 'CursorLineNr' })
  original_colors.LineNr = { fg = line_nr.fg, bg = line_nr.bg, bold = line_nr.bold, italic = line_nr.italic }
  original_colors.CursorLineNr = { fg = cursor_line_nr.fg, bg = cursor_line_nr.bg, bold = cursor_line_nr.bold, italic = cursor_line_nr.italic }
end

-- Apply light gray scheme
local function set_light_gray()
  vim.api.nvim_set_hl(0, 'LineNr', { fg = '#d3d3d3' })      -- light gray
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#a9a9a9' }) -- slightly darker for focused line
end

-- Restore original scheme
local function restore_original()
  vim.api.nvim_set_hl(0, 'LineNr', original_colors.LineNr)
  vim.api.nvim_set_hl(0, 'CursorLineNr', original_colors.CursorLineNr)
end

-- Toggle state
local toggled = false

local function toggle_line_numbers()
  if not toggled then
    save_original_colors()
    set_light_gray()
    toggled = true
  else
    restore_original()
    toggled = false
  end
end

-- Map F11 to toggle
vim.keymap.set('n', '<F11>', toggle_line_numbers, { desc = 'Toggle line number colors' })

--END CODE FOR TOGGLING LINE NUMBER COLORS

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10 

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.signcolumn = "yes"

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Make diagnostics show in a floating window on CursorHold
vim.o.updatetime = 300 -- Time before CursorHold fires (ms)

-- Function to check if any floating windows are visible (including hover)
local function has_floating_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then -- This identifies floating windows
			return true
		end
	end
	return false
end

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		-- Only show diagnostic if no floating window is already visible
		if not has_floating_window() then
			vim.diagnostic.open_float(nil, {
				focusable = false,
				focus = false,
				border = "rounded",
				source = "always",
			})
		end
	end,
})

-- focus diagnostics
vim.keymap.set("n", "<leader>df", function()
	vim.diagnostic.open_float(nil, {
		focusable = true,
		focus = true,
		border = "rounded",
		source = "always",
	})
end, { desc = "Open focused diagnostic window" })

-- for kinesis advantage
vim.keymap.set({ "n", "v", "x" }, "'", ":")
vim.keymap.set({ "n", "v", "x" }, "\"", ":")
vim.keymap.set({ "n", "v", "x" }, ";", "'")
vim.keymap.set({ "n", "v", "x" }, ":", "\"")


vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

vim.keymap.set('n', 'r', 'u', { noremap = true })       -- undo (overwrites replace-char)
vim.keymap.set('n', 'R', '<C-r>', { noremap = true })
vim.keymap.set('n', 'u', '<Nop>', { noremap = true })   -- unbind default undo (moved to r)

vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<right>", "<C-w>l")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")

vim.keymap.set("n", "Z", "J", { noremap = true })  -- Join lines
vim.keymap.set('n', '<C-w>', '<C-w>c', { noremap = true, silent = true, nowait = true })

-- open new terminal
vim.api.nvim_set_keymap("n", "<leader>to", "terminal<CR>", { noremap = true, silent = true })

--open terminal in a new window
--vim.api.nvim_set_keymap("n", "<leader>to", ":vsplit | wincmd h | terminal<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":vsplit | terminal<CR>", { noremap = true, silent = true })

-- Disable ZZ to prevent accidental exit from entire application
vim.keymap.set("n", "ZZ", "<Nop>", { noremap = true, silent = true })
-- Close the current window with ZZ
vim.keymap.set("n", "ZZ", "<C-w>c", { noremap = true, silent = true })

-- use ESC to escape terminal mode
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- Map Option+Delete to delete previous word in insert mode
-- <M-BS> means Meta (Option) + Backspace (Delete)
vim.keymap.set("i", "<M-BS>", "<C-W>", { noremap = true, silent = true })

-- re highlight text when shifting code blocks left or right
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")


-- prevent command line from exiting if you press backspace with an empty carriage
vim.cmd([[
  cnoremap <expr> <BS> getcmdline() == '' ? '<Right>' : "\<BS>"
]])

-- half page movement
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<C-d>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<C-u>', { noremap = true, silent = true })

-- replaces your C-] mapping
vim.keymap.set('n', '<C-S-A-F9>', '<C-]>', { noremap = true, silent = true, nowait = true })

-- goto definition, pinned (ctrl+; via kitty -> ctrl+shift+alt+f10)
-- jumps in the current window/view (same as <C-]>), but pins the buffer
-- we're leaving as permanent, so the original file keeps its own barbar tab
-- instead of being unlisted/replaced. The buffer we land on stays an
-- ordinary disposable preview.
vim.keymap.set('n', '<C-S-A-F10>', function()
	require('config.preview_buffer').cancel_preview() -- pin the buffer we're jumping from
	vim.lsp.buf.definition({
		on_list = function(options)
			vim.fn.setqflist({}, ' ', options)
			vim.cmd('cfirst')
		end,
	})
end, { noremap = true, silent = true, nowait = true, desc = "Goto definition (pinned)" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- defaults:
		-- https://neovim.io/doc/user/news-0.11.html#_defaults

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("<C-l>", vim.lsp.buf.hover, "Hover Documentation")
		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("<leader>la", vim.lsp.buf.code_action, "Code Action")
		map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
		map("<leader>lf", vim.lsp.buf.format, "Format")
		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			-- When cursor stops moving: Highlights all instances of the symbol under the cursor
			-- When cursor moves: Clears the highlighting
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- When LSP detaches: Clears the highlighting
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

--highlight text after pasting it
-- vim.api.nvim_set_keymap("n", "p", "p`[v`]", { noremap = true })
vim.api.nvim_set_keymap("n", "P", "P`[v`]", { noremap = true })

-- open new tabs to the right (I think?)
vim.opt.splitright = true

-- show this symbol at the beginning of wrapped lines
vim.opt.showbreak = "↪ "

-- Create a command `:fullsplit bot` that opens a new window at the bottom that is the full width of the screen. Works even if there are two or more windows open.
--[[
vim.api.nvim_create_user_command("Fullsplit", function(opts)
	if opts.args == "bot" then
		vim.cmd("botright new")
	end
end, { nargs = 1 })
--]]
-- Prefer this version for now because I only want horizontal splits
vim.api.nvim_create_user_command("Fullsplit", function()
	vim.cmd("botright new")
end, { desc = "Open a new window at the bottom, full width" })

-- Vertical split version
vim.api.nvim_create_user_command("Fullvsplit", function()
	vim.cmd("botright vnew")
end, { desc = "Open a new window at the right, full height" })

-- Disable auto-comment on Enter but keep other formatting
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove("r")
		vim.opt.formatoptions:remove("o")
		vim.opt.formatoptions:remove("O")
	end,
})

-- Create a user command to restart all LSP servers
vim.api.nvim_create_user_command("LspRestart", function()
	-- Stop all active LSP clients
	for _, client in ipairs(vim.lsp.get_active_clients()) do
		vim.lsp.stop_client(client.id)
	end
	-- Optional: Notify when done
	vim.notify("All LSP servers restarted!", vim.log.levels.INFO)
end, {})


-- Enable spell checking for .txt and .md files
vim.api.nvim_create_autocmd("BufRead", {
    pattern = { "*.txt", "*.md" },
    callback = function()
        vim.opt.spell = true
        vim.opt.spelllang = "en_us"   -- or your preferred language
    end,
})




-- Create an augroup to prevent duplicate autocmds on reload
local indent_group = vim.api.nvim_create_augroup("LanguageIndent", { clear = true })

-- Set 4 spaces for Python and C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "cpp", "c" },
  group = indent_group,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})
