#!/bin/bash

set -euf -o pipefail

polipo proxyAddress=0.0.0.0 proxyPort=8123 socksParentProxy=localhost:11080 authCredentials=${PROXY_USERNAME}:${PROXY_PASSWORD} &