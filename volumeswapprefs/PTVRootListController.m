#include "PTVRootListController.h"
#include <spawn.h>

@interface PSListController (iOS12Plus)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface PSSpecifier
-(id)propertyForKey:(NSString *)key;
@end

@interface NSUserDefaults (bonus)
- (id)objectForKey:(id)arg1 inDomain:(id)arg2;
@end

@implementation PTVRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
		NSArray *chosenIDs = @[@"isReversedOption"];
		self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
		for (PSSpecifier *specifier in _specifiers) {
		if ([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
		}
	}
return _specifiers;
}
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
   [super setPreferenceValue:value specifier:specifier];
   NSString *key = [specifier propertyForKey:@"key"];
     if([key isEqualToString:@"isEnabled"]) {
       if(![value boolValue]) {
         [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"isReversedOption"]] animated:YES];
       	} else if(![self containsSpecifier:self.savedSpecifiers[@"isReversedOption"]]) {
         [self insertContiguousSpecifiers:@[self.savedSpecifiers[@"isReversedOption"]] afterSpecifierID:@"isEnabledSwitch" animated:YES];
        }
    }
 }
-(void)viewDidLoad {
   [super viewDidLoad];
   NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/Library/PreferenceBundles/volumeswapprefs.bundle/root.plist"];
   if(![preferences[@"isEnabled"] boolValue]) {
	[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"isReversedOption"]] animated:YES];
    }
}
-(void)reloadSpecifiers {
   [super reloadSpecifiers];
   NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/Library/PreferenceBundles/volumeswapprefs.bundle/root.plist"];
   if(![preferences[@"isEnabled"] boolValue]) {
	[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"isReversedOption"]] animated:YES];
	}
}
@end
