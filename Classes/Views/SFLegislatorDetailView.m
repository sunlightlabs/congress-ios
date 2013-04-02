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
    self.insets = UIEdgeInsetsMake(8.0f, 8.0f, 16.0f, 8.0f);
    _decorativeLines = [NSMutableArray array];

    _contactLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contactLabel.textColor = [UIColor primaryTextColor];
    _contactLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.numberOfLines = 1;
    [self addSubview:_contactLabel];
    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
    for (SSLineView *lview in _decorativeLines) {
        lview.lineColor = [UIColor detailLineColor];
        [self addSubview:lview];
    }

    _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _addressLabel.textColor = [UIColor primaryTextColor];
    _addressLabel.font = [UIFont bodyTextFont];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.numberOfLines = 0;
    [self addSubview:_addressLabel];

    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    _calloutView.insets = UIEdgeInsetsMake(14.0f, 14.0f, 13.0f, 7.0f);
    [self addSubview:_calloutView];

    _photo = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 100.0f, 125.f)];
    _photoFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108.0f, 133.f)];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage photoFrame]];
    backgroundView.size = _photoFrame.size;
    [_photoFrame addSubview:backgroundView];
    [_photoFrame addSubview:_photo];
    [_calloutView addSubview:_photoFrame];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont legislatorTitleFont];
    _nameLabel.textColor = [UIColor primaryTextColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.backgroundColor = [UIColor clearColor];
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

    _callButton = [SFCongressButton buttonWithTitle:@"Call"];
    [self addSubview:_callButton];

    _websiteButton = [SFCongressButton buttonWithTitle:@"Website"];
    [self addSubview:_websiteButton];

    _socialButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_socialButtonsView];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    _calloutView.top = self.topInset;
    _calloutView.left = self.leftInset;
    _calloutView.width = self.insetsWidth;

    [_favoriteButton sizeToFit];
    _favoriteButton.right = self.width - self.rightInset;
    _favoriteButton.top = self.topInset;

    CGFloat colWidth = self.insetsWidth - (_photoFrame.right + 4.0f);
    _nameLabel.frame = CGRectMake(_photoFrame.right + 9.0f, (_photoFrame.top + _photoFrame.width/4), colWidth, 0.0f);
    [_nameLabel sizeToFit];

    [_infoText sizeToFit];
    _infoText.frame = CGRectMake(_photoFrame.right + 9.0f, _nameLabel.bottom + 5.0f, (_calloutView.insetsWidth- _photoFrame.right - 9.0f), _infoText.height);

    [_calloutView layoutSubviews];

    [_contactLabel sizeToFit];
    CGSize contactLabelSize = _contactLabel.attributedText.size;
    _contactLabel.frame = CGRectMake(0, _calloutView.bottom + 7.0f, contactLabelSize.width, contactLabelSize.height);
    _contactLabel.center = CGPointMake((self.width/2), _contactLabel.center.y);

    SSLineView *lview = _decorativeLines[0];
    lview.width = _contactLabel.left - 16.0f;
    lview.left = 17.0f;
    lview.center = CGPointMake(lview.center.x, _contactLabel.center.y);
    lview = _decorativeLines[1];
    lview.width = self.width - _contactLabel.right - 17.0f - self.rightInset;
    lview.right = self.width - self.rightInset;
    lview.center = CGPointMake(lview.center.x, _contactLabel.center.y);

    NSArray *subviews = [_socialButtonsView subviews];
    SFImageButton *previousSubView = nil;
    CGFloat svMaxHeight = 0.0f;
    CGFloat svWidth = 0.0f;
    CGFloat socialButtonPadding;
    for (SFImageButton *sv in subviews) {
        [sv sizeToFit];
        CGFloat xPos = 0.0f;
        if (previousSubView) {
            xPos = previousSubView.right;
        }
        sv.frame = CGRectMake(xPos, 0.0f, sv.width, sv.height);
        previousSubView = sv;
        svWidth = sv.right;
        svMaxHeight = MAX(svMaxHeight, sv.height);
    }
    socialButtonPadding = previousSubView.verticalPadding;
    [_socialButtonsView layoutSubviews];
    _socialButtonsView.frame = CGRectMake(self.leftInset, (_contactLabel.bottom + 8.0f - socialButtonPadding), svWidth, svMaxHeight);

    [_addressLabel sizeToFit];
    _addressLabel.top = _socialButtonsView.top + socialButtonPadding;
    _addressLabel.left = _socialButtonsView.right + 10.0f;

    lview = _decorativeLines[0];
    [_websiteButton sizeToFit];
    _websiteButton.left = lview.left;
    _websiteButton.top = _socialButtonsView.bottom;


    [_callButton sizeToFit];
    _callButton.right = self.right - self.rightInset;
    _callButton.top = _addressLabel.bottom + 8.0f;

}


@end
