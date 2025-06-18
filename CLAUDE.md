# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with [homesick](https://github.com/technicalpickles/homesick), containing personal configuration files for various development tools and applications. The structure follows homesick conventions with configurations stored in the `home/` directory.

## Architecture

- **home/**: Contains all dotfiles that will be symlinked to the user's home directory
  - Configuration files (`.gitconfig`, `.tmux.conf`, etc.)
  - **home/.config/**: XDG-compliant application configurations
    - **nvim/**: Neovim configuration with Lua-based setup using LazyVim
    - **fish/**: Fish shell configuration with custom functions and aliases
    - **mise/**: Runtime version manager configuration
    - **alacritty/**, **ghostty/**: Terminal emulator configs
    - **karabiner/**: Keyboard customization
    - **lazygit/**: Git UI configuration

## Key Configuration Components

### Neovim Setup
- **init.lua**: Main configuration entry point, sets up basic options and loads modules
- **lua/maps.lua**: Custom key mappings
- **lua/lazyvim.lua**: LazyVim plugin manager setup
- **lua/plugins/**: Individual plugin configurations (40+ plugins)
- Uses mise-managed Python interpreters for plugins
- Requires vim backup/swap/undo directories (created by `make_vim_dir.sh`)

### Shell Environment (Fish)
- Custom `prj` function for project switching with tmux integration
- Uses ghq for repository management and fzf for fuzzy finding
- Integrates with mise for runtime version management
- Aliases for common tools (nvim, lazygit, eza, etc.)

### Development Tools Integration
- **mise**: Manages Node.js, Ruby, Python, Go, Deno versions
- **Git**: Extensive alias configuration, delta for diff viewing, 1Password for signing
- **tmux**: Custom configuration for terminal multiplexing

## Common Commands

### Homesick Management
```bash
# Deploy dotfiles (symlink to home directory)
homesick symlink dotfiles

# Pull latest changes
homesick pull dotfiles

# Check status
homesick status dotfiles
```

### Neovim Plugin Management
Neovim uses LazyVim - plugins are automatically managed. When editing plugin configurations in `lua/plugins/`, restart Neovim to load changes.

### Development Environment
- Use `mise install` to install configured language runtimes
- Fish shell aliases: `vi`/`vim` → `nvim`, `lg` → `lazygit`, `ls` → `eza`
- Project navigation: `prj` command for fuzzy project selection with tmux

## File Editing Guidelines

### Neovim Plugin Configurations
- Located in `home/.config/nvim/lua/plugins/`
- Each plugin typically has its own file
- Use Lua syntax, not Vimscript
- In Lua 5.1 (Neovim): use `unpack()`, not `table.unpack()`

### Shell Configuration
- Fish config in `home/.config/fish/config.fish`
- Local overrides can go in `config.local.fish` (not tracked in git)

### Git Configuration
- Personal git aliases extensively configured in `.gitconfig`
- Uses SSH signing with 1Password integration