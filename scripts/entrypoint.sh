#!/bin/bash

VALID_ARGS=$(getopt -o f:hor --long file:,help,skip-opt,run -- "$@")

if [[ $? -ne 0 ]]; then
    exit 1;
fi

_help () {
  echo 'LaTeXCompilerDockerImage'
  echo 'A Docker image with all the tools ready to compile a latex project with pdflatex and bibtex.'
  echo
  echo 'Usage:'
  echo '  docker run -t latex-img:latest -v <project_root>/:/data/ (-f | --file) <tex_file_name> [-o --skip-opt]'
  echo '  docker run -t latex-img:latest (-h | --help)'
  echo '  docker run -t latex-img:latest (-r | --run)'
  echo
  echo 'Options:'
  echo '  -f --file       The main .tex file name without the suffix.'
  echo '  -h --help       Show this screen. All other options are ignored.'
  echo '  -o --skip-opt   Skip the optimization of the file.'
  echo '  -r --run        Open a bash shell in the container.'
}

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -f | --file)
        _filename="$2"
        shift 2
        ;;
    -h | --help)
        _help
        exit 0
        ;;
    -o | --skip-opt)
        _skip_opt=true
        shift
        ;;
    -r | --run)
        bash
        exit 0
        ;;
    --) shift;
        break
        ;;
  esac
done

# Call the /compile.sh script
if [ -z "$_filename" ]; then
  @echo "\e[1;31m[The --file argument must be set. Aborting...]\e[0m"
  exit 1
fi

/compile.sh "$_filename" "$_skip_opt" || exit "$?"
