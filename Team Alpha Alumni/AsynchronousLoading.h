//
//  AsynchronousLoading.h
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynchronousLoading : NSObject

+ (void)loadDataFromJsonFileAtUrl:(NSURL*)url completion:(void(^)(NSArray *fetchedData, NSError *error))completion;

+ (void)loadImageFromUrl:(NSURL*)url completion:(void(^)(UIImage *image, NSError *error))completion;

@end
