SNSViewDemo
===========

ソーシャル投稿ツール（？）デモ
－－－－－－－－－－－－－－－－－－－
①　ツールの長所
　－　facebook,twitter,line,google+,mail投稿機能は簡単に出来る。
　－　SNSShareViewは別にしたのでボタンの位置、画面をカスタマイズするのは簡単に出来る。
－－－－－－－－－－－－－－－－－－－
②　
＋　必要なフレームワーク
   // Twitter
　－　Twitter+OAuth <単品の場合と同様になる>
　－　YAJLiOS		  <単品の場合と同様になる>

　// Facebook
　－　FacebookSDK

　// Google+
　－　 iosから
	•	AddressBook.framework
	•	AssetsLibrary.framework
	•	Foundation.framework
	•	CoreLocation.framework
	•	CoreMotion.framework
	•	CoreGraphics.framework
	•	CoreText.framework
	•	MediaPlayer.framework
	•	Security.framework
	•	SystemConfiguration.framework
	•	UIKit.framework

　－　 Sdkから
	GooglePlus.framework
	GooglePlus.bundle
	GoogleOpenSource.framework
　
＋　外部ツール
　−　MBProgressHUD
　−　CustomIOS7AlertView
　−　BTButton
　−　iToast
－－－－－－－－－－－－－－－－－－－
③　設定
＋　ビュー設定のところに：Other Linker Flags: -ObjC
＋　Google+用のscheme
＋　Facebook用のscheme
＋　ARCじゃないのクラス：-fno-objc-arc　を追加する
＋　AppDelegate.mにFacebook,Goolge+用の設定を入れる
－－－－－－－－－－－－－－－－－－－
④　SNSShareを追加する
＋　表示したいControllerにController.mファイルに下記のようにSNSShareビューを追加する
	SNSShareViewController* snsShare = [[SNSShareViewController alloc] init];
    snsShare.delegate = self;
    [self addChildViewController:snsShare];
    [self.view addSubview:snsShare.view];
    snsShare.view.frame = CGRectMake(0, screenSize.height - SnsShareSizeHeight, 		SnsShareSizeWidth, SnsShareSizeHeight);
    [snsShare didMoveToParentViewController:self];

＋　投稿結果を取るようにSnSShareResultDelegateのメーソッドを追加する
#pragma SnSShareResultDelegate
- (void)shareSucceeded:(int)skSNSmode
{
    NSLog(@"shareSucceeded::%d:",skSNSmode);
    [_snsToast setText:@"投稿しました"];
    [_snsToast show];
}

- (void)shareFailed:(int)skSNSmode
{
    NSLog(@"shareFailed::%d:",skSNSmode);
    [_snsToast setText:@"投稿に失敗しました"];
    [_snsToast show];
}
－－－－－－－－－－－－－－－－－－－
⑤　具体的にはSNSViewDemoに参考をするようにお願いします。
－－－－－－－－－－－－－－－－－－－
以上です。

