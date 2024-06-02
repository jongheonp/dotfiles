local opt = vim.opt

opt.clipboard = 'unnamedplus' -- TODO: OSC52

opt.mouse = 'a'
opt.mousescroll = { 'ver:1', 'hor:1' }

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.cursorlineopt = 'number'

opt.scrolloff = 999 -- Keep the cursor at middle

opt.splitright = true
opt.splitbelow = true

-- Softwrap
opt.linebreak = true
opt.breakat = ' \t;,!?'
opt.breakindent = true
opt.breakindentopt = { 'shift:2', 'sbr' }

-- Default plus blink in insert mode (had to because of WezTerm...)
opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25-blinkon1,r-cr-o:hor20'

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
opt.formatoptions:remove "o"
