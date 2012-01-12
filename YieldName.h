//
//  YieldName.h
//  Nutrient Wise
//
//  Created by drvolks on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YieldName : NSManagedObject

@property (nonatomic, retain) NSNumber * yieldNameId;
@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;

@end
