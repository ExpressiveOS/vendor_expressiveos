#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#
# ExpressiveOS OTA update package

EOS_TARGET_PACKAGE := $(PRODUCT_OUT)/$(EXPRESSIVE_BUILD_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

# ExpressiveOS keeps the target-files zip the package is made from: every incremental
# OTA from this build starts from it. Only the unpacked copy and its file list go.
# The zip is made before the package, because ota_from_target_files may rewrite
# META/dynamic_partitions_info.txt in the unpacked copy (disable_ublk) while it runs.
$(INTERNAL_OTA_PACKAGE_TARGET): | $(BUILT_TARGET_FILES_PACKAGE)
$(EOS_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET) $(BUILT_TARGET_FILES_PACKAGE)
	$(hide) mv -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EOS_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EOS_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(EOS_TARGET_PACKAGE).sha256sum
	$(hide) rm -rf $(patsubst %.zip,%,$(BUILT_TARGET_FILES_PACKAGE)) $(BUILT_TARGET_FILES_DIR)
	$(hide) ./vendor/expressiveos/build/tasks/ascii_output.sh
	@echo "Package Complete: $(EOS_TARGET_PACKAGE)" >&2

.PHONY: eos
eos: $(EOS_TARGET_PACKAGE) $(DEFAULT_GOAL)

# Transition alias
.PHONY: bacon
bacon: eos
