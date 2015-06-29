//
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchController.h"
#import "Search.h"
#import "MKiCloudSync.h"
#import <HockeySDK/HockeySDK.h>

#define kDebug NO
#define kMainNib @"TabBarController"
#define kDatabase @"DATA_v1.5.sqlite"
#define kDatabaseFileName @"DATA_v1.5"
#define kDatabaseFileExt @"sqlite"
#define kModelFileName @"Model"
#define kModelFileExt @"mom"
#define kSearchTitle @"Search"
#define kFavoriteTitle @"Favorites"
#define kProfileTitle @"Profile"
#define kSettingsTitle @"Settings"
#define kSearchTab 0
#define kFavoriteTab 1
#define kProfileTab 2
#define kSettingsTab 3
#define kFirstViewTitle @"firstViewTitle"
#define kfirstViewText @"firstViewText"
#define kFirstViewButton @"firstViewButton"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootController;
@synthesize searchController;
@synthesize languageHelper;
@synthesize profileHelper;
@synthesize languageDelegates;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setup];
    
    [self setupTabBarController];
    [self pushManagedContextToViewControllers];
    
    [MKiCloudSync start];
    
    return YES;
} 

- (void) setupTabBarController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSBundle mainBundle] loadNibNamed:kMainNib owner:self options:nil];
    [self.window addSubview:rootController.view];
    [self.window setRootViewController:rootController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self setTabLabels];
}

- (void) setup {
    languageHelper = [LanguageHelper sharedInstance];
    profileHelper = [ProfileHelper sharedInstance];
    languageDelegates = [[NSMutableArray alloc] init];
    
    if([languageHelper language] == nil) {
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if(kDebug) {
            NSLog(@"Setting the default language to %@", language);
        }
        
        [languageHelper setLanguage:language];
    }
    
    BOOL firstView = NO;
    if([profileHelper selectedProfile] == nil) {
        NSString *profile = [[profileHelper supportedProfiles] objectAtIndex:0];
        if(kDebug) {
            NSLog(@"Setting the default profile to %@", profile);
        }
        
        firstView = YES;
        
        [profileHelper setSelectedProfile:profile];
    }
    
    //TODO faire fonctionner ceci
    if(firstView) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[languageHelper localizedString:kFirstViewTitle]
                                                                       message:[languageHelper localizedString:kfirstViewText]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:[languageHelper localizedString:kFirstViewButton]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void) pushManagedContextToViewControllers {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    
    NSArray *viewControllers = [rootController viewControllers];
    for (id viewController in viewControllers) {
        // Translate the tab labels
        if ([viewController respondsToSelector:@selector(setFinder:)]) {
            [viewController setFinder:[[Finder alloc] initWithContext:context]];
            
            if ([viewController respondsToSelector:@selector(setViewControllers:)]) {
                NSArray *viewControllers2 = [viewController viewControllers];
                for (id viewController2 in viewControllers2) {
                    [viewController2 setFinder:[[Finder alloc] initWithContext:context]];
                }
            }
        }
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kModelFileName withExtension:kModelFileExt];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    NSString *storePath = [documentDirectory stringByAppendingPathComponent: kDatabase];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:kDatabaseFileName ofType:kDatabaseFileExt];
        if (defaultStorePath) {
            NSLog(@"A new version of the database will be copied to the Documents directory. Old file(s) will be removed");
            
            NSError *error = nil;
            NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:documentDirectory error:&error];
            if (error == nil) {
                for (NSString *path in directoryContents) {
                    NSString *fullPath = [documentDirectory stringByAppendingPathComponent:path];
                    BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
                    if (!removeSuccess) {
                        NSLog(@"Error deleting %@", fullPath);
                    }
                }
            } else {
                NSLog(@"Error getting files in %@", documentDirectory);
            }
            
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void) fireLanguageChanged {
    for(id delegate in languageDelegates) {
        [delegate languageChanged];
    }
    
    [self setTabLabels];
}

- (void) setTabLabels {
    for(UITabBarItem *item in rootController.tabBar.items) {
        switch (item.tag) {
            case kSearchTab:
                item.title = [languageHelper localizedString:kSearchTitle];
                break;
            case kFavoriteTab:
                item.title = [languageHelper localizedString:kFavoriteTitle];
                break;
            case kProfileTab:
                item.title = [languageHelper localizedString:kProfileTitle];
                break;
            case kSettingsTab:
                item.title = [languageHelper localizedString:kSettingsTitle];
                break;
                
            default:
                break;
        }
    }
}

- (void) registerLanguageDelegate:(id)delegate {
    [languageDelegates addObject:delegate];
}

@end
