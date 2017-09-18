set -x EDITOR 'vim'

set -x CPPFLAGS -I/usr/local/opt/openssl/include
set -x LDFLAGS -L/usr/local/opt/openssl/lib

set -x JAVA_HOME (/usr/libexec/java_home)

set -g theme_color_scheme terminal

alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi=vim
alias mux=tmuxinator

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \c] peco_select_ghq_repository
end
