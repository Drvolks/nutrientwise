//
//  NutritiveValue.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName;

@interface NutritiveValue : NSManagedObject

@property (nonatomic, retain) NSNumber * nutritiveId;
@property (nonatomic, retain) NSNumber * nutritiveValue;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) FoodName *foodName;

@end
