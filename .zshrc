# eval "$(starship init zsh)"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

autoload -Uz compinit
compinit

# Better completion menu
zstyle ':completion:*' menu select

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Completion colors — grayscale
zstyle ':completion:*' list-colors \
  '=(#b)*(=0)=38;5;250' \
  '=(#b)*(=1)=38;5;255' \
  '=(#b)*(=2)=38;5;245' \
  '=(#b)*(=3)=38;5;240'

# Autosuggestions — dark gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# --------------------------------------------------
# History
# --------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

alias ls="eza --long --header --icons=always --group-directories-first"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{white}[%F{cyan}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{white}]%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}✓%f"

PROMPT='%F{red}%n%f%F{white}@%f%F{magenta}%m%f %F{blue}%~%f %F{blue}$%f $(git_prompt_info)'
fastfetch

