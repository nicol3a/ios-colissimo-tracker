//
//  TrackerTableViewController.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import "TrackerTableViewController.h"

#import "TrackerTableViewCell.h"

@interface TrackerTableViewController ()

@end

@implementation TrackerTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    [self setupTableView];
    [self registerTrackerTableViewCell];
    [self setupRefreshControl];
    [self downloadTrackingStatuses];
}

#pragma mark - Setup

- (void)setupData
{
    self.trackingStatuses = [NSArray array];
    self.downloader = [[TrackerDownloader alloc] initWithTrackingID:@"CC642475613FR"];
    self.downloader.delegate = self;
}

- (void)setupTableView
{
    self.title = @"Tracking";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 82.0;
}

- (void)registerTrackerTableViewCell
{
    UINib *nib = [UINib nibWithNibName:kTrackerTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kTrackerTableViewCellIdentifier];
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadTrackingStatuses) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Actions

- (void)downloadTrackingStatuses
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.downloader downloadTrackingStatuses];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trackingStatuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackerTableViewCellIdentifier];
    [cell configureForTrackingStatus:self.trackingStatuses[indexPath.row]];
    return cell;
}

#pragma mark - TrackerDownloaderDelegate

- (void)trackerDownloader:(TrackerDownloader *)downloader didDownloadTrackingStatuses:(NSArray *)trackingStatuses
{
    self.trackingStatuses = trackingStatuses;
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self updateUIAfterDownload];
    });
}

- (void)updateUIAfterDownload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
