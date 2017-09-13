//
//  SearchController.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Search.h"
#import "FoodDetail.h"
#import "AppDelegate.h"

#define kTitle @"Search"
#define kCancel @"Cancel"
#define kRowIdentifier @"rowIdentifier"
#define kClearSearchBar @""

@implementation Search

@synthesize searchBar;
@synthesize resultTable;
@synthesize searchResults;
@synthesize finder;
@synthesize languageHelper;
@synthesize cellHelper;
@synthesize banner;

- (id) init {
    return self;
}

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
    
    #ifdef FREE
        [self.banner setAdUnitID:@"ca-app-pub-2793046476751764/3785848734"];
        self.banner.rootViewController = self;
        GADRequest *request = [GADRequest request];
        #ifdef DEBUG
            request.testDevices = @[@"9daac87965735d59a75181ae69755337", kGADSimulatorID];
        #endif
        [self.banner loadRequest:request];
        [self.banner setHidden:false];
    
        self.banner.center = CGPointMake(self.view.center.x, self.view.frame.size.height-CGSizeFromGADAdSize(kGADAdSizeBanner).height/2);
    #else
        [self.banner setHidden:true];
    #endif
    
    languageHelper = [LanguageHelper sharedInstance];
    cellHelper = [CellHelper sharedInstance];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];
    
    [self languageChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    languageHelper = nil;
    cellHelper = nil;
    searchBar = nil;
    resultTable = nil;
    searchResults = nil;
    finder = nil;
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
    return [cellHelper makeFoodNameCell:tableView rowIdentifier:kRowIdentifier indexPath:indexPath searchResults:searchResults];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
    return indexPath;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar { 
    [bar setShowsCancelButton:YES animated:YES];
    
    [bar cancelButton:[languageHelper localizedString:kCancel]];
    
    return YES;  
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)bar {  
    [bar setShowsCancelButton:NO animated:YES];
    return YES;
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
    searchBar.text = kClearSearchBar;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

- (void) languageChanged {
    self.title = [languageHelper localizedString:kTitle];
    
    searchBar.text = kClearSearchBar;
    [self resetSearch];
    [resultTable reloadData];
}

@end
