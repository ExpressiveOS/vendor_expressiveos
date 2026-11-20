#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifneq ($(TARGET_BOOTANIMATION),)
include $(CLEAR_VARS)
LOCAL_MODULE := bootanimation.zip
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/media

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(TARGET_BOOTANIMATION)
	@mkdir -p $(dir $@)
	@cp $(TARGET_BOOTANIMATION) $@

BOOTANIMATION_SYMLINK := $(TARGET_OUT_PRODUCT)/media/bootanimation-dark.zip
$(BOOTANIMATION_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	$(hide) ln -sf bootanimation.zip $@

ALL_DEFAULT_INSTALLED_MODULES += $(BOOTANIMATION_SYMLINK)
endif
