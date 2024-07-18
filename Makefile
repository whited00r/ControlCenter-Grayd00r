THEOS_DEVICE_IP = 192.168.1.19
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk
ARCHS = armv7

BUNDLE_NAME = ControlCenter
ControlCenter_FILES = ControlCenterPanel.mm ControlCenterView.m NSData+Base64.m
ControlCenter_INSTALL_PATH = /Library/Panel/Panels
ControlCenter_FRAMEWORKS = Foundation UIKit Security
ControlCenter_LIBRARIES = flipswitch
ControlCenter_PRIVATE_FRAMEWORKS = GraphicsServices

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += controlcenter
include $(THEOS_MAKE_PATH)/aggregate.mk
