//
//  ImageCache.m
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/22/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache
#pragma mark - ImageCache Class Variable -
static ImageCache   *_imageCacheSingleton = nil;

#pragma mark - ImageCache Class Methods -
+ (instancetype)imageCache
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _imageCacheSingleton = [ImageCache new];
    });
    
    return _imageCacheSingleton;
}

@end
