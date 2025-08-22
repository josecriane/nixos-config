#!/bin/bash

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m'

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
fi


echo -e "${YELLOW}===================== WIP =====================${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}        NixOS/nix-darwin Initial Setup         ${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}Detected OS: ${OS}${NC}"
echo ""

function setup_ssh_keys {
    echo -e "${YELLOW}Setting up SSH keys...${NC}"

    if [ ! -f /etc/agenix/agenix-key.age ]; then
        echo -e "${RED}Error: /etc/agenix/agenix-key.age not found${NC}"
        echo "Please copy agenix-key.age to /etc/agenix/agenix-key.age"
        return 1
    fi
    AGENIX_KEY="/etc/agenix/agenix-key.age"

    # Decrypt SSH keys
    if [ ! -f ~/.ssh/id_rsa.age ] || [ ! -f ~/.ssh/id_rsa_pub.age ]; then
        echo -e "${RED}Error: SSH key age files not found in ~/.ssh/${NC}"
        echo "Please copy id_rsa.age and id_rsa_pub.age to ~/.ssh/"
        return 1
    fi

    if [[ "$OS" == "linux" ]]; then
        # Clean up old keys
        rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub

        nix run nixpkgs#age -- -d -i "$AGENIX_KEY" ~/.ssh/id_rsa.age > ~/.ssh/id_rsa
        nix run nixpkgs#age -- -d -i "$AGENIX_KEY" ~/.ssh/id_rsa_pub.age > ~/.ssh/id_rsa.pub
    else
        # Insert HERE a copy ssh keys.
    fi
    
    # Set proper permissions
    chmod 600 ~/.ssh/id*
    chmod 644 ~/.ssh/*.pub
    
    # Setup SSH agent
    eval $(ssh-agent -s)
    ssh-add
    ssh-add -l
    
    echo -e "${GREEN}SSH keys configured successfully${NC}"
}

# macOS specific setup
function setup_macos {
    echo -e "${BLUE}Starting macOS setup...${NC}"
    echo ""
    
    # Check if Nix is already installed
    if ! command -v nix &> /dev/null; then
        echo -e "${YELLOW}Installing Nix...${NC}"
        
        # Install Xcode command line tools
        echo -e "${GREEN}Installing Xcode command line tools...${NC}"
        xcode-select --install 2>/dev/null || echo "Xcode tools already installed"
        
        # Install Nix using Determinate Systems installer
        echo -e "${GREEN}Installing Nix...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    else
        echo -e "${GREEN}Nix is already installed${NC}"
    fi
    
    # Setup SSH keys
    setup_ssh_keys
    
    # Build initial configuration
    echo -e "${YELLOW}Building initial configuration...${NC}"
    HOSTNAME=${1:-$(hostname)}
    nix --extra-experimental-features 'nix-command flakes' build ~/nixos-config#$HOSTNAME
    
    # First switch
    echo -e "${YELLOW}Switching to configuration...${NC}"
    if which darwin-rebuild &> /dev/null; then
        sudo darwin-rebuild switch --flake ~/nixos-config#$HOSTNAME
    else
        sudo ~/nixos-config/result/sw/bin/darwin-rebuild switch --flake ~/nixos-config#$HOSTNAME
    fi
    
    # Cleanup
    if [ -e ./result ]; then
        unlink ./result
    fi
    
    echo -e "${GREEN}macOS setup completed!${NC}"
}

# Linux/NixOS specific setup
function setup_nixos {
    echo -e "${BLUE}Starting NixOS setup...${NC}"
    echo ""
    
    echo -e "${YELLOW}Prerequisites:${NC}"
    echo "- Secure Boot should be disabled in firmware"
    echo "- Enable Secure Boot db to enroll new keys"
    echo "- agenix-key.age should be in /etc/agenix/"
    echo "- id_rsa.age and id_rsa_pub.age should be in ~/.ssh/"
    echo ""
    
    read -p "Continue with setup? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled"
        exit 1
    fi
    
    # Get hostname
    HOSTNAME=${1:-$(hostname)}
    echo -e "${GREEN}Using hostname: $HOSTNAME${NC}"
    
    # Update hardware configuration
    if [ -f /etc/nixos/hardware-configuration.nix ]; then
        echo -e "${YELLOW}Copying hardware configuration...${NC}"
        cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/${HOSTNAME}/hardware-configuration.nix
        echo -e "${GREEN}Hardware configuration updated${NC}"
    else
        echo -e "${YELLOW}Warning: /etc/nixos/hardware-configuration.nix not found${NC}"
    fi
    
    # Setup SSH keys
    setup_ssh_keys
    
    # Enable SecureBoot (optional)
    read -p "Enable Secure Boot? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Setting up Secure Boot...${NC}"
        # Source: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde
        sudo nix run nixpkgs#sbctl create-keys
        sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
        bootctl status
    fi
    
    # First rebuild
    echo -e "${YELLOW}Performing first rebuild...${NC}"
    sudo SSH_AUTH_SOCK="$SSH_AUTH_SOCK" nixos-rebuild switch --flake ~/nixos-config#${HOSTNAME}
    
    # Optional: Enroll fingerprint
    read -p "Enroll fingerprint? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Enrolling fingerprint...${NC}"
        fprintd-enroll
        fprintd-verify
    fi
    
    echo -e "${GREEN}NixOS setup completed!${NC}"
}

# Main
function main {
    case "$OS" in
        "macos")
            setup_macos
            ;;
        "linux")
            setup_nixos "$@"
            ;;
        *)
            echo -e "${RED}Unsupported operating system: $OSTYPE${NC}"
            echo "This script only supports macOS and NixOS"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"