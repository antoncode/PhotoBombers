//
//  PhotoController.m
//  Photo Bombers
//
//  Created by Anton Rivera on 6/7/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "PhotoController.h"
#import <SAMCache/SAMCache.h>

@implementation PhotoController

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion
{
    if (photo == nil || size == nil || completion == nil) {
        return;
    }
    
    NSString *key = [[NSString alloc] initWithFormat:@"%@-%@", photo[@"id"], size];
    UIImage *image =[[SAMCache sharedCache] imageForKey:key];
    
    if (image) {    // If the photo was already downloaded, don't download it again.
        completion(image);
        return;
    }
    // If you don't have the photo, run all of this
    NSURL *url = [[NSURL alloc] initWithString:photo[@"images"][size][@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];  // Get image form URL
        [[SAMCache sharedCache] setImage:image forKey:key]; // Save photo in cache
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);   // Called on the main queue since it's changing the UI. ie not background work
        });
    }];
    [task resume];
}

@end
