# LaTeX Compiler Docker Image
A Docker image with all the tools ready to compile a latex project with `pdflatex` and `bibtex`

## Build

To build the image, use the following command:

```shell
docker build . --tag latex-img:latest
```

## Usage

To use the image, use the following command:

```shell
docker run --rm -t latex-img:latest -help

LaTeXCompilerDockerImage
A Docker image with all the tools ready to compile a latex project with pdflatex and bibtex
Usage:
  docker run -t latex-img:latest -v <path_to_project_root>/:/data/ (-f | --file) <tex_file_name> [-o --skip-opt]
  docker run -t latex-img:latest (-h | --help)
  docker run -it latex-img:latest (-r | --run)
Options:
  -f --file       The main .tex file name without the suffix.
  -h --help       Show this screen. All other options are ignored.
  -o --skip-opt   Skip the optimization of the file.
  -r --run        Open a bash shell in the container.
```
