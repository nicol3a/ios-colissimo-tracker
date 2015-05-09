//
//  TrackerTableViewCell.h
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kTrackerTableViewCellIdentifier;

@class TrackingStatus;

@interface TrackerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (readonly, nonatomic) NSDateFormatter *dateFormatter;

- (void)configureForTrackingStatus:(TrackingStatus *)trackingStatus;

@end
