PROMPT='%F{green}%n@%m%f %F{blue}%1~%f %# '

unsetopt BEEP
unsetopt PROMPTSP
setopt HISTIGNOREALLDUPS SHAREHISTORY

export LS_COLORS="" # TODO: Fix

# brew autocomplete
if type brew &> /dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export HOMEBREW_NO_ENV_HINTS=1

autoload -Uz compinit select-word-style
compinit
select-word-style bash # NOTE: Affects Alt-Backspace

# Completion styles
zstyle ':completion:*' completer _expand _extensions _complete _correct _approximate
zstyle ':completion:*:default' list-colors ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS=" \
--info=inline-right \
--color=\
fg+:-1,\
bg+:-1,\
gutter:-1,\
hl+:green,\
info:-1,\
border:-1,\
separator:-1,\
prompt:16,\
pointer:16,\
marker:16,\
spinner:17,\
header:gray"

if type nvim &> /dev/null; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
fi

RIPGREP_CONFIG_PATH=$HOME/.config/rg/ripgreprc
if type rg &> /dev/null && [[ -f "$RIPGREP_CONFIG_PATH" ]]; then
  export RIPGREP_CONFIG_PATH
fi

source "$HOME/.aliases"
