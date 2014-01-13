//
//  SFFullTextViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/16/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBill.h"

@interface SFFullTextViewController : GAITrackedViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIActivityViewController *activityController;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIBarButtonItem *activityButton;
@property (nonatomic, strong) UIWebView *webView;

- (id)initWithBill:(SFBill *)bill;

@end


@interface UISafariPDFActivity : UIActivity
@property (nonatomic, strong) SFBill *bill;
@end
