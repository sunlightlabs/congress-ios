//
//  SFFullTextViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/16/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFullTextViewController.h"

@interface SFFullTextViewController ()

@end

@implementation SFFullTextViewController {
    SFBill *_bill;
    NSURL *_loadedURL;
    BOOL _hasLoaded;
}

@synthesize activityController = _activityController;
@synthesize activityIndicator = _activityIndicator;
@synthesize closeButton = _closeButton;
@synthesize activityButton = _activityButton;
@synthesize webView = _webView;

- (id)initWithBill:(SFBill *)bill
{
    _bill = bill;
    return [super initWithNibName:nil bundle:nil];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor primaryBackgroundColor]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasLoaded = NO;
    
    NSMutableArray *activities = [[NSMutableArray alloc] init];
    NSMutableArray *activityItems = [[NSMutableArray alloc] initWithObjects:_bill, nil];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Text of %@", [_bill.identifier displayName]]];
    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem actionButtonWithTarget:self action:@selector(showActivityViewController)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(closeFullTextView)]];
    
    _webView = [[UIWebView alloc] init];
    [_webView setDelegate:self];
    [_webView setBackgroundColor:[UIColor primaryBackgroundColor]];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_webView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:_activityIndicator];
    
    /* load request */
    
    NSString *optimalKey = nil;
    for (NSString *key in @[@"xml", @"html", @"pdf"]) {
        NSString *urlString = _bill.lastVersion[@"urls"][key];
        if (urlString != nil && ![urlString isEqualToString:@""]) {
            optimalKey = key;
            break;
        }
    }
    
    if (optimalKey != nil) {
        _loadedURL = [NSURL URLWithString:_bill.lastVersion[@"urls"][optimalKey]];
        [_webView setScalesPageToFit:YES];
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:_loadedURL]];
    }
    
    /* UIActivityViewController */
    
    [activities addObject:[[UICongressGovActivity alloc] init]];
    
    if ([_bill.lastVersion valueForKeyPath:@"urls.html"] || [_bill.lastVersion valueForKeyPath:@"urls.xml"]) {
        [activities addObject:[[UISafariActivity alloc] init]];
    }
    
    if ([_bill.lastVersion valueForKeyPath:@"urls.pdf"]) {
        [activities addObject:[[UISafariPDFActivity alloc] init]];
    }
    
    _activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                            applicationActivities:activities];
    
    /* layout constraints */
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:150.0]];
}

#pragma mark - private

- (void)showActivityViewController
{
    [self presentViewController:_activityController animated:YES completion:NULL];
}

- (void)closeFullTextView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _hasLoaded = YES;
    [_activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return !_hasLoaded;
}

@end



#pragma mark - UIFullTextActivity

@implementation UIFullTextActivity

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[SFBill class]]) {
            return YES;
        }
    };
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[SFBill class]]) {
            self.bill = obj;
            break;
        }
    };
}

@end


#pragma mark - UISafariActivity

@implementation UISafariActivity

- (NSString *)activityType { return @"safari"; }
- (NSString *)activityTitle { return @"Open in Safari"; }
- (UIImage *)activityImage { return [UIImage imageNamed:@"Safari"]; }

- (void)performActivity {
    NSURL *url = [NSURL URLWithString:[self.bill.lastVersion valueForKeyPath:@"urls.xml"] ?: [self.bill.lastVersion valueForKeyPath:@"urls.html"]];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end


#pragma mark - UISafariPDFActivity

@implementation UISafariPDFActivity

- (NSString *)activityType { return @"safari-pdf"; }
- (NSString *)activityTitle { return @"Open PDF in Safari"; }
- (UIImage *)activityImage { return [UIImage imageNamed:@"Safari"]; }

- (void)performActivity {
    NSURL *url = [NSURL URLWithString:self.bill.lastVersion[@"urls"][@"pdf"]];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end


#pragma mark - UIOpenCongressActivity

@implementation UIOpenCongressActivity

- (NSString *)activityType { return @"open-congress"; }
- (NSString *)activityTitle { return @"Open on OpenCongress.org"; }
- (UIImage *)activityImage { return nil; }

- (void)performActivity {
    NSURL *url = [self.bill openCongressFullTextURL];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end


#pragma mark - UIGovTrackActivity

@implementation UIGovTrackActivity

- (NSString *)activityType { return @"govtrack"; }
- (NSString *)activityTitle { return @"Open on GovTrack.us"; }
- (UIImage *)activityImage { return nil; }

- (void)performActivity {
    NSURL *url = [self.bill govTrackFullTextURL];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end


#pragma mark - UICongressGovActivity

@implementation UICongressGovActivity

- (NSString *)activityType { return @"congressgov"; }
- (NSString *)activityTitle { return @"Open on Congress.gov"; }
- (UIImage *)activityImage { return nil; }

- (void)performActivity {
    NSURL *url = [self.bill congressGovFullTextURL];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end
