//
//  Refuse.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RefuseName;

@interface Refuse : NSManagedObject

@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSDecimalNumber * refuseAmount;
@property (nonatomic, retain) NSNumber * refuseNameId;
@property (nonatomic, retain) RefuseName *refuseName;

@end
