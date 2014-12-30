//
//  TableViewController.m
//  Image Viewer
//
//  Created by Eric E. van Leeuwen on 12/22/14.
//  Copyright (c) 2014 Eric E. van Leeuwen. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "../Caches/ImageCache.h"
#import "../Categories/UIImage+UIImage_ImageViewer.h"
#import "../Managers/ImageDownloadManager.h"
#import "../Managers/WebServiceManager.h"

@interface TableViewController ()
#pragma mark - TableViewController Private Properties -
@property               NSArray     *images;

#pragma mark - TableViewController Private Instance Methods -
- (void)refreshTableView;

@end

@implementation TableViewController
#pragma mark - UIViewController Instance Methods -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    self.images = [NSArray array];
    [[WebServiceManager webServiceManager] imagesFromServerWithCompletionHandler:^(NSArray *images, NSError *error) {
        if (error != nil)
        {
            NSLog(@"Fetching images from server encountered error:\t%@", error);
        }
        else
        {
            self.images = images;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowImageDetails"])
    {
        // Get the new view controller using [segue destinationViewController] and pass the selected object to it
        ((DetailViewController *)segue.destinationViewController).imageDictionary = [self.images objectAtIndex:[self.tableView indexPathForCell:sender].row];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - UITableViewDelegate Protocol Methods -
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"] isEqual:[NSNull null]] == NO)
    {
        [[ImageDownloadManager imageDownloadManager] cancelImageForURLString:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
    }
}

#pragma mark - UITableViewDataSource Protocol Methods -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImagesTableViewCell"];
    
    // Configure the cell... It's a basic/default so it has a UIImageView and UILabel provided
    NSString *cellTextLabelText = @"<missing caption>";
    if ([[[self.images objectAtIndex:indexPath.row] objectForKey:@"caption"] isEqual:[NSNull null]] == NO)
    {
        cellTextLabelText = [[self.images objectAtIndex:indexPath.row] objectForKey:@"caption"];
    }
    cell.textLabel.text = cellTextLabelText;
    
    UIImage *cellImageViewImage = nil;
    if ([[ImageCache imageCache] objectForKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]] != nil)
    {
        cellImageViewImage = [[ImageCache imageCache] objectForKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
    }
    else
    {
        if ([[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"] isEqual:[NSNull null]])
        {
            UIImage *workingImage = [UIImage imageForNull];

            [[ImageCache imageCache] setObject:workingImage forKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
            
            cellImageViewImage = [[ImageCache imageCache] objectForKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
        }
        else
        {
            [[ImageDownloadManager imageDownloadManager] imageForURLString:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"] withCompletionHandler:^(NSError *error) {
                if (error != nil)
                {
                    NSLog(@"Downloading thumbnail from server encountered error:\t%@", error);
                }
                else
                {
                    UIImage *workingImage = [[[ImageCache imageCache] objectForKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]] tableViewThumbCroppedAndResized];

                    [[ImageCache imageCache] setObject:workingImage forKey:[[self.images objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }
            }];
        }
    }
    
    cell.imageView.image = cellImageViewImage;
    
    return cell;
}

#pragma mark - TableViewController Private Instance Methods -
- (void)refreshTableView
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
