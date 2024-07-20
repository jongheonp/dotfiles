local opt = vim.opt

opt.clipboard = 'unnamedplus' -- TODO: OSC52

opt.mouse = 'a'
opt.mousescroll = { 'ver:1', 'hor:1' }

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.cursorlineopt = 'number'

opt.splitright = true
opt.splitbelow = true

-- Softwrap
opt.linebreak = true
opt.breakat = ' \t;,!?'
opt.breakindent = true
opt.breakindentopt = { 'shift:2', 'sbr' }

opt.ignorecase = true
opt.smartcase = true

-- Insert 2 <S>s instead of <Tab> while editing
opt.expandtab = true -- Insert spaces instead of tabs
opt.shiftwidth = 2 -- Number of whitespace for (auto)indent
opt.softtabstop = -1 -- Use shiftwidth's value

-- Pop up menu even when only one match, explicit insert & select by user
-- Not sure about preview... does it do anything for cmp?
opt.completeopt = {'menu', 'menuone', 'noselect' }
opt.inccommand = 'split'

-- Used for CursorHold autocmd
opt.updatetime = 250

-- Don't insert comment leader after 'o' or 'O' in insert mode
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  callback = function()
    opt.formatoptions:remove('o')
  end
})
