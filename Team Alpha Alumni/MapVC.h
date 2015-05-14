//
//  MapVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Person.h"

@interface MapVC : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) Person *selectedPerson;
@property (strong, nonatomic) UIPopoverController *popover;

@end
