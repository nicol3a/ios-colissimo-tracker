//
//  TrackerTableViewCellTests.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>
#import "TrackerTableViewCell.h"
#import "TrackingStatus.h"

@interface TrackerTableViewCellTests : XCTestCase

@property (strong, nonatomic) TrackerTableViewCell *cell;

@end

@implementation TrackerTableViewCellTests

- (void)setUp {
    [super setUp];
    self.cell = [[NSBundle mainBundle] loadNibNamed:kTrackerTableViewCellIdentifier owner:self options:nil].firstObject;
}

- (void)tearDown {
    self.cell = nil;
    [super tearDown];
}

- (void)testCellHasADateLabelProperty
{
    XCTAssertTrue(class_getProperty([TrackerTableViewCell class], "dateLabel"), @"TrackingTableViewCell object should have a dateLabel property");
}

- (void)testCellHasALocationLabelProperty
{
    XCTAssertTrue(class_getProperty([TrackerTableViewCell class], "locationLabel"), @"TrackingTableViewCell object should have a locationLabel property");
}

- (void)testCellHasAMessageLabelProperty
{
    XCTAssertTrue(class_getProperty([TrackerTableViewCell class], "messageLabel"), @"TrackingTableViewCell object should have a messageLabel property");
}

- (void)testCellDateLabelOutletIsLinked
{
    XCTAssertNotNil(self.cell.dateLabel, @"Date label outlet should be linked");
}

- (void)testCellLocationLabelOutletIsLinked
{
    XCTAssertNotNil(self.cell.locationLabel, @"Location label outlet should be linked");
}

- (void)testCellMessageLabelOutletIsLinked
{
    XCTAssertNotNil(self.cell.messageLabel, @"Message label outlet should be linked");
}

- (void)testDateFormattedIsEqualToDayMonthInLetterAndYear
{
    XCTAssertEqualObjects(self.cell.dateFormatter.dateFormat, @"dd MMM yyyy", @"Date formatter's format should be equal to 'dd MMM yyyy'");
}

- (void)testConfigureCellWithTrackingStatusObjectCorrectlySetLabelValues
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    TrackingStatus *trackingStatus = [[TrackingStatus alloc] init];
    trackingStatus.date = [dateFormatter dateFromString:@"25/04/2015"];
    trackingStatus.location = @"Brussels";
    trackingStatus.message = @"Colis acheminé";
    
    [self.cell configureForTrackingStatus:trackingStatus];
    
    XCTAssertEqualObjects(self.cell.dateLabel.text, [self.cell.dateFormatter stringFromDate:trackingStatus.date], @"Date label should be equal to '25/04/2015'");
    XCTAssertEqualObjects(self.cell.locationLabel.text, trackingStatus.location, @"Date label should be equal to '25/04/2015'");
    XCTAssertEqualObjects(self.cell.messageLabel.text, trackingStatus.message, @"Date label should be equal to '25/04/2015'");
}

@end
