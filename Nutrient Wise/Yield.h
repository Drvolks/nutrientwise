//
//  Yield.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodName, YieldName;

@interface Yield : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSDecimalNumber * yieldAmount;
@property (nonatomic, retain) NSNumber * yieldNameId;
@property (nonatomic, retain) YieldName *yieldName;
@property (nonatomic, retain) FoodName *foodName;

@end
