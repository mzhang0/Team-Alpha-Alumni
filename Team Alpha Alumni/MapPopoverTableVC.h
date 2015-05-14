//
//  MapPopoverTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapVC.h"

@interface MapPopoverTableVC : UITableViewController

@property (strong, nonatomic) NSArray *residents;
@property (strong, nonatomic) MapVC *mapViewController;

@end
