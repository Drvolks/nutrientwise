//
//  ArrayHelperTests.m
//  Nutrient WiseTests
//

#import <XCTest/XCTest.h>
#import "ArrayHelper.h"

@interface ArrayHelperTests : XCTestCase
@end

@implementation ArrayHelperTests

- (void)testSharedInstanceIsSingleton {
    ArrayHelper *a = [ArrayHelper sharedInstance];
    ArrayHelper *b = [ArrayHelper sharedInstance];
    XCTAssertNotNil(a);
    XCTAssertTrue(a == b);
}

- (void)testSortAscendingByName {
    NSArray *input = @[
        @{@"name": @"Carrot"},
        @{@"name": @"Apple"},
        @{@"name": @"Banana"},
    ];
    NSArray *sorted = [[ArrayHelper sharedInstance] sort:input key:@"name" ascending:YES];
    XCTAssertEqualObjects([sorted[0] objectForKey:@"name"], @"Apple");
    XCTAssertEqualObjects([sorted[1] objectForKey:@"name"], @"Banana");
    XCTAssertEqualObjects([sorted[2] objectForKey:@"name"], @"Carrot");
}

- (void)testSortDescendingByName {
    NSArray *input = @[
        @{@"name": @"Apple"},
        @{@"name": @"Banana"},
        @{@"name": @"Carrot"},
    ];
    NSArray *sorted = [[ArrayHelper sharedInstance] sort:input key:@"name" ascending:NO];
    XCTAssertEqualObjects([sorted[0] objectForKey:@"name"], @"Carrot");
    XCTAssertEqualObjects([sorted[2] objectForKey:@"name"], @"Apple");
}

- (void)testSortEmptyArray {
    NSArray *sorted = [[ArrayHelper sharedInstance] sort:@[] key:@"name" ascending:YES];
    XCTAssertEqual(sorted.count, 0u);
}

- (void)testSortSingleElementArray {
    NSArray *input = @[@{@"name": @"Only"}];
    NSArray *sorted = [[ArrayHelper sharedInstance] sort:input key:@"name" ascending:YES];
    XCTAssertEqual(sorted.count, 1u);
    XCTAssertEqualObjects([sorted[0] objectForKey:@"name"], @"Only");
}

- (void)testSortNumericValuesAscending {
    NSArray *input = @[
        @{@"n": @3},
        @{@"n": @1},
        @{@"n": @2},
    ];
    NSArray *sorted = [[ArrayHelper sharedInstance] sort:input key:@"n" ascending:YES];
    XCTAssertEqualObjects([sorted[0] objectForKey:@"n"], @1);
    XCTAssertEqualObjects([sorted[2] objectForKey:@"n"], @3);
}

- (void)testSortMutableArrayReturnsMutable {
    NSMutableArray *input = [@[
        @{@"name": @"Banana"},
        @{@"name": @"Apple"},
    ] mutableCopy];
    NSMutableArray *sorted = [[ArrayHelper sharedInstance] sortMutableArray:input
                                                                        key:@"name"
                                                                  ascending:YES];
    XCTAssertTrue([sorted isKindOfClass:[NSMutableArray class]]);
    XCTAssertEqualObjects([sorted[0] objectForKey:@"name"], @"Apple");
    XCTAssertEqualObjects([sorted[1] objectForKey:@"name"], @"Banana");
}

- (void)testSortIsStableAcrossCalls {
    NSArray *input = @[@{@"k": @"b"}, @{@"k": @"a"}, @{@"k": @"c"}];
    NSArray *first = [[ArrayHelper sharedInstance] sort:input key:@"k" ascending:YES];
    NSArray *second = [[ArrayHelper sharedInstance] sort:input key:@"k" ascending:YES];
    XCTAssertEqualObjects(first, second);
}

@end
