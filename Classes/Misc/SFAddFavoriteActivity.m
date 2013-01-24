//
//  SFAddFavoriteActivity.m
//  Congress
//
//  Created by Daniel Cloud on 1/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//
// TODO: Override activityViewController to display custom UI for toggling favorite rather than performActivity

#import "SFAddFavoriteActivity.h"
#import "SynchronizedObject.h"
#import "SFFavoriteViewController.h"

@interface SFAddFavoriteActivity() <SFFavoriteViewControllerDelegate>

@end

@implementation SFAddFavoriteActivity

@synthesize favoritableItems;

-(NSString *)activityType
{
    return @"UIActivityTypeAddFavorite";
}

-(NSString *)activityTitle
{
    return @"Add Favorite";
}

-(UIImage *)activityImage
{
    return [UIImage imageNamed:@"AddFavorite.png"];
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    BOOL canPerform = NO;
    for (NSObject *item in activityItems)
    {
        if ([item isKindOfClass:[SynchronizedObject class]])
        {
            canPerform = YES;
        }
    }
    return canPerform;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems
{
    self.favoritableItems = [NSMutableArray array];
    for (id item in activityItems)
    {
        if ([item isKindOfClass:[SynchronizedObject class]])
        {
            [self.favoritableItems addObject:item];
        }
    }
}

//-(void)performActivity
//{
//    
//    for (SynchronizedObject *object in self.favoritableItems)
//    {
//        object.persist = YES;
//    }
//    [self activityDidFinish:YES];
//}

-(UIViewController *)activityViewController
{
    SFFavoriteViewController *vc = [[SFFavoriteViewController alloc] initWithNibName:nil bundle:nil];
    vc.object = [favoritableItems lastObject];
    vc.delegate = self;
    return vc;
}

#pragma mark - SFFavoriteViewController delegate methods

- (void)favoriteViewControllerDidDismiss:(SFFavoriteViewController *)viewController
{
    self.favoritableItems = nil;
    [self activityDidFinish:YES];
}

@end
