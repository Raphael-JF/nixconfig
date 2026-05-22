local telescope = require("telescope")

telescope.setup({
    defaults = {
	sorting_strategy = "ascending",
	layout_config = {
		prompt_position = "top",
	},
    },
    file_ignore_patterns = {
    "node_modules",
    "dist",
    "build",
    "target",
    "vendor",
    "public",
    "coverage",
    "logs",
    "tmp",
    ".git",
    },
    pickers = {
        find_files = {
            hidden = true,
        },
    },
})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

vim.keymap.set("n", "<C-p>", function()
	builtin.find_files({
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if not entry then
					return
				end

				local filepath = vim.fn.fnamemodify(
					entry.path or entry.filename or entry.value,
					":p"
				)

				-- Si déjà ouvert : aller dessus
				for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)

						if vim.fn.fnamemodify(name, ":p") == filepath then
							vim.api.nvim_set_current_tabpage(tab)
							vim.api.nvim_set_current_win(win)
							return
						end
					end
				end

				local current_buf = vim.api.nvim_get_current_buf()
				local current_name = vim.api.nvim_buf_get_name(current_buf)
				local is_modified = vim.bo[current_buf].modified

				local escaped = vim.fn.fnameescape(filepath)

				-- Cas du [No Name] vide
				if current_name == "" and not is_modified then
					vim.cmd("edit " .. escaped)
				else
					vim.cmd("tabedit " .. escaped)
				end
			end)

			return true
		end,
	})
end)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})