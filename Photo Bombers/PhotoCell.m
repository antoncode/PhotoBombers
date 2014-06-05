//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Anton Rivera on 4/6/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "PhotoCell.h"
#import <SAMCache/SAMCache.h>

@implementation PhotoCell

- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    
    NSURL *url = [[NSURL alloc] initWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    [self downloadPhotoWithURL:url];    // Download photos form Instagram
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;     // Sets imageView to the full bounds on the contentView.  ie imageView fills the entire cell.
}

- (void)downloadPhotoWithURL:(NSURL *)url
{
    NSString *key = [[NSString alloc] initWithFormat:@"%@-thumbnail", self.photo[@"id"]];
    UIImage *photo =[[SAMCache sharedCache] imageForKey:key];
    
    if (photo) {    // If the photo was already downloaded, don't download it again.
        self.imageView.image = photo;
        return;
    }
    // If you don't have the photo, run all of this
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];  // Get image form URL
        [[SAMCache sharedCache] setImage:image forKey:key]; // Save photo in cache
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;   // Called on the main queue since it's changing the UI. ie not background work
        });
    }];
    [task resume];
}

@end
