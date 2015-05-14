//
//  MapVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "MapVC.h"
#import "MapViewAnnotation.h"
#import "MapPopoverTableVC.h"
#import "ProfileVC.h"
#import <RestKit/RestKit.h>

@interface MapVC ()

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPeople];
}

- (void)loadPeople {
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping* personMapping = [RKObjectMapping mappingForClass:[Person class]];
    [personMapping addAttributeMappingsFromDictionary:@{
                                                        @"fullName": @"name",
                                                        @"location": @"location",
                                                        @"work": @"position",
                                                        @"year": @"startYear",
                                                        @"role": @"role",
                                                        @"memory": @"memory",
                                                        @"experience": @"experience",
                                                        @"thumbnail": @"thumbnail",
                                                        @"fullRes" : @"photo"
                                                       }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:personMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/qvtgyrroizbfzti/Trial3b.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Location"];
    annotationView.canShowCallout = NO;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    MapPopoverTableVC *mapPopoverTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowPopover"];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:mapPopoverTableController];
    self.popover.delegate = self;
    
    MapViewAnnotation *locationAnnotation = view.annotation;
    
    mapPopoverTableController.residents = locationAnnotation.peopleLivingHere;
    mapPopoverTableController.mapViewController = self;
    
    [self.popover presentPopoverFromRect:view.frame inView:view.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender {
    
    if ([segue.identifier isEqualToString:@"ShowProfileFromPopover"]) {
        
        ProfileVC *profileViewController = segue.destinationViewController;
        profileViewController.alumnus = self.selectedPerson;

        [self.popover dismissPopoverAnimated:NO];
    }
}

@end
