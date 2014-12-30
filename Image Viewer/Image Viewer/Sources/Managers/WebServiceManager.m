//
//  WebServiceManager.m
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "WebServiceManager.h"

#pragma mark - WebServiceManager Private typedefs -
typedef void (^WebServiceManagerPrivateQueryForRequestURLCompletionHandler) (id result, NSError *error);

@interface WebServiceManager ()
#pragma mark - WebServiceManager Private Properties -
@property   NSOperationQueue    *queryOperationQueue;

#pragma mark - WebServiceManager Private Instance Methods -
- (void)queryForRequest:(NSURLRequest *)request completionHandler:(WebServiceManagerPrivateQueryForRequestURLCompletionHandler)completionHandler;

@end

@implementation WebServiceManager

#pragma mark - WebServiceManager Class Variable -
static  WebServiceManager   *_webServiceManagerSingleton = nil;

#pragma mark - WebServiceManager Class Methods -
+ (instancetype)webServiceManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webServiceManagerSingleton = [WebServiceManager new];
        _webServiceManagerSingleton.queryOperationQueue = [NSOperationQueue new];
    });
    
    return _webServiceManagerSingleton;
}

#pragma mark - WebServiceManager Instance Methods -
- (void)imagesFromServerWithCompletionHandler:(WebServiceManagerImagesCompletionHandler)completionHandler
{
    NSMutableURLRequest *allImagesRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/89445730/images.json"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    if (allImagesRequest != nil)
    {
        [self queryForRequest:allImagesRequest completionHandler:^(id result, NSError *error) {
            if (error != nil)
            {
                completionHandler(nil, error);
            }
            else if ([result isKindOfClass:[NSArray class]])
            {
                completionHandler(result, nil);
            }
            else
            {
                completionHandler(nil, [NSError errorWithDomain:@"ImageViewerErrorDomain" code:-4 userInfo:@{NSLocalizedDescriptionKey: @"Unsupported response type"}]);
            }
        }];
    }
    else
    {
        completionHandler(nil, [NSError errorWithDomain:@"ImageViewerErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to create URL Request"}]);
    }
}

#pragma mark - WebServiceManager Private Instance Methods -
- (void)queryForRequest:(NSURLRequest *)request completionHandler:(WebServiceManagerPrivateQueryForRequestURLCompletionHandler)completionHandler
{
        if ([NSURLConnection canHandleRequest:request])
        {
            [NSURLConnection sendAsynchronousRequest:request queue:self.queryOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError != nil)
                {
                    completionHandler(nil, connectionError);
                }
                else if (data != nil)
                {
                    NSError *jsonDeserializationError;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
                    if (jsonDeserializationError == nil)
                    {
                        completionHandler(jsonObject, nil);
                    }
                    else
                    {
                        completionHandler(nil, jsonDeserializationError);
                    }
                }
                else
                {
                    completionHandler(nil, [NSError errorWithDomain:@"ImageViewerErrorDomain" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Unknown URL Connection issue"}]);
                }
            }];
        }
        else
        {
            completionHandler(nil, [NSError errorWithDomain:@"ImageViewerErrorDomain" code:-2 userInfo:@{NSLocalizedDescriptionKey : @"URL Connection can't handle URL Request"}]);
        }
}

@end
