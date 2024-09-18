local opt = vim.opt

opt.breakindent = true
opt.breakindentopt = { 'shift:2', 'sbr' }

opt.clipboard = 'unnamedplus' -- TODO: OSC52

opt.completeopt = {'menu', 'menuone', 'noselect' }

opt.cursorline = true

opt.expandtab = true -- Insert spaces instead of tabs

-- Don't insert comment leader after 'o' or 'O' in insert mode
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  callback = function()
    opt.formatoptions:remove('o')
  end
})

opt.grepprg = 'rg --vimgrep --smart-case'

opt.ignorecase = true

opt.inccommand = 'split'

opt.linebreak = true -- Softwrap

opt.mouse = 'a'
opt.mousescroll = { 'ver:1', 'hor:1' }

opt.number = true
opt.relativenumber = true

opt.shiftwidth = 2 -- Number of whitespace for (auto)indent

opt.showmode = false

opt.smartcase = true

opt.softtabstop = -1 -- Use shiftwidth's value

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250 -- Used for CursorHold autocmd
