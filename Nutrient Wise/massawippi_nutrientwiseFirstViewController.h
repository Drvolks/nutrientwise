//
//  massawippi_nutrientwiseFirstViewController.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface massawippi_nutrientwiseFirstViewController : UIViewController {
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
