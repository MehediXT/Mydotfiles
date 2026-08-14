# =========================
# Performance optimizations
# =========================
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# =========================
# Completion cache
# =========================
autoload -Uz compinit

if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# =========================
# Oh My Zsh
# =========================
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="spaceship"

# =========================
# Spaceship settings
# =========================
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡ => "

SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  git
  line_sep
  char
)

# =========================
# Plugins
# =========================
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# =========================
# Autosuggestions
# =========================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# =========================
# Alias expansion
# =========================
globalias() {
    if [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]]; then
        zle _expand_alias
        zle expand-word
    fi

    zle self-insert
}

# Disabled because you don't want
# aliases expanding automatically
# when pressing Space.
#
# zle -N globalias
# bindkey " " globalias

bindkey "^[[Z" magic-space
bindkey -M isearch " " magic-space

# =========================
# SSH agent
# =========================
_load_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" >/dev/null

        if [ -f "$HOME/.ssh/id_github_sign_and_auth" ]; then
            ssh-add "$HOME/.ssh/id_github_sign_and_auth" 2>/dev/null
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _load_ssh_agent

# =========================
# PATH
# =========================
export VOLTA_HOME="$HOME/.volta"

export PATH="$VOLTA_HOME/bin:$HOME/.local/bin:$HOME/.turso:$PATH"

# =========================
# OpenRGB aliases
# =========================

# General
alias rgb-list='openrgb --list-devices'
alias rgb-gui='openrgb'

# RAM
alias rgb-ram-rainbow='openrgb --device 0 --mode "Rainbow Wave" && openrgb --device 1 --mode "Rainbow Wave"'

alias rgb-ram-red='openrgb --device 0 --mode Direct --color FF0000 && openrgb --device 1 --mode Direct --color FF0000'

alias rgb-ram-blue='openrgb --device 0 --mode Direct --color 0000FF && openrgb --device 1 --mode Direct --color 0000FF'

alias rgb-ram-purple='openrgb --device 0 --mode Direct --color 8000FF && openrgb --device 1 --mode Direct --color 8000FF'

alias rgb-ram-white='openrgb --device 0 --mode Direct --color FFFFFF && openrgb --device 1 --mode Direct --color FFFFFF'

alias rgb-ram-off='openrgb --device 0 --mode Direct --color 000000 && openrgb --device 1 --mode Direct --color 000000'

# Corsair RAM effects
alias rgb-ram-rain='openrgb --device 0 --mode Rain && openrgb --device 1 --mode Rain'

alias rgb-ram-pulse='openrgb --device 0 --mode "Color Pulse" && openrgb --device 1 --mode "Color Pulse"'

alias rgb-ram-rainbow='openrgb --device 0 --mode "Rainbow Wave" && openrgb --device 1 --mode "Rainbow Wave"'

alias rgb-ram-wave='openrgb --device 0 --mode "Color Wave" && openrgb --device 1 --mode "Color Wave"'

alias rgb-ram-marquee='openrgb --device 0 --mode Marquee && openrgb --device 1 --mode Marquee'

alias rgb-ram-visor='openrgb --device 0 --mode Visor && openrgb --device 1 --mode Visor'

alias rgb-ram-seq='openrgb --device 0 --mode Sequential && openrgb --device 1 --mode Sequential'

alias rgb-ram-off='openrgb --device 0 --mode Direct --color 000000 && openrgb --device 1 --mode Direct --color 000000'

# MSI RTX 3060
alias rgb-gpu-rainbow='openrgb --device 2 --mode Rainbow'
alias rgb-gpu-off='openrgb --device 2 --mode Off'
alias rgb-gpu-red='openrgb --device 2 --mode Direct --color FF0000'
alias rgb-gpu-blue='openrgb --device 2 --mode Direct --color 0000FF'
alias rgb-gpu-purple='openrgb --device 2 --mode Direct --color 8000FF'
alias rgb-gpu-white='openrgb --device 2 --mode Direct --color FFFFFF'
alias rgb-gpu-rainbow='openrgb --device 2 --mode Rainbow'
alias rgb-gpu-breathe='openrgb --device 2 --mode Breathing'
alias rgb-gpu-flash='openrgb --device 2 --mode Flashing'
alias rgb-gpu-doubleflash='openrgb --device 2 --mode Doubleflashing'
alias rgb-gpu-wave='openrgb --device 2 --mode Wave'
alias rgb-gpu-meteor='openrgb --device 2 --mode Meteor'
alias rgb-gpu-lightning='openrgb --device 2 --mode Lightning'
alias rgb-gpu-stream='openrgb --device 2 --mode Streaming'
alias rgb-gpu-flow='openrgb --device 2 --mode Flowing'
alias rgb-gpu-whirl='openrgb --device 2 --mode Whirling'
alias rgb-gpu-off='openrgb --device 2 --mode Off'

# Logitech G203
alias rgb-mouse-red='openrgb --device 3 --mode Static --color FF0000'
alias rgb-mouse-blue='openrgb --device 3 --mode Static --color 0000FF'
alias rgb-mouse-purple='openrgb --device 3 --mode Static --color 8000FF'
alias rgb-mouse-white='openrgb --device 3 --mode Static --color FFFFFF'
alias rgb-mouse-off='openrgb --device 3 --mode Off'

# =========================
# Source aliases last
# =========================
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

# =========================
# Terminal system summary
# =========================
if [[ -o interactive && -t 1 ]] && command -v neofetch >/dev/null 2>&1; then
    neofetch --config "$HOME/.config/neofetch/config.conf"
fi
