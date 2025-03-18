local utils = require("coolStuff.utils")

local M = {}
M.active_win = nil -- Track the current floating window

-- Floating window config based on editor size
local function float_win_config()
  local width = math.min(math.floor(vim.o.columns * 0.8), 100)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = utils.center_in(vim.o.columns, width),
    row = utils.center_in(vim.o.lines, height),
    border = "single",
  }
end

-- Open file in floating window
local function open_floating_file(filepath)
  local path = utils.expand_path(filepath)

  -- Check if the file exists
  if vim.fn.filereadable(path) == 0 then
    vim.notify("File does not exist: " .. path, vim.log.levels.ERROR)
    return
  end

  -- Close previous floating window if still open
  if M.active_win and vim.api.nvim_win_is_valid(M.active_win) then
    vim.api.nvim_win_close(M.active_win, true)
  end

  -- Look for an existing buffer with this file
  local buf = vim.fn.bufnr(path, true)

  -- If the buffer doesn't exist, create one and edit the file
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, path)
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end)
  end

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, float_win_config())
  M.active_win = win -- store the active window ID
  vim.cmd("setlocal nospell")

  -- Set 'q' keybinding to close window (with unsaved changes check)
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    noremap = true,
    silent = true,
    callback = function()
      if vim.api.nvim_get_option_value("modified", { buf = buf }) then
        vim.notify("Changes toh Save krle bhai", vim.log.levels.WARN)
      else
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Update window size on VimResized event (with window validity check)
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, float_win_config())
      end
    end,
    once = false,
  })
end

-- Helper to safely create user commands (avoids duplication error)
local function safe_create_user_command(name, fn, opts)
  local ok = pcall(vim.api.nvim_get_user_command, name)
  if not ok then
    vim.api.nvim_create_user_command(name, fn, opts or {})
  end
end

-- Setup user commands for Ti and Td
local function setup_user_commands(opts)
  local target_file = opts.target_file or "tt.md"
  local resolved_target_file = vim.fn.resolve(target_file)

  if vim.fn.filereadable(resolved_target_file) == true then
    opts.target_file = resolved_target_file
  else
    opts.target_file = opts.global_file
  end

  -- Create the Ti command
  safe_create_user_command("Ti", function()
    open_floating_file(opts.target_file)
  end)

  -- Create the Td command
  safe_create_user_command("Td", function()
    open_floating_file("~/tt")
  end)
end

-- Setup keymaps for Ti and Td
local function setup_keymaps()
  vim.keymap.set("n", "<leader>td", ":Td<CR>", { silent = true })
  vim.keymap.set("n", "<leader>ti", ":Ti<CR>", { silent = true })
end

-- Public setup function to initialize commands and keymaps
M.setup = function(opts)
  setup_user_commands(opts or {})
  setup_keymaps()
end

return M
