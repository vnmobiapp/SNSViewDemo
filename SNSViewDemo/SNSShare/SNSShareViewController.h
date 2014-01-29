//
//  SNSShareViewController.h
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/27.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSShareView.h"
#import "CustomIOS7AlertView.h"
#import <MessageUI/MessageUI.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import <GooglePlus/GooglePlus.h>
#import "MBProgressHUD.h"
#import "Header.h"

enum {
    skfacebook,
    sktwitter,
    skline,
    skgoogleplus,
    skmail,
    sknone,
};

@protocol SnSShareResultDelegate;

@interface SNSShareViewController : UIViewController<SNSShareViewDelegate,CustomIOS7AlertViewDelegate,
MFMailComposeViewControllerDelegate,SA_OAuthTwitterControllerDelegate,GPPSignInDelegate,GPPShareDelegate,MBProgressHUDDelegate>
@property(nonatomic, strong)NSString* beginShareString;
@property(nonatomic, strong)NSString* mailName;
@property(nonatomic)id<SnSShareResultDelegate> delegate;

- (void)loadGooglePlusDialog;
- (void)showIndicatorUntilFinishAuth;
- (void)finishIndicatorWithAuth;

@end


@protocol SnSShareResultDelegate <NSObject>

@required
- (void)shareSucceeded: (int)skSNSmode;
- (void)shareFailed: (int)skSNSmode;

@end