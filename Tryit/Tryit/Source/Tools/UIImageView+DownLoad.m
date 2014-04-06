//
//  UIImage+DownLoad.m
//  Tryit
//
//  Created by Mars on 4/6/14.
//  Copyright (c) 2014 Sktlab. All rights reserved.
//

#import "UIImageView+DownLoad.h"

@implementation UIImageView(DownLoad)

- (void)fixSetImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request addValue:@"image/*" forHTTPHeaderField:@"content-type"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

@end
