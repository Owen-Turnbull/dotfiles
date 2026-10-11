-- Local fork of Old-Farmer/preview-buffer.nvim.
--
-- One buffer at a time is "preview" (disposable); everything else is
-- "pinned" (permanent). There's a single preview slot, reassigned only when
-- a genuinely *new* buffer is opened (BufAdd) -- just navigating between
-- already-open buffers (via <C-o>, switching to a pinned tab, etc.) never
-- touches it. When a new buffer takes the slot, the buffer it displaces
-- gets unlisted, unless that buffer has since been pinned.
--
-- Closing means unlisting (not :bdelete), so the buffer's jumplist marks
-- survive and <C-o>/<C-i> keep working across it.
local M = {}

local PIN_VAR = "preview_buffer_pinned"
local preview_buf = nil -- current unpinned "preview" buffer, or nil
local restoring = false -- true while a session is being restored

local default_opts = {
	callback = function(buf) end,
}

local final_opts = {}

local function is_pinned(buf)
	return vim.b[buf][PIN_VAR] == true
end

function M.is_preview(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	return not is_pinned(buf)
end

local function sync_barbar_pin(buf)
	local ok, barbar_state = pcall(require, "barbar.state")
	if ok and not barbar_state.is_pinned(buf) then
		require("barbar.api").toggle_pin(buf)
	end
end

function M.cancel_preview(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	vim.b[buf][PIN_VAR] = true
	if preview_buf == buf then
		preview_buf = nil
	end
	sync_barbar_pin(buf)
	final_opts.callback(buf)
end

-- Session restoring badds several buffers in a row, well before
-- post_restore_cmds gets a chance to pin them -- without this guard, the
-- BufAdd handler below would unlist earlier restored buffers as later ones
-- take the preview slot. See plugins/auto-session.lua.
function M.set_restoring(val)
	restoring = val
end

function M.enable()
	local group_id = vim.api.nvim_create_augroup("preview-buffer.group", { clear = true })

	local start_buf = vim.api.nvim_get_current_buf()
	vim.b[start_buf][PIN_VAR] = true -- the buffer you started in stays permanent

	vim.api.nvim_create_autocmd("BufAdd", {
		group = group_id,
		pattern = "*",
		callback = function(args)
			if restoring then
				return
			end

			local buf = args.buf

			-- ignore floating pickers/prompts/etc. (e.g. Telescope)
			if vim.bo[buf].buftype ~= "" or is_pinned(buf) then
				return
			end

			local old_preview = preview_buf
			preview_buf = buf

			if old_preview and old_preview ~= buf and vim.api.nvim_buf_is_valid(old_preview) and not is_pinned(old_preview) then
				-- defer until the new buffer's content is actually loaded,
				-- so we don't unlist the old preview out from under a jump
				-- that never finishes (e.g. a cancelled LSP definition)
				vim.api.nvim_create_autocmd("BufReadPost", {
					group = group_id,
					buffer = buf,
					once = true,
					callback = function()
						if vim.api.nvim_buf_is_valid(old_preview) and not is_pinned(old_preview) then
							vim.bo[old_preview].buflisted = false
						end
					end,
				})
			end
		end,
	})
end

function M.disable()
	vim.api.nvim_del_augroup_by_name("preview-buffer.group")
	preview_buf = nil
end

function M.toggle()
	if preview_buf == nil then
		M.enable()
	else
		M.disable()
	end
end

function M.setup(opts)
	final_opts = vim.tbl_extend("force", default_opts, opts or {})
	M.enable()

	vim.api.nvim_create_user_command("PreviewBufferToggle", M.toggle, {})
end

return M
