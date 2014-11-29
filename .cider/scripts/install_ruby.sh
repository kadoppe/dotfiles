#!/usr/bin/env bash

if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
else
    puterr "rbenv not installed"
    exit 1
fi

rbenv install 2.1.5 --skip-existing
rbenv global 2.1.5
gem update --system
