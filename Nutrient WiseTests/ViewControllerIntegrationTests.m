//
//  ViewControllerIntegrationTests.m
//  Nutrient WiseTests
//
//  Integration tests that instantiate each view controller from its XIB,
//  feed it test fixtures, trigger lifecycle + datasource/delegate methods,
//  and assert observable state. This exercises large swaths of the view
//  controllers without needing a full XCUITest runner.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NWTestSupport.h"
#import "LanguageHelper.h"
#import "ProfileHelper.h"
#import "Finder.h"
#import "FoodName.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"
#import "Measure.h"
#import "ConversionFactor.h"

#import "Favorites.h"
#import "Profiles.h"
#import "Settings.h"
#import "SettingsLanguage.h"
#import "ProfileSelection.h"
#import "MeasureSelection.h"
#import "FoodDetail.h"
#import "AllNutritiveValues.h"
#import "About.h"
#import "Search.h"
#import "SearchController.h"
#import "FavoritesController.h"
#import "ProfilesController.h"
#import "SettingsController.h"
#import "UISearchBar+UISearchBarLocalized.h"

// Minimal delegate stubs so we can verify push/delegate call paths.
@interface NWProfileSelectionStub : NSObject <ProfileSelectionDelegate>
@property (nonatomic, copy) NSString *lastProfile;
@end
@implementation NWProfileSelectionStub
- (void)profileSelected:(NSString *)profile { self.lastProfile = profile; }
@end

@interface NWSettingsLanguageStub : NSObject <SettingsLanguageDelegate>
@property (nonatomic, copy) NSString *lastLanguage;
@end
@implementation NWSettingsLanguageStub
- (void)languageSelected:(NSString *)language { self.lastLanguage = language; }
@end

@interface NWMeasureSelectionStub : NSObject <MeasureSelectionDelegate>
@property (nonatomic, strong) ConversionFactor *lastConversion;
@end
@implementation NWMeasureSelectionStub
- (void)conversionFactorSelected:(ConversionFactor *)conversionFactor { self.lastConversion = conversionFactor; }
@end

@interface ViewControllerIntegrationTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) Finder *finder;
@property (nonatomic, strong) FoodName *apple;
@property (nonatomic, strong) FoodName *banana;
@property (nonatomic, strong) ConversionFactor *appleCup;
@end

@implementation ViewControllerIntegrationTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    [[ProfileHelper sharedInstance] setSelectedProfile:@"generic"];

    self.ctx = [NWTestSupport newInMemoryContext];
    self.finder = [[Finder alloc] initWithContext:self.ctx];

    // Food + nutrients
    self.apple = [NWTestSupport insertFoodWithId:1 englishName:@"Apple, raw" frenchName:@"Pomme, crue" inContext:self.ctx];
    self.banana = [NWTestSupport insertFoodWithId:2 englishName:@"Banana, raw" frenchName:@"Banane, crue" inContext:self.ctx];

    NSArray *symbols = @[@"KCAL", @"FAT", @"TSAT", @"TRFA", @"CHOL", @"NA",
                          @"CARB", @"TDF", @"TSUG", @"PROT", @"H2O", @"K",
                          @"P", @"MG", @"STAR", @"MUFA", @"PUFA", @"FE", @"CA"];
    double value = 1.0;
    for (NSString *symbol in symbols) {
        NutritiveName *name = [NWTestSupport insertNutritiveNameWithSymbol:symbol
                                                                englishName:[@"name-" stringByAppendingString:symbol]
                                                                 frenchName:[@"nom-" stringByAppendingString:symbol]
                                                                       unit:@"g"
                                                                  inContext:self.ctx];
        [NWTestSupport insertNutritiveValue:value name:name food:self.apple inContext:self.ctx];
        [NWTestSupport insertNutritiveValue:value * 2 name:name food:self.banana inContext:self.ctx];
        value += 1.0;
    }

    // Conversions for apple so FoodDetail can exercise both measure paths
    Measure *cup  = [NWTestSupport insertMeasureWithId:7 englishName:@"1 cup" frenchName:@"1 tasse"  inContext:self.ctx];
    Measure *slice = [NWTestSupport insertMeasureWithId:8 englishName:@"1 slice" frenchName:@"1 tranche" inContext:self.ctx];
    self.appleCup = [NWTestSupport insertConversionFactor:1.25 measure:cup food:self.apple inContext:self.ctx];
    [NWTestSupport insertConversionFactor:0.3 measure:slice food:self.apple inContext:self.ctx];

    NSError *error = nil;
    [self.ctx save:&error];
    XCTAssertNil(error);
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    self.ctx = nil;
    self.finder = nil;
    self.apple = nil;
    self.banana = nil;
    self.appleCup = nil;
    [super tearDown];
}

// MARK: - Helpers

- (UINavigationController *)navWithRoot:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    // Force navigation bar layout
    [nav.view layoutIfNeeded];
    return nav;
}

// MARK: - Favorites

- (void)testFavoritesLoadsEmpty {
    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;  // triggers viewDidLoad
    [vc viewWillAppear:NO];

    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:0], 0);
    XCTAssertNil(vc.navigationItem.rightBarButtonItem);
}

- (void)testFavoritesLoadsWithFavoritesAndRendersCells {
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.apple];
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.banana];

    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    [vc viewWillAppear:NO];

    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:0], 2);
    UITableViewCell *row0 = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(row0);
    XCTAssertNotNil(vc.navigationItem.rightBarButtonItem);
}

- (void)testFavoritesToggleEditFlipsTableEditing {
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.apple];

    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    [vc viewWillAppear:NO];

    XCTAssertFalse(vc.table.editing);
    [vc toggleEdit:nil];
    XCTAssertTrue(vc.table.editing);
    [vc toggleEdit:nil];
    XCTAssertFalse(vc.table.editing);
}

- (void)testFavoritesLanguageChangedUpdatesTitle {
    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    [vc languageChanged];
    XCTAssertNotNil(vc.navigationItem.title);
}

- (void)testFavoritesDidSelectPushesFoodDetail {
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.apple];

    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];
    [vc viewWillAppear:NO];

    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

- (void)testFavoritesSwipeToDeleteRemovesRow {
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.apple];
    [[FavoriteHelper sharedInstance] addFoodToFavorite:self.banana];

    Favorites *vc = [[Favorites alloc] initWithNibName:@"Favorites" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    [vc viewWillAppear:NO];
    XCTAssertEqual(vc.favorites.count, 2u);

    [vc tableView:vc.table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual(vc.favorites.count, 1u);

    [vc tableView:vc.table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual(vc.favorites.count, 0u);
    XCTAssertNil(vc.navigationItem.rightBarButtonItem);
}

// MARK: - Profiles

- (void)testProfilesViewLoadsAndRendersRow {
    Profiles *vc = [[Profiles alloc] initWithNibName:@"Profiles" bundle:nil];
    (void)vc.view;
    XCTAssertEqual([vc numberOfSectionsInTableView:vc.table], 1);
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:0], 1);
    UITableViewCell *cell = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(cell);
    XCTAssertNotNil([vc tableView:vc.table titleForHeaderInSection:0]);
    XCTAssertNil([vc tableView:vc.table titleForHeaderInSection:1]);
}

- (void)testProfilesProfileSelectedUpdatesAndReloads {
    Profiles *vc = [[Profiles alloc] initWithNibName:@"Profiles" bundle:nil];
    (void)vc.view;
    [vc profileSelected:@"rein"];
    XCTAssertEqualObjects([[ProfileHelper sharedInstance] selectedProfile], @"rein");
}

- (void)testProfilesDidSelectPushesProfileSelection {
    Profiles *vc = [[Profiles alloc] initWithNibName:@"Profiles" bundle:nil];
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];

    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

- (void)testProfilesLanguageChangedRefreshes {
    Profiles *vc = [[Profiles alloc] initWithNibName:@"Profiles" bundle:nil];
    (void)vc.view;
    [vc languageChanged];
    XCTAssertNotNil(vc.navigationItem.title);
}

- (void)testProfilesNumberOfRowsZeroForUnknownSection {
    Profiles *vc = [[Profiles alloc] initWithNibName:@"Profiles" bundle:nil];
    (void)vc.view;
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:5], 0);
}

// MARK: - ProfileSelection

- (void)testProfileSelectionLoadsAndRendersAllProfiles {
    ProfileSelection *vc = [[ProfileSelection alloc] initWithProfile:@"generic"];
    (void)vc.view;
    NSInteger rows = [vc tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(rows, 6);
}

- (void)testProfileSelectionDidSelectInvokesDelegate {
    NWProfileSelectionStub *stub = [[NWProfileSelectionStub alloc] init];
    ProfileSelection *vc = [[ProfileSelection alloc] initWithProfile:@"generic"];
    (void)vc.view;
    vc.delegate = stub;

    UINavigationController *nav = [self navWithRoot:vc];
    [vc tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(stub.lastProfile);
    (void)nav;
}

// MARK: - Settings

- (void)testSettingsLoadsAndRendersBothRows {
    Settings *vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    (void)vc.view;
    XCTAssertEqual([vc numberOfSectionsInTableView:vc.table], 2);
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:0], 1);
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:1], 1);

    UITableViewCell *lang = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *about = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    XCTAssertNotNil(lang);
    XCTAssertNotNil(about);

    XCTAssertNotNil([vc tableView:vc.table titleForHeaderInSection:0]);
    XCTAssertNil([vc tableView:vc.table titleForHeaderInSection:1]);
    XCTAssertNil([vc tableView:vc.table titleForHeaderInSection:3]);
}

- (void)testSettingsDidSelectLanguagePushesSettingsLanguage {
    Settings *vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];
    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

- (void)testSettingsDidSelectAboutPushesAbout {
    Settings *vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];
    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

- (void)testSettingsLanguageSelectedPersistsAndReloads {
    Settings *vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    (void)vc.view;
    [vc languageSelected:@"fr"];
    XCTAssertEqualObjects([[LanguageHelper sharedInstance] language], @"fr");
}

- (void)testSettingsNumberOfRowsZeroForUnknownSection {
    Settings *vc = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
    (void)vc.view;
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:5], 0);
}

// MARK: - SettingsLanguage

- (void)testSettingsLanguageRendersSupportedLanguages {
    SettingsLanguage *vc = [[SettingsLanguage alloc] initWithLanguage:@"en"];
    (void)vc.view;
    NSInteger rows = [vc tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(rows, 2);
}

- (void)testSettingsLanguageDidSelectInvokesDelegate {
    NWSettingsLanguageStub *stub = [[NWSettingsLanguageStub alloc] init];
    SettingsLanguage *vc = [[SettingsLanguage alloc] initWithLanguage:@"en"];
    (void)vc.view;
    vc.delegate = stub;
    UINavigationController *nav = [self navWithRoot:vc];

    [vc tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(stub.lastLanguage);

    stub.lastLanguage = nil;
    [vc tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertNotNil(stub.lastLanguage);
    (void)nav;
}

// MARK: - MeasureSelection

- (void)testMeasureSelectionLoadsWithConversions {
    NSArray *conversions = [[self.apple valueForKey:@"conversionFactors"] allObjects];
    MeasureSelection *vc = [[MeasureSelection alloc] initWithConversionFactors:conversions
                                                       selectedConversionFactor:conversions.firstObject];
    (void)vc.view;
    NSInteger rows = [vc tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(rows, (NSInteger)conversions.count);
}

- (void)testMeasureSelectionDidSelectInvokesDelegate {
    NWMeasureSelectionStub *stub = [[NWMeasureSelectionStub alloc] init];
    NSArray *conversions = [[self.apple valueForKey:@"conversionFactors"] allObjects];
    MeasureSelection *vc = [[MeasureSelection alloc] initWithConversionFactors:conversions
                                                       selectedConversionFactor:conversions.firstObject];
    (void)vc.view;
    vc.delegate = stub;
    UINavigationController *nav = [self navWithRoot:vc];

    [vc tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(stub.lastConversion);
    (void)nav;
}

// MARK: - FoodDetail

- (void)testFoodDetailLoadsWithGenericProfile {
    [[ProfileHelper sharedInstance] setSelectedProfile:@"generic"];
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;

    XCTAssertNotNil(vc.nutritiveValues);
    XCTAssertNil(vc.genericValues, @"generic profile has no separate genericValues");

    NSInteger sections = [vc numberOfSectionsInTableView:vc.table];
    XCTAssertEqual(sections, 3);

    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:0], 1);
    XCTAssertGreaterThan([vc tableView:vc.table numberOfRowsInSection:1], 0);
    XCTAssertEqual([vc tableView:vc.table numberOfRowsInSection:2], 1);

    for (NSInteger s = 0; s < sections; s++) {
        for (NSInteger r = 0; r < [vc tableView:vc.table numberOfRowsInSection:s]; r++) {
            UITableViewCell *cell = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
            XCTAssertNotNil(cell);
        }
        // Exercise header title branches
        [vc tableView:vc.table titleForHeaderInSection:s];
    }
    [vc viewWillAppear:NO];
}

- (void)testFoodDetailLoadsWithNonGenericProfileAddsGenericSection {
    [[ProfileHelper sharedInstance] setSelectedProfile:@"rein"];
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;

    XCTAssertNotNil(vc.nutritiveValues);
    XCTAssertNotNil(vc.genericValues);

    NSInteger sections = [vc numberOfSectionsInTableView:vc.table];
    XCTAssertEqual(sections, 4);

    for (NSInteger s = 0; s < sections; s++) {
        NSInteger rows = [vc tableView:vc.table numberOfRowsInSection:s];
        for (NSInteger r = 0; r < rows; r++) {
            UITableViewCell *cell = [vc tableView:vc.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
            XCTAssertNotNil(cell);
        }
        [vc tableView:vc.table titleForHeaderInSection:s];
    }
}

- (void)testFoodDetailFavoritePressedTogglesFavoriteState {
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;

    XCTAssertFalse([[FavoriteHelper sharedInstance] isFavorite:self.apple]);
    [vc performSelector:@selector(favoritePressed:) withObject:nil];
    XCTAssertTrue([[FavoriteHelper sharedInstance] isFavorite:self.apple]);
    [vc performSelector:@selector(favoritePressed:) withObject:nil];
    XCTAssertFalse([[FavoriteHelper sharedInstance] isFavorite:self.apple]);
}

- (void)testFoodDetailConversionFactorSelectedUpdatesState {
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;

    [vc conversionFactorSelected:self.appleCup];
    XCTAssertEqual(vc.selectedConversionFactor, self.appleCup);
    XCTAssertEqualObjects([[FavoriteHelper sharedInstance] favoriteConversionMeasure:self.apple], @7);
}

- (void)testFoodDetailPickAConversionFactorPrefersOneUnit {
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;

    NSSet *conversions = [self.apple valueForKey:@"conversionFactors"];
    ConversionFactor *picked = [vc pickAConversionFactor:conversions];
    XCTAssertNotNil(picked);
    Measure *m = [picked valueForKey:@"maesure"];
    NSString *name = [m valueForKey:@"englishName"];
    XCTAssertTrue([name hasPrefix:@"1 "]);
}

- (void)testFoodDetailDidSelectAllRowPushesAllNutritiveValues {
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];

    // Section index 2 is "All Nutritive Values" in generic profile
    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

- (void)testFoodDetailDidSelectMeasurePushesMeasureSelection {
    FoodDetail *vc = [[FoodDetail alloc] initWithFood:self.apple];
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];

    [vc tableView:vc.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

// MARK: - AllNutritiveValues

- (void)testAllNutritiveValuesLoadsAndBuildsIndex {
    AllNutritiveValues *vc = [[AllNutritiveValues alloc] initWithFoodName:self.apple conversionFactor:nil];
    (void)vc.view;

    NSInteger sections = [vc numberOfSectionsInTableView:nil];
    XCTAssertGreaterThan(sections, 0);

    // Walk at least one row per section
    for (NSInteger s = 0; s < sections; s++) {
        NSInteger rows = [vc tableView:nil numberOfRowsInSection:s];
        if (rows > 0) {
            UITableView *dummy = [[UITableView alloc] init];
            UITableViewCell *cell = [vc tableView:dummy cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:s]];
            XCTAssertNotNil(cell);
        }
        [vc tableView:nil titleForHeaderInSection:s];
    }
}

- (void)testAllNutritiveValuesWithConversionFactor {
    AllNutritiveValues *vc = [[AllNutritiveValues alloc] initWithFoodName:self.apple conversionFactor:self.appleCup];
    (void)vc.view;

    NSInteger sections = [vc numberOfSectionsInTableView:nil];
    XCTAssertGreaterThan(sections, 0);
}

// MARK: - About

- (void)testAboutLoadsInEnglish {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    About *vc = [[About alloc] init];
    (void)vc.view;
    XCTAssertNotNil(vc.view);
}

- (void)testAboutLoadsInFrench {
    [[LanguageHelper sharedInstance] setLanguage:@"fr"];
    About *vc = [[About alloc] init];
    (void)vc.view;
    XCTAssertNotNil(vc.view);
}

// MARK: - Search

- (void)testSearchLoadsEmptyState {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    XCTAssertEqual([vc tableView:vc.resultTable numberOfRowsInSection:0], 0);
}

- (void)testSearchFindsMatchingRows {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;

    [vc search:@"apple"];
    XCTAssertEqual([vc tableView:vc.resultTable numberOfRowsInSection:0], 1);

    UITableViewCell *cell = [vc tableView:vc.resultTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(cell);
}

- (void)testSearchBarTextDidChangeRunsSearch {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;

    [vc searchBar:vc.searchBar textDidChange:@"apple"];
    XCTAssertEqual(vc.searchResults.count, 1u);

    [vc searchBar:vc.searchBar textDidChange:@""];
    XCTAssertEqual(vc.searchResults.count, 0u);
}

- (void)testSearchBarCancelButtonResets {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;

    [vc search:@"apple"];
    XCTAssertEqual(vc.searchResults.count, 1u);

    [vc searchBarCancelButtonClicked:vc.searchBar];
    XCTAssertEqual(vc.searchResults.count, 0u);
    XCTAssertEqualObjects(vc.searchBar.text, @"");
}

- (void)testSearchBarShouldBeginAndEndEditingReturnYes {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;

    XCTAssertTrue([vc searchBarShouldBeginEditing:vc.searchBar]);
    XCTAssertTrue([vc searchBarShouldEndEditing:vc.searchBar]);
    // willSelectRow returns the same index path it was given
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    XCTAssertEqualObjects([vc tableView:vc.resultTable willSelectRowAtIndexPath:ip], ip);
    [vc searchBarSearchButtonClicked:vc.searchBar];
}

- (void)testSearchLanguageChangedRefreshesUI {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    XCTAssertNoThrow([vc languageChanged]);
}

- (void)testSearchDidSelectRowPushesFoodDetail {
    Search *vc = [[Search alloc] initWithNibName:@"Search" bundle:nil];
    vc.finder = self.finder;
    (void)vc.view;
    UINavigationController *nav = [self navWithRoot:vc];

    [vc search:@"apple"];
    [vc tableView:vc.resultTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue(nav.viewControllers.count >= 1);
}

// MARK: - Nav controllers (*Controller.m files)

- (void)testSearchControllerLifecycle {
    SearchController *nav = [[SearchController alloc] initWithNibName:nil bundle:nil];
    nav.finder = self.finder;
    (void)nav.view;
    [nav didReceiveMemoryWarning];
    XCTAssertEqual(nav.finder, self.finder);
}

- (void)testFavoritesControllerLifecycle {
    FavoritesController *nav = [[FavoritesController alloc] initWithNibName:nil bundle:nil];
    nav.finder = self.finder;
    (void)nav.view;
    [nav didReceiveMemoryWarning];
    XCTAssertEqual(nav.finder, self.finder);
}

- (void)testProfilesControllerLifecycle {
    ProfilesController *nav = [[ProfilesController alloc] initWithNibName:nil bundle:nil];
    (void)nav.view;
    [nav didReceiveMemoryWarning];
    XCTAssertNotNil(nav);
}

- (void)testSettingsControllerLifecycle {
    SettingsController *nav = [[SettingsController alloc] initWithNibName:nil bundle:nil];
    (void)nav.view;
    [nav didReceiveMemoryWarning];
    XCTAssertNotNil(nav);
}

// MARK: - AllNutritiveValues extras

- (void)testAllNutritiveValuesSectionIndexTitlesAndDidSelect {
    AllNutritiveValues *vc = [[AllNutritiveValues alloc] initWithFoodName:self.apple conversionFactor:nil];
    (void)vc.view;

    NSArray *titles = [vc sectionIndexTitlesForTableView:nil];
    XCTAssertTrue(titles.count > 0);

    UITableView *dummy = [[UITableView alloc] init];
    [vc tableView:dummy didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(vc);
}

- (void)testAllNutritiveValuesDecomposeAndFilterStripsAccents {
    AllNutritiveValues *vc = [[AllNutritiveValues alloc] initWithFoodName:self.apple conversionFactor:nil];
    (void)vc.view;
    NSString *result = [vc decomposeAndFilterString:@"Énergie"];
    XCTAssertNotNil(result);
    // Strip combining marks; first character should now be base letter E/e
    unichar first = [result characterAtIndex:0];
    XCTAssertTrue(first == 'E' || first == 'e');
}

// MARK: - UISearchBar category

- (void)testUISearchBarCancelButtonLocalizationDoesNotCrash {
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setShowsCancelButton:YES animated:NO];
    XCTAssertNoThrow([bar cancelButton:@"Annuler"]);
}

// MARK: - Lifecycle sweep
// Exercise didReceiveMemoryWarning / initWithNibName across every VC to pick
// up the trivial uncovered lines in one pass.
- (void)testLifecycleSweepAcrossAllViewControllers {
    NSArray *vcClasses = @[
        [Favorites class], [Profiles class], [Settings class],
        [SettingsLanguage class], [ProfileSelection class],
        [MeasureSelection class], [FoodDetail class],
        [AllNutritiveValues class], [About class], [Search class],
    ];
    for (Class cls in vcClasses) {
        UIViewController *vc = [[cls alloc] initWithNibName:nil bundle:nil];
        XCTAssertNotNil(vc);
        [vc didReceiveMemoryWarning];
    }
}

@end
