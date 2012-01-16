//
//  REDACTED_nutrientwiseAppDelegate.h
//  Nutrient Wise
//
//  Created by drvolks on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface REDACTED_nutrientwiseAppDelegate : UIResponder <UIApplicationDelegate>

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
