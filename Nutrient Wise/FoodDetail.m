//
//  FoodDetail.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodDetail.h"
#import "NutritiveValue.h"
#import "NutritiveName.h"
#import "Measure.h"
#import "NutientValueCell.h"
#import "MeasureSelection.h"
#import "AllNutritiveValues.h"
#import "ArrayHelper.h"

#define kDebug YES
#define kTitle @"NutritiveValues"
#define kNutritiveSymbolColumn @"nutritiveSymbol"
#define kNutritiveValuesAttribute @"nutritiveValues"
#define kRowIdentifierMeasure @"rowIdentifierMeasure"
#define kRowIdentifierNutient @"rowIdentifierNutient"
#define kRowIdentifierAll @"rowIdentifierAll"
#define kFoodIdColumn @"foodId"
#define kConversionFactorsAttribute @"conversionFactors"
#define kMeasureColumn @"maesure"
#define kMeasureIdColumn @"measureId"
#define kNutritiveNameColumn @"nutritiveName"
#define kImageNotFavorite @"29-heart.png"
#define kImageFavorite @"29-heart-red.png"

@implementation FoodDetail

@synthesize foodName;
@synthesize nutritiveValues;
@synthesize table;
@synthesize languageHelper;
@synthesize arrayHelper;
@synthesize profileHelper;
@synthesize favoriteHelper;
@synthesize selectedConversionFactor;
@synthesize cellNibLoaded;
@synthesize cellHelper;

- (id)initWithFood:(FoodName *)foodEntity {
    foodName = foodEntity;
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
    profileHelper = [[ProfileHelper alloc] init];
    favoriteHelper = [[FavoriteHelper alloc] init];
    cellHelper = [[CellHelper alloc] init];
    arrayHelper = [[ArrayHelper alloc] init];
    
    self.title = [languageHelper localizedString:kTitle];
    
    NSArray *keys = [self nutritiveValueKeys];
    nutritiveValues = [self nutritiveValues:keys];
    
    //Sort Data
    NSString *pkey = [@"nutritiveName." stringByAppendingString:[languageHelper nameColumn]];
    nutritiveValues = [arrayHelper sort:nutritiveValues key:pkey ascending:YES];
    
    cellNibLoaded = NO;
    
    [self prepareDisplay];
}

- (void) prepareDisplay {
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    navigationLabel.text = [foodName valueForKey:[languageHelper nameColumn]];
    navigationLabel.font = [UIFont systemFontOfSize:12];
    navigationLabel.lineBreakMode = UILineBreakModeWordWrap;
    navigationLabel.numberOfLines = 2;
    [navigationLabel setBackgroundColor:[UIColor clearColor]];
	[navigationLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = navigationLabel;
    
    BOOL isFavorite = [favoriteHelper isFavorite:foodName];
    NSString *image = kImageNotFavorite;
    if(isFavorite) {
        image = kImageFavorite;                
    }
    
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStyleBordered target:self action:@selector(favoriteButtonPressed:)];  
    self.navigationItem.rightBarButtonItem = favoriteButton;
    
    if(selectedConversionFactor == nil) {
        NSNumber *favoriteConversion = [favoriteHelper favoriteConversionMeasure:foodName];
        NSSet *conversionFactors = [foodName valueForKey:kConversionFactorsAttribute];
        if(favoriteConversion != nil) {
            for(ConversionFactor *conversionFactor in conversionFactors) {
                Measure *measure = [conversionFactor valueForKey:kMeasureColumn];
                NSNumber *measureId = [measure valueForKey:kMeasureIdColumn];
                
                if([measureId isEqualToNumber:favoriteConversion]) {
                    selectedConversionFactor = conversionFactor;
                }
            }
        }

        if(selectedConversionFactor == nil) {
            // pick any conversion
            selectedConversionFactor = [[conversionFactors allObjects] objectAtIndex:0];
        }
    }

    if(kDebug) {
        NSLog(@"Preparing display for FoodId %@", [foodName valueForKey:kFoodIdColumn]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSArray *) nutritiveValueKeys {
    return [profileHelper nutritiveSymbolsForProfile:[profileHelper selectedProfile]];
}

- (NSArray *) nutritiveValues:(NSArray *)keys {
    NSSet *nutritiveValueEntities = [foodName valueForKey:kNutritiveValuesAttribute];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(NutritiveValue *nutritiveValue in nutritiveValueEntities) {
        NutritiveName *nutritiveName = [nutritiveValue valueForKey:kNutritiveNameColumn];
        NSString *symbol = [nutritiveName valueForKey:kNutritiveSymbolColumn];
        
        for(NSString *keySymbol in keys) {
            if([keySymbol isEqualToString:symbol]) {
                [result addObject:nutritiveValue];
            }
        }
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierMeasure];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierMeasure];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        Measure *measure = [selectedConversionFactor valueForKey:kMeasureColumn];
        cell.textLabel.text = [measure valueForKey:[languageHelper nameColumn]];
        
        return cell;
    }
    else if(section == 1) {
        if(!cellNibLoaded) {
            UINib *nib = [UINib nibWithNibName:@"NutientValueCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:kRowIdentifierNutient];
            cellNibLoaded = YES;
        }
        
        return [cellHelper makeNutientValueCell:tableView :kRowIdentifierNutient :nutritiveValues :indexPath :selectedConversionFactor];
    } 
    else if(section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifierAll];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifierAll];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [languageHelper localizedString:@"All Nutritive Values"];
        
        return cell;
    }
    
    return nil; 
}

- (IBAction)favoriteButtonPressed:(id)sender {
    if([favoriteHelper isFavorite:foodName])
    {
        [favoriteHelper removeFavorite:foodName];
    } else {
        [favoriteHelper addFoodToFavorite:foodName];
    }
    
    [self prepareDisplay];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return 1;
            break;
        case (1):
            return [self.nutritiveValues count];
            break;
        case (2):
            return 1;
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case (0):
            return [languageHelper localizedString:@"Selected Measure"];
            break;
        case (1):
            return [[languageHelper localizedString:@"Values for profile "] stringByAppendingString:[languageHelper localizedString:[profileHelper selectedProfile]]];
            break;
        case (3):
            // no label
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    NSString *title = [foodName valueForKey:[languageHelper nameColumn]];
    if([title length] > 20) {
        title = [[title substringToIndex:20] stringByAppendingString:@"..."];
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    if(section == 0) {
        NSSet *conversionFactors = [foodName valueForKey:kConversionFactorsAttribute];
        MeasureSelection *measureSelectionView = [[MeasureSelection alloc] initWithConversionFactors:[conversionFactors allObjects]:selectedConversionFactor];
        [measureSelectionView setDelegate:self];
        [self.navigationController pushViewController:measureSelectionView animated:YES];
    }
    else if(section == 2) {
        AllNutritiveValues *allView = [[AllNutritiveValues alloc] initWithFoodName:foodName :selectedConversionFactor];
        [self.navigationController pushViewController:allView animated:YES];
        allView = nil;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) conversionFactorSelected:(ConversionFactor *) conversionFactor {
    selectedConversionFactor = conversionFactor;
    
    [favoriteHelper addConversionToFavorite:conversionFactor :foodName];
    
    [table reloadData];
}

@end
