#!/usr/bin/env bash

REQUIREMENTS_FILE="./requirements.txt"

add_requirement() {
    if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
        touch "$REQUIREMENTS_FILE"
    fi

    local package="$1"
    local package_version=$(pip freeze | grep -i "^${package}==")
    
    if ! grep -q "^${package}==" "$REQUIREMENTS_FILE"; then
        if [[ -s "$REQUIREMENTS_FILE" ]]; then
            echo "" >> "$REQUIREMENTS_FILE"
        fi
        echo "$package_version" >> "$REQUIREMENTS_FILE"
    fi
}

install() {
    local package="$1"
    
    if [[ -z "$package" ]]; then
        echo "Error: Package name required"
        return 1
    fi
    
    pip install "$package"
    local status=$?
    
    if [[ $status -eq 0 ]]; then
        add_requirement "$package"
    fi
    
    return $status
}

uninstall() {
    local package="$1"
    
    if [[ -z "$package" ]]; then
        echo "Error: Package name required"
        return 1
    fi
    
    pip uninstall -y "$package"
    local status=$?
    
    if [[ $status -eq 0 ]]; then
        sed -i '' "/^${package}==/d" "$REQUIREMENTS_FILE"
    fi
    
    return $status
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