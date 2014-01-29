//
//  Header.h
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/29.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#ifndef SNSViewDemo_Header_h
#define SNSViewDemo_Header_h

/* TwitterのID */
#define		TwitterConsumerKey		@"iMtKFPgsve2nT5FCg8OHQ"
#define		TwitterConsumerSecret	@"0A5weL86v8hdBlylvwxwEIGBXCwEOjgpLMNty2EzFrY"
/* Google_PlusのID */
#define     kClientId               @"678205940706-mockd4ak6eubm8vi835a9i2jlipblcqk.apps.googleusercontent.com"

/* FacebookのID */
#define FacebookAppId @"fb502435656543851"

/* サイズ */
#define SnsShareSizeWidth   320
#define SnsShareSizeHeight  55
#define SnsBtnSize          44

/* Macro */
#define	UIColorFromRGBA(R,G,B,A) [UIColor colorWithRed:((float)R/255.0) green:((float)G/255.0) blue:((float)B/255.0) alpha:(float)A]

/* メッセージ */
#define Sns_default_mailname            @"お知らせ"
#define Sns_default_first_share_mess    @"おはよう御座います！"

/* リソース名 */
#define Sns_resources_fb_btn_on         @"btn_fb_on.png"
#define Sns_resources_fb_btn_off        @"btn_fb_off.png"

#define Sns_resources_tw_btn_on         @"btn_tw_on.png"
#define Sns_resources_tw_btn_off        @"btn_tw_off.png"

#define Sns_resources_line_btn_on       @"btn_line_on.png"
#define Sns_resources_line_btn_off      @"btn_line_off.png"

#define Sns_resources_gp_btn_on         @"btn_gp_on.png"
#define Sns_resources_gp_btn_off        @"btn_gp_off.png"

#define Sns_resources_mail_btn_on       @"btn_mail_on.png"
#define Sns_resources_mail_btn_off      @"btn_mail_off.png"

#endif
