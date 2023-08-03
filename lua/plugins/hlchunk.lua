return {
  {
    {
      "shellRaining/hlchunk.nvim",
      event = { "UIEnter" },
      opts = {
        indent = {
          -- chars = { "│", "│", "·", "·" },
          -- chars = { "│", "¦", "┆", "┊" }, -- more code can be found in https://unicodeplus.com/
          chars = { "│" }, -- more code can be found in https://unicodeplus.com/

          style = {
            "#333333",
          },
        },

        blank = {
          enable = false,
        },

        chunk = {
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
          style = "#00ffff",
        },

        line_num = {
          style = "#00ffff",
        },
      },
    },
  },
}
