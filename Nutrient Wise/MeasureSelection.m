//
//  MeasureSelection.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeasureSelection.h"
#import "ConversionFactor.h"
#import "Measure.h"
#import "FoodDetail.h"

#define kRowIdentifier @"rowIdentifier"
#define kMeasureAttribute @"maesure"
#define kMeasureIdColumn @"measureId"

@implementation MeasureSelection

@synthesize conversionFactors;
@synthesize selectedConversionFactor;
@synthesize languageHelper;
@synthesize delegate;

- (id) initWithConversionFactors:(NSArray *) pConversionFactors
        selectedConversionFactor:(ConversionFactor *)pSelectedConversionFactor {
    self = [super initWithNibName:@"MeasureSelection" bundle:nil];
    if (self) {
        conversionFactors = pConversionFactors;
        selectedConversionFactor = pSelectedConversionFactor;
    }
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
    
    languageHelper = [LanguageHelper sharedInstance];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    conversionFactors = nil;
    selectedConversionFactor = nil;
    languageHelper = nil;
    delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    ConversionFactor *conversionFactor = [conversionFactors objectAtIndex:row];
    
    [[self delegate] conversionFactorSelected:conversionFactor];
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [conversionFactors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    ConversionFactor *conversionFactor = [conversionFactors objectAtIndex:row];
    Measure *measure = [conversionFactor valueForKey:kMeasureAttribute];
    NSNumber *measureId = [measure valueForKey:kMeasureIdColumn];
    
    Measure *selectedMeasure = [selectedConversionFactor valueForKey:kMeasureAttribute];
    NSNumber *selectedMeasureId = [selectedMeasure valueForKey:kMeasureIdColumn];
    if([selectedMeasureId isEqualToNumber:measureId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [measure valueForKey:[languageHelper nameColumn]];
    
    return cell; 
}

@end
