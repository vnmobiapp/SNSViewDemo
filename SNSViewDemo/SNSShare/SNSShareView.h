//
//  SNSShareView.h
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/27.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "Header.h"

@protocol  SNSShareViewDelegate;

@interface SNSShareView : UIView

@property id <SNSShareViewDelegate>delegate;


@end


@protocol SNSShareViewDelegate <NSObject>

@required
- (void)clickBtnFacebook;
- (void)clickBtnTwitter;
- (void)clickBtnLine;
- (void)clickBtnGooglePlus;
- (void)clickBtnMail;

@end