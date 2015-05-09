//
//  TrackerDownloader.h
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackerDownloader;

@protocol TrackerDownloaderDelegate <NSObject>

@required

- (void)trackerDownloader:(TrackerDownloader *)downloader didDownloadTrackingStatuses:(NSArray *)trackingStatuses;

@end

@interface TrackerDownloader : NSObject

@property (readonly, nonatomic) NSString *trackingID;
@property (readonly, nonatomic) NSString *baseURL;
@property (weak, nonatomic) id<TrackerDownloaderDelegate> delegate;

- (instancetype)initWithTrackingID:(NSString *)trackingID;
- (void)downloadTrackingStatuses;
- (NSURLRequest *)URLRequestForDownload;
- (NSURL *)URLForDownload;
- (NSString *)stringURLForDownload;
- (void)handleDownloadResult:(NSData *)data;

@end
