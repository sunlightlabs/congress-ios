//
//  SFFollowHowToView.m
//  Congress
//
//  Created by Daniel Cloud on 5/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFollowHowToView.h"
#import "SFLabel.h"
#import "SFLineView.h"

@implementation SFFollowHowToView
{
    SFLineView *_leftLine;
    SFLineView *_rightLine;
    SFLabel *_titleLabel;
    SFLabel *_starringDescription;
    UIImageView *_unselectedStarImage;
    UIImageView *_selectedStarImage;
//    SFLabel *_settingsDescription;
//    UIImageView *_settingsImage;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor primaryBackgroundColor];
        _leftLine = [[SFLineView alloc] initWithFrame:CGRectMake(0, 0, 2.0f, 1.0f)];
        _leftLine.lineColor = [UIColor detailLineColor];
        [self addSubview:_leftLine];
        _rightLine = [[SFLineView alloc] initWithFrame:CGRectMake(0, 0, 2.0f, 1.0f)];
        _rightLine.lineColor = [UIColor detailLineColor];
        [self addSubview:_rightLine];

        _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.textColor = [UIColor subtitleColor];
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"HOW TO " attributes:@{ NSFontAttributeName: [UIFont subitleStrongFont] }];
        [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Follow" attributes:@{ NSFontAttributeName: [UIFont subitleEmFont] }]];
        _titleLabel.attributedText = titleString;
        [self addSubview:_titleLabel];

        _starringDescription = [[SFLabel alloc] initWithFrame:CGRectZero];
        _starringDescription.userInteractionEnabled = NO;
        _starringDescription.backgroundColor = self.backgroundColor;
        _starringDescription.font = [UIFont bodyTextFont];
        _starringDescription.textColor = [UIColor primaryTextColor];
        _starringDescription.numberOfLines = 0;
        [_starringDescription setText:@"Tap the star icon on a page to add it to your following list for quick access and updates."
                          lineSpacing:[NSParagraphStyle lineSpacing]];
        [self addSubview:_starringDescription];

        _unselectedStarImage = [[UIImageView alloc] initWithImage:[UIImage followUnselectedImage]];
        [self addSubview:_unselectedStarImage];
        _selectedStarImage = [[UIImageView alloc] initWithImage:[UIImage followIsSelectedImage]];
        [self addSubview:_selectedStarImage];


//        _settingsDescription = [[SFLabel alloc] initWithFrame:CGRectZero];
//        _settingsDescription.userInteractionEnabled = NO;
//        _settingsDescription.backgroundColor = self.backgroundColor;
//        _settingsDescription.font = [UIFont bodyTextFont];
//        _settingsDescription.textColor = [UIColor primaryTextColor];
//        _settingsDescription.numberOfLines = 0;
//        [_settingsDescription setText:@"To edit what you follow, tap the star again to deselect it or go to the settings page in the lower left of the sidebar."
//                          lineSpacing:[NSParagraphStyle lineSpacing]];
//        [self addSubview:_settingsDescription];
//
//        _settingsImage = [[UIImageView alloc] initWithImage:[UIImage settingsButtonImage]];
//        [self addSubview:_settingsImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _leftLine.frame = CGRectMake(4.0f, 0, 18.0f, 1.0f);
    [_titleLabel sizeToFit];
    _titleLabel.left = _leftLine.right + 8.0f;
    _titleLabel.top = 36.0f;
    _rightLine.frame = CGRectMake(_titleLabel.right + 8.0f, 0, (self.width - (_titleLabel.right + 8.0f) - 8.0f), 1.0f);
    _leftLine.center = CGPointMake(_leftLine.center.x, _titleLabel.center.y);
    _rightLine.center = CGPointMake(_rightLine.center.x, _titleLabel.center.y);

    CGSize fitSize = [_starringDescription sizeThatFits:CGSizeMake(190.0f, CGFLOAT_MAX)];
    _starringDescription.frame = CGRectMake(86.0f, _titleLabel.bottom + 45.0f, fitSize.width, fitSize.height);

    _unselectedStarImage.frame = CGRectMake(0, _starringDescription.top + 4.0f, _unselectedStarImage.width, _unselectedStarImage.height);
    _unselectedStarImage.center = CGPointMake(_titleLabel.center.x, _unselectedStarImage.center.y);

    _selectedStarImage.frame = CGRectMake(0, _unselectedStarImage.bottom + 6.0f, _selectedStarImage.width, _selectedStarImage.height);
    _selectedStarImage.center = CGPointMake(_titleLabel.center.x, _selectedStarImage.center.y);

//    CGSize settingsDescriptionSize = [_settingsDescription sizeThatFits:CGSizeMake(190.0f, CGFLOAT_MAX)];
//    _settingsDescription.frame = CGRectMake(86.0f, _starringDescription.bottom + 45.0f, settingsDescriptionSize.width, settingsDescriptionSize.height);
//
//    _settingsImage.frame = CGRectMake(0, _settingsDescription.top + 4.0f, _settingsImage.width, _settingsImage.height);
//    _settingsImage.center = CGPointMake(_titleLabel.center.x, _settingsDescription.center.y);
}

@end
