local M = {}

local builtin = require("telescope.builtin")
local custom_buffers = require("custom.telescope.builtin_buffers").buffers
local flag = { silent = true, noremap = true }

local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")

local function gen_entry_maker(opts)
	opts = opts or {}

	local signs = (function()
		local signs = {}
		local type_diagnostic = vim.diagnostic.severity
		for _, severity in ipairs(type_diagnostic) do
			local status, sign = pcall(function()
				-- only the first char is upper all others are lowercalse
				return vim.trim(
					vim.fn.sign_getdefined("DiagnosticSign" .. severity:lower():gsub("^%l", string.upper))[1].text
				)
			end)
			if not status then
				sign = severity:sub(1, 1)
			end
			signs[severity] = sign
		end
		return signs
	end)()

	local display_items = {
		{ width = utils.if_nil(signs, 8, 10) },
		{ remaining = true },
	}
	local line_width = vim.F.if_nil(opts.line_width, 0.5)
	if not utils.is_path_hidden(opts) then
		table.insert(display_items, 2, { width = line_width })
	end
	local displayer = entry_display.create({
		separator = " │ ",
		items = display_items,
	})

	local make_display = function(entry)
		local filename = utils.transform_path(opts, entry.filename)

		-- add styling of entries
		local pos = string.format("%4d:%2d", entry.lnum, entry.col)
		local line_info = {
			(signs and signs[entry.type] .. " " or "") .. pos,
			"Diagnostic" .. entry.type,
		}

		--TODO(conni2461): I dont like that this is symbol lnum:col | msg | filename
		--                 i want: symbol filename:lnum:col | msg
		--                 or    : symbol lnum:col | msg
		--                 I think this is more natural
		return displayer({
			line_info,
			entry.text,
			filename,
		})
	end

	return function(entry)
		return {
			value = entry,
			ordinal = ("%s %s"):format(not opts.ignore_filename and entry.filename or "", entry.text),
			display = make_display,
			filename = entry.filename,
			type = entry.type,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
		}
	end
end

local function custom_diagnostics()
	builtin.diagnostics({
		entry_maker = gen_entry_maker(),
	})
end

function M.set()
	vim.keymap.set("n", "<leader>f", builtin.find_files, flag)
	vim.keymap.set("n", "<leader>F", builtin.git_files, flag)
	vim.keymap.set("n", "<leader>S", builtin.git_status, flag)
	vim.keymap.set("n", "<leader>g", builtin.live_grep, flag)
	vim.keymap.set("n", "<leader>w", custom_buffers, flag)
	vim.keymap.set("n", "<leader>m", builtin.marks, flag)
	vim.keymap.set("n", "<leader>q", builtin.quickfix, flag)
	vim.keymap.set("n", "<leader>d", custom_diagnostics, flag)
end

return M
