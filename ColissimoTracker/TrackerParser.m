//
//  TrackerParser.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import "TrackerParser.h"

#import "TrackingStatus.h"

@interface TrackerParser ()

@end

@implementation TrackerParser

#pragma mark - Lifetime

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        _data = data;
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    return self;
}

#pragma mark - Actions

- (NSArray *)parseData
{
    NSArray *trackingStatusElements = [self convertDataIntoJSON];
    NSMutableArray *trackingStatuses = [NSMutableArray array];
    
    [trackingStatusElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [trackingStatuses addObject:[self convertTrackingStatusElementIntoTrackingStatusObject:obj]];
    }];
    
    return trackingStatuses;
}

- (id)convertDataIntoJSON
{
    [self cleanData];
    
    id result = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    if (![result isKindOfClass:[NSArray class]]) {
        result = [NSArray array];
    }
    return result;
}

- (void)cleanData
{
    [self stripNewLinesAndTabs];
    [self replaceQuoteHexaCharacters];
}

- (void)stripNewLinesAndTabs
{
    NSString *text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    text = [text stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    self.data = [text dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)replaceQuoteHexaCharacters
{
    NSString *text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    text = [text stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    self.data = [text dataUsingEncoding:NSUTF8StringEncoding];
}

- (TrackingStatus *)convertTrackingStatusElementIntoTrackingStatusObject:(NSDictionary *)trackingStatusElement
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [self stringByStrippingHTML:trackingStatusElement[@"date"]];
    NSString *location = [self stringByStrippingHTML:trackingStatusElement[@"lieu"]];
    NSString *message = [self stringByStrippingHTML:trackingStatusElement[@"message"]];
    
    TrackingStatus *trackingStatus = [[TrackingStatus alloc] init];
    trackingStatus.date = [self.dateFormatter dateFromString:dateString];
    trackingStatus.location = location;
    trackingStatus.message = message;
    
    return trackingStatus;
}

- (NSString *)stringByStrippingHTML:(NSString *)originalString
{
    NSRange range;
    NSString *string = [originalString copy];
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    }
    return string;
}

@end
