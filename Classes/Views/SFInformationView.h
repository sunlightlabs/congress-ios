//
//  SFInformationView.h
//  Congress
//
//  Created by Daniel Cloud on 12/2/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"

@class SFLabel;
@class TTTAttributedLabel;
@class SFCongressButton;

@interface SFInformationView : SFContentView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SFLabel *headerLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) SFCongressButton *donateButton;
@property (nonatomic, strong) SFCongressButton *feedbackButton;
@property (nonatomic, strong) SFCongressButton *joinButton;

@end
