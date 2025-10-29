#!/usr/bin/zsh

man() {
  command man "$@" | col -bx | bat -l man -p
}
