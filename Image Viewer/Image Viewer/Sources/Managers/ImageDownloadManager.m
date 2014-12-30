//
//  ImageDownloadManager.m
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/22/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "ImageDownloadManager.h"
#import "../Caches/ImageCache.h"

@interface ImageDownloadManager ()
#pragma mark - ImageDownloadManager Private Properties -
@property               NSOperationQueue        *imageDownloadOperationQueue;

@end

@implementation ImageDownloadManager
#pragma mark - ImageDownloadManager Class Variable -
static  ImageDownloadManager    *_imageDownloadManager = nil;

#pragma mark - ImageDownloadManager Class Methods -
+ (instancetype)imageDownloadManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _imageDownloadManager = [ImageDownloadManager new];
        _imageDownloadManager.imageDownloadOperationQueue = [NSOperationQueue new];
    });
    
    return _imageDownloadManager;
}

#pragma mark - ImageDownloadManager Instance Methods -
- (void)imageForURLString:(NSString *)imageURLString withCompletionHandler:(ImageDownloadManagerImageCompletionHandler)completionHandler
{
    [self.imageDownloadOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil)
            {
                completionHandler(error);
            }
            else if (data != nil)
            {
                UIImage *image = [UIImage imageWithData:data];
                if (image != nil)
                {
                    [[ImageCache imageCache] setObject:image forKey:imageURLString];
                    completionHandler(nil);
                }
                else
                {
                    completionHandler([NSError errorWithDomain:@"ImageViewerErrorDomain" code:-5 userInfo:@{NSLocalizedDescriptionKey: @"Image data returned from server is corrupt"}]);
                }
            }
            else
            {
                completionHandler([NSError errorWithDomain:@"ImageViewerErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Unknown URL Connection issue"}]);
            }
        }];
        [dataTask resume];
    }]];
}

- (void)cancelImageForURLString:(NSString *)imageURLString
{
    [self.imageDownloadOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [[NSURLSession sharedSession] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            for (NSURLSessionDataTask *aDataTask in dataTasks)
            {
                if ([aDataTask.currentRequest.URL.absoluteString isEqualToString:imageURLString])
                {
                    [aDataTask cancel];
                    break;
                }
            }
        }];
    }]];
}

@end
