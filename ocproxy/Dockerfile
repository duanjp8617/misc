FROM ubuntu:18.04
# Original maintainer:
# MAINTAINER "Joshua C. Randall" <jcrandall@alum.mit.edu>
# modified by djp

# Update packages
RUN apt-get update && \

# Install packages
RUN apt-get -y install \
      openconnect \
      ocproxy \
      polipo

# Setup polipo proxy entrypoint
ADD polipo-proxy.sh /docker/polipo-proxy.sh
ADD openconnect.sh /docker/openconnect.sh

# Expose port 8123 for the polipo authenticating http proxy 
EXPOSE 8123