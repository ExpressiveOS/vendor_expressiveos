#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_VERSION_MAJOR = 17
PRODUCT_VERSION_MINOR = 0

EXPRESSIVE_BUILD_TYPE ?= Unofficial

ifeq ($(EXPRESSIVE_BUILD_TYPE),Official)
else ifeq ($(EXPRESSIVE_BUILD_TYPE),Unofficial)
else
$(error EXPRESSIVE_BUILD_TYPE must be Official or Unofficial. Current value: $(EXPRESSIVE_BUILD_TYPE))
endif

# ExpressiveOS's own version, shown in the zip name, Settings, and Updater.
EXPRESSIVE_VERSION := 2.0

ifeq ($(WITH_GMS),true)
EXPRESSIVE_MODVERSION := $(EXPRESSIVE_VERSION)
else
EXPRESSIVE_MODVERSION := $(EXPRESSIVE_VERSION)-Vanilla
endif

# The build's own date, matching build.prop across make passes even across midnight.
EXPRESSIVE_DATE := $(shell f=$(BUILD_DATETIME_FILE); if [ -s "$$f" ]; then date -ud @$$(cat "$$f") +%Y%m%d; else date -u +%Y%m%d; fi)

# Internal & display version
EXPRESSIVE_BUILD_VERSION := ExpressiveOS-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(EXPRESSIVE_DATE)-$(EOS_BUILD)-$(EXPRESSIVE_MODVERSION)-$(EXPRESSIVE_BUILD_TYPE)
EXPRESSIVE_DISPLAY_VERSION := v$(EXPRESSIVE_MODVERSION)-$(EXPRESSIVE_DATE)

# Version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.expressiveos.build.type=$(EXPRESSIVE_BUILD_TYPE) \
    ro.expressiveos.build.version=$(EXPRESSIVE_BUILD_VERSION) \
    ro.expressiveos.display.version=$(EXPRESSIVE_DISPLAY_VERSION) \
    ro.expressiveos.version=$(EXPRESSIVE_MODVERSION) \
    ro.expressiveos.device=$(EOS_BUILD) \
    ro.modversion=$(EXPRESSIVE_MODVERSION)
