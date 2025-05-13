#!/usr/bin/env bash

create_requirements_txt() {
    local file="./requirements.txt"
    
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi
}

install() {
    local package="$1"
    
    if [[ -z "$package" ]]; then
        echo "Error: Package name required"
        return 1
    fi
    
    create_requirements_txt
}

uninstall() {
    local package="$1"
    
    if [[ -z "$package" ]]; then
        echo "Error: Package name required"
        return 1
    fi
}

case "$1" in
    install)
        install "$2"
        ;;
    uninstall)
        uninstall "$2"
        ;;
    *)
        echo "Usage: $0 {install|uninstall} <package>"
        exit 1
        ;;
esac