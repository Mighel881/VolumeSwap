THEOS_DEVICE_IP=localhost
THEOS_DEVICE_KEY=alpine
THEOS_DEVICE_PORT=2222

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeSwap

VolumeSwap_FILES = Tweak.xm
VolumeSwap_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += volumeswapprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
