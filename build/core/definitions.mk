#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#

define uniq
$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
endef

include vendor/expressiveos/build/core/utils.mk
include vendor/expressiveos/build/core/default_installed_modules.mk
