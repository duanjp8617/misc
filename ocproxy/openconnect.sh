#!/bin/bash

set -euf -o pipefail

openconnect --script-tun --script "ocproxy -D 11080" -b ${OC_HOST}