//
//  ProfileHelperTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import "ProfileHelper.h"
#import "NWTestSupport.h"

@interface ProfileHelperTests : XCTestCase
@end

@implementation ProfileHelperTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    [super tearDown];
}

- (void)testSharedInstanceIsSingleton {
    ProfileHelper *a = [ProfileHelper sharedInstance];
    ProfileHelper *b = [ProfileHelper sharedInstance];
    XCTAssertNotNil(a);
    XCTAssertTrue(a == b);
}

- (void)testSupportedProfilesCount {
    NSArray *p = [[ProfileHelper sharedInstance] supportedProfiles];
    XCTAssertEqual(p.count, 6u);
}

- (void)testSupportedProfilesContainsAllKnownKeys {
    NSArray *p = [[ProfileHelper sharedInstance] supportedProfiles];
    XCTAssertTrue([p containsObject:@"generic"]);
    XCTAssertTrue([p containsObject:@"rein"]);
    XCTAssertTrue([p containsObject:@"diabete"]);
    XCTAssertTrue([p containsObject:@"lipide"]);
    XCTAssertTrue([p containsObject:@"hypertension"]);
    XCTAssertTrue([p containsObject:@"enceinte"]);
}

- (void)testGenericProfileKey {
    XCTAssertEqualObjects([[ProfileHelper sharedInstance] genericProfileKey], @"generic");
}

- (void)testSelectedProfileIsNilByDefault {
    XCTAssertNil([[ProfileHelper sharedInstance] selectedProfile]);
    XCTAssertFalse([[ProfileHelper sharedInstance] genericProfileSelected]);
}

- (void)testSetSelectedProfilePersists {
    ProfileHelper *h = [ProfileHelper sharedInstance];
    [h setSelectedProfile:@"rein"];
    XCTAssertEqualObjects([h selectedProfile], @"rein");
    XCTAssertFalse([h genericProfileSelected]);
}

- (void)testGenericProfileSelectedTrueAfterSet {
    ProfileHelper *h = [ProfileHelper sharedInstance];
    [h setSelectedProfile:@"generic"];
    XCTAssertTrue([h genericProfileSelected]);
}

- (void)testNutritiveSymbolsForGeneric {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"generic"];
    NSArray *expected = @[@"KCAL", @"FAT", @"TSAT", @"TRFA", @"CHOL", @"NA", @"CARB", @"TDF", @"TSUG", @"PROT"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForRenal {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"rein"];
    NSArray *expected = @[@"PROT", @"H2O", @"K", @"P", @"NA", @"MG"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForDiabetes {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"diabete"];
    NSArray *expected = @[@"CARB", @"TSUG", @"STAR"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForLipids {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"lipide"];
    NSArray *expected = @[@"CHOL", @"TRFA", @"MUFA", @"PUFA", @"TSAT", @"FAT"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForHypertension {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"hypertension"];
    XCTAssertEqualObjects(symbols, @[@"NA"]);
}

- (void)testNutritiveSymbolsForPregnancy {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"enceinte"];
    NSArray *expected = @[@"PROT", @"FE", @"CA", @"TDF"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForUnknownProfileFallsBackToGeneric {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:@"totally-made-up"];
    NSArray *expected = @[@"KCAL", @"FAT", @"TSAT", @"TRFA", @"CHOL", @"NA", @"CARB", @"TDF", @"TSUG", @"PROT"];
    XCTAssertEqualObjects(symbols, expected);
}

- (void)testNutritiveSymbolsForNilProfileFallsBackToGeneric {
    NSArray *symbols = [[ProfileHelper sharedInstance] nutritiveSymbolsForProfile:nil];
    XCTAssertEqual(symbols.count, 10u);
    XCTAssertEqualObjects(symbols[0], @"KCAL");
}

@end
