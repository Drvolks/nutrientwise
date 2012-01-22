//
//  massawippi_nutrientwiseAppDelegate.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (strong, nonatomic) IBOutlet SearchController *searchController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
