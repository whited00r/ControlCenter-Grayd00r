#import <Preferences/Preferences.h>

@interface ControlCenterListController: PSListController {
}
@end

@implementation ControlCenterListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ControlCenter" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
