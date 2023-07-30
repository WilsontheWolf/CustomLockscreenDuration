TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard Prefrences


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomLockscreenDuration

CustomLockscreenDuration_FILES = Tweak.x
CustomLockscreenDuration_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += customlockscreendurationprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
