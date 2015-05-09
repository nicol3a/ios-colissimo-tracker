//
//  TrackingStatus.h
//  ColissimoTracker
//
//  Created by Nicolas Bichon on 26/04/2015.
//  Copyright (c) 2015 Nicolas Bichon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingStatus : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *message;

@end
