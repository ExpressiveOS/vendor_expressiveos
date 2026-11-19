#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#

# build-manifest.xml
BUILD_BROKEN_SRC_DIR_RW_ALLOWLIST := $(abspath .repo/manifests.git)

# Recovery
BOARD_USES_FULL_RECOVERY_IMAGE ?= true

-include vendor/expressiveos/config/BoardConfigReservedSize.mk
include vendor/expressiveos/sepolicy/SEPolicy.mk
