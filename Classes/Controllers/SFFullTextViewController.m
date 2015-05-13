//
//  SFFullTextViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/16/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFullTextViewController.h"
#import "SFCongressGovActivity.h"
#import "SFSafariActivity.h"
#import <UIWebView+AFNetworking.h>
#import <AFNetworking/AFURLResponseSerialization.h>

@interface SFFullTextViewController ()

@end

@implementation SFFullTextViewController {
    SFBill *_bill;
    NSURL *_loadedURL;
    BOOL _hasLoaded;
}

@synthesize activityController;
@synthesize activityIndicator;
@synthesize closeButton;
@synthesize activityButton;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Bill Full Text Screen";
    }
    return self;
}

- (id)initWithBill:(SFBill *)bill {
    _bill = bill;
    return [self initWithNibName:nil bundle:nil];
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor colorWithRed:0.46f green:0.46f blue:0.43f alpha:1.00f]];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _hasLoaded = NO;

    NSMutableArray *activities = [[NSMutableArray alloc] init];
    NSMutableArray *activityItems = [[NSMutableArray alloc] initWithObjects:_bill, nil];

    [self.navigationItem setTitle:[NSString stringWithFormat:@"Text of %@", [_bill.identifier displayName]]];
//    [self.navigationItem setRightBarButtonItem:[UIBarButtonItem actionButtonWithTarget:self action:@selector(showActivityViewController)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(closeFullTextView)]];

    self.webView = [[UIWebView alloc] init];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:[UIColor colorWithRed:0.69f green:0.70f blue:0.65f alpha:1.00f]];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.webView];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:self.activityIndicator];

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
        [self.webView setScalesPageToFit:YES];

        AFHTTPResponseSerializer *responseSerializer = [optimalKey isEqualToString:@"xml"] ? [AFXMLParserResponseSerializer serializer] : [AFHTTPResponseSerializer serializer];
        self.webView.responseSerializer = responseSerializer;

        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:_loadedURL] progress:nil success:nil failure:nil];
    }

    /* UIActivityViewController */

    [activities addObject:[SFCongressGovActivity activityForBillText:_bill]];

    if ([_bill.lastVersion valueForKeyPath:@"urls.xml"] || [_bill.lastVersion valueForKeyPath:@"urls.html"]) {
        NSURL *url = [NSURL URLWithString:[_bill.lastVersion valueForKeyPath:@"urls.xml"] ? :[_bill.lastVersion valueForKeyPath:@"urls.html"]];
        [activities addObject:[SFSafariActivity activityForURL:url]];
    }

    if ([_bill.lastVersion valueForKeyPath:@"urls.pdf"]) {
        [activities addObject:[[UISafariPDFActivity alloc] init]];
    }

    self.activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                            applicationActivities:activities];

    /* layout constraints */

    NSDictionary *viewDict = @{ @"webView" : self.webView };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[webView]-(4)-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(4)-[webView]-(4)-|" options:0 metrics:nil views:viewDict]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:150.0]];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark - private

- (void)showActivityViewController {
    [self presentViewController:self.activityController animated:YES completion:NULL];
}

- (void)closeFullTextView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _hasLoaded = YES;
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return !_hasLoaded;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    CLS_LOG(@"SFFullTextViewController.webView didFailLoadWithError: %@ at URL: %@", error.localizedDescription, [self.webView.request.URL absoluteString]);
}

@end


#pragma mark - UISafariPDFActivity

@implementation UISafariPDFActivity

- (NSString *)activityType {
    return @"safari-pdf";
}

- (NSString *)activityTitle {
    return @"Open PDF in Safari";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"Safari"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[SFBill class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[SFBill class]]) {
            self.bill = obj;
            break;
        }
    }
}

- (void)performActivity {
    NSURL *url = [NSURL URLWithString:self.bill.lastVersion[@"urls"][@"pdf"]];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:urlOpened];
}

@end
