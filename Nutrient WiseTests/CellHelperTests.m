//
//  CellHelperTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "CellHelper.h"
#import "LanguageHelper.h"
#import "FoodName.h"
#import "NutritiveName.h"
#import "NutritiveValue.h"
#import "ConversionFactor.h"
#import "Measure.h"
#import "NWTestSupport.h"

@interface CellHelperTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@end

@implementation CellHelperTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
    [[LanguageHelper sharedInstance] setLanguage:@"en"];
    self.ctx = [NWTestSupport newInMemoryContext];
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    self.ctx = nil;
    [super tearDown];
}

- (void)testSharedInstanceIsSingleton {
    CellHelper *a = [CellHelper sharedInstance];
    CellHelper *b = [CellHelper sharedInstance];
    XCTAssertNotNil(a);
    XCTAssertTrue(a == b);
}

- (void)testNutrientNameForRowUsesEnglishColumn {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    FoodName *food = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    NutritiveName *protein = [NWTestSupport insertNutritiveNameWithSymbol:@"PROT"
                                                               englishName:@"Protein"
                                                                frenchName:@"Protéines"
                                                                      unit:@"g"
                                                                 inContext:self.ctx];
    NutritiveValue *nv = [NWTestSupport insertNutritiveValue:5.2 name:protein food:food inContext:self.ctx];

    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *name = [[CellHelper sharedInstance] nutrientNameForRow:path nutritiveValues:@[nv]];
    XCTAssertEqualObjects(name, @"Protein");
}

- (void)testNutrientNameForRowUsesFrenchColumnInFrenchMode {
    [[LanguageHelper sharedInstance] setLanguage:@"fr"];

    FoodName *food = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    NutritiveName *protein = [NWTestSupport insertNutritiveNameWithSymbol:@"PROT"
                                                               englishName:@"Protein"
                                                                frenchName:@"Protéines"
                                                                      unit:@"g"
                                                                 inContext:self.ctx];
    NutritiveValue *nv = [NWTestSupport insertNutritiveValue:5.2 name:protein food:food inContext:self.ctx];

    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *name = [[CellHelper sharedInstance] nutrientNameForRow:path nutritiveValues:@[nv]];
    XCTAssertEqualObjects(name, @"Protéines");
}

- (void)testMakeNutientValueCellProducesCellWithNameAndValue {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    FoodName *food = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    NutritiveName *kcal = [NWTestSupport insertNutritiveNameWithSymbol:@"KCAL"
                                                            englishName:@"Energy"
                                                             frenchName:@"Énergie"
                                                                   unit:@"kcal"
                                                              inContext:self.ctx];
    NutritiveValue *nv = [NWTestSupport insertNutritiveValue:95.0 name:kcal food:food inContext:self.ctx];

    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                       style:UITableViewStylePlain];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [[CellHelper sharedInstance] makeNutientValueCell:table
                                                                 rowIdentifier:@"NVC"
                                                                nutritiveValues:@[nv]
                                                                      indexPath:path
                                                               conversionFactor:nil
                                                                      avecIndex:NO];
    XCTAssertNotNil(cell);
    XCTAssertEqualObjects(cell.textLabel.text, @"Energy");
    XCTAssertTrue([cell.detailTextLabel.text hasSuffix:@"kcal"]);
    XCTAssertTrue([cell.detailTextLabel.text hasPrefix:@"95"]);
}

- (void)testMakeNutientValueCellAppliesConversionFactor {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    FoodName *food = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    NutritiveName *kcal = [NWTestSupport insertNutritiveNameWithSymbol:@"KCAL"
                                                            englishName:@"Energy"
                                                             frenchName:@"Énergie"
                                                                   unit:@"kcal"
                                                              inContext:self.ctx];
    NutritiveValue *nv = [NWTestSupport insertNutritiveValue:100.0 name:kcal food:food inContext:self.ctx];
    Measure *cup = [NWTestSupport insertMeasureWithId:7 englishName:@"1 cup" frenchName:@"1 tasse" inContext:self.ctx];
    ConversionFactor *cf = [NWTestSupport insertConversionFactor:2.5 measure:cup food:food inContext:self.ctx];

    UITableView *table = [[UITableView alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [[CellHelper sharedInstance] makeNutientValueCell:table
                                                                 rowIdentifier:@"NVC"
                                                                nutritiveValues:@[nv]
                                                                      indexPath:path
                                                               conversionFactor:cf
                                                                      avecIndex:YES];
    // 100 * 2.5 = 250
    XCTAssertTrue([cell.detailTextLabel.text hasPrefix:@"250"]);
}

- (void)testMakeNutientValueCellIgnoresZeroConversionFactor {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    FoodName *food = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    NutritiveName *kcal = [NWTestSupport insertNutritiveNameWithSymbol:@"KCAL"
                                                            englishName:@"Energy"
                                                             frenchName:@"Énergie"
                                                                   unit:@"kcal"
                                                              inContext:self.ctx];
    NutritiveValue *nv = [NWTestSupport insertNutritiveValue:77.0 name:kcal food:food inContext:self.ctx];
    Measure *m = [NWTestSupport insertMeasureWithId:9 englishName:@"none" frenchName:@"aucun" inContext:self.ctx];
    ConversionFactor *cf = [NWTestSupport insertConversionFactor:0.0 measure:m food:food inContext:self.ctx];

    UITableView *table = [[UITableView alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [[CellHelper sharedInstance] makeNutientValueCell:table
                                                                 rowIdentifier:@"NVC"
                                                                nutritiveValues:@[nv]
                                                                      indexPath:path
                                                               conversionFactor:cf
                                                                      avecIndex:NO];
    // Zero conversion is ignored; raw value passes through.
    XCTAssertTrue([cell.detailTextLabel.text hasPrefix:@"77"]);
}

- (void)testMakeFoodNameCellShowsEnglishName {
    [[LanguageHelper sharedInstance] setLanguage:@"en"];

    FoodName *apple = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    UITableView *table = [[UITableView alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [[CellHelper sharedInstance] makeFoodNameCell:table
                                                             rowIdentifier:@"FNC"
                                                                 indexPath:path
                                                             searchResults:@[apple]];
    XCTAssertNotNil(cell);
    XCTAssertEqualObjects(cell.textLabel.text, @"Apple");
    XCTAssertEqual(cell.accessoryType, UITableViewCellAccessoryDisclosureIndicator);
}

- (void)testMakeFoodNameCellShowsFrenchNameInFrenchMode {
    [[LanguageHelper sharedInstance] setLanguage:@"fr"];

    FoodName *apple = [NWTestSupport insertFoodWithId:1 englishName:@"Apple" frenchName:@"Pomme" inContext:self.ctx];
    UITableView *table = [[UITableView alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [[CellHelper sharedInstance] makeFoodNameCell:table
                                                             rowIdentifier:@"FNC"
                                                                 indexPath:path
                                                             searchResults:@[apple]];
    XCTAssertEqualObjects(cell.textLabel.text, @"Pomme");
}

@end
