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

#define kDebug YES
#define kNutritiveNameColumn @"nutritiveName"
#define kNutritiveValueColumn @"nutritiveValue"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"

@implementation CellHelper

@synthesize languageHelper;

- (id) init {
    languageHelper = [[LanguageHelper alloc] init];
    
    return self;
}

- (NutientValueCell *) makeNutientValueCell:(UITableView *) table:(NSString *) rowIdentifier:(NSArray *) nutritiveValues:(NSIndexPath *) indexPath:(ConversionFactor *) conversionFactor {
    NSUInteger row = [indexPath row];
    
    NutientValueCell *cell = [table dequeueReusableCellWithIdentifier:rowIdentifier];
    
    NutritiveValue *nutritiveValue = [nutritiveValues objectAtIndex:row];
    NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
    
    cell.nutient.text = [nutritiveName valueForKey:[languageHelper nameColumn]];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
    
    NSDecimalNumber *value = [nutritiveValue valueForKey:kNutritiveValueColumn];
    NSDecimalNumber *conversion = [conversionFactor valueForKey:kConversionFactorColumn];
    if(kDebug) {
        NSLog(@"Nutritive value is %@", value);
        NSLog(@"Conversion factor is %@", conversion);
    }
    if(conversion != nil) {
        value = [value decimalNumberByMultiplyingBy:conversion];
    }
    cell.value.text = [[value decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
    cell.measure.text = [nutritiveName valueForKey:kUnitColumn];
    
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
