//
//  TrackerDownloader.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import "TrackerDownloader.h"

#import "TrackerParser.h"

@interface TrackerDownloader ()

@end

@implementation TrackerDownloader

#pragma mark - Lifetime

- (instancetype)initWithTrackingID:(NSString *)trackingID
{
    self = [super init];
    if (self) {
        _trackingID = trackingID;
        _baseURL = @"http://api.ntag.fr/colissimo/?id=";
    }
    return self;
}

#pragma mark - Actions

- (void)downloadTrackingStatuses
{
    [NSURLConnection sendAsynchronousRequest:[self URLRequestForDownload] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self handleDownloadResult:data];
    }];
}

- (NSURLRequest *)URLRequestForDownload
{
    return [[NSURLRequest alloc] initWithURL:[self URLForDownload]];
}

- (NSURL *)URLForDownload
{
    return [[NSURL alloc] initWithString:[self stringURLForDownload]];
}

- (NSString *)stringURLForDownload
{
    return [self.baseURL stringByAppendingString:self.trackingID];
}

- (void)handleDownloadResult:(NSData *)data
{
    TrackerParser *parser = [[TrackerParser alloc] initWithData:data];
    NSArray *trackingStatuses = [parser parseData];
    
    [self.delegate trackerDownloader:self didDownloadTrackingStatuses:trackingStatuses];
}

@end
