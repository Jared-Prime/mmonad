#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace
set -o pipefail

# README
# ------
# In downstream projects, copy your own docker-init.d directory into
# the container /root. The scripts there will be run on container startup
# and can provide optional extensions for your project's needs.

time bundle exec rake test

exec "$@"