//
//  MapVC.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MBXMapKit/MBXMapKit.h>
#import "Person.h"

@interface MapVC : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate, MBXRasterTileOverlayDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (strong, nonatomic) NSArray *people;
@property (strong, nonatomic) Person *selectedPerson;
@property (strong, nonatomic) UIPopoverController *popover;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;

- (IBAction)SelectedSearchButton:(id)sender;

@end
