//
//  GroupName.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName;

@interface GroupName : NSManagedObject

@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;
@property (nonatomic, retain) NSNumber * groupNameCode;
@property (nonatomic, retain) NSNumber * groupNameId;
@property (nonatomic, retain) FoodName *foodNames;

@end
