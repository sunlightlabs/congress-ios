//
//  SFOCEmailConfirmationViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/29/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFOCEmailConfirmationViewController.h"
#import "SFLegislatorDetailViewController.h"
#import "SFViewDeckController.h"

@interface SFOCEmailConfirmationViewController () {
    UIButton *closeButton;
    UIButton *confirmButton;
    UIImageView *sunlightLogoView;
    UIImageView *openCongressLogoView;
    UILabel *infoLabel;
}
@end

@implementation SFOCEmailConfirmationViewController

@synthesize ocEmailConfirmationDelegate = _ocEmailConfirmationDelegate;

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    sunlightLogoView = [[UIImageView alloc] initWithImage:[UIImage sfLogoImage]];
    sunlightLogoView.translatesAutoresizingMaskIntoConstraints = NO;
    sunlightLogoView.accessibilityLabel = @"Sunlight Foundation logo";
    sunlightLogoView.accessibilityHint = @"Congress app was created by the Sunlight Foundation";
    [self.view addSubview:sunlightLogoView];
    
    openCongressLogoView = [[UIImageView alloc] initWithImage:[UIImage ocLogoImage]];
    openCongressLogoView.translatesAutoresizingMaskIntoConstraints = NO;
    openCongressLogoView.accessibilityLabel = @"OpenCongress logo";
    openCongressLogoView.accessibilityHint = @"OpenCongress is a project of the Sunlight Foundation";
    [self.view addSubview:openCongressLogoView];
    
    infoLabel = [[UILabel alloc] init];
    [infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [infoLabel setNumberOfLines:0];
    [infoLabel setTextColor:[UIColor primaryTextColor]];
    [infoLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [infoLabel setText:@"When you send your first email, you will receive a reply asking you to register with OpenCongress and confirm your address. This information is required by many members of Congress in order to verify that you are their constituent.\n\nThis is a one time process."];
    [self.view addSubview:infoLabel];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmButton setBackgroundColor:[UIColor navigationBarBackgroundColor]];
    [confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [confirmButton setTitle:@"Okay, let's do it!" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [confirmButton.layer setCornerRadius:5.0f];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton sizeToFit];
    [self.view addSubview:confirmButton];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [closeButton setTitle:@"Nevermind" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor menuBackgroundColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [closeButton sizeToFit];
    [self.view addSubview:closeButton];
    
    
    NSDictionary *metrics = @{ @"inset": @32.0 };
    
    NSDictionary *views = @{ @"sflogo": sunlightLogoView,
                             @"oclogo": openCongressLogoView,
                             @"info": infoLabel,
                             @"close": closeButton,
                             @"confirm": confirmButton };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[sflogo]-(16)-[oclogo]-(40)-[info]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[confirm(44)]-(16)-[close(44)]-(28)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(inset)-[info]-(inset)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(inset)-[confirm]-(inset)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(inset)-[close]-(inset)-|" options:0 metrics:metrics views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sunlightLogoView attribute:NSLayoutAttributeCenterX toItem:infoLabel]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openCongressLogoView attribute:NSLayoutAttributeCenterX toItem:infoLabel]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)confirm {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SFOCEmailConfirmation];
    if (_ocEmailConfirmationDelegate && [_ocEmailConfirmationDelegate respondsToSelector:@selector(setShouldShowEmailComposer:)]) {
        [_ocEmailConfirmationDelegate setShouldShowEmailComposer:YES];
    }
    [self close];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
