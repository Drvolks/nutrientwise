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
#define kSearchHint @"SearchHint"
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
@synthesize emptyStateView;
@synthesize emptyStateLabel;

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

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.resultTable.backgroundColor = [UIColor systemBackgroundColor];

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

    // Empty state view
    emptyStateView = [[UIView alloc] init];
    emptyStateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:emptyStateView];

    UIImage *icon = [UIImage imageNamed:@"LaunchIcon"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.layer.cornerRadius = 20;
    iconView.clipsToBounds = YES;
    [emptyStateView addSubview:iconView];

    emptyStateLabel = [[UILabel alloc] init];
    emptyStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    emptyStateLabel.font = [UIFont systemFontOfSize:16];
    emptyStateLabel.textColor = [UIColor secondaryLabelColor];
    emptyStateLabel.textAlignment = NSTextAlignmentCenter;
    emptyStateLabel.numberOfLines = 0;
    [emptyStateView addSubview:emptyStateLabel];

    [NSLayoutConstraint activateConstraints:@[
        [emptyStateView.topAnchor constraintEqualToAnchor:searchBar.bottomAnchor],
        [emptyStateView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [emptyStateView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [emptyStateView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [iconView.centerXAnchor constraintEqualToAnchor:emptyStateView.centerXAnchor],
        [iconView.centerYAnchor constraintEqualToAnchor:emptyStateView.centerYAnchor constant:-60],
        [iconView.widthAnchor constraintEqualToConstant:90],
        [iconView.heightAnchor constraintEqualToConstant:90],

        [emptyStateLabel.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:16],
        [emptyStateLabel.leadingAnchor constraintEqualToAnchor:emptyStateView.leadingAnchor constant:40],
        [emptyStateLabel.trailingAnchor constraintEqualToAnchor:emptyStateView.trailingAnchor constant:-40],
    ]];

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

- (void) updateEmptyState {
    BOOL hasResults = [searchResults count] > 0;
    BOOL isSearching = [searchBar.text length] > 0;
    emptyStateView.hidden = hasResults || isSearching;
}

- (void) resetSearch {
    searchResults = [[NSArray alloc] init];
}

- (void) search:(NSString *)text {
    [self resetSearch];

    self.searchResults = [finder searchFoodByName:text];
    [resultTable reloadData];
    [self updateEmptyState];
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
        [self updateEmptyState];
        return;
    }

    [self search:searchText];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)bar {
    searchBar.text = kClearSearchBar;
    [self resetSearch];
    [resultTable reloadData];
    [self updateEmptyState];

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
    emptyStateLabel.text = [languageHelper localizedString:kSearchHint];

    searchBar.text = kClearSearchBar;
    [self resetSearch];
    [resultTable reloadData];
    [self updateEmptyState];
}

@end
