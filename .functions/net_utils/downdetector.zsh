#!/usr/bin/zsh

downdetector() {
  if [[ -z $1 ]]; then
    _show_message "Usage: downdetector <service>" error
    return 1
  fi

  local service="$1"
  local urls=(
    "https://$service.com"
    "https://www.$service.com"
    "https://status.$service.com"
  )
  local result=""
  local reachable=false

  for url in "${urls[@]}"; do
    if curl -s --connect-timeout 5 "$url" >/dev/null; then
      reachable=true
    else
      result="Problems with $url"
    fi
  done

  if [[ $reachable == true ]]; then
    _show_message "$service status:" plus "All reachable"
  else
    if [[ -z $result ]]; then
      _show_message "$service status:" error "Service does not exist or is unreachable"
    else
      _show_message "$service status:" error "$result"
    fi
  fi
}
