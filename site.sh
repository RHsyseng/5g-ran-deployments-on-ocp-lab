#!/bin/bash

_CURR_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
rm -rf $_CURR_DIR/gh-pages $_CURR_DIR/.cache

podman run --rm -ti -v $_CURR_DIR:/antora:z --entrypoint antora docker.io/antora/antora:3.0.0 site.yml