//
//  NutritiveSource.h
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NutritiveSource : NSManagedObject

@property (nonatomic, retain) NSNumber * nutritiveSourceId;
@property (nonatomic, retain) NSNumber * nutritiveSourceCode;
@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSString * frenchName;

@end
