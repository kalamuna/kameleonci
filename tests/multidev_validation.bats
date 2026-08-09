#!/usr/bin/env bats

setup() {
    # Get the directory of the current test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    source "$DIR/../.github/scripts/workflow_functions.sh"
}

@test "Accept a valid multidev branch name" {
    validate_pantheon_multidev_name "fix-123"
}

@test "Accept an 11 character branch name" {
    validate_pantheon_multidev_name "abcdefghijk"
}

@test "Reject a branch name longer than 11 characters" {
    run validate_pantheon_multidev_name "abcdefghijkl"
    [ "$status" -eq 1 ]
}

@test "Reject uppercase characters" {
    run validate_pantheon_multidev_name "Fix-123"
    [ "$status" -eq 1 ]
}

@test "Reject a leading hyphen" {
    run validate_pantheon_multidev_name "-fix"
    [ "$status" -eq 1 ]
}

@test "Reject underscores and slashes" {
    run validate_pantheon_multidev_name "fix_123"
    [ "$status" -eq 1 ]
    run validate_pantheon_multidev_name "fix/123"
    [ "$status" -eq 1 ]
}
