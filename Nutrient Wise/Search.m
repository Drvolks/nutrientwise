//
//  SearchController.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Search.h"
#import "FoodDetail.h"

#define kTitle @"Search"
#define kRowIdentifier @"rowIdentifier"

@implementation Search

@synthesize searchBar;
@synthesize resultTable;
@synthesize searchResults;
@synthesize finder;
@synthesize languageHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    self.languageHelper = [[LanguageHelper alloc] init];
    
    self.title = [languageHelper localizedString:kTitle];
    
    [self resetSearch];

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

- (void) resetSearch {
    searchResults = [[NSArray alloc] init];
}

- (void) search:(NSString *)text {
    [self resetSearch];

    self.searchResults = [finder searchFoodByName:text];
    [resultTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
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
    FoodName *foodName = [searchResults objectAtIndex:row];
    
    cell.textLabel.text = [foodName valueForKey:[languageHelper nameColumn]];

    return cell; 
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
    return indexPath;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
    [searchBar resignFirstResponder];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] == 0) {
        [self resetSearch];
        [resultTable reloadData];
        return;
    }
    
    [self search:searchText];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)bar {
    searchBar.text = @"";
    [self resetSearch];
    [resultTable reloadData];

    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    FoodName *foodName = [searchResults objectAtIndex:row];
    
    FoodDetail *foodDetailView = [[FoodDetail alloc] initWithFood:foodName];
    [self.navigationController pushViewController:foodDetailView animated:YES];
    
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

@end
