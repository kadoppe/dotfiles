set -x EDITOR 'vim'

set -x CPPFLAGS -I/usr/local/opt/openssl/include
set -x LDFLAGS -L/usr/local/opt/openssl/lib

set -x JAVA_HOME (/usr/libexec/java_home)

set -g theme_color_scheme terminal

status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

alias vi=vim
alias mux=tmuxinator

eval (direnv hook fish)

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \c] peco_select_ghq_repository
end

source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
