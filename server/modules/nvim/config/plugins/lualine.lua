
-- nombre de curseurs visual_multi
local function vm_cursors()
  if vim.fn.exists("b:visual_multi") == 0 then
    return ""
  end
  local ok, infos = pcall(vim.fn.VMInfos)
  if not ok or vim.tbl_isempty(infos) then
    return ""
  end
  if infos.total == 1 then
    return "1 cursor"
  end
  return string.format("%d cursors", infos.total)
end



local mode_utils = require("lualine.utils.mode")

local function get_mode_text()
  if vim.fn.exists("b:visual_multi") == 1 then
    return "VISUAL-MULTI"
  end
  return mode_utils.get_mode()
end


require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    section_separators = {
        left = "",
        right = "",
    },

    component_separators = {
        left = "",
        right = "",
    },

    globalstatus = true,
  },

  sections = {

    -- left
    lualine_a = {
      {
        function() return "  " .. get_mode_text() end,
        color = nil, -- leave color to lualine to handle
      },
    },

    lualine_b = {
      {
        "branch",
        icon = "",

        separator = "",
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
      "%=",
     {
        function()
          return os.date(" %H:%M")
        end,
      },
    },    -- droite
    lualine_x = {
        vm_cursors, 
        {
        "filetype",
        icon_only = false,
        separator = "",
        }
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

