//
//  Person.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSArray *work;
@property (strong, nonatomic) NSNumber *startYear;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *memory;
@property (strong, nonatomic) NSString *experience;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *photo;

- (NSString *)getFormattedWorkInformation;

+ (RKObjectRequestOperation *)getObjectRequestOperation;

@end
