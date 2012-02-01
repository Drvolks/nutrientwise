//
//  NutientValueCellHelper.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellHelper.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"

#define kDebug NO
#define kNutritiveNameColumn @"nutritiveName"
#define kNutritiveValueColumn @"nutritiveValue"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"

@implementation CellHelper

@synthesize languageHelper;

static CellHelper *instance = nil;

+ (id) sharedInstance {
    if(instance == nil) {
        instance = [[self allocWithZone:NULL] init];
    }
    
    return instance;
}

- (id) init {
    languageHelper = [LanguageHelper sharedInstance];
    
    return self;
}

- (UITableViewCell *) makeNutientValueCell:(UITableView *) table:(NSString *) rowIdentifier:(NSArray *) nutritiveValues:(NSIndexPath *) indexPath:(ConversionFactor *) conversionFactor {
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rowIdentifier];
    
    NutritiveValue *nutritiveValue = [nutritiveValues objectAtIndex:row];
    NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    //cell.textLabel.numberOfLines = 2;
    //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = [nutritiveName valueForKey:[languageHelper nameColumn]];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
    
    NSDecimalNumber *value = [nutritiveValue valueForKey:kNutritiveValueColumn];
    if(conversionFactor != nil) {
        NSDecimalNumber *conversion = [conversionFactor valueForKey:kConversionFactorColumn];
        if(kDebug) {
            NSLog(@"Nutritive value is %@", value);
            NSLog(@"Conversion factor is %@", conversion);
        }
        if(conversion != nil && [conversion doubleValue] > 0) {
            value = [value decimalNumberByMultiplyingBy:conversion];
        }
    }
    
    cell.detailTextLabel.text = [[[value decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue] stringByAppendingString:[nutritiveName valueForKey:kUnitColumn]];
    
    return cell;
}

- (UITableViewCell *) makeFoodNameCell:(UITableView *) table:(NSString *)rowIdentifier:(NSIndexPath *)indexPath:(NSArray *) searchResults {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:rowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSUInteger row = [indexPath row];
    FoodName *foodName = [searchResults objectAtIndex:row];
    
    cell.textLabel.text = [foodName valueForKey:[languageHelper nameColumn]];
    
    return cell; 
}

@end
