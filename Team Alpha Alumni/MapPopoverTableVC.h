//
//  MapPopoverTableVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@protocol SelectedPersonProtocol <NSObject>

- (void)setSelectedPerson:(Person *)person;

@end

@interface MapPopoverTableVC : UITableViewController

@property (nonatomic) id delegate;
@property (strong, nonatomic) NSArray *residents;

@end
