//
//  PhotoController.h
//  Photo Bombers
//
//  Created by Anton Rivera on 6/7/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoController : NSObject

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
