local M = {}

local diffview = require("diffview")
local lib = require("diffview.lib")

local function make_toggle_fn(fn)
	return function()
		local view = lib.get_current_view()
		if view then
			diffview.close()
		else
			fn()
		end
	end
end

local toggle_open = make_toggle_fn(diffview.open)
local toggle_file_history = make_toggle_fn(function()
	diffview.file_history(nil, "%")
end)

local function set_keymap()
	local flag = { silent = true, noremap = true }
	vim.keymap.set("n", ",d", toggle_open, flag)
	vim.keymap.set("n", ",f", toggle_file_history, flag)
end

function M.setup()
	set_keymap()
	diffview.setup({
		keymaps = {
			view = {
				["q"] = diffview.close,
			},
			file_panel = {
				["q"] = diffview.close,
			},
			file_history_panel = {
				["q"] = diffview.close,
			},
		},
	})
end

return M
