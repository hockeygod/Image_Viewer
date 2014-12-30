//
//  UIImage+UIImage_ImageViewer.h
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/30/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_ImageViewer)
#pragma mark - UIImage (UIImage_ImageViewer) Category Class Methods -
+ (instancetype)imageForNull;

#pragma mark - UIImage (UIImage_ImageViewer) Category Instance Methods -
- (instancetype)tableViewThumbCroppedAndResized;

@end
