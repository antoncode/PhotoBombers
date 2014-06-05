//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Anton Rivera on 4/6/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"

#import <SimpleAuth/SimpleAuth.h>

@interface PhotosViewController ()

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *photos;

@end

@implementation PhotosViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photo Bombers";
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];   // Allows you to save data to disk and get it back easily.  Made for storing preferences but will work for our access token.  Best place to store access tokens is in keychain.
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {  // Not logged in, run authorization
        // Using SimpleAuth/OAuth 2.0
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            NSString *accessToken = responseObject[@"credentials"][@"token"];   // Getting our access token
            
            [userDefaults setObject:accessToken forKey:@"accessToken"];
            [userDefaults synchronize]; // Saves user defaults to disk
        }];
    } else {
        NSLog(@"Already logged in!");
        [self refresh];
    }
    
//    // Downloading data with NSURLSession
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *url = [[NSURL alloc] initWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"Response: %@", text);
//    }];
//    [task resume];  // Start task
}

- (void)refresh
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //            NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        //            NSLog(@"text: %@", text);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]; // Converts JSON data into dictionaries
        
        //            NSArray *photos = [responseDictionary valueForKeyPath:@"data.images.standard_resolution.url"]; // Traverses all levels of the dictionary
        self.photos = [responseDictionary valueForKeyPath:@"data"]; // Grab all the data
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    cell.photo = self.photos[indexPath.row];

    return cell;
}

@end
