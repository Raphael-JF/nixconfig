require("mini.surround").setup({
  custom_surroundings = {
    ["("] = {
      output = function()
        return {
          left = "(",
          right = ")",
        }
      end,
    },

    ["["] = {
      output = function()
        return {
          left = "[",
          right = "]",
        }
      end,
    },

    ["{"] = {
      output = function()
        return {
          left = "{",
          right = "}",
        }
      end,
    },
  },
})
