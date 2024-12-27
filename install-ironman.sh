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

# Enable command history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
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
compinit

# Colorful completion menus
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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
EOF

# Change default shell to zsh
chsh -s $(which zsh)

echo "JARVIS installation complete. Please restart your terminal and enjoy your new Iron Man theme!"
echo "Your previous .zshrc has been backed up to .zshrc.backup" 
