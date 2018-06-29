#!/bin/bash
set -ex


#############
# VARIABLES #
#############
TAGGED_HEAD=False
GITHUB_TOKEN=XXXXX


#############
# FUNCTIONS #
#############
function check_if_head_tag {
    set +e
    LATEST_TAG=$(git describe --exact-match HEAD --tags 2>/dev/null)
    # shellcheck disable=SC2181
    if [ "$?" -eq 0 ]; then
        TAGGED_HEAD=true # Let's remember we run on a tagged head for a later use
    fi
}

function change_readme_release {
    sed
    # who is the author of this commit?
    git add README.md
    git commit -s -m "Bump README with the new release tag."
}


########
# MAIN #
########
make prepare
mv "$GOPATH"/src/github.com/docker/docker/vendor/github.com/docker/go-connections/nat "$GOPATH"/src/github.com/docker/docker/vendor/github.com/docker/go-connections/nonat
make
sudo ./cn version
sudo make tests

# we know check if HEAD is a tagged commit
# if so, we build a PR
check_if_head_tag
if $TAGGED_HEAD; then
    ./release.sh -g "$GITHUB_TOKEN" -t "$LATEST_TAG"
    change_readme_release
fi