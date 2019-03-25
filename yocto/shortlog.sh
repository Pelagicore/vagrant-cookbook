#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2017 Pelagicore AB
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
# SOFTWARE.
#
# For further information see LICENSE
#
#
# Usage: shortlog.sh <manifest> <yocto_build_dir> <source_code_root> <old_manifest>|<git_hash>
#
# Source the environment and print git shortlog for each layer to stdout.
#

MANIFEST=$1
YOCTO_BUILD_DIR="$2"
SOURCE_CODE_ROOT="$3"

# A positive exit code from now on is fatal
set -ex

if [ "${4: -4}" == ".xml" ]; then
    OLD_MANIFEST="$4"
else
    BRANCH=${4:-origin/master}
    OLD_MANIFEST="$(mktemp old_manifest.XXXXXX)"
    git show $BRANCH:$MANIFEST > "${OLD_MANIFEST}"
    CLEANUP_MANIFEST="1"
fi

# Get git shortlog for each meta layer if there is any changes of the revision
get_changes() {
    path="$1"
    layer="$2"
    layer_dir="$3"
    cd $SOURCE_CODE_ROOT
    # Parse the manifest to get the hash of the layer for current commit and BRANCH
    hash_A=$(xmllint --xpath "string(/manifest/project[@path=\"$path\"]/@revision)" ${OLD_MANIFEST})
    hash_B=$(xmllint --xpath "string(/manifest/project[@path=\"$path\"]/@revision)" $MANIFEST)
    if [[ $hash_A != $hash_B ]]
    then
        cd $layer_dir
        # Get git shortlog as well as the layer name
        LOG="$(git shortlog $hash_A..$hash_B . || true)"
        if [ -n "$LOG" ]; then
            echo "Changes for layer $layer"
            echo
            echo "$LOG"
            echo -e '\n\n===============================================================\n\n'
        fi
    fi
}

cd $SOURCE_CODE_ROOT
# Get the diff between the current and the previous manifest
diff=$(diff -u ${OLD_MANIFEST} $MANIFEST || true)
if [[ ! -z "${diff// }" ]]
then
    cd "$YOCTO_BUILD_DIR"
    # Get the layers used in the build
    bitbake-layers show-layers | awk 'NR>2 {print $1 " " $2}' | while read layer_name layer_dir
    do
        [ -z "$layer_dir" ] && continue
        cd $layer_dir
        # Fetch the exact path name
        path=$(repo forall $layer_dir -c "echo \$REPO_PATH")
        get_changes $path $layer_name $layer_dir
    done
fi

if [ -n "$CLEANUP_MANIFEST" ]; then
    rm ${OLD_MANIFEST}
fi
