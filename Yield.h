//
//  Yield.h
//  Nutrient Wise
//
//  Created by drvolks on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YieldName;

@interface Yield : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSNumber * yieldNameId;
@property (nonatomic, retain) NSDecimalNumber * yieldAmount;
@property (nonatomic, retain) YieldName *yieldName;

@end
