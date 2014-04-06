//
//  UIImage+DownLoad.h
//  Tryit
//
//  Created by Mars on 4/6/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"
@interface UIImageView (DownLoad)

- (void)fixSetImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholderImage;

@end
