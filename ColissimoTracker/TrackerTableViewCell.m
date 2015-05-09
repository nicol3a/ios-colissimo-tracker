//
//  TrackerTableViewCell.m
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import "TrackerTableViewCell.h"

#import "TrackingStatus.h"

NSString * const kTrackerTableViewCellIdentifier = @"TrackerTableViewCell";

@implementation TrackerTableViewCell

#pragma mark - Lifetime

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd MMM yyyy";
    }
    return self;
}

#pragma mark - Setup

- (void)configureForTrackingStatus:(TrackingStatus *)trackingStatus
{
    self.dateLabel.text = [self.dateFormatter stringFromDate:trackingStatus.date];
    self.locationLabel.text = trackingStatus.location;
    self.messageLabel.text = trackingStatus.message;
}

@end
