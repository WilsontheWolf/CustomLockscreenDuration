#import <Foundation/Foundation.h>
#import "CLSDPRootListController.h"

@implementation CLSDPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
