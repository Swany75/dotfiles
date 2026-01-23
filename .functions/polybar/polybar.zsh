function settarget() {
    ip_address=$1
    machine_name=$2

    # Si no s'especifica nom, s'usa "unknown"
    if [ -z "$machine_name" ]; then
        machine_name="unknown"
    fi

	echo "$ip_address $machine_name" > ~/.config/polybar/bin/target

    export TARGET="$ip_address"
    export TARGET_NAME="$machine_name"
    export T="$ip_address"
    export t="$ip_address"
}

# Neteja el target
function cleartarget() {
    > ~/.config/polybar/bin/target
    unset TARGET TARGET_NAME T t
}
