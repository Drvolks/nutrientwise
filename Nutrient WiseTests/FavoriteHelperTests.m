//
//  FavoriteHelperTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import "FavoriteHelper.h"
#import "FoodName.h"
#import "Measure.h"
#import "ConversionFactor.h"
#import "NWTestSupport.h"

@interface FavoriteHelperTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@end

@implementation FavoriteHelperTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
    self.ctx = [NWTestSupport newInMemoryContext];
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    self.ctx = nil;
    [super tearDown];
}

- (void)testSharedInstanceIsSingleton {
    FavoriteHelper *a = [FavoriteHelper sharedInstance];
    FavoriteHelper *b = [FavoriteHelper sharedInstance];
    XCTAssertNotNil(a);
    XCTAssertTrue(a == b);
}

- (void)testNoFavoritesInitially {
    NSMutableDictionary *favs = [[FavoriteHelper sharedInstance] favotiteFoodIds];
    XCTAssertNotNil(favs);
    XCTAssertEqual(favs.count, 0u);
}

- (void)testIsFavoriteReturnsNoForUnknownFood {
    FoodName *food = [NWTestSupport insertFoodWithId:42 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    XCTAssertFalse([[FavoriteHelper sharedInstance] isFavorite:food]);
}

- (void)testAddFoodToFavorite {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *food = [NWTestSupport insertFoodWithId:100 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];

    [h addFoodToFavorite:food];

    XCTAssertTrue([h isFavorite:food]);
    NSMutableDictionary *favs = [h favotiteFoodIds];
    XCTAssertEqual(favs.count, 1u);
    XCTAssertNotNil([favs objectForKey:@"100"]);
}

- (void)testAddMultipleFavoritesTracksAll {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *apple = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    FoodName *banana = [NWTestSupport insertFoodWithId:2 englishName:@"Banana" frenchName:@"Banane" inContext:self.ctx];
    FoodName *carrot = [NWTestSupport insertFoodWithId:3 englishName:@"Carrot" frenchName:@"Carotte" inContext:self.ctx];

    [h addFoodToFavorite:apple];
    [h addFoodToFavorite:banana];
    [h addFoodToFavorite:carrot];

    XCTAssertTrue([h isFavorite:apple]);
    XCTAssertTrue([h isFavorite:banana]);
    XCTAssertTrue([h isFavorite:carrot]);
    XCTAssertEqual([h favotiteFoodIds].count, 3u);
}

- (void)testRemoveFavorite {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *food = [NWTestSupport insertFoodWithId:55 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];

    [h addFoodToFavorite:food];
    XCTAssertTrue([h isFavorite:food]);

    [h removeFavorite:food];
    XCTAssertFalse([h isFavorite:food]);
    XCTAssertEqual([h favotiteFoodIds].count, 0u);
}

- (void)testRemoveFavoriteThatIsNotPresentIsHarmless {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *food = [NWTestSupport insertFoodWithId:99 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    XCTAssertNoThrow([h removeFavorite:food]);
    XCTAssertFalse([h isFavorite:food]);
}

- (void)testAddConversionToFavorite {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *food = [NWTestSupport insertFoodWithId:200 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    Measure *cup = [NWTestSupport insertMeasureWithId:7 englishName:@"1 cup" frenchName:@"1 tasse" inContext:self.ctx];
    ConversionFactor *cf = [NWTestSupport insertConversionFactor:1.25 measure:cup food:food inContext:self.ctx];

    [h addConversionToFavorite:cf foodName:food];

    NSNumber *measureId = [h favoriteConversionMeasure:food];
    XCTAssertEqualObjects(measureId, @7);
}

- (void)testAddConversionReplacesPreviousConversionForSameFood {
    FavoriteHelper *h = [FavoriteHelper sharedInstance];
    FoodName *food = [NWTestSupport insertFoodWithId:300 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    Measure *cup = [NWTestSupport insertMeasureWithId:7 englishName:@"1 cup" frenchName:@"1 tasse" inContext:self.ctx];
    Measure *slice = [NWTestSupport insertMeasureWithId:8 englishName:@"1 slice" frenchName:@"1 tranche" inContext:self.ctx];
    ConversionFactor *cfCup = [NWTestSupport insertConversionFactor:1.0 measure:cup food:food inContext:self.ctx];
    ConversionFactor *cfSlice = [NWTestSupport insertConversionFactor:0.3 measure:slice food:food inContext:self.ctx];

    [h addConversionToFavorite:cfCup foodName:food];
    XCTAssertEqualObjects([h favoriteConversionMeasure:food], @7);

    [h addConversionToFavorite:cfSlice foodName:food];
    XCTAssertEqualObjects([h favoriteConversionMeasure:food], @8);
}

- (void)testFavoriteConversionMeasureNilWhenNeverSet {
    FoodName *food = [NWTestSupport insertFoodWithId:400 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    XCTAssertNil([[FavoriteHelper sharedInstance] favoriteConversionMeasure:food]);
}

- (void)testFavotiteIdsReturnsFreshDictWhenNoData {
    NSMutableDictionary *d = [[FavoriteHelper sharedInstance] favotiteIds:@"never-written-key"];
    XCTAssertNotNil(d);
    XCTAssertEqual(d.count, 0u);
}

@end
