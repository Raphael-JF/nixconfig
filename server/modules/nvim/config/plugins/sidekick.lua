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



