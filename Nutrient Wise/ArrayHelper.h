//
//  ArrayHelper.h
//  Nutrient Wise
//
//  Created by Genevieve Meloche on 12-01-28.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageHelper.h"

@interface ArrayHelper : NSObject

+ (id) sharedInstance;
-(NSArray *) sort:(NSArray *)array key:(NSString *)sortKey ascending:(BOOL)pAscending;
-(NSMutableArray *) sortMutableArray:(NSMutableArray *)array key:(NSString *)sortKey ascending:(BOOL)pAscending;

@end
