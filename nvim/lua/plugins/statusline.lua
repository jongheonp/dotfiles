return {
  {
    'echasnovski/mini.statusline',
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 999 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 999 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineDevinfo',  strings = { git } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo }},
            { hl = 'MiniStatuslineFileinfo', strings = { '%l,%c%V' }}
          })
        end
      }
    },
    config = function(_, opts)
      require('mini.statusline').setup(opts)
    end
  }
}
