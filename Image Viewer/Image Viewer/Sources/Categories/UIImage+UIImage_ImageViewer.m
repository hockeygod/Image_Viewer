//
//  UIImage+UIImage_ImageViewer.m
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/30/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "UIImage+UIImage_ImageViewer.h"

@implementation UIImage (UIImage_ImageViewer)

#pragma mark - UIImage (UIImage_ImageViewer) Category Class Methods -
+ (instancetype)imageForNull
{
    UIImage *workingImage = [UIImage new];
    NSString *text = @"?";
    UIFont *font = [UIFont systemFontOfSize:20.0];
    CGSize size = CGSizeMake(40.0, 40.0);
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName:font}];
    CGRect rect = (CGRect){.origin=CGPointMake(((size.width - textSize.width) / 2), ((size.height - textSize.height) / 2)), .size=size};
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    
    workingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return workingImage;
}

#pragma mark - UIImage (UIImage_ImageViewer) Category Instance Methods -
- (instancetype)tableViewThumbCroppedAndResized
{
    UIImage *returnImage = [UIImage new];
    //crop
    CGRect cropRect = CGRectZero;
    if (self.size.width < self.size.height)
    {
        cropRect = CGRectMake(0, ((self.size.height - self.size.width) / 2), self.size.width, self.size.width);
    }
    else
    {
        cropRect = CGRectMake(((self.size.width - self.size.height) / 2), 0, self.size.height, self.size.height);
    }
    CGImageRef croppedImage = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    returnImage = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    
    //resize
    CGRect resizeRect = CGRectMake(0, 0, 40.0, 40.0);
    UIGraphicsBeginImageContextWithOptions(resizeRect.size, NO, [UIScreen mainScreen].scale);
    [returnImage drawInRect:resizeRect];
    returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}

@end
