//
//  SNSShareViewController.m
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/27.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import "SNSShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface SNSShareViewController ()
{
    int snsMode;
    UITextView* textView;
    SA_OAuthTwitterEngine *engine;
    BOOL isGooglePlusTouched;

    MBProgressHUD *_progressDialog;
}
@end

@implementation SNSShareViewController
@synthesize beginShareString = _beginShareString;
@synthesize mailName = _mailName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    SNSShareView* shareView = [[SNSShareView alloc] initWithFrame:CGRectMake(0, 0, SnsShareSizeWidth, SnsShareSizeHeight)];
    shareView.backgroundColor = [UIColor lightGrayColor];
    shareView.delegate = self;
    //[self.view addSubview:shareView];
    self.view = shareView;

    snsMode = sknone;
    if (_beginShareString == NULL) {
        _beginShareString = Sns_default_first_share_mess;
    }

    if (_mailName == NULL) {
        _mailName = Sns_default_mailname;
    }

    // Google Plus
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email

    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;

    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope

    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    //[signIn trySilentAuthentication];

    // Goolge+
    [GPPShare sharedInstance].delegate = self;

    // indicator
    _progressDialog = [[MBProgressHUD alloc] initWithView:self.view];
	_progressDialog.color = UIColorFromRGBA(214.0,48.0,105.0,0.0);
	_progressDialog.dimBackground = YES;
	_progressDialog.delegate = self;
    [self.view addSubview:_progressDialog];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SNSShareViewDelegate method
- (void)clickBtnFacebook
{
    snsMode = skfacebook;
    if (FBSession.activeSession.isOpen) {
        [self requestPermissonIfNeedAndLoadShareDialog];
    } else {
        [self openSession];
    }
}

- (void)clickBtnTwitter
{
    snsMode = sktwitter;
    [self showTwitterView];
}

- (void)clickBtnLine
{
    snsMode = skline;
    [self sendToLine];
}

- (void)clickBtnGooglePlus
{
    snsMode = skgoogleplus;
    isGooglePlusTouched = true;
    if([[GPPSignIn sharedInstance] authentication]){
        [self loadGooglePlusDialog];
    } else {
        [[GPPSignIn sharedInstance] authenticate];
    }
}

- (void)clickBtnMail
{
    snsMode = skmail;
    [self showMailView];
}

#pragma Facebook
// Facebookセッション作成
- (void)openSession {
    FBSession* sess = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
    [FBSession setActiveSession:sess];
    [sess openWithBehavior:(FBSessionLoginBehaviorForcingWebView) completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session
                            state:status
                            error:error];
    }];
}

// Facebookセッション変更処理
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
                [FBRequestConnection
                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                   NSDictionary<FBGraphUser> *user,
                                                   NSError *error) {
                     if (!error) {
                         [self requestPermissonIfNeedAndLoadShareDialog];
                     }
                 }];
            }

            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }

    if (state == FBSessionStateClosedLoginFailed) {
        // error message?
    }
    
}

// パーミッションを確認してから投稿ダイアログ表示
- (void)requestPermissonIfNeedAndLoadShareDialog {
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error && [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound) {
                                                    // Now have the permission
                                                    [self loadShareDialog];
                                                } else if (error){
                                                    // Facebook SDK * error handling *
                                                    // if the operation is not user cancelled
                                                    if ([FBErrorUtility errorCategoryForError:error] != FBErrorCategoryUserCancelled) {
                                                        // error message?
                                                    }
                                                }
                                            }];
    } else {
        [self loadShareDialog];
    }
}

// Facebook投稿
- (void)sendToFacebook: (NSString*)shareText
{
    [FBSettings setLoggingBehavior:[NSSet
                                    setWithObjects:FBLoggingBehaviorFBRequests,
                                    FBLoggingBehaviorFBURLConnections,
                                    nil]];

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    shareText, @"message",
                                    nil];

    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
                              if (error) {
                                  [self.delegate shareFailed:skfacebook];

                                  NSInteger underlyingSubCode = [[error userInfo]
                                                                 [@"com.facebook.sdk:ParsedJSONResponseKey"]
                                                                 [@"body"]
                                                                 [@"error"]
                                                                 [@"code"] integerValue];
                                  // 同じなメッセージ連続に投稿する意外のエラーになる場合ログアウトする
                                  if (underlyingSubCode != 506) {
                                      [FBSession.activeSession closeAndClearTokenInformation];
                                  }
                              } else {
                                  [self.delegate shareSucceeded:skfacebook];
                              }
                              // Show the result in an alert
                              [[self navigationController] popViewControllerAnimated:YES];
                          }];
}

#pragma dialog
- (void)loadShareDialog
{
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];

    // Add some custom content to the alert view
    [alertView setContainerView:[self makeShareDialog]];
    [alertView setTag:snsMode];

    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"投稿", @"閉じる", nil]];
    [alertView setDelegate:self];

    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];

    [alertView setUseMotionEffects:true];

    // And launch the dialog
    [alertView show];

}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        switch ([alertView tag]) {
            case skfacebook:
                NSLog(@"facebook投稿");
                [self sendToFacebook:textView.text];
                break;

            case sktwitter:
                NSLog(@"twitter投稿");
                [self sendToTwitter:textView.text];
                break;

            default:
                break;
        }
    }
    snsMode = sknone;
    [alertView close];
}


- (UIView*)makeShareDialog
{
    // background作成
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    //shareView.backgroundColor = [UIColor redColor];

    // icon作成
    UIImageView* iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 44, 44)];
    [shareView addSubview:iconImg];

    // title作成
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(54, 5, 182, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [shareView addSubview:title];

    // UItextview作成
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 54, 280, 140)];
    textView.text = _beginShareString;
    [shareView addSubview:textView];

    switch (snsMode) {
        case skfacebook:
            iconImg.image = [UIImage imageNamed:@"btn_fb_off.png"];
            title.text = @"Facebookへ投稿";
            break;
        case sktwitter:
            iconImg.image = [UIImage imageNamed:@"btn_tw_off.png"];
            title.text = @"Twitterへ投稿";
            break;
        default:
            break;
    }

    return shareView;
}

#pragma Line
// Line投稿
- (void)sendToLine
{
    snsMode = sknone;
    NSString *contentKey = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                 (CFStringRef)_beginShareString,
                                                                                                 NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    NSString *contentType = @"text";
    NSString *urlFormat = nil;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]]) {
        // インストールされている
        urlFormat = @"line://msg/%@/%@";
    }else{
        // インストールされていない
        urlFormat = @"http://line.naver.jp/R/msg/%@/?%@";
    }

    NSString *urlString = [NSString
                           stringWithFormat: urlFormat,
                           contentType, contentKey];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];

}

#pragma Mail
- (void)showMailView
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:_mailName];

	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"%@\n",_beginShareString];
    [picker setMessageBody:emailBody isHTML:YES];
    if (picker) {
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

#pragma mark - Mail Delegate Methods
//==========================================================================
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
//==========================================================================
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    snsMode = sknone;
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SNS Share Delegate Methods
// Twitter投稿
- (void)sendToTwitter:(NSString*)shareText
{
//    [self startIndicator:DLG_MESSAGE_M0018I];
    [engine sendUpdate: shareText];
}

// Twitterログイン
- (void)showTwitterView
{
    // TweetEngine初期化
    if (!engine)
    {
        engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        engine.consumerKey = TwitterConsumerKey;
        engine.consumerSecret = TwitterConsumerSecret;
    }

    // OAuthコントローラ設定
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: engine delegate: self];

    if (controller)
    {
        [self presentViewController:controller animated:YES completion:^{}];

    } else {
        [self loadShareDialog];
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    [self loadShareDialog];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {

}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
}

#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
    [self.delegate shareSucceeded:sktwitter];
    [[self navigationController] popToViewController:self animated:YES];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
    // アプリ連携に許可取り消しになった場合の処理
    BOOL logout = false;
    if (error) {
        logout = true;
        int statusCode = error.code;
        NSDictionary* userInfo = [error userInfo];
        if (statusCode == 403) {
            NSError* err;
            NSString* body = (NSString*)[userInfo objectForKey:@"body"];
            NSArray *array = [body componentsSeparatedByString:@"}]}"];
            NSString* bodyJSON = [[array objectAtIndex:0] stringByAppendingString:@"}]}"];
            if (body != nil) {
                NSData* data = [bodyJSON dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0 error:&err];
                NSArray* errors = [dict objectForKey:@"errors"];
                NSDictionary* errDict = [errors objectAtIndex:0];
                int errCode = [[errDict objectForKey:@"code"] intValue];
                // 同じなメッセージ連続に投稿するのエラーになる場合ログアウトしない
                if (errCode == 187) {
                    logout = false;
                }
            }
        }
    }
    // 同じなメッセージ連続に投稿する意外のエラーになる場合ログアウトする
    if (logout) {
        [engine clearAccessToken];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"authData"];
    }

    // 投稿失敗の処理
    [self.delegate shareFailed:sktwitter];
    [[self navigationController] popToViewController:self animated:YES];
}

#pragma Googleplus 
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
//    NSLog(@"Received error %@ and auth object %@",error, auth);
    [self finishIndicatorWithAuth];
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}

-(void)refreshInterfaceBasedOnSignIn
{
//    NSLog(@"you have logined");
    if ([[GPPSignIn sharedInstance] authentication]) {
        if (isGooglePlusTouched) {
            [self loadGooglePlusDialog];
        }
    } else {
    }
}

- (void)loadGooglePlusDialog
{
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    // Other sharing options might be defined here.
    [shareBuilder setPrefillText:_beginShareString];
    [shareBuilder open];
    isGooglePlusTouched = false;
}

// Google+投稿
- (void)finishedSharingWithError:(NSError *)error {
    if (!error) {
        [self.delegate shareSucceeded:skgoogleplus];
    } else if (error.code == kGPPErrorShareboxCanceled) {
        return;
    // Unauthorized場合ログアウトする
    } else if (error.code == 401) {
        [[GPPSignIn sharedInstance] signOut];
        return;
    } else {
        [self.delegate shareFailed:skgoogleplus];
    }
}

#pragma Indicator
- (void)showIndicatorUntilFinishAuth
{
    [_progressDialog show:YES];
}

- (void)finishIndicatorWithAuth
{
    [_progressDialog hide:YES];
}
@end
