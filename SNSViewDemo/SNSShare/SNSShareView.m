//
//  SNSShareView.m
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/27.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import "SNSShareView.h"
#import "BTButton.h"

@implementation SNSShareView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}


- (void)loadView
{
    // facebookボタン
    BTButton* btnFacebook = [BTButton buttonWithType:UIButtonTypeRoundedRect];
    [btnFacebook setImage:[UIImage imageNamed:Sns_resources_fb_btn_off] forState:UIControlStateNormal];
    [btnFacebook setImage:[UIImage imageNamed:Sns_resources_fb_btn_on] forState:UIControlStateHighlighted];
    [btnFacebook setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]];
    [btnFacebook setBackgroundColorHighlighted:[UIColor colorWithRed:0.f green:0.f blue:255.f alpha:0.5f]];
    [btnFacebook addTarget:_delegate action:@selector(clickBtnFacebook) forControlEvents:UIControlEventTouchUpInside];
    [btnFacebook setCornerRadius:6.f];
    [btnFacebook setExclusiveTouch:YES];

    // twitterボタン
    BTButton* btnTwitter = [BTButton buttonWithType:UIButtonTypeRoundedRect];
    [btnTwitter setImage:[UIImage imageNamed:Sns_resources_tw_btn_off] forState:UIControlStateNormal];
    [btnTwitter setImage:[UIImage imageNamed:Sns_resources_tw_btn_on] forState:UIControlStateHighlighted];
    [btnTwitter setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]];
    [btnTwitter setBackgroundColorHighlighted:[UIColor colorWithRed:0.f green:0.f blue:255.f alpha:0.5f]];
    [btnTwitter addTarget:_delegate action:@selector(clickBtnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [btnTwitter setCornerRadius:6.f];
    [btnTwitter setExclusiveTouch:YES];

    // lineボタン
    BTButton* btnLine = [BTButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLine setImage:[UIImage imageNamed:Sns_resources_line_btn_off] forState:UIControlStateNormal];
    [btnLine setImage:[UIImage imageNamed:Sns_resources_line_btn_on] forState:UIControlStateHighlighted];
    [btnLine setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]];
    [btnLine setBackgroundColorHighlighted:[UIColor colorWithRed:0.f green:0.f blue:255.f alpha:0.5f]];
    [btnLine addTarget:_delegate action:@selector(clickBtnLine) forControlEvents:UIControlEventTouchUpInside];
    [btnLine setCornerRadius:6.f];
    [btnLine setExclusiveTouch:YES];

    // googleplusボタン
    BTButton* btnGoogleplus = [BTButton buttonWithType:UIButtonTypeRoundedRect];
    [btnGoogleplus setImage:[UIImage imageNamed:Sns_resources_gp_btn_off] forState:UIControlStateNormal];
    [btnGoogleplus setImage:[UIImage imageNamed:Sns_resources_gp_btn_on] forState:UIControlStateHighlighted];
    [btnGoogleplus setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]];
    [btnGoogleplus setBackgroundColorHighlighted:[UIColor colorWithRed:0.f green:0.f blue:255.f alpha:0.5f]];
    [btnGoogleplus addTarget:_delegate action:@selector(clickBtnGooglePlus) forControlEvents:UIControlEventTouchUpInside];
    [btnGoogleplus setCornerRadius:6.f];
    [btnGoogleplus setExclusiveTouch:YES];

    // mailボタン
    BTButton* btnMail = [BTButton buttonWithType:UIButtonTypeRoundedRect];
    [btnMail setImage:[UIImage imageNamed:Sns_resources_mail_btn_off] forState:UIControlStateNormal];
    [btnMail setImage:[UIImage imageNamed:Sns_resources_mail_btn_on] forState:UIControlStateHighlighted];
    [btnMail setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3f]];
    [btnMail setBackgroundColorHighlighted:[UIColor colorWithRed:0.f green:0.f blue:255.f alpha:0.5f]];
    [btnMail addTarget:_delegate action:@selector(clickBtnMail) forControlEvents:UIControlEventTouchUpInside];
    [btnMail setCornerRadius:6.f];
    [btnMail setExclusiveTouch:YES];


    // ボタンの位置設定
    #define base_x      12
    #define base_y      8
    #define margin_x    63
    btnFacebook.frame   = CGRectMake(base_x, base_y, SnsBtnSize, SnsBtnSize);
    btnTwitter.frame    = CGRectMake(base_x + margin_x, base_y, SnsBtnSize, SnsBtnSize);
    btnLine.frame       = CGRectMake(base_x + margin_x*2, base_y, SnsBtnSize, SnsBtnSize);
    btnGoogleplus.frame = CGRectMake(base_x + margin_x*3, base_y, SnsBtnSize, SnsBtnSize);
    btnMail.frame       = CGRectMake(base_x + margin_x*4, base_y, SnsBtnSize, SnsBtnSize);

    // ボタンを追加
    [self addSubview:btnFacebook];
    [self addSubview:btnTwitter];
    [self addSubview:btnLine];
    [self addSubview:btnGoogleplus];
    [self addSubview:btnMail];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    // line部分
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    CGRect lineRect = rect;
    lineRect.size.height = 5;
    CGContextSetFillColorWithColor(context, redColor.CGColor);
	CGContextFillRect(context, lineRect);


    // gradient部分
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    CGRect gradientRect = rect;
    gradientRect.origin.y = 5;
    drawLinearGradient(context, gradientRect, whiteColor.CGColor, lightGrayColor.CGColor);
}

// copy from ...
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };

    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
