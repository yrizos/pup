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

list() {
    local missing_packages=0
    
    while IFS='=' read -r package version; do
        version=$(echo "$version" | sed 's/=*//g')
        
        installed_version=$(pip freeze | grep "^${package}==" | cut -d'=' -f3)
        
        if [[ -z "$installed_version" ]]; then
            echo -e "\033[31mError: Package ${package}==${version} is not installed\033[0m"
            missing_packages=$((missing_packages + 1))
        elif [[ "$version" != "$installed_version" ]]; then
            echo -e "\033[31mError: Package ${package}==${version} version mismatch (found ${installed_version})\033[0m"
            missing_packages=$((missing_packages + 1))
        else
            echo "${package}==${version}"
        fi
    done < "$REQUIREMENTS_FILE"
    
    if [[ $missing_packages -gt 0 ]]; then
        return 1
    fi
    
    return 0
}

case "$1" in
    install)
        install "$2"
        ;;
    uninstall)
        uninstall "$2"
        ;;
    list)
        list
        ;;
    sync)
        pip install -r "$REQUIREMENTS_FILE"
        ;;
    *)
        echo "Usage: $0 {install|uninstall|list|sync} <package>"
        exit 1
        ;;
esac