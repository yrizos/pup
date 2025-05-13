# pup

A simple bash script to update `requirements.txt` when installing or uninstalling packages.

## Usage

```bash
$ ./pup.sh {install|uninstall|list|sync} <package>
```

## Commands

- `install <package>`: Installs a package and adds it to `requirements.txt`.
- `uninstall <package>`: Uninstalls a package and removes it from `requirements.txt`.
- `list`: Checks requirements.txt for missing or mismatched packages.
- `sync`: Installs all packages listed in `requirements.txt`.
