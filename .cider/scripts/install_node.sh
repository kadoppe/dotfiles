#!/usr/bin/env bash

nodebrew install-binary latest --skip-existing
nodebrew use latest

npm install -g hubot
npm install -g coffee-script
