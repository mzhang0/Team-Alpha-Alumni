//
//  MapVC.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "Person.h"
#import "MapVC.h"
#import "MapViewAnnotation.h"
#import <RestKit/RestKit.h>
#import <MapKit/MapKit.h>

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
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/9hk5g1mr558y0zy/Trial3a.json"];
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
            
            NSMutableString *formattedSubtitle = [[NSMutableString alloc] init];
            
            for (Person *individual in filteredPeople)
                [formattedSubtitle appendFormat:@"%@ - %@\n\n", individual.name, individual.position];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
                
                if (error)
                    NSLog(@"Geocoding failed: %@", error);
                else {
                    MapViewAnnotation *poi = [[MapViewAnnotation alloc] init];
                    CLPlacemark *placemark = [placemarks firstObject];
                    
                    poi.coordinate = placemark.location.coordinate;
                    poi.title = location;
                    poi.subtitle = formattedSubtitle;
                    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
