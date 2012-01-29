//
//  AllNutritiveValues.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllNutritiveValues.h"
#import "NutientValueCell.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"
#import "ArrayHelper.h"

#define kNutritiveValuesAttribute @"nutritiveValues"
#define kRowIdentifier @"rowIdentifier"
#define kUnitColumn @"unit"
#define kConversionFactorColumn @"conversionFactor"
#define kNutritiveValueColumn @"nutritiveValue"
#define kNutritiveNameColumn @"nutritiveName"

@implementation AllNutritiveValues

@synthesize foodName;
@synthesize nutritiveValues;
@synthesize selectedConversionFactor;
@synthesize languageHelper;
@synthesize arrayHelper;
@synthesize cellNibLoaded;
@synthesize cellHelper;

- (id) initWithFoodName:(FoodName *)food:(ConversionFactor *) conversionFactor {
    foodName = food;
    selectedConversionFactor = conversionFactor;
    NSSet *nutritiveValueEntities = [foodName valueForKey:kNutritiveValuesAttribute];    
    nutritiveValues = [nutritiveValueEntities allObjects];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    languageHelper = [[LanguageHelper alloc] init];
    arrayHelper = [[ArrayHelper alloc] init];

    cellHelper = [[CellHelper alloc] init];
    
    cellNibLoaded = NO;
    
    //Sort Data
    NSString *pkey = [@"nutritiveName." stringByAppendingString:[languageHelper nameColumn]];
    nutritiveValues = [arrayHelper sort:nutritiveValues key:pkey ascending:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    foodName = nil;
    nutritiveValues = nil;
    selectedConversionFactor = nil;
    languageHelper = nil;
    arrayHelper = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [nutritiveValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
    if(!cellNibLoaded) {
        UINib *nib = [UINib nibWithNibName:@"NutientValueCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kRowIdentifier];
        cellNibLoaded = YES;
    }
    
    return [cellHelper makeNutientValueCell:tableView :kRowIdentifier :nutritiveValues :indexPath :selectedConversionFactor];
}

@end
