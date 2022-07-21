set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
set -g theme_nerd_fonts yes

# aliases
alias vi=nvim
alias vim=nvim
alias mux=tmuxinator
alias lzd=lazydocker

set -gx EDITOR 'nvim'

# path
set PATH /opt/homebrew/bin $PATH

# go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# pyenv
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

# openssl
set -x CPPFLAGS -I/usr/local/opt/openssl/include
set -x LDFLAGS -L/usr/local/opt/openssl/lib

# direnv
eval (direnv hook fish)

# peco
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \c] peco_select_ghq_repository
end

