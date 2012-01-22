//
//  SearchController.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Search.h"
#import "FoodDetail.h"

@implementation Search

@synthesize searchBar;
@synthesize resultTable;
@synthesize searchResults;
@synthesize finder;

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Search";
    
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

    NSLog(@"searching %@", text);
    self.searchResults = [finder searchFoodByName:text :[self isFrench]];
    NSLog(@"Found %d foods", [self.searchResults count]);
    [resultTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableIdentifier = @"TableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    }
    
    NSUInteger row = [indexPath row];
    FoodName *foodName = [searchResults objectAtIndex:row];
    
    if([self isFrench]) {
        cell.textLabel.text = [foodName valueForKey:@"frenchName"];
    } else {
         cell.textLabel.text = [foodName valueForKey:@"englishName"];
    }
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

    [bar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    FoodName *foodName = [searchResults objectAtIndex:row];
    
    FoodDetail *foodDetailView = [[FoodDetail alloc] initWithFood:foodName];
    [self.navigationController pushViewController:foodDetailView animated:YES];
}

- (BOOL *) isFrench {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *language = [settings objectForKey:@"language"];
    
    if([language compare:@"fr"] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

@end
