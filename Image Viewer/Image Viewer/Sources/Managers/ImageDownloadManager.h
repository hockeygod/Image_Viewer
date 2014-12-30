//
//  ImageDownloadManager.h
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/22/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - ImageDownloadManager typedefs -
typedef void    (^ImageDownloadManagerImageCompletionHandler)   (NSError *error);

@interface ImageDownloadManager : NSObject
#pragma mark - ImageDownloadManager Class Methods -
+ (instancetype)imageDownloadManager;

#pragma mark - ImageDownloadManager Instance Methods -
- (void)imageForURLString:(NSString *)imageURLString withCompletionHandler:(ImageDownloadManagerImageCompletionHandler)completionHandler;
- (void)cancelImageForURLString:(NSString *)imageURLString;

@end
