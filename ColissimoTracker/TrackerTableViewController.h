//
//  TrackerTableViewController.h
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrackerDownloader.h"

@class TrackerDownloader;

@interface TrackerTableViewController : UITableViewController <TrackerDownloaderDelegate>

@property (strong, nonatomic) TrackerDownloader *downloader;
@property (strong, nonatomic) NSArray *trackingStatuses;

- (void)registerTrackerTableViewCell;
- (void)downloadTrackingStatuses;
- (void)updateUIAfterDownload;

@end
