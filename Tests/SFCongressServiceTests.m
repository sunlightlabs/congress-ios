//
//  SFCongressServiceTests.m
//  Congress
//
//  Created by Daniel Cloud on 2/9/15.
//  Copyright (c) 2015 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SFBillService.h"
#import "SFCommitteeService.h"
#import "SFHearingService.h"
#import "SFLegislatorService.h"
#import "SFRollCallVoteService.h"

@interface SFCongressServiceTests : XCTestCase

@property (nonatomic, strong) OHHTTPStubsResponse *noResultsResponse;

@end

@implementation SFCongressServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (self.noResultsResponse == nil) {
        self.noResultsResponse = [OHHTTPStubsResponse responseWithJSONObject:@{@"count": @0, @"page": @{ @"count": @0, @"per_page": @0, @"page": @1} } statusCode:200 headers:@{}];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNoResultsBillService {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"congress.api.sunlightfoundation.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return self.noResultsResponse;
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Test SFBillService missing results in JSON"];

    [SFBillService billsWithIds:@[@"foo"] completionBlock:^(NSArray *resultsArray) {
        XCTAssertNotNil(resultsArray);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Test failed! %@", error);
    }];

    [OHHTTPStubs removeLastStub];
    
}

- (void)testNoResultsCommitteeService {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"congress.api.sunlightfoundation.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return self.noResultsResponse;
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Test SFCommitteeService missing results in JSON"];

    [SFCommitteeService committeesWithCompletionBlock:^(NSArray *committees) {
        XCTAssertNotNil(committees);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Test failed! %@", error);
    }];

    [OHHTTPStubs removeLastStub];
    
}

- (void)testNoResultsHearingService {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"congress.api.sunlightfoundation.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return self.noResultsResponse;
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Test SFHearingService missing results in JSON"];

    [SFHearingService hearingsForCommitteeId:@"foo" completionBlock:^(NSArray *hearings) {
        XCTAssertNotNil(hearings);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Test failed! %@", error);
    }];

    [OHHTTPStubs removeLastStub];
    
}

- (void)testNoResultsLegislatorService {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"congress.api.sunlightfoundation.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return self.noResultsResponse;
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Test SFLegislatorService missing results in JSON"];
    // This is an example of a functional test case.
    //    XCTAssert(YES, @"Pass");
    [SFLegislatorService legislatorsWithParameters:@{@"last_name": @"Tillis"} completionBlock:^(NSArray *resultsArray) {
        XCTAssertNotNil(resultsArray);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Test failed! %@", error);
    }];

    [OHHTTPStubs removeLastStub];
    
}

- (void)testNoResultsRollCallVoteService {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"congress.api.sunlightfoundation.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return self.noResultsResponse;
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Test SFRollCallVoteService missing results in JSON"];

    [SFRollCallVoteService votesForBill:@"foo" completionBlock:^(NSArray *resultsArray) {
        XCTAssertNotNil(resultsArray);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Test failed! %@", error);
    }];

    [OHHTTPStubs removeLastStub];
    
}

@end
