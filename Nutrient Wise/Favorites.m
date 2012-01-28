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
    
    self.favoriteHelper = [[FavoriteHelper alloc] init];
    self.languageHelper = [[LanguageHelper alloc] init];
    
    self.navigationItem.title = [languageHelper localizedString:kTitle];
    [self.navigationItem.rightBarButtonItem setTitle:[languageHelper localizedString:kEdit]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadFavorites];

}

- (void) loadFavorites {
    NSArray *favoriteIds = [self.favoriteHelper favotiteFoodIds];
    NSMutableArray *favoriteEntities = [[NSMutableArray alloc] init];
    
    NSLog(@"ids = %@", favoriteIds);
    
    for(NSNumber *favorite in favoriteIds) {
        NSLog(@"search for %@", favorite);
        FoodName *food = [finder getFoodName:favorite];
        if(food) {
            [favoriteEntities addObject:food];
        }
    }
    
    self.favorites = favoriteEntities;
    
    [table reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRowIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRowIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    }
    
    NSUInteger row = [indexPath row];
    FoodName *foodName = [favorites objectAtIndex:row];
    
    cell.textLabel.text = [foodName valueForKey:[languageHelper nameColumn]];
    
    return cell; 
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

@end
