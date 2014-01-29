//
//  DemoViewController.m
//  SNSViewDemo
//  Version 1.0
//
//  Created by Hoang Anh on 2014/01/28.
//  Copyright (c) 2014年 vnmobiapp. All rights reserved.
//

#import "DemoViewController.h"
#import "iToast.h"

@interface DemoViewController ()
{
    // SNS
    iToast* _snsToast;
}
@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor purpleColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    SNSShareViewController* snsShare = [[SNSShareViewController alloc] init];
    snsShare.delegate = self;
    [self addChildViewController:snsShare];
    [self.view addSubview:snsShare.view];
    snsShare.view.frame = CGRectMake(0, screenSize.height/2, SnsShareSizeWidth, SnsShareSizeHeight);
    [snsShare didMoveToParentViewController:self];

    // SNS Toast
    _snsToast = [[iToast alloc] initWithText:@""];
    [_snsToast setDuration:3000];
    [_snsToast setGravity:iToastGravityBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
@end
