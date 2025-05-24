return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  { "wakatime/vim-wakatime", lazy = false },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      {
        "<leader>ucc",
        function()
          -- Check Copilot status without using client.is_attached
          local status_ok, copilot = pcall(require, "copilot")
          if not status_ok then
            vim.notify("Copilot is not properly initialized", vim.log.levels.ERROR)
            return
          end

          if vim.g.copilot_status == nil then
            vim.g.copilot_status = "running"
          end

          if vim.g.copilot_status == "running" then
            vim.g.copilot_status = "stopped"
            vim.cmd("Copilot disable")
            vim.notify("Copilot disabled", vim.log.levels.INFO)
          else
            vim.g.copilot_status = "running"
            vim.cmd("Copilot enable")
            vim.notify("Copilot enabled", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle Copilot",
      },
    },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      filetypes = {
        yaml = false,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      suggestion = {
        enable = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-a>",
          next = "<C-]>",
          prev = "<C-[>",
          dismiss = "<C-\\>",
        },
      },
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          advanced = {
            listCount = 10,
            inlineSuggestCount = 3,
          },
        },
      },
    },
    config = function(_, opts)
      vim.schedule(function()
        require("copilot").setup(opts)
      end)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app; yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/usr/bin/google-chrome-stable"
    end,
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<leader>mdn", ":MarkdownPreview<CR>")
      vim.keymap.set("n", "<leader>mds", ":MarkdownPreviewStop<CR>")

      vim.g.mkdp_markdown_css = "/Users/michaelwilliams/dotfiles/.config/nvim/assets/md.css"
      vim.g.mkdp_highlight_css = "/Users/michaelwilliams/dotfiles/.config/nvim/assets/mdhl.css"
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter", -- you can adjust the event to fit your needs
  --   config = function()
  --     -- Setup for nvim-cmp (basic config)
  --     local cmp = require("cmp")
  --     cmp.setup({
  --       -- Add your cmp configuration here
  --       mapping = {
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }),
  --       },
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "buffer" },
  --       }),
  --     })
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   opts = {},
  --   config = function(_, opts)
  --     local copilot_cmp = require("copilot_cmp")
  --     copilot_cmp.setup(opts)
  --   end,
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   event = "VeryLazy",
  --   branch = "canary",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     debug = true, -- Enable debugging
  --     -- See Configuration section for rest
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  {
    "mechatroner/rainbow_csv",
    ft = { "csv" },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
}
