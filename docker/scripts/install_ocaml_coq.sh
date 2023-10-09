#!/bin/bash

apt-get -y --no-install-recommends install \
    gcc \
    build-essential \
    curl \
    unzip \
    bubblewrap \
    git \
    libgmp-dev

install -m 755 ./$OPAM_BIN /usr/local/bin/opam

opam init --disable-sandboxing --dot-profile=~/.bashrc --shell-setup
opam switch create 4.14.0
opam install -y dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release menhir
opam pin add -y coq 8.17.1
opam install -y coq-lsp

