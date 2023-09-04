#!/bin/bash

# Parse arguments
_filename="$1"
_skip_opt="$2"

_filename_tex="$_filename".tex
_filename_pdf="$_filename".pdf
_filename_opt_pdf="$_filename"_opt.pdf

. /verbose.sh

_pdflatex_command() {
  pdflatex -shell-escape -interaction=nonstopmode -output-directory . "$_filename"
}

_bibtex_command() {
  bibtex "$_filename"
}

# Script start
if [ -f /data/"$_filename_tex" ]; then

  # Copy latex to temp folder and move there
  cp -r /data /data_tmp
  cd /data_tmp || exit

  _info "Compiling $_filename_tex to $_filename_pdf..."

  # Start of the compilation
  _build_commands_sequence=( _pdflatex_command _bibtex_command _pdflatex_command _pdflatex_command )

  for _command_index in "${!_build_commands_sequence[@]}" ; do
    _command="${_build_commands_sequence[$_command_index]}"

    _info "$(( _command_index + 1 ))/${#_build_commands_sequence[@]}" "$(declare -f "$_command" | sed -e '1d' -e '2d' -e '$d' -e '3s/^[[:space:]]*//')"

    $_command
    _status_code="$?"

    if [ "$_status_code" -gt 1  ]; then
      _fail "Compilation failed with code $_status_code!" 'Aborting...'
      exit "$_status_code"
    fi
  done

  # Copy compiled pdf back in shared volume
  cp /data_tmp/"$_filename_pdf" /data/"$_filename_pdf"

  _success 'Document compiled!'

  # Optimization
  if [ "$_skip_opt" = true ]; then
    # Skipping optimization
    _info 'Skipping optimization.'
    exit 0
  fi

  _info "Optimizing $_filename_pdf to $_filename_opt_pdf..."

  if ! _status_code=$(ps2pdf "$_filename_pdf" "$_filename_opt_pdf"); then
    _fail "Optimization failed with code $_status_code!" 'Aborting...'
    exit "$_status_code"
  fi

  _size_unit=kB
  (( _org_size = $(wc -c "$_filename_pdf" | cut -d' ' -f1)/1000 ))
  (( _opt_size = $(wc -c "$_filename_opt_pdf" | cut -d' ' -f1)/1000 ))
  (( _opt_gain = 100*(_org_size - _opt_size)/_org_size )) || true

  if [ "$_org_size" -gt 1000 ]; then
    _size_unit=MB
    (( _org_size = _org_size/1000 ))
    (( _opt_size = _opt_size/1000 ))
  fi

  # Copy optimized pdf back in shared volume
  cp /data_tmp/"$_filename_opt_pdf" /data/"$_filename_opt_pdf"

  _success 'Optimization successful!' "From ${_org_size} ${_size_unit} to ${_opt_size} ${_size_unit} (-$_opt_gain%)"

  exit 0

else
  _fail "File $_filename_tex not found" 'Aborting...'
  exit 1
fi