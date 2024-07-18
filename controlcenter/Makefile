include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ControlCenter
ControlCenter_FILES = ControlCenter.mm
ControlCenter_INSTALL_PATH = /Library/PreferenceBundles
ControlCenter_FRAMEWORKS = UIKit
ControlCenter_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ControlCenter.plist$(ECHO_END)
