//
//  TrackingStatusTests.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <objc/runtime.h>
#import "TrackingStatus.h"

@interface TrackingStatusTests : XCTestCase

@end

@implementation TrackingStatusTests

- (void)testTrackingStatusHasADateProperty
{
    XCTAssertTrue(class_getProperty([TrackingStatus class], "date"), @"TrackingStatus object should have a date property");
}

- (void)testTrackingStatusHasALocationProperty
{
    XCTAssertTrue(class_getProperty([TrackingStatus class], "location"), @"TrackingStatus object should have a location property");
}

- (void)testTrackingStatusHasAMessageProperty
{
    XCTAssertTrue(class_getProperty([TrackingStatus class], "message"), @"TrackingStatus object should have a message property");
}

@end
