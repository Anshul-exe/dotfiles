-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Close current buffer
keymap.set("n", "<C-w>", ":bd<CR>")

-- CLose whatever :q does
keymap.set("n", "<C-q>", "<:q<CR>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Disabling J (joins next line to current line)
keymap.set("n", "J", "<nop>")

-- Select all
-- keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Window resizer
keymap.set("n", "sh", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
keymap.set("n", "sl", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
keymap.set("n", "sj", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally
keymap.set("n", "sk", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally
keymap.set("n", "<C-m>", ":MaximizerToggle<CR>", { noremap = true, silent = true })
-- Window Scroll
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")
-- Move window with vim-tmux-navigator
keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>")
keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>")
keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>")
keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>")

-- Opening all the tabs after fv
keymap.set("n", "<Leader>t", ":tab all<Return>")

-- Gen.nvim keymaps
keymap.set({ "n", "v" }, "<leader>G", ":Gen<CR>")

-- Fix <Esc> in insert mode (Restore Escape key's behavior after latest LazyVim update)
vim.keymap.del("i", "<esc>") -- delete LazyVim's mapping
vim.keymap.set("i", "<esc>", "<esc>", { noremap = true, silent = true })

-- R Programming shitz
-- keymap.set("n", "<Leader>r", ":R<CR>", { noremap = true, silent = true }) -- Start R
-- keymap.set("n", "<Leader>l", "<Plug>RSendLine", {}) -- Send current line to R
-- keymap.set("v", "<Leader>l", "<Plug>RSendSelection", {}) -- Send selection to R
-- keymap.set("n", "<Leader>a", "<Plug>RSendFile", {}) -- Send entire file to R
-- keymap.set("n", "<Leader>q", ":RQuit<CR>") -- Quit R

-- Diagnostics
-- keymap.set("n", "<C-j>", function()
--   vim.diagnostic.goto_next()
-- end, opts)
