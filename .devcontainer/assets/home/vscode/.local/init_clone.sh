#!/usr/bin/env bash
set -eu

if [ -z "$(ls -A /workspace)" ]; then
    git clone $GIT_REPOSITORY /workspace
fi

echo "Repository is ready"
