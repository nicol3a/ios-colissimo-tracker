//
//  TrackerTableViewControllerTests.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>
#import <OCMock/OCMock.h>
#import "TrackerTableViewController.h"
#import "TrackerTableViewCell.h"
#import "TrackingStatus.h"
#import "TrackerDownloader.h"

@interface TrackerTableViewControllerTests : XCTestCase

@property (strong, nonatomic) TrackerTableViewController *tableViewController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) TrackingStatus *trackingStatus;

@end

@implementation TrackerTableViewControllerTests

- (void)setUp {
    [super setUp];
    self.tableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Tracker Main View"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    self.trackingStatus = [[TrackingStatus alloc] init];
    self.trackingStatus.date = [self.dateFormatter dateFromString:@"25/04/2015"];
    self.trackingStatus.location = @"Brussels";
    self.trackingStatus.message = @"Colis acheminé";
}

- (void)tearDown {
    self.tableViewController = nil;
    self.dateFormatter = nil;
    self.trackingStatus = nil;
    [super tearDown];
}

- (void)testTrackingStatusesArrayShouldBeInitializedWithZeroObject
{
    [self.tableViewController viewDidLoad];
    XCTAssertNotNil(self.tableViewController.trackingStatuses, @"The tracking statuses array should be initialized in viewDidLoad");
    XCTAssertEqual(self.tableViewController.trackingStatuses.count, 0, @"The tracking statuses array should contain zero objects initially");
}

- (void)testControllerShouldHaveADownloaderProperty
{
    XCTAssertTrue(class_getProperty([TrackerTableViewController class], "downloader"), @"TrackerTableViewController object should have a downloader property");
}

- (void)testDownloaderPropertyIsInitializedInViewDidLoad
{
    [self.tableViewController viewDidLoad];
    XCTAssertNotNil(self.tableViewController.downloader, @"Downloader property should be initialized in viewDidLoad");
}

- (void)testTrackerViewCellIsRegisteredForReuseIdentifierInViewDidLoad
{
    [self.tableViewController viewDidLoad];
    TrackerTableViewCell *cell =  [self.tableViewController.tableView dequeueReusableCellWithIdentifier:kTrackerTableViewCellIdentifier];
    XCTAssertNotNil(cell, @"TrackerTableViewCell cell should be registered in the table view");
}

- (void)testRefreshControlIsInitializedInViewDidLoad
{
    [self.tableViewController viewDidLoad];
    XCTAssertNotNil(self.tableViewController.refreshControl, @"Refresh control should be initialized in viewDidLoad");
}

- (void)testRefreshControlActionTargetIsCorrectlyInitialized
{
    NSSet *targets = [self.tableViewController.refreshControl allTargets];
    XCTAssertEqual(targets.count, 1, @"Refresh control target should be set and call downloadTrackingStatuses action");
}

- (void)testControllerImplementsTrackerDownloaderDelegate
{
    XCTAssertTrue([self.tableViewController conformsToProtocol:@protocol(TrackerDownloaderDelegate)], @"Controller should implement TrackerDownloaderDelegate protocol");
}

- (void)testControllerImplementsTrackerDownloaderDelegateMethod
{
    XCTAssertTrue([self.tableViewController respondsToSelector:@selector(trackerDownloader:didDownloadTrackingStatuses:)], @"Controller should implement TrackerDownloaderDelegate method");
}

- (void)testDownloaderDelegatePropertyIsImplementedInTrackerTableViewController
{
    [self.tableViewController viewDidLoad];
    XCTAssertEqualObjects(self.tableViewController.downloader.delegate, self.tableViewController, @"Downloader's delegate property should be equal to TrackerTableViewController");
}

- (void)testTableViewNumberOfSectionIsEqualToOne
{
    NSInteger numberOfSections = [self.tableViewController numberOfSectionsInTableView:nil];
    XCTAssertEqual(numberOfSections, 1, @"There should be only one section in the table view");
}

- (void)testTableViewNumberOfRowsReturnTheNumberOfTrackingStatuses
{
    self.tableViewController.trackingStatuses = @[@"1", @"2", @"3"];
    NSInteger numberOfRows = [self.tableViewController tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(numberOfRows, 3, @"There should be as many rows as in the tracking status array");
}

- (void)testTableViewShouldReturnATrackerTableViewCellAtIndexPath
{
    [self.tableViewController viewDidLoad];
    self.tableViewController.trackingStatuses = @[self.trackingStatus];
    TrackerTableViewCell *cell = (TrackerTableViewCell *)[self.tableViewController tableView:self.tableViewController.tableView
                                                                       cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    XCTAssertTrue([cell isKindOfClass:[TrackerTableViewCell class]], @"Cell for row at index path should return a TrackerTableViewCell object");
    XCTAssertNotNil(cell, @"Table view cell for row at index path should return a valid cell");
}

- (void)testTableViewCellIsConfigured
{
    [self.tableViewController viewDidLoad];
    self.tableViewController.trackingStatuses = @[self.trackingStatus];
    TrackerTableViewCell *cell = (TrackerTableViewCell *)[self.tableViewController tableView:self.tableViewController.tableView
                                                                       cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqualObjects(cell.locationLabel.text, self.trackingStatus.location, @"Cell should be configured in cellForRowAtIndexPath method");
}

- (void)testTableViewCellIsConfiguredWithTrackingStatusesArrayObject
{
    TrackingStatus *secondTrackingStatus = [[TrackingStatus alloc] init];
    secondTrackingStatus.date = [self.dateFormatter dateFromString:@"25/04/2015"];
    secondTrackingStatus.location = @"Cupertino";
    secondTrackingStatus.message = @"Colis acheminé";

    [self.tableViewController viewDidLoad];
    self.tableViewController.trackingStatuses = @[self.trackingStatus, secondTrackingStatus];
    TrackerTableViewCell *cell = (TrackerTableViewCell *)[self.tableViewController tableView:self.tableViewController.tableView
                                                                       cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertEqualObjects(cell.locationLabel.text, secondTrackingStatus.location, @"Cell should be configured in cellForRowAtIndexPath method");
}

- (void)testControllerShouldDownloadTrackingStatuses
{
    id mockDownloader = OCMClassMock([TrackerDownloader class]);
    
    [self.tableViewController viewDidLoad];
    self.tableViewController.downloader = mockDownloader;
    [self.tableViewController downloadTrackingStatuses];
    
    OCMVerify([mockDownloader downloadTrackingStatuses]);
}

- (void)testTrackingStatusesArrayIsUpdatedWhenDownloadIsFinishedWithDownloadResult
{
    [self.tableViewController viewDidLoad];
    XCTAssertEqual(self.tableViewController.trackingStatuses.count, 0, @"Tracking statuses array should be equal to zero before download");
    [self.tableViewController trackerDownloader:nil didDownloadTrackingStatuses:@[self.trackingStatus]];
    XCTAssertEqual(self.tableViewController.trackingStatuses.count, 1, @"Tracking statuses array should be equal to one after download");
}

//- (void)testRefreshControlIsHiddenAfterDownload
//{
//    id mockRefreshControl = OCMClassMock([UIRefreshControl class]);
//    
//    [self.tableViewController viewDidLoad];
//    self.tableViewController.refreshControl = mockRefreshControl;
//    [self.tableViewController updateUIAfterDownload];
//    
//    OCMVerify([mockRefreshControl endRefreshing]);
//}

- (void)testTableViewIsReloadedAfterDownload
{
    id mockTableView = OCMClassMock([UITableView class]);
    
    [self.tableViewController viewDidLoad];
    self.tableViewController.tableView = mockTableView;
    [self.tableViewController updateUIAfterDownload];
    
    OCMVerify([mockTableView reloadData]);
}

- (void)testNetworkActivityIndicatorIsVisibleWhenDownloadStarts
{
    [self.tableViewController viewDidLoad];
    [self.tableViewController downloadTrackingStatuses];
    XCTAssertTrue([UIApplication sharedApplication].isNetworkActivityIndicatorVisible, @"Network activity indicator should be visible when the download starts");
}

- (void)testNetworkActivityIndicatorIsHiddenWhenDownloadStops
{
    [self.tableViewController viewDidLoad];
    [self.tableViewController updateUIAfterDownload];
    XCTAssertFalse([UIApplication sharedApplication].isNetworkActivityIndicatorVisible, @"Network activity indicator should be hidden when the download stops");
}

@end
