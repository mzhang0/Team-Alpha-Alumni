//
//  AsynchronousLoading.m
//  Team Alpha Alumni
//
//  Copyright (c) 2015 Awesome Inc. All rights reserved.
//

#import "AsynchronousLoading.h"

@implementation AsynchronousLoading
        
+ (void)loadDataFromJsonFileAtUrl:(NSURL*)url completion:(void(^)(NSArray *fetchedData, NSError *error))completion {

    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
            
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error)
            completion(nil, error);
        else {
            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completion(jsonData, error);
        }
    }];
}

+ (void)loadImageFromUrl:(NSURL*)url completion:(void(^)(UIImage *fetchedImage, NSError *error))completion {
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error)
            completion(nil, error);
        else {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completion(image, error);
        }
    }];
}

@end

