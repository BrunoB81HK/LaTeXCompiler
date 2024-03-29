FROM ubuntu:20.04

LABEL org.opencontainers.image.description="A Docker image with all the tools ready to compile a latex project with `pdflatex` and `bibtex`"
LABEL org.opencontainers.image.source=https://github.com/BrunoB81HK/LaTeXCompiler
LABEL org.opencontainers.image.version=0.4

# Update Ubuntu Software repository
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -q && \
    apt install -qy \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-bibtex-extra \
    texlive-science \
    ghostscript \
    inkscape

# Clean apt
RUN apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy scripts and set entrypoint
COPY ./scripts/* /
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
