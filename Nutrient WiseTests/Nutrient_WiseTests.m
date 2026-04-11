//
//  Nutrient_WiseTests.m
//  Nutrient WiseTests
//
//  Legacy entry point kept so the existing pbxproj reference still builds.
//  Real coverage lives in per-class files: LanguageHelperTests,
//  ProfileHelperTests, ArrayHelperTests, FavoriteHelperTests, FinderTests.
//

#import "Nutrient_WiseTests.h"

@implementation Nutrient_WiseTests

- (void)testHostAppLoads {
    // Smoke test: the host app bundle must load or nothing else will run.
    XCTAssertNotNil([NSBundle mainBundle]);
}

@end
