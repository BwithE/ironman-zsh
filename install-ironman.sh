#!/bin/bash

echo "Initializing JARVIS installation protocol..."

# Install required packages
echo "Installing required packages..."
sudo apt install zsh neofetch figlet lolcat acpi cowsay fortune -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Create directories if they don't exist
mkdir -p ~/.config/neofetch
mkdir -p ~/scripts

# Create JARVIS/FRIDAY welcome message
cat > ~/.jarvis_welcome << 'EOF'
#!/bin/bash
if [ $UID -eq 0 ]; then
    echo "
╔════════════════════════════════════════════╗
║             FRIDAY TERMINAL                ║
║          'Welcome back, Boss.'             ║
╚════════════════════════════════════════════╝" | lolcat
else
    echo "
╔════════════════════════════════════════════╗
║             JARVIS TERMINAL                ║
║        'Good evening, Mr. Stark.'          ║
╚════════════════════════════════════════════╝" | lolcat
fi
EOF

chmod +x ~/.jarvis_welcome

# Create battery status script
cat > ~/scripts/battery-status << 'EOF'
#!/bin/bash
battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')
if [ $battery_level -ge 80 ]; then
    echo "Arc Reactor Power: ${battery_level}% ▰▰▰▰▰" | lolcat
elif [ $battery_level -ge 60 ]; then
    echo "Arc Reactor Power: ${battery_level}% ▰▰▰▰▱" | lolcat
elif [ $battery_level -ge 40 ]; then
    echo "Arc Reactor Power: ${battery_level}% ▰▰▰▱▱" | lolcat
elif [ $battery_level -ge 20 ]; then
    echo "Arc Reactor Power: ${battery_level}% ▰▰▱▱▱" | lolcat
else
    echo "⚠ Warning: Arc Reactor Power Critical: ${battery_level}% ▰▱▱▱▱" | lolcat
fi
EOF

chmod +x ~/scripts/battery-status

# Create Neofetch config
cat > ~/.config/neofetch/config.conf << 'EOF'
# Neofetch Iron Man config
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "CPU" cpu
    info "Memory" memory
    info "GPU" gpu
    info cols
}

# Iron Man colors
colors=(196 39 196 196 39 7)
EOF

# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup

# Update .zshrc
cat > ~/.zshrc << 'EOF'
# Iron Man/JARVIS Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enhanced History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# Additional shell options
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify             # report the status of background jobs immediately
setopt numericglobsort    # sort filenames numerically when it makes sense
setopt promptsubst        # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# Enhanced key bindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
    
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi

# Enhanced directory listings
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Enable auto-completion
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# Colorful completion menus
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Iron Man themed directory colors (red and gold)
export LS_COLORS="di=38;5;196:ln=38;5;214:so=38;5;208:pi=38;5;226:ex=38;5;202:bd=38;5;196:cd=38;5;196:su=38;5;196:sg=38;5;196:tw=38;5;196:ow=38;5;196"

# JARVIS Colors
export TERM="xterm-256color"

# Iron Man color scheme
if [ $UID -eq 0 ]; then
    # FRIDAY prompt for root (yellow letters with red dots)
    export PS1=$'%F{yellow}F%F{196}.%F{yellow}R%F{196}.%F{yellow}I%F{196}.%F{yellow}D%F{196}.%F{yellow}A%F{196}.%F{yellow}Y %F{208}➤ %F{39}%~ %F{yellow}# %f'
else
    # JARVIS prompt for normal user (red letters with yellow dots)
    export PS1=$'%F{196}J%F{yellow}.%F{196}A%F{yellow}.%F{196}R%F{yellow}.%F{196}V%F{yellow}.%F{196}I%F{yellow}.%F{196}S%F{yellow}. %F{208}➤ %F{39}%~ %F{196}$ %f'
fi

# JARVIS Aliases
alias jarvis="echo 'At your service, sir.' | lolcat"
alias suit="neofetch --ascii_colors 196 --colors 196 39 196 196 39 7"
alias analyze="htop"
alias shield="sudo"
alias deploy="git push"
alias mark="mkdir"
alias power="battery-status"
alias friday="fortune | cowsay | lolcat"

# screens
alias sl='screen -ls'
alias sr='screen -r'

# ip
alias ia='ip -br a'

# netcat listener / python web hosting server
alias listener="nc -nvlp 443"
alias server='python3 -m http.server 80'

# Welcome message
if [ -f ~/.jarvis_welcome ]; then
    bash ~/.jarvis_welcome
fi

# Custom JARVIS prompt
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_jarvis dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs battery time)
POWERLEVEL9K_CUSTOM_JARVIS="echo ''"

# Custom command not found handler
command_not_found_handler() {
    echo "Sir, the command '$1' is not recognized in my database." | lolcat
    return 127
}

# Less colors for man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable syntax-highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=bold
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi 
EOF

# Change default shell to zsh
chsh -s $(which zsh)

echo "JARVIS installation complete. Please restart your terminal and enjoy your new Iron Man theme!"
echo "Your previous .zshrc has been backed up to .zshrc.backup" 
