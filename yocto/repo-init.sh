#!/bin/bash
MANIFEST_REPO=$1
MENIFEST_REPO_BRANCH=$2
MANIFEST=$3
YOCTODIR="$4"

# Clone recipes
mkdir -p "$YOCTODIR"
cd "$YOCTODIR"
repo init -u "$MANIFEST_REPO" -m "$MANIFEST" -b dev
repo sync
