FROM ubuntu:20.04

LABEL maintainer="bp.busque@outlook.com"
LABEL version="0.1"
LABEL description="A Docker image with all the tools ready to compile a latex project with `pdflatex` and `bibtex`"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
RUN apt upgrade -y

# Install desired packages
RUN apt install -y texlive-latex-extra texlive-fonts-extra texlive-bibtex-extra
RUN apt install -y ghostscript
RUN apt install -y texlive-science
RUN apt install -y inkscape
RUN apt install -y tree

# Clean apt
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

# Set the working directory
# WORKDIR /data

# Copy scripts and set entrypoint to image
COPY ./scripts/* /
ENTRYPOINT ["/entrypoint.sh"]
