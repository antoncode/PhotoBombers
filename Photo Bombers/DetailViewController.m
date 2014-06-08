//
//  DetailViewController.m
//  Photo Bombers
//
//  Created by Anton Rivera on 6/7/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()

@property (nonatomic) UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];

    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    // add gesture recognizer to dismiss detail view controller
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews
{
    // called whenever view changes size so that it can re-layout everything inside of it
    [super viewDidLayoutSubviews];
    
    // View controlelr's view's size
    CGSize size = self.view.bounds.size;
    
    // Image view's size
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    // center view in screen dynamically
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
