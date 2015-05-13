//
//  MapVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVC : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) UIPopoverController *popover;

@end
