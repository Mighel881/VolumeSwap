INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeSwap

VolumeSwap_FILES = Tweak.x
VolumeSwap_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
