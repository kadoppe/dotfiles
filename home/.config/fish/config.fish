set -x EDITOR 'vim'

set PATH /opt/homebrew/bin $PATH
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

set -x CPPFLAGS -I/usr/local/opt/openssl/include
set -x LDFLAGS -L/usr/local/opt/openssl/lib

set -x JAVA_HOME (/usr/libexec/java_home)

set -g theme_color_scheme terminal

status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

load_nvm

alias vi=nvim
alias mux=tmuxinator
alias lzd=lazydocker

eval (direnv hook fish)

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \c] peco_select_ghq_repository
end
