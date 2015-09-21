//
//  MapVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "MapVC.h"
#import "MapViewAnnotation.h"
#import "ProfileVC.h"
#import "SearchTableVC.h"

@interface MapVC ()

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPeople];
    
    [MBXMapKit setAccessToken:@"pk.eyJ1IjoibXpoYW5nMCIsImEiOiJIel9aZWZJIn0.lOCIvOv6myHnBwnM-v8paQ"];
    
    self.rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:@"mzhang0.d1d979d1"];
    self.rasterOverlay.delegate = self;
    [self.MapView addOverlay:self.rasterOverlay];
}

- (void)loadPeople {
    
    RKObjectRequestOperation *objectRequestOperation = [Person getObjectRequestOperation];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.people = mappingResult.array;
        RKLogInfo(@"Loaded people:\n %@", self.people);
        
        NSMutableArray *locationCollection = [[NSMutableArray alloc] init];
        
        for (Person *individual in self.people)
            [locationCollection addObject:individual.location];
        
        //Removes duplicates
        NSArray *locations = [[NSSet setWithArray:locationCollection] allObjects];
    
        for (NSString *location in locations) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location MATCHES %@", location];
            NSArray *filteredPeople = [self.people filteredArrayUsingPredicate:predicate];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
                
                if (error)
                    NSLog(@"Geocoding failed: %@", error);
                else {
                    MapViewAnnotation *poi = [[MapViewAnnotation alloc] init];
                    CLPlacemark *placemark = [placemarks firstObject];
                    
                    poi.coordinate = placemark.location.coordinate;
                    poi.peopleLivingHere = filteredPeople;
                    
                    [self.MapView addAnnotation:poi];
                }
            }];
        }
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
          
          RKLogError(@"Error: %@", error);
          
          //Displays the error to the user
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error localizedDescription] message:nil preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
          
          [alert addAction:okAction];
          [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [objectRequestOperation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]]) {
        
        MBXRasterTileRenderer *renderer = [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Location"];
    annotationView.canShowCallout = NO;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    MapViewAnnotation *locationAnnotation = view.annotation;
    
    self.popover = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowPopover"];
    
    CGFloat height;
    
    switch (locationAnnotation.peopleLivingHere.count) {
        case 1:
            height = 66;
            break;
        case 2:
            height = 110;
            break;
        case 3:
            height = 154;
            break;
        default:
            height = 211;
    }
    
    self.popover.preferredContentSize = CGSizeMake(500, height);

    self.popover.residents = locationAnnotation.peopleLivingHere;
    self.popover.delegate = self;
    
    self.popover.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:self.popover animated:YES completion:nil];
    
    UIPopoverPresentationController *popoverController = [self.popover popoverPresentationController];
    popoverController.sourceView = view.superview;
    popoverController.sourceRect = view.frame;
}

#pragma mark - Navigation

- (void)setSelectedPerson:(Person *)selectedPerson {
    
    ProfileVC *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    profileController.alumnus = selectedPerson;
    [self.popover dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (IBAction)SelectedSearchButton:(id)sender {
    
    SearchTableVC *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchController.people = self.people;
    [self.navigationController pushViewController:searchController animated:YES];
}

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 }
 */

@end
