#!/usr/bin/env bats

setup() {
    # Get the directory of the current test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    source "$DIR/../.github/scripts/workflow_functions.sh"
    # set_var writes to the files GitHub Actions exposes as GITHUB_ENV/GITHUB_OUTPUT
    export GITHUB_ENV="$BATS_TEST_TMPDIR/github_env"
    export GITHUB_OUTPUT="$BATS_TEST_TMPDIR/github_output"
    touch "$GITHUB_ENV" "$GITHUB_OUTPUT"
}

@test "set_var uses the default value when no override is set" {
    export HOST="pantheon"
    unset HOST_OVERRIDE
    set_var HOST
    grep -q "^HOST=pantheon$" "$GITHUB_ENV"
    grep -q "^HOST=pantheon$" "$GITHUB_OUTPUT"
}

@test "set_var prefers the override when one is set" {
    export HOST="pantheon"
    export HOST_OVERRIDE="acquia"
    set_var HOST
    grep -q "^HOST=acquia$" "$GITHUB_ENV"
    grep -q "^HOST=acquia$" "$GITHUB_OUTPUT"
}

@test "set_var treats an empty override as unset" {
    export HOST="platform"
    export HOST_OVERRIDE=""
    set_var HOST
    grep -q "^HOST=platform$" "$GITHUB_ENV"
    grep -q "^HOST=platform$" "$GITHUB_OUTPUT"
}

@test "set_var writes an empty value when neither is set" {
    unset MULTIDEV MULTIDEV_OVERRIDE
    set_var MULTIDEV
    grep -q "^MULTIDEV=$" "$GITHUB_ENV"
    grep -q "^MULTIDEV=$" "$GITHUB_OUTPUT"
}
