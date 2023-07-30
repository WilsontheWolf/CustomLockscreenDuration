TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomLockscreenDurationPrefs

CustomLockscreenDurationPrefs_FILES = CLSDPRootListController.m
CustomLockscreenDurationPrefs_FRAMEWORKS = UIKit
CustomLockscreenDurationPrefs_PRIVATE_FRAMEWORKS = Preferences
CustomLockscreenDurationPrefs_INSTALL_PATH = /Library/PreferenceBundles
CustomLockscreenDurationPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
