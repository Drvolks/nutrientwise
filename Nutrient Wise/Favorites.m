//
//  Favorites.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favorites.h"
#import "FoodName.h"
#import "FoodDetail.h"
#import "ArrayHelper.h"
#import "AppDelegate.h"

#define kDebug NO
#define kRowIdentifier @"rowIdentifier"
#define kTitle @"Favorites"
#define kEdit @"Edit"
#define kDone @"Done"

@implementation Favorites

@synthesize favoriteHelper;
@synthesize table;
@synthesize favorites;
@synthesize finder;
@synthesize languageHelper;
@synthesize cellHelper;
@synthesize arrayHelper;

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
    
    favoriteHelper = [FavoriteHelper sharedInstance];
    languageHelper = [LanguageHelper sharedInstance];
    cellHelper = [CellHelper sharedInstance];
    arrayHelper = [ArrayHelper sharedInstance];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadFavorites];

}

- (void) loadFavorites {
    NSArray *favoriteIds = [[self.favoriteHelper favotiteFoodIds] allValues];
    NSMutableArray *favoriteEntities = [[NSMutableArray alloc] init];
    
    if(kDebug) {
        NSLog(@"ids = %@", favoriteIds);
    }
    
    for(NSNumber *favorite in favoriteIds) {
        if(kDebug) {
            NSLog(@"search for %@", favorite);
        }
        FoodName *food = [finder getFoodName:favorite];
        if(food) {
            [favoriteEntities addObject:food];
        }
    }
    
    //Sort Data
    self.favorites = [arrayHelper sortMutableArray:favoriteEntities key:[languageHelper nameColumn] ascending:YES];
    
    [table reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    favoriteHelper = nil;
    table = nil;
    favorites = nil;
    finder = nil;
    languageHelper = nil;
    cellHelper = nil;
    arrayHelper = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [cellHelper makeFoodNameCell:tableView rowIdentifier:kRowIdentifier indexPath:indexPath searchResults:favorites];
}

- (IBAction)toggleEdit:(id)sender {
    [self.table setEditing:!self.table.editing animated:YES];
    
    if(self.table.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:[languageHelper localizedString:kDone]];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:[languageHelper localizedString:kEdit]];
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    FoodName *foodName = [favorites objectAtIndex:row];
    
    [favoriteHelper removeFavorite:foodName];
    [self.favorites removeObjectAtIndex:row];
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    FoodName *foodName = [favorites objectAtIndex:row];
    
    FoodDetail *foodDetailView = [[FoodDetail alloc] initWithFood:foodName];
    [self.navigationController pushViewController:foodDetailView animated:YES];
}

- (void) languageChanged {
    self.navigationItem.title = [languageHelper localizedString:kTitle];
    [self.navigationItem.rightBarButtonItem setTitle:[languageHelper localizedString:kEdit]];
    
    self.title = [languageHelper localizedString:kTitle];
}

@end
