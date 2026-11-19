# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#
# ExpressiveOS build environment helpers (sourced by build/make/envsetup.sh).

function check_product()
{
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree. Try setting TOP." >&2
        return
    fi
    if (echo -n "$1" | grep -q -e "^eos_") ; then
        EOS_BUILD=$(echo -n "$1" | sed -e 's/^eos_//g')
    else
        EOS_BUILD=
    fi
    export EOS_BUILD

    TARGET_PRODUCT=$1 \
    TARGET_RELEASE=$2 \
    TARGET_BUILD_VARIANT= \
    TARGET_BUILD_TYPE= \
    TARGET_BUILD_APPS= \
    _get_build_var_cached TARGET_DEVICE > /dev/null
    # hide successful answers, but allow the errors to show
}

function mka()
{
    m "$@"
}

function cout()
{
    if [ "$OUT" ]; then
        cd "$OUT"
    else
        echo "Couldn't locate out directory. Try setting OUT."
    fi
}

function aospremote()
{
    if ! git rev-parse --git-dir &> /dev/null; then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm aosp 2> /dev/null
    local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##g; s#\/google##g")
    local PFX="platform/"
    if (echo "$PROJECT" | grep -qv "^device") && (echo "$PROJECT" | grep -qv "^kernel") && (echo "$PROJECT" | grep -qv "^toolchain"); then
        PFX="platform/"
    else
        PFX=""
    fi
    git remote add aosp "https://android.googlesource.com/$PFX$PROJECT"
    echo "Remote 'aosp' created"
}
