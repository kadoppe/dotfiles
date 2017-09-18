set -x EDITOR 'vim'

source ~/.asdf/asdf.fish
set -x PATH $HOME/.pyenv/bin $PATH

status --is-interactive; and . (pyenv init - | psub)
status --is-interactive; and . (pyenv virtualenv-init -)

set -x JAVA_HOME (/usr/libexec/java_home)

set -g theme_color_scheme terminal

alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi=vim
alias mux=tmuxinator

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
  bind \c] peco_select_ghq_repository
end
