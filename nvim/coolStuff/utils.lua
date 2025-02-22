-- local M = {}
--
-- -- Function to center an element
-- M.center_in = function(total, size)
--   return math.floor((total - size) / 2)
-- end
--
-- -- Function to expand a file path
-- M.expand_path = function(path)
--   return vim.fn.expand(path)
-- end
--
-- return M
local utils = {}

function utils.fix_telescope_parens_win()
  if vim.fn.has("win32") then
    local ori_fnameescape = vim.fn.fnameescape
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.fn.fnameescape = function(...)
      local result = ori_fnameescape(...)
      return result:gsub("\\", "/")
    end
  end
end

function utils.expand_path(path)
  if path:sub(1, 1) == "~" then
    return os.getenv("HOME") .. path:sub(2)
  end
  return path
end

function utils.center_in(outer, inner)
  return (outer - inner) / 2
end

return utils
