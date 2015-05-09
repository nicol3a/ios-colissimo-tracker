//
//  TrackerParser.h
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackingStatus;

@interface TrackerParser : NSObject

@property (readwrite, nonatomic) NSData *data;
@property (readonly, nonatomic) NSDateFormatter *dateFormatter;

- (instancetype)initWithData:(NSData *)data;

- (NSArray *)parseData;
- (id)convertDataIntoJSON;
- (void)stripNewLinesAndTabs;
- (void)replaceQuoteHexaCharacters;
- (TrackingStatus *)convertTrackingStatusElementIntoTrackingStatusObject:(NSDictionary *)trackingStatusElement;
- (NSString *)stringByStrippingHTML:(NSString *)originalString;

@end
