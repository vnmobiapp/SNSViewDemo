SNSViewDemo
==================

ソーシャル投稿ツールの使い方	
---------------------------------

**① ツールの長所**

* facebook,twitter,line,google+,mail投稿機能が簡単に出来る。                     
* SNSShareViewは別にしたのでボタンの位置、画面のカスタマイズを容易に行うことが出来る。

[![](http://s13.postimg.org/eglpodufr/SNSShare_View_Image.png)](http://s13.postimg.org/eglpodufr/SNSShare_View_Image.png)

**② 必要なフレームワーク**

* Twitter						
	−　Twitter+OAuth 					
	−　YAJLiOS					

* Facebook						
	－　FacebookSDK					

 * Google+					
	−　iosから						
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

	　−　Sdkから				
		GooglePlus.framework				
		GooglePlus.bundle				
		GoogleOpenSource.framework		
	
* 外部ツール					
　−　MBProgressHUD				
　−　CustomIOS7AlertView					
　−　BTButton				
　−　iToast						

**③ 設定**

* ビュー設定のところに：Other Linker Flags: -ObjC				
* Google+用のscheme					
* Facebook用のscheme				
* ARCクラス以外の場合、：-fno-objc-arc　を追加する				
* AppDelegate.mにFacebook,Goolge+用の設定を入れる

**④ SNSShareを追加する**
 
表示したいControllerにController.mファイルに下記のようにSNSShareビューを追加する

	SNSShareViewController* snsShare = [[SNSShareViewController alloc] init];			
    snsShare.delegate = self;			
    [self addChildViewController:snsShare];						
    [self.view addSubview:snsShare.view];			
    snsShare.view.frame = CGRectMake(0, screenSize.height - SnsShareSizeHeight, SnsShareSizeWidth, SnsShareSizeHeight);					
    [snsShare didMoveToParentViewController:self];			
	
投稿結果を取るようにSNSShareResultDelegateのメーソッドを追加する				

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

**⑤ 具体的にはSNSViewDemoを参考にしてください。**

以上です。

