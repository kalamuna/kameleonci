#!/bin/bash

detect_host() {
    if [[ "${DEPLOY_REPO}" == *"drush.in"* ]]; then
        echo "pantheon"
        return 0
    elif [[ "${DEPLOY_REPO}" == *"platform.sh"* ]]; then
        echo "platform"
        return 0
    elif [[ "${DEPLOY_REPO}" == *"acquia"* ]]; then
        echo "acquia"
        return 0
    else
        echo "Unknown host"
        return 1
    fi
}

validate_pantheon_multidev_name() {
    local branch_name="$1"
    if [[ ! "$branch_name" =~ ^[a-z0-9][a-z0-9-]{0,10}$ ]]; then
        return 1
    fi
    return 0
}

set_var() {
    local var="$1"
    local override_var="${var}_OVERRIDE"
    local override="${!override_var}"
    local envval="${!var}"
    if [ ! -z "$override" ]; then
        echo "$var=$override"
        return 0
    else
        echo "$var=$envval"
        return 0
    fi
}
