#!/bin/bash

# Dotfiles Installation Script for Fedora + Hyprland
# Based on rixprog's actual system configuration
# This script installs all necessary dependencies for the dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running on Fedora
check_os() {
    if [ ! -f /etc/fedora-release ]; then
        print_error "This script is designed for Fedora. Exiting."
        exit 1
    fi
    print_success "Fedora detected"
}

# Update system
update_system() {
    print_info "Updating system packages..."
    sudo dnf update -y
    print_success "System updated"
}

# Enable RPM Fusion repositories
enable_rpmfusion() {
    print_info "Enabling RPM Fusion repositories..."
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    print_success "RPM Fusion enabled"
}

# Enable COPR repositories
enable_copr_repos() {
    print_info "Enabling COPR repositories..."
    
    # Hyprland
    sudo dnf copr enable -y solopasha/hyprland
    
    print_success "COPR repositories enabled"
}

# Install Hyprland and Wayland essentials
install_hyprland() {
    print_info "Installing Hyprland ecosystem..."
    sudo dnf install -y \
        hyprland \
        hyprland-uwsm \
        hyprpaper \
        hyprlock \
        hypridle \
        hyprpicker \
        hyprcursor \
        hyprlang \
        hyprutils \
        aquamarine \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk \
        qt5-qtwayland \
        qt6-qtwayland \
        polkit-gnome \
        xfce-polkit \
        wl-clipboard \
        cliphist \
        uwsm
    print_success "Hyprland installed"
}

# Install Waybar
install_waybar() {
    print_info "Installing Waybar..."
    sudo dnf install -y waybar
    print_success "Waybar installed"
}

# Install terminal and shell
install_terminal_shell() {
    print_info "Installing Kitty terminal and shell tools..."
    sudo dnf install -y \
        kitty \
        kitty-kitten \
        kitty-shell-integration \
        kitty-terminfo \
        zsh \
        bash-completion \
        fzf \
        ripgrep \
        fd-find \
        bat \
        eza \
        zoxide \
        starship \
        tmux \
        htop \
        btop
    print_success "Terminal and shell tools installed"
}

# Install Neovim and development tools
install_neovim() {
    print_info "Installing Neovim and development tools..."
    sudo dnf install -y \
        neovim \
        python3-neovim \
        python3-pip \
        nodejs \
        npm \
        gcc \
        gcc-c++ \
        g++ \
        make \
        cmake \
        ninja-build \
        git \
        git-core \
        tree-sitter-cli \
        ccache \
        kernel-devel \
        kernel-headers
    print_success "Neovim and dev tools installed"
}

# Install Rofi (Wayland fork)
install_rofi() {
    print_info "Installing Rofi and launchers..."
    sudo dnf install -y \
        rofi \
        rofi-themes \
        wofi
    print_success "Rofi installed"
}

# Install notification daemon
install_swaync() {
    print_info "Installing SwayNC (notification center)..."
    sudo dnf install -y SwayNotificationCenter
    print_success "SwayNC installed"
}

# Install media and screenshot tools
install_media_tools() {
    print_info "Installing media and screenshot tools..."
    sudo dnf install -y \
        grim \
        slurp \
        swappy \
        wf-recorder \
        mpv \
        vlc \
        pavucontrol \
        pipewire \
        pipewire-alsa \
        pipewire-pulseaudio \
        pipewire-jack-audio-connection-kit \
        wireplumber \
        playerctl \
        playerctl-libs
    print_success "Media tools installed"
}

# Install additional Hyprland tools
install_hypr_tools() {
    print_info "Installing additional Hyprland utilities..."
    sudo dnf install -y \
        nwg-look \
        nwg-bar \
        nwg-panel \
        nwg-dock-hyprland \
        wlogout \
        wlr-randr \
        swww \
        waypaper \
        light \
        brightnessctl
    print_success "Hyprland tools installed"
}

# Install file manager and utilities
install_utilities() {
    print_info "Installing utilities..."
    sudo dnf install -y \
        thunar \
        thunar-archive-plugin \
        thunar-volman \
        tumbler \
        file-roller \
        fastfetch \
        wget \
        wget2 \
        curl \
        unzip \
        zip \
        p7zip \
        gvfs \
        gvfs-mtp \
        gvfs-smb \
        tree \
        xclip \
        xsel
    print_success "Utilities installed"
}

# Install fonts
install_fonts() {
    print_info "Installing fonts..."
    sudo dnf install -y \
        fontawesome-fonts \
        fontawesome-6-free-fonts \
        fontawesome-6-brands-fonts \
        fontawesome4-fonts \
        google-noto-emoji-fonts \
        google-noto-color-emoji-fonts \
        google-noto-sans-cjk-vf-fonts \
        fira-code-fonts \
        jetbrains-mono-fonts \
        liberation-fonts-all \
        dejavu-sans-fonts \
        dejavu-sans-mono-fonts
    
    # Install Nerd Fonts manually
    print_info "Installing JetBrainsMono Nerd Font..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    cd /tmp
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -q JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
    rm JetBrainsMono.zip
    
    fc-cache -fv
    print_success "Fonts installed"
}

# Install Oh My Posh
install_oh_my_posh() {
    print_info "Installing Oh My Posh..."
    
    curl -s https://ohmyposh.dev/install.sh | bash -s
    
    print_success "Oh My Posh installed"
}

# Install themes and icons
install_themes() {
    print_info "Installing GTK themes and icons..."
    sudo dnf install -y \
        adwaita-gtk2-theme \
        adwaita-icon-theme \
        gnome-themes-extra \
        breeze-icon-theme \
        papirus-icon-theme \
        qt6ct \
        qt5ct \
        adwaita-qt5 \
        adwaita-qt6
    print_success "Themes and icons installed"
}

# Install Qt Wayland support
install_qt_wayland() {
    print_info "Installing Qt Wayland components..."
    sudo dnf install -y \
        qt6-qtwayland \
        qt6-qtwayland-adwaita-decoration \
        qt5-qtwayland \
        qadwaitadecorations-qt5
    print_success "Qt Wayland support installed"
}

# Setup ZSH
setup_zsh() {
    print_info "Setting up ZSH..."
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # Change default shell to zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Changing default shell to ZSH..."
        chsh -s $(which zsh)
        print_success "Default shell changed to ZSH (restart required)"
    fi
    
    print_success "ZSH setup complete"
}

# Install container tools (optional)
install_container_tools() {
    print_info "Do you want to install container tools (Docker, Podman)? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo dnf install -y \
            podman \
            docker-cli \
            moby-engine \
            docker-buildx \
            containerd \
            containernetworking-plugins
        print_success "Container tools installed"
    fi
}

# Install browsers
install_browsers() {
    print_info "Do you want to install browsers? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo dnf install -y firefox
        
        # Brave browser (from your package list)
        print_info "Installing Brave browser..."
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install -y brave-browser
        
        print_success "Browsers installed"
    fi
}

# Install code editors
install_code_editors() {
    print_info "Do you want to install VS Code and Cursor? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        # VS Code
        print_info "Installing VS Code..."
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf install -y code
        
        # Cursor is already in your system - from cursor repo
        print_info "Cursor can be installed from https://cursor.com"
        
        print_success "Code editors installed"
    fi
}

# Final setup
final_setup() {
    print_info "Performing final setup..."
    
    # Create necessary directories
    mkdir -p ~/.config
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/share/applications
    mkdir -p ~/Pictures/Screenshots
    mkdir -p ~/Pictures/Wallpapers
    mkdir -p ~/.wm_screenshots
    
    # Add user to video group for backlight control
    sudo usermod -aG video $USER
    
    print_success "Directories created and user groups configured"
}

# Main installation function
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║     Dotfiles Installation Script (Fedora+Hyprland)     ║"
    echo "║                  by rixprog                            ║"
    echo "║       Based on ML4W Dotfiles Configuration             ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    print_warning "This script will install packages and modify your system."
    print_info "Press Enter to continue or Ctrl+C to cancel..."
    read -r
    
    check_os
    update_system
    enable_rpmfusion
    enable_copr_repos
    install_hyprland
    install_waybar
    install_terminal_shell
    install_neovim
    install_rofi
    install_swaync
    install_media_tools
    install_hypr_tools
    install_utilities
    install_fonts
    install_oh_my_posh
    install_themes
    install_qt_wayland
    setup_zsh
    install_container_tools
    install_browsers
    install_code_editors
    final_setup
    
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "Installation complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""
    print_info "Next steps:"
    echo "  1. Log out and select 'Hyprland' from your login manager"
    echo "  2. Your dotfiles should already be configured via the bare repo"
    echo "  3. Restart your terminal to activate ZSH"
    echo "  4. Review and customize ~/.config/hypr/hyprland.conf"
    echo "  5. Check waybar config at ~/.config/waybar/"
    echo ""
    print_warning "You may need to reboot for all changes to take effect."
    print_info "To enable Hyprland at login, install a display manager like:"
    echo "  sudo dnf install sddm"
    echo "  sudo systemctl enable sddm"
    echo ""
}

# Run main function
main
