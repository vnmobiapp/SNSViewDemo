//
//  AppDelegate.m
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/27.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import "AppDelegate.h"
#import "SNSShareViewController.h"
#import "Header.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Facebook
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Facebook
    [FBSession.activeSession close];
}

// Facebookとgoogle plus
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    // Facebookの場合
    if ([url.scheme isEqualToString:FacebookAppId]) {
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }

    // Google plusの場合
    // 働いている画面を取得
    id view = [self getTopController];
    // Indicatorを表示する
    if([view respondsToSelector:@selector(showIndicatorUntilFinishAuth)]){
        [view showIndicatorUntilFinishAuth];
    }

    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

-(id)getTopController{
	UIViewController *controller = (UIViewController *)self.window.rootViewController;
	id ctr = [[controller childViewControllers] lastObject];
	return ctr;
}

@end
