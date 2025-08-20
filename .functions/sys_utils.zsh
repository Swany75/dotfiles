#!/bin/zsh

TRASH_DIR="${HOME}/.trash"

man() {
  command man "$@" | col -bx | bat -l man -p
}

rm() {
  local OPTIND opt
  local files=()

  # Ensure trash directory exists
  if [[ ! -d "$TRASH_DIR" ]]; then
    mkdir -p "$TRASH_DIR"
  fi

  # Parse options but silently ignore -r and -f
  while getopts ":rf" opt; do
    case $opt in
      r|f)
        # Ignore -r and -f options silently
        ;;
      \?)
        echo "rm: invalid option -- $OPTARG"
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  files=("$@")

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "rm: missing operand"
    return 1
  fi

  for f in "${files[@]}"; do
    if [[ -e "$f" ]]; then
      local base=$(basename -- "$f")
      local target="$TRASH_DIR/$base"
      # If target exists, add timestamp prefix
      if [[ -e "$target" ]]; then
        target="$TRASH_DIR/$(date +%s)_$base"
      fi
      mv -- "$f" "$target"
      if [[ $? -ne 0 ]]; then
        echo "rm: failed to move '$f' to trash"
      fi
    else
      echo "rm: cannot remove '$f': No such file or directory"
    fi
  done
}

