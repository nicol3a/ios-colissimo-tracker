//
//  TrackerDownloaderTests.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>
#import "TrackerDownloader.h"
#import "TrackingStatus.h"

@interface TrackerDownloaderTests : XCTestCase <TrackerDownloaderDelegate>

@property (strong, nonatomic) TrackerDownloader *downloader;
@property (strong, nonatomic) NSData *responseData;
@property (assign, nonatomic) BOOL delegateCalled;
@property (strong, nonatomic) NSArray *trackingStatuses;

@end

@implementation TrackerDownloaderTests

- (void)setUp {
    [super setUp];
    self.downloader = [[TrackerDownloader alloc] initWithTrackingID:@"CC642475613FR"];
    self.downloader.delegate = self;
    NSString *responseString = @"["\
        "{"\
            "\"date\": \"<td headers=\\\"Date\\\">25/04/2015</td>\","\
            "\"message\": \"<td headers=\\\"Libelle\\\">Votre colis a \u00e9t\u00e9 d\u00e9pos\u00e9 au bureau de poste d&#39;exp\u00e9dition</td>\","\
            "\"lieu\": \"<td headers=\\\"site\\\" class=\\\"last\\\">\\r\\n\\t\\t\\t\\r\\n\\t\\t\\tBureau de Poste St brevin les pins\\r\\n\\t\\t\\t\\r\\n\\t\\t\\t\\r\\n\\t\\t\\t</td> \""\
        "}"\
    "]";
    self.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    self.delegateCalled = NO;
}

- (void)tearDown {
    self.downloader.delegate = nil;
    self.downloader = nil;
    self.responseData = nil;
    self.delegateCalled = NO;
    [super tearDown];
}

- (void)testTrackerDownloaderInitializerWithTrackingIDCorrectlySetTrackingID
{
    XCTAssertEqualObjects(self.downloader.trackingID, @"CC642475613FR", @"Tracking ID should be equal to 'CC642475613FR'");
}

- (void)testBaseURLIsCorrectlySetted
{
    XCTAssertEqualObjects(self.downloader.baseURL, @"http://api.ntag.fr/colissimo/?id=", @"Base URL should be 'http://api.ntag.fr/colissimo/?id='");
}

- (void)testDownloadURLCorrectlyConcatenedBaseURLAndTrackingID
{
    XCTAssertEqualObjects([self.downloader stringURLForDownload], @"http://api.ntag.fr/colissimo/?id=CC642475613FR", @"URL + Tracking ID should be correctly concatened");
}

- (void)testDownloadURLReturnsANotNilValue
{
    XCTAssertNotNil([self.downloader URLForDownload], @"Download URL should returns a not nil object");
}

- (void)testDownloadURLAbsoluteStringIsEqualToStringURL
{
    XCTAssertEqualObjects([[self.downloader URLForDownload] absoluteString], [self.downloader stringURLForDownload], @"Download URL's absolute string property should be equal to download string URL");
}

- (void)testDownloadURLRequestReturnsANotNilValue
{
    XCTAssertNotNil([self.downloader URLRequestForDownload], @"Download URL request should returns a not nil object");
}

- (void)testDownloadURLRequestURLIsEqualToDownloadURL
{
    XCTAssertEqualObjects([[[self.downloader URLRequestForDownload] URL] absoluteString], [[self.downloader URLForDownload] absoluteString], @"Download URL request's URL's absolute string object should be equal to download URL's absolute string object");
}

- (void)testDelegatePropertyImplementsTrackerDownloaderDelegateProtocol
{
    XCTAssertTrue([self.downloader.delegate conformsToProtocol:@protocol(TrackerDownloaderDelegate)], @"Delegate property conforms to TrackingDownloadDelegate protocol");
}

- (void)testHandleDownloadResultCallDelegate
{
    [self.downloader handleDownloadResult:[NSData data]];
    XCTAssertTrue(self.delegateCalled, @"Handling the download result should call the delegate");
}

- (void)testHandleDownloadResultCallDelegateWithDataParsed
{
    [self.downloader handleDownloadResult:self.responseData];
    id trackingStatus = self.trackingStatuses.firstObject;
    XCTAssertTrue([trackingStatus isKindOfClass:[TrackingStatus class]], @"Handling the download result should call the delegate with an array of TrackingStatus objects");
}

#pragma mark - TrackerDownloaderDelegate

- (void)trackerDownloader:(TrackerDownloader *)downloader didDownloadTrackingStatuses:(NSArray *)trackingStatuses
{
    self.delegateCalled = YES;
    self.trackingStatuses = trackingStatuses;
}

@end
