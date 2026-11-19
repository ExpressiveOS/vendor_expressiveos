#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#
# ExpressiveOS SELinux policy configuration (canonical layout, no common/dynamic/).

SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    vendor/expressiveos/sepolicy/public \
    vendor/expressiveos/sepolicy/mosey/system_ext/public

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    vendor/expressiveos/sepolicy/private \
    vendor/expressiveos/sepolicy/mosey/system_ext/private

# Guard vendor sepolicy so devices shipping a prebuilt stock vendor.img (Pixel 11s)
# do not pull source-built vendor rules into their build.
ifeq ($(BOARD_PREBUILT_VENDORIMAGE),)
BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/expressiveos/sepolicy/vendor
endif
