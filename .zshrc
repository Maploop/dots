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

PROMPT='%F{red}%n%f%F{white}@%f%F{magenta}%m%f %F{blue}%~%f %F{blue}$%f '
fastfetch
