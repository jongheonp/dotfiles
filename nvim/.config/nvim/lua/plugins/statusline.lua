return {
  {
    'echasnovski/mini.statusline',
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git           = MiniStatusline.section_git({ trunc_width = 40 })
          local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 999 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineFilename', strings = { git, diff, diagnostics } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFilename', strings = { '%-14.(%l,%c%V%)' } },
            { hl = 'MiniStatuslineFilename', strings = { fileinfo } }
          })
        end
      },
    }
  }
}
