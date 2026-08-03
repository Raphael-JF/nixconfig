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



vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")


