//
//  TrackerParserTests.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>
#import "TrackerParser.h"
#import "TrackingStatus.h"

@interface TrackerParserTests : XCTestCase

@property (strong, nonatomic) TrackerParser *parser;
@property (strong, nonatomic) NSString *responseString;
@property (strong, nonatomic) NSString *responseStringStripped;
@property (strong, nonatomic) NSData *responseData;

@end

@implementation TrackerParserTests

- (void)setUp {
    [super setUp];
    self.responseString = @"["\
        "{"\
            "\"date\": \"<td headers=\\\"Date\\\">25/04/2015</td>\","\
            "\"message\": \"<td headers=\\\"Libelle\\\">Votre colis a \u00e9t\u00e9 d\u00e9pos\u00e9 au bureau de poste d&#39;exp\u00e9dition</td>\","\
            "\"lieu\": \"<td headers=\\\"site\\\" class=\\\"last\\\">\\r\\n\\t\\t\\t\\r\\n\\t\\t\\tBureau de Poste St brevin les pins\\r\\n\\t\\t\\t\\r\\n\\t\\t\\t\\r\\n\\t\\t\\t</td>\""\
        "}"\
    "]";
    self.responseStringStripped = @"["\
        "{"\
            "\"date\": \"<td headers=\\\"Date\\\">25/04/2015</td>\","\
            "\"message\": \"<td headers=\\\"Libelle\\\">Votre colis a \u00e9t\u00e9 d\u00e9pos\u00e9 au bureau de poste d&#39;exp\u00e9dition</td>\","\
            "\"lieu\": \"<td headers=\\\"site\\\" class=\\\"last\\\">Bureau de Poste St brevin les pins</td>\""\
        "}"\
    "]";
    self.responseData = [self.responseString dataUsingEncoding:NSUTF8StringEncoding];
    self.parser = [[TrackerParser alloc] initWithData:self.responseData];
}

- (void)tearDown {
    self.parser = nil;
    self.responseData = nil;
    [super tearDown];
}

- (void)testTrackerParserInitializerWithResponseDataCorrectlySetResponseData
{
    XCTAssertEqual(self.parser.data, self.responseData, @"Response data object should be equal to response data passed through the initializer");
}

- (void)testDataFormatterIsEqualToDayMonthAndYearSeparatedBySlashes
{
    XCTAssertEqualObjects(self.parser.dateFormatter.dateFormat, @"dd/MM/yyyy", @"Data formatter's format should be 'dd/MM/yyyy'");
}

- (void)testRemoveNewLinesAndTabCharactersReturnsStringWithoutTheseCharacters
{
    self.parser.data = [@"\\r\\n\\tBureau de Poste St brevin les pins" dataUsingEncoding:NSUTF8StringEncoding];
    [self.parser stripNewLinesAndTabs];
    NSString *stringStripped = [[NSString alloc] initWithData:self.parser.data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(stringStripped, @"Bureau de Poste St brevin les pins", @"New lines and tabs characters should be removed from the original string");
}

- (void)testReplaceQuoteHexaCharactersReturnsStringWithNormalQuote
{
    self.parser.data = [@"Votre colis a \u00e9t\u00e9 d\u00e9pos\u00e9 au bureau de poste d&#39;exp\u00e9dition" dataUsingEncoding:NSUTF8StringEncoding];
    [self.parser replaceQuoteHexaCharacters];
    NSString *stringEdited = [[NSString alloc] initWithData:self.parser.data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(stringEdited, @"Votre colis a été déposé au bureau de poste d'expédition", @"Quote hexa characters '&#39;' should be replaced by a normal quote");
}

- (void)testStrippingHTML
{
    NSString *sampleHTML = @"<td headers=\\\"Date\\\">25/04/2015</td>";
    XCTAssertEqualObjects([self.parser stringByStrippingHTML:sampleHTML], @"25/04/2015", @"Stripped HTML string should be equal to '25/04/2015'");
}

- (void)testDataConvertedIntoJSONIsNotNil
{
    XCTAssertNotNil([self.parser convertDataIntoJSON], @"Data should be converted into a valid JSON dictionary");
}

- (void)testDataConvertedIntoJSONReturnsAnArray
{
    XCTAssertTrue([[self.parser convertDataIntoJSON] isKindOfClass:[NSArray class]], @"Parsing the data should return an array of elements");
}

- (void)testNotArrayDataConvertedIntoJSONReturnsAnEmptyArray
{
    NSData *notArrayData = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    TrackerParser *parser = [[TrackerParser alloc] initWithData:notArrayData];
    XCTAssertTrue([[parser convertDataIntoJSON] isKindOfClass:[NSArray class]], @"Parsing the data which does not contain an array should return an empty array");
}

- (void)testTrackingStatusElementIsCorrectlyConvertedToATrackingStatusObject
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDictionary *trackingStatusElement = [[self.parser convertDataIntoJSON] firstObject];
    TrackingStatus *trackingStatus = [self.parser convertTrackingStatusElementIntoTrackingStatusObject:trackingStatusElement];
    XCTAssertNotNil(trackingStatus.date, @"TrackingStatus date's property should not be nil");
    XCTAssertTrue([trackingStatus.date compare:[dateFormatter dateFromString:@"25/04/2015"]] == NSOrderedSame, @"TrackingStatus date's property should be equal to '25/04/2015'");
    XCTAssertEqualObjects(trackingStatus.location, @"Bureau de Poste St brevin les pins", @"TrackingStatus location's property should be equal to 'Bureau de Poste St brevin les pins'");
    XCTAssertEqualObjects(trackingStatus.message, @"Votre colis a été déposé au bureau de poste d'expédition", @"TrackingStatus message's property should be equal to 'Votre colis a été déposé au bureau de poste d'expédition'");
}

- (void)testParseDataReturnedAnArrayOfTrackingStatusObjects
{
    NSArray *trackingStatuses = [self.parser parseData];
    XCTAssertTrue([trackingStatuses.firstObject isKindOfClass:[TrackingStatus class]], @"Parsing the data should return an array of TrackingStatus objects");
}

@end
