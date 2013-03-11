//
//  SFCongressSettingsViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressSettingsViewController.h"
#import "IIViewDeckController.h"

@implementation SFCongressSettingsViewController

@synthesize headerLabel = _headerLabel;
@synthesize descriptionLabel = _descriptionLabel;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Settings";

        _headerLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
        _headerLabel.text = @"About Congress for iOS";

        _descriptionLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.text = @"Lorem ipsum dolor sit amet ultrices risus felis penatibus venenatis molestie imperdiet augue Class habitant pulvinar malesuada laoreet cubilia, tempor in consectetuer ornare pellentesque Ut orci, cursus placerat! Mauris Duis diam wisi ornare. Habitant.\n\nInceptos primis aliquam inceptos cubilia sociosqu massa! Conubia dis dui. Ultrices. Vivamus ut condimentum habitant. Natoque laoreet congue. Habitasse, taciti Nunc!!";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    _headerLabel.backgroundColor = self.view.backgroundColor;
    _headerLabel.textColor = [UIColor primaryTextColor];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_headerLabel];
    _headerLabel.width = self.view.width;

    _descriptionLabel.backgroundColor = self.view.backgroundColor;
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.preferredMaxLayoutWidth = self.view.width;
    [self.view addSubview:_descriptionLabel];
    _descriptionLabel.width = self.view.width;
    _descriptionLabel.top = _headerLabel.bottom;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_headerLabel, _descriptionLabel);
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[_headerLabel]-|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[_descriptionLabel]-|"
                               options:0 metrics:nil views:viewsDictionary]];
    CGSize constrainedSize = CGSizeMake(_descriptionLabel.width - 50.0f, self.view.frame.size.height);
    CGSize labelSize = [_descriptionLabel.text sizeWithFont:_descriptionLabel.font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-[_headerLabel]-20-[_descriptionLabel(>=descHeight)]"
                               options:0 metrics:@{@"descHeight":@(labelSize.height)} views:viewsDictionary]];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
