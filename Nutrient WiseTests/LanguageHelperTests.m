//
//  LanguageHelperTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import "LanguageHelper.h"
#import "NWTestSupport.h"

@interface LanguageHelperTests : XCTestCase
@end

@implementation LanguageHelperTests

- (void)setUp {
    [super setUp];
    [NWTestSupport resetUserDefaults];
    // Drop the cached bundle so it gets re-resolved per test.
    ((LanguageHelper *)[LanguageHelper sharedInstance]).bundle = nil;
}

- (void)tearDown {
    [NWTestSupport resetUserDefaults];
    ((LanguageHelper *)[LanguageHelper sharedInstance]).bundle = nil;
    [super tearDown];
}

- (void)testSharedInstanceIsSingleton {
    LanguageHelper *a = (LanguageHelper *)[LanguageHelper sharedInstance];
    LanguageHelper *b = (LanguageHelper *)[LanguageHelper sharedInstance];
    XCTAssertNotNil(a);
    XCTAssertTrue(a == b, @"sharedInstance must return the same object");
}

- (void)testSupportedLanguagesContainsEnAndFr {
    NSArray *langs = [[LanguageHelper sharedInstance] supportedLanguages];
    XCTAssertEqual(langs.count, 2u);
    XCTAssertTrue([langs containsObject:@"en"]);
    XCTAssertTrue([langs containsObject:@"fr"]);
}

- (void)testLanguageDefaultsToEnglishWhenUnset {
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    XCTAssertEqualObjects([h language], @"en");
    XCTAssertFalse([h french]);
    XCTAssertEqualObjects([h nameColumn], @"englishName");
}

- (void)testSetLanguageFrench {
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    [h setLanguage:@"fr"];
    XCTAssertEqualObjects([h language], @"fr");
    XCTAssertTrue([h french]);
    XCTAssertEqualObjects([h nameColumn], @"frenchName");
}

- (void)testSetLanguageEnglish {
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    [h setLanguage:@"fr"];
    [h setLanguage:@"en"];
    XCTAssertEqualObjects([h language], @"en");
    XCTAssertFalse([h french]);
}

- (void)testLanguageTruncatesLocaleStringsLongerThanTwoChars {
    // iOS sometimes hands back "en-CA", "fr-CA". LanguageHelper trims to 2.
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:@"en-CA" forKey:@"language"];
    XCTAssertEqualObjects([h language], @"en");

    [[NSUserDefaults standardUserDefaults] setObject:@"fr-CA" forKey:@"language"];
    XCTAssertEqualObjects([h language], @"fr");
}

- (void)testLanguageFallsBackToEnglishForUnsupportedLocale {
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:@"es" forKey:@"language"];
    XCTAssertEqualObjects([h language], @"en");

    [[NSUserDefaults standardUserDefaults] setObject:@"de-DE" forKey:@"language"];
    XCTAssertEqualObjects([h language], @"en");
}

- (void)testLocalizedStringLoadsBundleForCurrentLanguage {
    LanguageHelper *h = (LanguageHelper *)[LanguageHelper sharedInstance];
    [h setLanguage:@"en"];
    // We don't assert a specific translation (that would couple to string
    // files), but localizedString: must return a non-nil NSString and must
    // populate the bundle as a side effect.
    h.bundle = nil;
    NSString *value = [h localizedString:@"some_key"];
    XCTAssertNotNil(value);
    XCTAssertTrue([value isKindOfClass:[NSString class]]);
    XCTAssertNotNil(h.bundle, @"localizedString: must resolve and cache a bundle");
}

@end
