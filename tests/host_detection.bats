#!/usr/bin/env bats

setup() {
    # Get the directory of the current test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    source "$DIR/../.github/scripts/workflow_functions.sh"
}

@test "Detect Pantheon host" {
    export DEPLOY_REPO="ssh://codeserver.dev.site@codeserver.dev.site.drush.in:2222/~/repository.git"
    result=$(detect_host)
    [ "$result" = "pantheon" ]
}

@test "Detect Platform.sh host" {
    export DEPLOY_REPO="project@git.region.platform.sh:project.git"
    result=$(detect_host)
    [ "$result" = "platform" ]
}

@test "Detect Acquia host" {
    export DEPLOY_REPO="project@git.acquia.com:project.git"
    result=$(detect_host)
    [ "$result" = "acquia" ]
}

@test "Invalid host should fail" {
    export DEPLOY_REPO="git@github.com:org/repo.git"
    run detect_host
    [ "$status" -eq 1 ]
    [ "$output" = "Unknown host" ]
}
