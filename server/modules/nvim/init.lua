---------------- OTHER ------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set colorscheme that supports treesitter
vim.cmd("colorscheme kanagawa")

-- Exit terminal mode with Escape
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Editor options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- Tab configuration
vim.opt.showtabline = 2  -- Always show tabline

local function tab_label(tabpage)
  local window = vim.fn.tabpagewinnr(tabpage)
  local buffer = vim.fn.tabpagebuflist(tabpage)[window]
  local buffer_name = vim.api.nvim_buf_get_name(buffer)

  if buffer_name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(buffer_name, ":.")
end

function _G.TabLine()
  local tabline = {}
  local current_tab = vim.fn.tabpagenr()
  local tab_count = vim.fn.tabpagenr("$")

  for tabpage = 1, tab_count do
    local selected = tabpage == current_tab and "%#TabLineSel#" or "%#TabLine#"
    table.insert(tabline, selected)
    table.insert(tabline, "%" .. tabpage .. "T")
    table.insert(tabline, " " .. tab_label(tabpage) .. " ")
  end

  table.insert(tabline, "%#TabLineFill#%T")
  return table.concat(tabline)
end

-- vim.opt.tabline = "%!v:lua.TabLine()"

-- Configure clipboard for Wayland using wl-clipboardj
-- vim.g.clipboard = {
--   name = "wl-clipboard",
--   copy = {
--     ["+"] = "wl-copy --foreground --type text/plain",
--     ["*"] = "wl-copy --primary --foreground --type text/plain",
--   },
--   paste = {
--     ["+"] = "wl-paste --no-newline",
--     ["*"] = "wl-paste --primary --no-newline",
--   },
-- }

-- auto save on insert leave and text changed
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! write",
})



-- LSP diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,   -- affiche les erreurs à droite de la ligne
  signs = true,
  underline = true,
  update_in_insert = false,
  })



-- Tab navigation keymaps
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { silent = true })
vim.keymap.set('n', '<C-q>', ':tabclose<CR>', { noremap = true, silent = true })

-- Source - https://stackoverflow.com/a/74584098
-- Posted by Brotify Force, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-05-26, License - CC BY-SA 4.0

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

-- doing it the hard way
vim.keymap.set('', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Right>', '<Nop>', { noremap = true, silent = true })

-- removing the J thing
vim.keymap.set("n", "J", "<Nop>")
vim.keymap.set("n", "K", "<Nop>")

-- easy indenting
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent and keep selection" })

vim.opt.number = true
vim.opt.relativenumber = true

-------------------- SIDEKICK --------------
-- require("copilot").setup({
--   should_attach = function()
--     return false
--   end,
-- })
vim.lsp.config('copilot', {
  settings = {
    telemetry = {
      telemetryLevel = "off",
    },
  },
})

vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()
  require("sidekick").setup({
  nes = {
    enabled = true,
    debounce = 100,        -- ms avant de demander une nouvelle suggestion
    trigger = {
      -- événements qui déclenchent une requête NES
      events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
    },
    clear = {
      -- événements qui effacent la suggestion active
      events = { },
      esc = true,           -- <Esc> efface aussi la suggestion
    },
    diff = {
      inline = "chars",     -- "words" | "chars" | false — granularité du diff inline
      show = "always",      -- "always" | "cursor" — "cursor" n'affiche le diff que quand le curseur est sur l'édition
    },
    signs = true,            -- signes dans la colonne de gauche
    jumplist = true,         -- ajoute une entrée dans la jumplist quand tu sautes vers une édition
  },
  cli = {
    enable = false,
  },
})


-- Keymaps
local map = vim.keymap.set

-- accepter suggestion inline
map("n", "<C-l>", function()
    -- if there is a next edit, jump to it, otherwise apply it if any
    if not require("sidekick").nes_jump_or_apply() then
        return "<C-l>" -- fallback to normal tab
    end
end, { expr = true })

map("i", "<C-l>", function()
  vim.lsp.inline_completion.get()
end)

-- refuser suggestion
map("i", "<C-]>", function()
require("sidekick").dismiss()
end)

-- demander une suggestion manuellement
map("n", "<leader>as", function()
require("sidekick").suggest()
end)

-- appliquer modifications proposées (multi-line / diff)
map("n", "<leader>ae", function()
require("sidekick").apply()
end)



------------------- LSP --------------



local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config('clangd', {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--compile-commands-dir=.",
        "--query-driver=/home/raph/.platformio/packages/toolchain-*/bin/*",
    },
})

vim.lsp.config('nil_ls', {

})

vim.lsp.enable({ 'clangd', 'nil_ls' })

-------------------- TREESITTER --------------
-- The new nvim-treesitter (`main` branch) does not start
          -- automatically. This autocmd starts it and auto-installs the
          -- language parser based on the `filetype`.
vim.api.nvim_create_autocmd({ 'Filetype' }, {
callback = function(event)
    -- Make sure nvim-treesitter is available
    local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
    if not ok then return end

    local parsers = require('nvim-treesitter.parsers')

    if not parsers[event.match] or not nvim_treesitter.install then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    nvim_treesitter.install({ lang }):await(function(err)
    if err then
        vim.notify('Treesitter install error for ft: ' .. ft .. ' err: ' .. err)
        return
    end

    pcall(vim.treesitter.start, event.buf)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    -- vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end)
end,
})

-- configuration
require("nvim-treesitter-textobjects").setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
}
vim.keymap.set({ "x", "o" }, "af", function()
require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)


--------------------- LUALINE -----------------
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    section_separators = {
        left = "",
        right = "",
    },

    component_separators = {
      left = "│",
      right = "│",
    },

    globalstatus = true,
    disabled_filetypes = {
      statusline = {
        "NvimTree",
        "TelescopePrompt",
      },
    },
  },

  sections = {

    -- gauche
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return " " .. str
        end,
        padding = { left = 1, right = 1 },
      },
    },

    lualine_b = {
      {
        "branch",
        icon = "",
      },

      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      },

      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰌵 ",
        },
      },
    },


    -- centre
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = " ●",
          readonly = " ",
          unnamed = "[No Name]",
        },
      },
    },


    -- droite
    lualine_x = {
      {
        "filetype",
        icon_only = false,
        separator = "",
      },

      {
        "encoding",
        separator = "",
      },

      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
      },
    },


    lualine_y = {
      {
        "progress",
        separator = "",
      },
    },


    lualine_z = {
      {
        "location",
      },
    },
  },


  inactive_sections = {
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },

    lualine_x = {
      "location",
    },
  },


  extensions = {
    "nvim-tree",
  },
})
--------------------- WHICH-KEY ---------------
require("which-key").setup()

--------------------- CMP ---------------------
cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },

  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Esc>"] = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.abort()
	else
		fallback()
	end
end, { "i", "s" }),
  }),
})

-------------------- TELESCOPE -------------------
-- local telescope = require("telescope")
--
-- telescope.setup({
--     defaults = {
-- 	sorting_strategy = "ascending",
-- 	layout_config = {
-- 		prompt_position = "top",
-- 	},
--     },
--     file_ignore_patterns = {
--     "node_modules",
--     "target",
--     "vendor",
--     "public",
--     "coverage",
--     "logs",
--     "tmp",
--     ".git",
--     },
--     pickers = {
--         find_files = {
--             hidden = true,
--         },
--     },
-- })
--
-- local builtin = require("telescope.builtin")
-- local actions = require("telescope.actions")
--
-- local builtin = require("telescope.builtin")
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")
--
-- local builtin = require("telescope.builtin")
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")
--
-- vim.keymap.set("n", "<C-p>", function()
-- 	require("telescope.builtin").find_files()
-- end)
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
--
--------------------- NVIM-TREE -------------------
require("nvim-tree").setup({
  view = {
    width = 40,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  actions = {
    open_file = {
        quit_on_open = true,
        resize_window = true,
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local keymap = vim.keymap.set


    -- Open file
    keymap("n", "<CR>", api.node.open.edit, { buffer = bufnr, noremap = true, silent = true })

    -- Create
    keymap("n", "<C-n>", api.fs.create, { buffer = bufnr, noremap = true, silent = true })

    -- Delete
    keymap("n", "<Del>", api.fs.remove, { buffer = bufnr, noremap = true, silent = true })

    -- Rename
    keymap("n", "<F2>", api.fs.rename, { buffer = bufnr, noremap = true, silent = true })

    -- Copy
    keymap("n", "y", api.fs.copy.node, { buffer = bufnr, noremap = true, silent = true })

    -- Cut
    keymap("n", "c", api.fs.cut, { buffer = bufnr, noremap = true, silent = true })

    -- Paste
    keymap("n", "p", api.fs.paste, { buffer = bufnr, noremap = true, silent = true })
  end,
})

-- Toggle nvim-tree with Ctrl+B
vim.keymap.set("n", "<C-b>", function()
  require("nvim-tree.api").tree.toggle()
end, { noremap = true, silent = true })

-------------- BUFFERLINE ------------------
vim.opt.termguicolors = true
require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "󰙅 Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
})



vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")

--------------- snacks nvim---------
require("snacks").setup({
  -- Recherche fuzzy (remplace Telescope pour beaucoup d'usages)
  picker = {
    enabled = true,
  },

  -- Notifications propres
  notifier = {
    enabled = true,
    timeout = 3000,
  },

  -- Remplace vim.ui.input()
  input = {
    enabled = true,
  },

  -- Terminal flottant
  terminal = {
    enabled = true,
  },

  -- Explorateur de fichiers (optionnel si tu gardes nvim-tree)
  explorer = {
    enabled = false,
  },

  -- Guides d'indentation
  indent = {
    enabled = true,
  },

  -- Animations
  animate = {
    enabled = true,
  },

  -- Dashboard au démarrage
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1 },
    },
  },

  -- Git browse (ouvre les liens github)
  gitbrowse = {
    enabled = true,
  },
})

local keymap = vim.keymap.set

keymap("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Find files" })

keymap("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })

keymap("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

keymap("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help" })

keymap("n", "<leader>tt", function()
  Snacks.terminal()
end, { desc = "Terminal" })

keymap("n", "<leader>nh", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })


------------ multicursor nvim -----
local mc = require("multicursors")

mc.setup({})
vim.keymap.set("v", "<C-d>", "<Cmd>MCvisualPattern<CR>", { desc = "Multicursor: sélection" })
vim.keymap.set("n", "<C-d>", "<Cmd>MCunderCursor<CR>", { desc = "Multicursor: sous le curseur" })
vim.keymap.set("n", "<leader>ma", "<Cmd>MCpattern<CR>", { desc = "Multicursor: toutes les occurrences" })
