return {
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
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({})
    end,
    opts = {
      blame_options = { "-w" },
    },
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3.1:8b", -- Default model
      quit_map = "q",
      retry_map = "<c-r>",
      accept_map = "<c-a>",
      host = "localhost",
      port = "11434",
      display_mode = "float",
      show_prompt = false,
      show_model = true, -- Show which model is being used
      no_auto_close = false,
      file = false,
      hidden = false,
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
      result_filetype = "markdown",
      debug = false,
    },
    config = function(_, opts)
      require("gen").setup(opts)

      -- Custom prompts with specific models
      require("gen").prompts = {
        -- DeepSeek Coder for code-specific tasks
        ["Review_Code"] = {
          prompt = "Review the following code and make concise suggestions:\n```$filetype\n$text\n```",
          model = "deepseek-coder:6.7b",
        },
        ["Enhance_Code"] = {
          prompt = "Enhance and optimize the following code and make concise suggestions:\n```$filetype\n$text\n```",
          model = "deepseek-coder:6.7b",
          extract = "```$filetype\n(.-)```",
          -- replace = true,
        },
        ["Fix_Code"] = {
          prompt = "Fix any bugs or issues in the following code:\n\n$text",
          model = "deepseek-coder:6.7b",
        },
        ["Change_Code"] = {
          prompt = "Regarding the following code, $input, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          -- replace = true,
          extract = "```$filetype\n(.-)```",
          model = "deepseek-coder:6.7b",
        },
        ["Generate_Code"] = {
          prompt = "Generate code for: $input",
          model = "deepseek-coder:6.7b",
        },
        ["Add_Comments"] = {
          prompt = "Add detailed comments to explain the following code:\n\n$text",
          model = "deepseek-coder:6.7b",
        },
        ["Write_Tests"] = {
          prompt = "Write unit tests for the following code:\n\n$text",
          model = "deepseek-coder:6.7b",
        },

        -- Llama 3.1 for everything else
        ["Ask"] = {
          prompt = "Regarding the following text, $input:\n$text",
          model = "llama3.1:8b",
        },
        ["Change"] = {
          prompt = "Change the following text, $input, just output the final text without additional quotes around it:\n$text",
          -- replace = true,
          model = "llama3.1:8b",
        },
        ["Generate"] = {
          prompt = "$input",
          replace = true,
          model = "llama3.1:8b",
        },
        ["Chat"] = {
          prompt = "$input",
          model = "llama3.1:8b",
        },
        ["Explain"] = {
          prompt = "Explain the following:\n\n$text",
          model = "llama3.1:8b",
        },
        ["Summarize"] = {
          prompt = "Summarize the following text:\n$text",
          model = "llama3.1:8b",
        },
        ["Make_List"] = {
          prompt = "Render the following text as a markdown list, just output the final text without additional quotes around it:\n$text",
          model = "llama3.1:8b",
          replace = true,
        },
        ["Make_Table"] = {
          prompt = "Render the following text as a markdown table, just output the final text without additional quotes around it:\n$text",
          replace = true,
          model = "llama3.1:8b",
        },
        ["Grammar_Correct"] = {
          prompt = "Modify the following text to improve grammar and spelling, just output the final text without additional quotes around it:\n$text",
          replace = true,
          model = "llama3.1:8b",
        },
        ["Enhance_Wording"] = {
          prompt = "Modify the following text to use better wording, just output the final text without additional quotes around it:\n$text",
          -- replace = true,
          model = "llama3.1:8b",
        },
        ["Make_Concise"] = {
          prompt = "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n$text",
          -- replace = true,
          model = "llama3.1:8b",
        },
        ["Make_Style"] = {
          prompt = "Transform the following text into the style of $input , just output the final text without additional quotes around it:\n$text",
          replace = true,
          model = "llama3.1:8b",
        },
      }
    end,
  },
}

-- make table
-- make concise
-- enhance wording
