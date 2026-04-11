//
//  FinderTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import "Finder.h"
#import "FoodName.h"
#import "LanguageHelper.h"
#import "NWTestSupport.h"

@interface FinderTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) Finder *finder;
@end

@implementation FinderTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    self.ctx = [NWTestSupport newInMemoryContext];
    self.finder = [[Finder alloc] initWithContext:self.ctx];

    [NWTestSupport insertFoodWithId:1 englishName:@"Apple, raw"        frenchName:@"Pomme, crue"     inContext:self.ctx];
    [NWTestSupport insertFoodWithId:2 englishName:@"Banana, raw"       frenchName:@"Banane, crue"    inContext:self.ctx];
    [NWTestSupport insertFoodWithId:3 englishName:@"Carrot, raw"       frenchName:@"Carotte, crue"   inContext:self.ctx];
    [NWTestSupport insertFoodWithId:4 englishName:@"Apple juice, canned" frenchName:@"Jus de pomme, en conserve" inContext:self.ctx];
    [NWTestSupport insertFoodWithId:5 englishName:@"Chicken breast"    frenchName:@"Poitrine de poulet" inContext:self.ctx];

    NSError *error = nil;
    [self.ctx save:&error];
    XCTAssertNil(error);
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    self.finder = nil;
    self.ctx = nil;
    [super tearDown];
}

- (void)testInitWithContextStoresContextAndLanguageHelper {
    XCTAssertEqual(self.finder.managedObjectContext, self.ctx);
    XCTAssertNotNil(self.finder.languageHelper);
}

- (void)testGetFoodNameByIdReturnsExpectedRecord {
    FoodName *food = [self.finder getFoodName:@2];
    XCTAssertNotNil(food);
    XCTAssertEqualObjects([food valueForKey:@"englishName"], @"Banana, raw");
}

- (void)testGetFoodNameByIdReturnsNilForUnknownId {
    FoodName *food = [self.finder getFoodName:@9999];
    XCTAssertNil(food);
}

- (void)testSearchFoodByNameFindsEnglishMatchCaseInsensitive {
    NSArray *results = [self.finder searchFoodByName:@"apple"];
    XCTAssertEqual(results.count, 2u);
    NSSet *ids = [NSSet setWithArray:[results valueForKeyPath:@"foodId"]];
    XCTAssertTrue([ids containsObject:@1]);
    XCTAssertTrue([ids containsObject:@4]);
}

- (void)testSearchFoodByNameMultipleWordsAllMustMatch {
    NSArray *results = [self.finder searchFoodByName:@"apple juice"];
    XCTAssertEqual(results.count, 1u);
    XCTAssertEqualObjects([results[0] valueForKey:@"englishName"], @"Apple juice, canned");
}

- (void)testSearchFoodByNameNoMatchReturnsEmpty {
    NSArray *results = [self.finder searchFoodByName:@"pineapple"];
    XCTAssertEqual(results.count, 0u);
}

- (void)testSearchFoodByNameUsesFrenchColumnWhenFrenchActive {
    [[LanguageHelper sharedInstance] setLanguage:@"fr"];
    // Finder caches LanguageHelper at init; re-init so it picks up the switch.
    self.finder = [[Finder alloc] initWithContext:self.ctx];

    NSArray *results = [self.finder searchFoodByName:@"pomme"];
    XCTAssertEqual(results.count, 2u); // "Pomme, crue" and "Jus de pomme, en conserve"

    NSArray *englishSearch = [self.finder searchFoodByName:@"banana"];
    XCTAssertEqual(englishSearch.count, 0u, @"French mode should match French names only");
}

- (void)testSearchFoodByNameIgnoresEmptyWhitespaceTokens {
    NSArray *results = [self.finder searchFoodByName:@"   apple    juice   "];
    XCTAssertEqual(results.count, 1u);
}

- (void)testPredicateWithNameColumnSingleWord {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    self.finder = [[Finder alloc] initWithContext:self.ctx];
    NSString *p = [self.finder predicateWithNameColumn:@"apple"];
    XCTAssertEqualObjects(p, @"englishName contains[cd] 'apple'");
}

- (void)testPredicateWithNameColumnMultipleWordsJoinsWithAnd {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    self.finder = [[Finder alloc] initWithContext:self.ctx];
    NSString *p = [self.finder predicateWithNameColumn:@"apple juice"];
    XCTAssertEqualObjects(p, @"englishName contains[cd] 'apple' && englishName contains[cd] 'juice'");
}

- (void)testPredicateWithNameColumnEscapesSingleQuote {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    self.finder = [[Finder alloc] initWithContext:self.ctx];
    NSString *p = [self.finder predicateWithNameColumn:@"d'oeuf"];
    XCTAssertTrue([p containsString:@"d\\'oeuf"]);
}

- (void)testPredicateWithNameColumnSwitchesColumnInFrench {
    [[LanguageHelper sharedInstance] setLanguage:@"fr"];
    self.finder = [[Finder alloc] initWithContext:self.ctx];
    NSString *p = [self.finder predicateWithNameColumn:@"pomme"];
    XCTAssertEqualObjects(p, @"frenchName contains[cd] 'pomme'");
}

@end
