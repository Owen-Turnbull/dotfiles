#CUSTOM CONFIG AT THE BOTTOM OF THIS FILE

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="random"

# this was replaced by oh-my-posh
#ZSH_THEME="jonathan"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
 HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
plugins=(git z vi-mode)


source $ZSH/oh-my-zsh.sh


#disabled by oh-my-posh
#MODE_INDICATOR="%F{white}+ %f"
#INSERT_MODE_INDICATOR="%F{yellow}+ %f"

PROMPT="$PROMPT\$(vi_mode_prompt_info)"
RPROMPT="\$(vi_mode_prompt_info)$RPROMPT"
# Ensure terminal shortcuts work in both vi-modes
bindkey -M viins '^C' copy_to_clipboard  # Insert mode
bindkey -M vicmd '^C' copy_to_clipboard  # Command mode

bindkey -M viins '^D' send_text_all_\x04
bindkey -M vicmd '^D' send_text_all_\x04

bindkey -M viins '^H' backward-delete-word  # Ctrl+Backspace
bindkey -M vicmd '^H' backward-delete-word

# For Ctrl+Shift+V (paste)
bindkey -M viins '^V' paste_from_clipboard
bindkey -M vicmd '^V' paste_from_clipboard

#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# Lines configured by zsh-newuser-install
setopt notify
unsetopt beep

#CUSTOM CONFIG
# TODO: change path to deduplicate directories (running where tt shows the same path three different times)


bindkey '^[l' autosuggest-accept  # Alt+l binding
alias newenv='set_environment_theme'
alias showenv=fastfetch
alias disablemonitor='hyprctl keyword monitor "eDP-1, disable"'
alias enablemonitor='hyprctl keyword monitor "eDP-1, enable"'
alias fixsound="systemctl --user stop wireplumber.service"
alias wificonnect="nmtui"
alias openwifilandingpage="xdg-open http://neverssl.com"
alias background0="kitten @ set-background-opacity 0.0"
alias backgroundfull="kitten @ set-background-opacity 1.0"
background_opacity() {
  kitten @ set-background-opacity "$1"
}
alias backgroundopacity="background_opacity"
alias activitymonitor="btop"
alias restart_evremap="systemctl restart evremap.service"



alias commands="grep '^alias ' ~/.zshrc | grep -v 'alias python=' | sed 's/^alias //'"

alias python="python3"
alias wallpapers='/home/owen/wallpapers/'

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences
#(set_terminal_theme &) 

# A wrapper function for 'lf' to enable cd on demand with the Enter key
lf() {
    # Create a unique temporary file
    local lf_cd_file=$(mktemp)
    # Export the file's path so the 'lf' process can see it
    export LF_CD_FILE="$lf_cd_file"

    # Run the actual lf file manager, passing along any arguments
    command lf "$@"

    # After lf exits, check if the temp file has a path in it
    if [[ -s "$LF_CD_FILE" ]]; then
        # If it does, change to that directory
        local target_dir=$(cat "$LF_CD_FILE")
        cd "$target_dir"
    fi

    # Clean up the temporary file
    unset LF_CD_FILE
    rm -f "$lf_cd_file"
}

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
path=($path /home/owen/.config/awww/target/release)
#source /home/owen/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#if you want to use oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.oh_my_posh_config.omp.json)"


export PATH=/opt/riscv/bin:$PATH
export PATH=${HOME}/bin/qemu/bin:${PATH}
