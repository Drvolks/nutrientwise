#import "ICloudSync.h"

static NSArray *_syncKeys;

@implementation ICloudSync

+(void) start {
    _syncKeys = @[@"language", @"profile", @"favorites", @"conversionFactors"];

    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    if (!store) {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFromiCloud:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateToiCloud:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];

    [store synchronize];
}

+(void) updateToiCloud:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

    for (NSString *key in _syncKeys) {
        id value = [defaults objectForKey:key];
        if (value) {
            [store setObject:value forKey:key];
        } else {
            [store removeObjectForKey:key];
        }
    }

    [store synchronize];
}

+(void) updateFromiCloud:(NSNotification *)notification {
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];

    for (NSString *key in _syncKeys) {
        id value = [store objectForKey:key];
        if (value) {
            [defaults setObject:value forKey:key];
        } else {
            [defaults removeObjectForKey:key];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateToiCloud:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}

@end
