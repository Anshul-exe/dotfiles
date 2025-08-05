local utils = require("coolStuff.utils")
local M = {}

M.active_win = nil -- Track the current floating window
M.config = {
  scratchpad_file = "~/.config/nvim/cheatSheet.md",
  temp_file = "~/tt.md",
  width_ratio = 0.8,
  height_ratio = 0.8,
  max_width = 100,
  border = "single",
}

-- Floating window config based on editor size
local function float_win_config()
  local width = math.min(math.floor(vim.o.columns * M.config.width_ratio), M.config.max_width)
  local height = math.floor(vim.o.lines * M.config.height_ratio)
  return {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor(utils.center_in(vim.o.columns, width)),
    row = math.floor(utils.center_in(vim.o.lines, height)),
    border = M.config.border,
    style = "minimal",
  }
end

-- Close the active floating window
local function close_floating_window()
  if M.active_win and vim.api.nvim_win_is_valid(M.active_win) then
    vim.api.nvim_win_close(M.active_win, true)
    M.active_win = nil
  end
end

-- Open file in floating window
local function open_floating_file(filepath)
  local path = utils.expand_path(filepath)

  -- Create directory if it doesn't exist
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  -- Create file if it doesn't exist
  if vim.fn.filereadable(path) == 0 then
    local file = io.open(path, "w")
    if file then
      file:write("# " .. vim.fn.fnamemodify(path, ":t:r") .. "\n\n")
      file:close()
    else
      vim.notify("Could not create file: " .. path, vim.log.levels.ERROR)
      return
    end
  end

  -- Close previous floating window if still open
  close_floating_window()

  -- Look for an existing buffer with this file
  local existing_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name == path then
        existing_buf = buf
        break
      end
    end
  end

  local buf
  if existing_buf then
    buf = existing_buf
  else
    -- Create new buffer and load the file
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, path)
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! edit " .. vim.fn.fnameescape(path))
    end)
  end

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, float_win_config())
  M.active_win = win

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
  vim.api.nvim_win_set_option(win, "spell", false)
  vim.api.nvim_win_set_option(win, "wrap", true)
  vim.api.nvim_win_set_option(win, "linebreak", true)

  -- Set keybindings for the floating window
  local opts = { noremap = true, silent = true, buffer = buf }

  -- 'q' to close (with unsaved changes check)
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      vim.notify("Save nahi kro barkhurdaar (:w or ZZ)", vim.log.levels.WARN)
    else
      close_floating_window()
    end
  end, opts)

  -- 'ZZ' to save and close
  vim.keymap.set("n", "ZZ", function()
    vim.cmd("write")
    close_floating_window()
  end, opts)

  -- 'ZQ' to quit without saving
  vim.keymap.set("n", "ZQ", function()
    vim.api.nvim_buf_set_option(buf, "modified", false)
    close_floating_window()
  end, opts)

  -- Escape to close (with unsaved changes check)
  vim.keymap.set("n", "<Esc>", function()
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      vim.notify("Save nahi kro barkhurdaar (:w or ZZ)", vim.log.levels.WARN)
    else
      close_floating_window()
    end
  end, opts)

  -- Auto-resize on VimResized
  local resize_autocmd = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, float_win_config())
      end
    end,
    once = false,
  })

  -- Clean up autocmd when window is closed
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    callback = function()
      pcall(vim.api.nvim_del_autocmd, resize_autocmd)
      if M.active_win == win then
        M.active_win = nil
      end
    end,
    once = true,
  })
end

-- Toggle floating file (open if closed, close if open)
local function toggle_floating_file(filepath)
  if M.active_win and vim.api.nvim_win_is_valid(M.active_win) then
    close_floating_window()
  else
    open_floating_file(filepath)
  end
end

-- Setup user commands
local function setup_user_commands()
  -- Remove existing commands if they exist
  pcall(vim.api.nvim_del_user_command, "Scratchpad")
  pcall(vim.api.nvim_del_user_command, "ScratchpadTemp")

  -- Create the Scratchpad command (main scratchpad file)
  vim.api.nvim_create_user_command("Scratchpad", function()
    toggle_floating_file(M.config.scratchpad_file)
  end, { desc = "Toggle main scratchpad file" })

  -- Create the ScratchpadTemp command (temporary file)
  vim.api.nvim_create_user_command("ScratchpadTemp", function()
    toggle_floating_file(M.config.temp_file)
  end, { desc = "Toggle temporary scratchpad file" })
end

-- Setup keymaps
local function setup_keymaps()
  vim.keymap.set("n", "<leader>ti", ":Scratchpad<CR>", {
    silent = true,
    desc = "Toggle main scratchpad",
  })
  vim.keymap.set("n", "<leader>td", ":ScratchpadTemp<CR>", {
    silent = true,
    desc = "Toggle temporary scratchpad",
  })
end

-- Public setup function to initialize the plugin
M.setup = function(opts)
  -- Merge user config with defaults
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end

  setup_user_commands()
  setup_keymaps()
end

-- Public API functions
M.open = function(filepath)
  open_floating_file(filepath or M.config.scratchpad_file)
end

M.toggle = function(filepath)
  toggle_floating_file(filepath or M.config.scratchpad_file)
end

M.close = function()
  close_floating_window()
end

return M
