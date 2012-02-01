//
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchController.h"
#import "LanguageHelper.h"
#import "ProfileHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (strong, nonatomic) IBOutlet SearchController *searchController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) LanguageHelper *languageHelper;
@property (strong, nonatomic) ProfileHelper *profileHelper;
@property (strong, nonatomic) NSMutableArray *languageDelegates;

- (NSString *)applicationDocumentsDirectory;
- (void) pushManagedContextToViewControllers;
- (void) setupTabBarController;
- (void) setup;
- (void) fireLanguageChanged;
- (void) registerLanguageDelegate:(id)delegate;
- (void) setTabLabels;

@end
