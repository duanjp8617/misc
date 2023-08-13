FROM ubuntu:22.04

COPY scripts/update_apt_source.sh /scripts/update_apt_source.sh
RUN /scripts/update_apt_source.sh

COPY scripts/install_emacs.sh /scripts/install_emacs.sh
RUN /scripts/install_emacs.sh