//
//  Person.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)getFormattedWorkInformation {
    
    NSMutableString *workInformation = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < self.work.count; i++) {
        NSDictionary *workEntry = [self.work objectAtIndex:i];
        
        NSString *position = [workEntry objectForKey:@"position"];
        NSString *company = [workEntry objectForKey:@"company"];
        
        if ([company isEqualToString:@""])
            [workInformation appendFormat:@"%@", position];
        else
            [workInformation appendFormat:@"%@ at %@", position, company];
        
        if (i < self.work.count - 1)
            [workInformation appendString:@", "];
    }
    return workInformation;
}

+ (RKObjectRequestOperation *)getObjectRequestOperation {
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectMapping* personMapping = [RKObjectMapping mappingForClass:[self class]];
    [personMapping addAttributeMappingsFromDictionary:@{
                                                        @"fullName": @"name",
                                                        @"location": @"location",
                                                        @"work": @"work",
                                                        @"year": @"startYear",
                                                        @"role": @"role",
                                                        @"memory": @"memory",
                                                        @"experience": @"experience",
                                                        @"thumbnail": @"thumbnail",
                                                        @"fullRes" : @"photo"
                                                       }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:personMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/92ricd41z0y3ouj/Trial3b%20-%20Test2.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
}

@end
