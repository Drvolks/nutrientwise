//
//  ArrayHelper.m
//  Nutrient Wise
//
//  Created by Genevieve Meloche on 12-01-28.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "ArrayHelper.h"

@implementation ArrayHelper


-(NSArray *) sort:(NSArray *)array key:(NSString *)sortKey ascending:(BOOL)pAscending {
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey 
                                                                 ascending:pAscending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    return [array sortedArrayUsingDescriptors:sortDescriptors];
}

@end
