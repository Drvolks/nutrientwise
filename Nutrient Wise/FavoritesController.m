//
//  FavoritesController.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesController.h"

#define kTitle @"Favorites"
#define kEdit @"Edit"
#define kDone @"Done"

@implementation FavoritesController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.languageHelper = [[LanguageHelper alloc] init];
    /*
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:[languageHelper localizedString:kEdit]
                                                                    style:UIBarButtonItemStylePlain target:nil action:nil];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[languageHelper localizedString:kTitle]];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [self.navigationBar pushNavigationItem:item animated:NO];
     */
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

@end
