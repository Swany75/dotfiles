#!/bin/zsh

function asciiart() {
    local file="$1"
    local width="${2:-80}"

    if [[ -z "$file" ]]; then
        _show_message "Usage: asciiart <image-file> [width]" "error"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        _show_message "File not found: $file" "error"
        return 1
    fi

    if command -v jp2a &>/dev/null; then
        jp2a --width="$width" --colors "$file"
        return $?
    fi

    _show_message "No ASCII image tool found. Install jp2a" "error"
    return 1
}

### PRINT ASCII ###########################################################

function ascii_demon() {
  echo -e "${colors[red]}
            .                                                      .
        .n                   .                 .                  n.
  .   .dP                  dP                   9b                 9b.    .
 4    qXb         .       dX                     Xb       .        dXp     t
dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb
9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
  9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
  \`9XXXXXXXXXXXXXXXXXXXXX'~   ~\`OOO8b   d8OOO'~   ~\`XXXXXXXXXXXXXXXXXXXXXP'
    \`9XXXXXXXXXXXP' \`9XX'          \`98v8P'          \`XXP' \`9XXXXXXXXXXXP'
        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                        )b.  .dbo.dP'\`v'\`9b.odb.  .dX(
                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                     dXXXXXXXXXXXP'   .   \`9XXXXXXXXXXXb
                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                    9XXb'   \`XXXXXb.dX|Xb.dXXXXX'   \`dXXP
                     \`'      9XXXXXX(   )XXXXXXP      \`'
                              XXXX X.\`v'.X XXXX
                              XP^X'\`b   d'\`X^XX
                              X. 9  \`   '  P )X
                              \`b  \`       '  d'
                               \`             '
 ${colors[reset]}"
}
