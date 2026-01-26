return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  -- stylua: ignore
  keys = {
    { "zk",    mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "Zk",    mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "nvim-mini/mini.hipatterns",
    version = false,
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require("solarized-osaka.hsl")
            --- @type string, string, string
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        -- Open blame window
        blame = "<Leader>gb",
        -- Open file/folder in git repository
        browse = "<Leader>go",
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
  },
  {
    "szw/vim-maximizer",
  },
  {
    "jalvesaq/Nvim-R",
    ft = { "r", "rmd" }, -- Load for R and R Markdown files only
    config = function()
      -- Basic Nvim-R settings
      vim.g.R_auto_start = 2 -- Automatically start R when opening an R file
      vim.g.R_assign = 0 -- Disable `<C-->` for `<-` to avoid interference
      vim.g.Rout_more_colors = 1 -- Enable better colors in the R console
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },
  {
    name = "scratchpad",
    dir = vim.fn.stdpath("config"), -- Points to your nvim config directory
    config = function()
      local scratchpad = require("coolStuff.float")
      scratchpad.setup({
        -- Main cheatsheet/scratchpad file
        scratchpad_file = "~/.config/nvim/cheatSheet.md",
        -- Temporary scratchpad file
        temp_file = "~/tt", -- or wherever you prefer
        -- Window sizing
        width_ratio = 0.8, -- 80% of screen width
        height_ratio = 0.8, -- 80% of screen height
        max_width = 120, -- Maximum width in columns
        -- Border style: "single", "double", "rounded", "solid", "shadow", "none"
        border = "rounded",
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- use latest stable release
    lazy = true,
    ft = "markdown",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      workspaces = {
        {
          name = "LesssGo",
          path = vim.fn.expand("~/clear_space/codeLore/learnings/DevOps/go/notes/"),
        },
      },

      -- 🔑 THIS IS THE IMPORTANT PART
      follow_url_func = function(url)
        -- Handle file:// URLs by opening them in Neovim
        if url:match("^file://") then
          local path = url:gsub("^file://", "")
          vim.cmd("edit " .. vim.fn.fnameescape(path))
        else
          -- Fallback for http(s) links
          vim.fn.jobstart({ "xdg-open", url }, { detach = true })
        end
      end,
    },
  },
}
