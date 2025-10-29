#!/bin/zsh

function tetas(){
    list=(
        tetitas tetazas tetorras tetotas tetarracas tetacas tetuzas teturras tetungas tetillas
        bufas bufarras bufarracas bufoncias mamelungas mamelones melones domingas bubalongas babongas
        pechugas peras peritas perolas mamellas tetolas gemelas maracas bazucas petacas
    )

	for item in "${list[@]}"; do
        echo "$item"
        sleep 0.3
    done
}

function jagger() {
    feh --bg-scale /home/swany/Pictures/Wallpapers/.jagermeister.jpg &>/dev/null
}

function rr() {
      curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash
}
