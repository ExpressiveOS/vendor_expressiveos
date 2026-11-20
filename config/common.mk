#
# Copyright (C) 2026 ExpressiveOS
# SPDX-License-Identifier: Apache-2.0
#
# Single lean ExpressiveOS 2.0 product makefile (pure AOSP base).

# 1. Kit staging hook (bootanimation, wallpapers, Expressive Launcher, ViPER4Android)
$(call inherit-product-if-exists, vendor/extra/product.mk)
PRODUCT_PACKAGES += bootanimation.zip

# 2. ExpressiveOS extras & Basic Call Recorder
$(call inherit-product, vendor/extras/expressiveos.mk)
TARGET_INCLUDE_BCR ?= true
ifeq ($(TARGET_INCLUDE_BCR),true)
$(call inherit-product, vendor/extras/bcr/bcr.mk)
endif

# Exclude kernel/compat repos from bp scanning
PRODUCT_SOURCE_ROOT_DIRS += -kernel/platform
PRODUCT_SOURCE_ROOT_DIRS += -prebuilts/misc/protobuf_vendorcompat
-include $(sort $(wildcard vendor/*/*/exclude-bp.mk))

# 3. GMS & Pixel experience (always shipped on ExpressiveOS)
WITH_GMS ?= true
ifeq ($(WITH_GMS),true)
WITH_GMS_COMMS_SUITE := true

ifeq ($(TARGET_USES_MINI_GAPPS),true)
$(call inherit-product, vendor/gms/gms_mini.mk)
else ifeq ($(TARGET_USES_PICO_GAPPS),true)
$(call inherit-product, vendor/gms/gms_pico.mk)
else
$(call inherit-product, vendor/gms/gms_full.mk)
endif

PRODUCT_PACKAGES += \
    SettingsGoogle \
    SystemUIGoogle

$(call inherit-product, vendor/pixel-style/config/common.mk)

TARGET_INCLUDE_MOSEY ?= false
TARGET_USES_MOSEY_NOPAUTH ?= false
ifeq ($(TARGET_INCLUDE_MOSEY),true)
ifeq ($(TARGET_USES_MOSEY_NOPAUTH),true)
$(call inherit-product, vendor/gms-mosey/mosey_nopauth/mosey-vendor.mk)
else
$(call inherit-product, vendor/gms-mosey/mosey/mosey-vendor.mk)
endif
endif

# Don't dexpreopt prebuilts (for GMS)
DONT_DEXPREOPT_PREBUILTS := true
RELAX_USES_LIBRARY_CHECK := true
endif

# 4. ExpressiveOS packages
PRODUCT_PACKAGES += \
    AxSandbox \
    AxThemeStore \
    BatteryStatsViewer \
    BtHelper \
    Changelog.txt \
    ExpressiveEgg \
    GameSpace \
    LMOFreeform \
    LMOFreeformSidebar \
    OmniJaws \
    OmniStyle \
    Stk \
    Updater

ifneq ($(TARGET_SUPPORTS_QUICK_TAP),false)
PRODUCT_PACKAGES += \
    ColumbusService
endif

# Pixel lockscreen clock-face plugins (SystemUIClocks-*)
$(call inherit-product-if-exists, packages/apps/SystemUIClocks/clocks.mk)

# Component overrides & sensitive phone numbers
PRODUCT_PACKAGES += \
    eos-component-overrides.xml \
    sensitive_pn.xml

# Updater OTA directory init script
PRODUCT_COPY_FILES += \
    vendor/expressiveos/prebuilt/common/etc/init/init.expressiveos-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.expressiveos-updater.rc

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/expressiveos/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-expressiveos-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-expressiveos-product.xml

# 5. Core system/product properties
PRODUCT_BRAND ?= ExpressiveOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0
PRODUCT_PRODUCT_PROPERTIES += persist.sys.expressiveos.debug_enabled=1
else
ifdef WITH_ADB_INSECURE
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0
PRODUCT_PRODUCT_PROPERTIES += persist.sys.expressiveos.debug_enabled=1
else
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=1
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := true
endif
PRODUCT_PRODUCT_PROPERTIES += persist.sys.strictmode.disable=true
endif

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.launcher.depth.widget=true

PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true \
    persist.sys.disable_rescue=true \
    ro.control_privapp_permissions=log \
    net.tethering.noprovisioning=true \
    ro.support_one_handed_mode?=true \
    ro.boot.wificountrycode?=00 \
    dalvik.vm.systemuicompilerfilter=speed \
    media.recorder.show_manufacturer_and_model=true

TARGET_ENABLE_BLUR ?= true
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.supports_background_blur=1
endif

PERF_ANIM_OVERRIDE ?= false
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.activity_anim_perf_override=$(PERF_ANIM_OVERRIDE)
ifeq ($(PERF_ANIM_OVERRIDE),true)
PRODUCT_PRODUCT_PROPERTIES += \
    debug.sf.predict_hwc_composition_strategy=0
endif

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_PRODUCT_PROPERTIES += \
    debug.sf.enable_transaction_tracing=false
endif

# 6. Boot image profile, ART flags, platform packages, fastbootd
ART_BUILD_TARGET_NDEBUG := false
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := false
ART_BUILD_HOST_DEBUG := false

ifeq ($(TARGET_BUILD_VARIANT),user)
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_SYMBOLS := false
endif

PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_COPY_FILES += \
    art/build/boot/preloaded-classes:$(TARGET_COPY_OUT_SYSTEM)/etc/preloaded-classes
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := \
    art/build/boot/boot-image-profile.txt
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/preloaded-classes

PRODUCT_DEXPREOPT_SPEED_APPS += \
    AppLocker \
    GameSpace \
    Launcher3QuickStep \
    NexusLauncherRelease \
    Settings \
    SettingsGoogle \
    SystemUI \
    SystemUIGoogle

PRODUCT_PACKAGES += \
    AvatarPicker \
    QuickAccessWallet \
    ThemePicker \
    ThemesStub \
    android.software.credentials.prebuilt.xml \
    libtensorflowlite_jni \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_lang_id_model \
    product_charger_res_images \
    product_charger_res_images_vendor

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/textclassifier/actions_suggestions.universal.model \
    system/etc/textclassifier/lang_id.model \
    system/etc/textclassifier/textclassifier.en.model \
    system/etc/textclassifier/textclassifier.universal.model \
    system/lib/libtensorflowlite_jni.so \
    system/lib64/libtensorflowlite_jni.so

PRODUCT_COPY_FILES += \
    device/sample/etc/apns-full-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.freeform_window_management.xml

ifneq ($(TARGET_DISABLE_FASTBOOTD),true)
PRODUCT_PACKAGES += \
    fastbootd
endif

# 7. Private signing keys (hard include for Official builds)
ifeq ($(EXPRESSIVE_BUILD_TYPE),Official)
include vendor/expressiveos-priv/keys/keys.mk
else
-include vendor/expressiveos-priv/keys/keys.mk
endif

# 8. Audio (AOSP + Pixel defaults)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage14.mk)
include vendor/expressiveos/config/aosp_audio.mk

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.notification_sound=Kernel.ogg \
    ro.config.alarm_alert=Fresh_morning.ogg \
    ro.config.ringtone=The_next_adventure.ogg

# 9. Overlays, VINTF compatibility matrix, version
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/expressiveos/overlay/common/external/setupdesign/main \
    vendor/expressiveos/overlay/common/frameworks/base/packages/SettingsLib \
    vendor/expressiveos/overlay/no-rro

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/expressiveos/overlay/common \
    vendor/expressiveos/overlay/no-rro

PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    ExpressiveOSNfcOverlay \
    NcmTetheringOverlay \
    NetworkStackOverlay \
    PermissionControllerOverlay \
    SettingsExpressiveOS \
    framework_compatibility_matrix.eos.xml

include vendor/expressiveos/config/version.mk
