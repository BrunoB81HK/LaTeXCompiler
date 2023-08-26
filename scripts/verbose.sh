_verbose() {
  local _color_num=${1:-1}
  local _main_msg=${2:-}
  local _supp_msg=${3:-}

  if [ -n "$_supp_msg" ]; then
    _supp_msg=" - $_supp_msg"
  fi

  echo -e "\n\e[1;3${_color_num}m[${_main_msg}]${_supp_msg}\e[0m"
}

_info() {
  local _main_msg=${1:-}
  local _supp_msg=${2:-}
  _verbose 4 "$_main_msg" "$_supp_msg"
}

_success() {
  local _main_msg=${1:-}
  local _supp_msg=${2:-}
  _verbose 2 "$_main_msg" "$_supp_msg"
}

_fail() {
  local _main_msg=${1:-}
  local _supp_msg=${2:-}
  _verbose 1 "$_main_msg" "$_supp_msg"
}
