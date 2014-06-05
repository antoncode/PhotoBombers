//
//  PhotoCell.h
//  Photo Bombers
//
//  Created by Anton Rivera on 4/6/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;   // Strong is the default type for object types
@property (nonatomic) NSDictionary *photo;

@end
