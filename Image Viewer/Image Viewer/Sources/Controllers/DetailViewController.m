//
//  DetailViewController.m
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/22/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "DetailViewController.h"
#import "../Caches/ImageCache.h"
#import "../Managers/ImageDownloadManager.h"

@interface DetailViewController () <UIScrollViewDelegate>
#pragma mark - DetailViewController Private Properties -
@property           IBOutlet    UIActivityIndicatorView     *activityIndicatorView;
@property           IBOutlet    UIScrollView                *scrollView;
@property                       UIImageView                 *imageView;

#pragma mark - DetailViewController Private Instance Methods -
- (void)addToScrollViewImage:(UIImage *)image;
- (void)centerScrollViewContents;
- (IBAction)displayCaptionAsAlert:(id)sender;
- (IBAction)toggleStatusAndNavigationBar:(id)sender;

@end

@implementation DetailViewController
#pragma mark - UIViewController Instance Methods -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if ([[ImageCache imageCache] objectForKey:[self.imageDictionary objectForKey:@"original"]])
    {
        [self addToScrollViewImage:[[ImageCache imageCache] objectForKey:[self.imageDictionary objectForKey:@"original"]]];
    }
    else
    {
        [self.activityIndicatorView startAnimating];
        [[ImageDownloadManager imageDownloadManager] imageForURLString:[self.imageDictionary objectForKey:@"original"] withCompletionHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil)
                {
                    NSLog(@"Downloading original from server encountered error:\t%@", error);
                }
                else
                {
                    [self addToScrollViewImage:[[ImageCache imageCache] objectForKey:[self.imageDictionary objectForKey:@"original"]]];
                }
                [self.activityIndicatorView stopAnimating];
            });
        }];
    }
    
    if ([[self.imageDictionary objectForKey:@"caption"] isEqual:[NSNull null]] == YES)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.activityIndicatorView isAnimating])
    {
        [[ImageDownloadManager imageDownloadManager] cancelImageForURLString:[self.imageDictionary objectForKey:@"original"]];
        [self.activityIndicatorView stopAnimating];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBar.hidden;
}

#pragma mark - DetailViewController Private Instance Methods -
- (void)addToScrollViewImage:(UIImage *)image
{
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointZero, .size=image.size};
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = image.size;
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    CGPoint contentsOffset = CGPointZero;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = ((boundsSize.width - contentsFrame.size.width) / 2.0);
    }
    else
    {
        contentsOffset.x = (-((boundsSize.width / 2.0) - (contentsFrame.size.width / 2.0)));
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsOffset.y = (-((boundsSize.height / 2.0) - (contentsFrame.size.height / 2.0)));
    }
    
    self.imageView.frame = contentsFrame;
    self.scrollView.contentOffset = contentsOffset;
}

- (IBAction)displayCaptionAsAlert:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Caption" message:[self.imageDictionary objectForKey:@"caption"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)toggleStatusAndNavigationBar:(id)sender
{
    self.navigationController.navigationBar.hidden = (!self.navigationController.navigationBar.hidden);
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
