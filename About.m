//
//  About.m
//  Nutrient Wise
//
//  Created by Jean-François Dufour on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "About.h"
#import "AppDelegate.h"

#define kTitle @"About"

// English strings
#define kCreatedByEn @"Nutrient Wise is a creation of Consultation Massawippi inc."
#define kDataSourceEn @"The data is adapted from: Canadian Nutrient File, Health Canada, 2010"
#define kDataSourceLinkTextEn @"www.healthcanada.gc.ca/cnf"

// French strings
#define kCreatedByFr @"Nutrient Wise est une cr\u00e9ation de Consultation Massawippi inc."
#define kDataSourceFr @"Les donn\u00e9es sont adapt\u00e9es de : Fichier canadien sur les \u00e9l\u00e9ments nutritifs, Sant\u00e9 Canada, 2010"
#define kDataSourceLinkTextFr @"www.santecanada.gc.ca/fcen"

@implementation About {
    UIImageView *_iconView;
    UILabel *_appNameLabel;
    UILabel *_versionLabel;
    UILabel *_createdByLabel;
    UILabel *_dataSourceLabel;
    UIButton *_dataSourceLink;
}

@synthesize languageHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[UIView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];

    languageHelper = [LanguageHelper sharedInstance];

    // App icon
    UIImage *icon = [UIImage imageNamed:@"LaunchIcon"];
    _iconView = [[UIImageView alloc] initWithImage:icon];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconView.layer.cornerRadius = 20;
    _iconView.clipsToBounds = YES;
    [self.view addSubview:_iconView];

    // App name
    _appNameLabel = [[UILabel alloc] init];
    _appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _appNameLabel.font = [UIFont boldSystemFontOfSize:24];
    _appNameLabel.textColor = [UIColor labelColor];
    _appNameLabel.textAlignment = NSTextAlignmentCenter;
    _appNameLabel.text = @"Nutrient Wise";
    [self.view addSubview:_appNameLabel];

    // Version
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _versionLabel.font = [UIFont systemFontOfSize:14];
    _versionLabel.textColor = [UIColor secondaryLabelColor];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    _versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", version, build];
    [self.view addSubview:_versionLabel];

    // Created by
    _createdByLabel = [[UILabel alloc] init];
    _createdByLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _createdByLabel.font = [UIFont systemFontOfSize:15];
    _createdByLabel.textColor = [UIColor labelColor];
    _createdByLabel.textAlignment = NSTextAlignmentCenter;
    _createdByLabel.numberOfLines = 0;
    [self.view addSubview:_createdByLabel];

    // Data source
    _dataSourceLabel = [[UILabel alloc] init];
    _dataSourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dataSourceLabel.font = [UIFont systemFontOfSize:15];
    _dataSourceLabel.textColor = [UIColor labelColor];
    _dataSourceLabel.textAlignment = NSTextAlignmentCenter;
    _dataSourceLabel.numberOfLines = 0;
    [self.view addSubview:_dataSourceLabel];

    // Data source link
    _dataSourceLink = [UIButton buttonWithType:UIButtonTypeSystem];
    _dataSourceLink.translatesAutoresizingMaskIntoConstraints = NO;
    _dataSourceLink.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dataSourceLink addTarget:self action:@selector(openDataSourceLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dataSourceLink];

    // Layout
    [NSLayoutConstraint activateConstraints:@[
        [_iconView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_iconView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        [_iconView.widthAnchor constraintEqualToConstant:90],
        [_iconView.heightAnchor constraintEqualToConstant:90],

        [_appNameLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_appNameLabel.topAnchor constraintEqualToAnchor:_iconView.bottomAnchor constant:16],

        [_versionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_versionLabel.topAnchor constraintEqualToAnchor:_appNameLabel.bottomAnchor constant:4],

        [_createdByLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_createdByLabel.topAnchor constraintEqualToAnchor:_versionLabel.bottomAnchor constant:32],
        [_createdByLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [_createdByLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],

        [_dataSourceLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_dataSourceLabel.topAnchor constraintEqualToAnchor:_createdByLabel.bottomAnchor constant:24],
        [_dataSourceLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [_dataSourceLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],

        [_dataSourceLink.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_dataSourceLink.topAnchor constraintEqualToAnchor:_dataSourceLabel.bottomAnchor constant:4],
    ]];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate registerLanguageDelegate:self];

    [self languageChanged];
}

- (void) languageChanged {
    self.title = [languageHelper localizedString:kTitle];

    BOOL isFrench = [[languageHelper language] isEqualToString:@"fr"];

    _createdByLabel.text = isFrench ? kCreatedByFr : kCreatedByEn;
    _dataSourceLabel.text = isFrench ? kDataSourceFr : kDataSourceEn;
    [_dataSourceLink setTitle:(isFrench ? kDataSourceLinkTextFr : kDataSourceLinkTextEn) forState:UIControlStateNormal];
}

- (void) openDataSourceLink {
    BOOL isFrench = [[languageHelper language] isEqualToString:@"fr"];
    NSString *urlString = isFrench ? @"https://www.canada.ca/fr/sante-canada/services/aliments-nutrition/saine-alimentation/donnees-nutritionnelles.html" : @"https://www.canada.ca/en/health-canada/services/food-nutrition/healthy-eating/nutrient-data.html";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
}

@end
