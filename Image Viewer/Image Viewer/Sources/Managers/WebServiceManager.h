//
//  WebServiceManager.h
//  ArcTouchCodeChallenge
//
//  Created by Eric E. van Leeuwen on 12/5/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - WebServiceManager Typedefs -
typedef void    (^WebServiceManagerImagesCompletionHandler)      (NSArray *images, NSError *error);

@interface WebServiceManager : NSObject
#pragma mark - WebServiceManager Class Methods -
+ (instancetype)webServiceManager;

#pragma mark - WebServiceManager Instance Methods -
- (void)imagesFromServerWithCompletionHandler:(WebServiceManagerImagesCompletionHandler)completionHandler;

@end
