#/bin/bash

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

HOSTNAME="MacBookAir10-1-jose-cribeiro"
CONF_NAME="darwinConfigurations.$HOSTNAME.system"

function install_nix {
    echo "${GREEN}Install dependencies${NC}"
    xcode-select --install

    echo "${GREEN}Install Nix${NC}"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
}

function build_conf {
    echo "${GREEN}Build dependencies${NC}"
    nix --extra-experimental-features 'nix-command flakes' build ~/nixos-config#$CONF_NAME
}

function switch {
    echo "${GREEN}Switch to generation${NC}"

    if which darwin-rebuild &> /dev/null; then
        sudo darwin-rebuild switch --flake ~/nixos-config#$HOSTNAME
    else
        sudo ~/nixos-config/result/sw/bin/darwin-rebuild switch --flake ~/nixos-config#$HOSTNAME
    fi

    echo "${GREEN}Cleaning up${NC}"
    if [ -e ./result ]; then
        unlink ./result
    fi
}

function list_generations {
    echo "${YELLOW}Available generations:${NC}"
    /run/current-system/sw/bin/darwin-rebuild --list-generations
}

function select_rollback {
    echo "${YELLOW}Enter the generation number for rollback:${NC}"
    read GEN_NUM

    if [ -z "$GEN_NUM" ]; then
        echo "${RED}No generation number entered. Aborting rollback.${NC}"
        exit 1
    fi

    rollback $GEN_NUM
}

function rollback {
    echo "${YELLOW}Rolling back to generation $1...${NC}"
    /run/current-system/sw/bin/darwin-rebuild switch --flake .#$HOSTNAME --switch-generation $1
}

function usage {
    echo "Usage: $(basename $0) [-i] [-b] [-s] [-bs] [-l] [-r] [-h]"
    echo "-i Install Nix"
    echo "-b Build configuration"
    echo "-s Switch to generation"
    echo "-l List generations"
    echo "-r list generations then rollback to GEN_NUM"
    echo "-h Help"
    exit 0
}

## Main
[ $# -eq 0 ] && usage
while getopts 'ibslrh' opt; do
    case "$opt" in
        i)
            install_nix
            ;;
        b)
            build_conf
            ;;
        s)
            switch
            ;;
        l)
            list_generations
            ;;
        r)
            list_generations
            select_rollback
            ;;
        ? | h)
            usage
        ;;
    esac
done
