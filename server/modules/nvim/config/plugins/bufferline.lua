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


