//
//  SFLegislatorDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailView.h"
#import "SFCalloutView.h"

@implementation SFLegislatorDetailView
{
    SFCalloutView *_calloutView;
    UIView *_photoFrame;
    NSArray *_decorativeLines;
}

@synthesize nameLabel = _nameLabel;
@synthesize infoText = _infoText;
@synthesize contactLabel = _contactLabel;
@synthesize addressLabel = _addressLabel;
@synthesize photo = _photo;
@synthesize socialButtonsView = _socialButtonsView;
@synthesize callButton = _callButton;
@synthesize officeMapButton = _officeMapButton;
@synthesize districtMapButton = _districtMapButton;
@synthesize websiteButton = _websiteButton;
@synthesize favoriteButton = _favoriteButton;

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)_initialize
{
    self.insets = UIEdgeInsetsMake(4.0f, 4.0f, 0, 4.0f);
    _decorativeLines = [NSMutableArray array];

    _contactLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contactLabel.textColor = [UIColor subtitleColor];
    _contactLabel.backgroundColor = [UIColor clearColor];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
    _contactLabel.lineBreakMode = NSLineBreakByClipping;
    [self addSubview:_contactLabel];
    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
    for (SSLineView *lview in _decorativeLines) {
        lview.lineColor = [UIColor detailLineColor];
        [self addSubview:lview];
    }

    _addressLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _addressLabel.textColor = [UIColor primaryTextColor];
    _addressLabel.font = [UIFont bodySmallFont];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.numberOfLines = 2;
    [_addressLabel setAccessibilityLabel:@"DC Office Address"];
    [self addSubview:_addressLabel];

    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    _calloutView.insets = UIEdgeInsetsMake(9.0f, 9.0f, 0, 9.0f);
    [self addSubview:_calloutView];

    _photo = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 100.0f, 125.f)];
    _photoFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108.0f, 133.f)];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage photoFrame]];
    backgroundView.size = _photoFrame.size;
    [_photoFrame addSubview:backgroundView];
    [_photoFrame addSubview:_photo];
    [_calloutView addSubview:_photoFrame];

    _nameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont legislatorTitleFont];
    _nameLabel.textColor = [UIColor primaryTextColor];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setAccessibilityLabel:@"Legislator"];
    [_calloutView addSubview:_nameLabel];

    _infoText = [[UILabel alloc] initWithFrame:CGRectZero];
    _infoText.font = [UIFont bodyTextFont];
    _infoText.textColor = [UIColor primaryTextColor];
    _infoText.numberOfLines = 0;
    _infoText.textAlignment = NSTextAlignmentLeft;
    _infoText.lineBreakMode = NSLineBreakByWordWrapping;
    _infoText.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_infoText];

    _favoriteButton = [[SFFavoriteButton alloc] init];
    [self addSubview:_favoriteButton];

    _officeMapButton = [SFCongressButton buttonWithTitle:@"Map Office"];
    [_officeMapButton setAccessibilityHint:@"Tap to load D.C. office in Apple maps"];
    [self addSubview:_officeMapButton];

    _callButton = [SFCongressButton buttonWithTitle:@"Call Office"];
    [_callButton setAccessibilityHint:@"Tap to initiate a call to the legislator's D.C. office"];
    [self addSubview:_callButton];

    _socialButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
    [_calloutView addSubview:_socialButtonsView];
    
    _websiteButton = [SFImageButton button];
    [_websiteButton setImage:[UIImage websiteImage] forState:UIControlStateNormal];
    [_calloutView addSubview:_websiteButton];

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    _calloutView.top = self.topInset;
    _calloutView.left = self.leftInset;
    _calloutView.width = self.insetsWidth;

    [_favoriteButton sizeToFit];
    _favoriteButton.right = self.width - self.rightInset;
    _favoriteButton.top = 0;

    CGFloat photoOffset = _photoFrame.right + 9.0f;

    CGFloat maxNameWidth = _calloutView.insetsWidth - photoOffset - (_calloutView.insetsWidth-_favoriteButton.left+ _favoriteButton.horizontalPadding/2);
    CGFloat maxHeight = _nameLabel.numberOfLines * _nameLabel.font.lineHeight;
    CGSize nameLabelFit = [_nameLabel sizeThatFits:CGSizeMake(maxNameWidth, maxHeight)];
    _nameLabel.frame = CGRectMake(photoOffset, _photoFrame.top, maxNameWidth, nameLabelFit.height);

    [_infoText sizeToFit];
    _infoText.frame = CGRectMake(photoOffset, _nameLabel.bottom + 5.0f, (_calloutView.insetsWidth- _photoFrame.right - 9.0f), _infoText.height);

    NSArray *subviews = [_socialButtonsView subviews];
    SFImageButton *previousSubView = nil;
    CGFloat svMaxHeight = 0.0f;
    CGFloat socialButtonPadding;
    for (SFImageButton *sv in subviews) {
        [sv sizeToFit];
        CGFloat xPos = 0.0f;
        if (previousSubView) {
            xPos = previousSubView.right;
        }
        sv.frame = CGRectMake(xPos, 0.0f, sv.width, sv.height);
        previousSubView = sv;
        svMaxHeight = MAX(svMaxHeight, sv.height);
    }
    socialButtonPadding = previousSubView.verticalPadding;
    [_websiteButton sizeToFit];

    CGFloat socialViewLeft = photoOffset-10.0f;
    [_socialButtonsView layoutSubviews];
    _socialButtonsView.frame = CGRectMake(socialViewLeft, ceilf(_photoFrame.bottom - svMaxHeight+previousSubView.verticalPadding), (4*44.0f), svMaxHeight);

    [_calloutView layoutSubviews];

    [_contactLabel sizeToFit];
    _contactLabel.top = _calloutView.bottom + 7.0f;
    _contactLabel.center = CGPointMake((self.width/2), _contactLabel.center.y);

    SSLineView *lview = _decorativeLines[0];
    lview.width = _contactLabel.left - 9.0f - _calloutView.leftInset;
    lview.left = 9.0f;
    lview.center = CGPointMake(lview.center.x, _contactLabel.center.y);
    lview = _decorativeLines[1];
    lview.width = _calloutView.width - _contactLabel.right - 9.0f;
    lview.right = self.width - 9.0f;
    lview.center = CGPointMake(lview.center.x, _contactLabel.center.y);

    lview = _decorativeLines[0];
    CGFloat addressAreaTop = _contactLabel.bottom + 9.0f;
    CGSize addressLabelSize = CGSizeMake(_calloutView.width, (_addressLabel.font.lineHeight*_addressLabel.numberOfLines));
    _addressLabel.frame = CGRectMake(lview.left, addressAreaTop, addressLabelSize.width, addressLabelSize.height);

    [_callButton sizeToFit];
    _callButton.right = self.width - 9.0f;
    _callButton.top = addressAreaTop - _callButton.verticalPadding;

    [_officeMapButton sizeToFit];
    _officeMapButton.right = _callButton.left - 4.0f;
    _officeMapButton.top = addressAreaTop - _callButton.verticalPadding;
}


@end
