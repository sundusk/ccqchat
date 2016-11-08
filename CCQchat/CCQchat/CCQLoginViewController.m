//
//  CCQLoginViewController.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQLoginViewController.h"

@interface CCQLoginViewController ()

/**
 账号
 */
@property (weak, nonatomic) IBOutlet UITextField *accountTF;

/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation CCQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 点击事件

/**
 注册
 */
- (IBAction)clickRegisterBth:(id)sender {
    EMError *error = [[EMClient sharedClient] registerWithUsername:self.accountTF.text  password:self.pwdTF.text];
    if (error==nil) {
        NSLog(@"注册成功");
    }
}

/**
 登录
 */
- (IBAction)clickLoginBth:(id)sender {
    EMError *error = [[EMClient sharedClient] loginWithUsername:self.accountTF.text password:self.pwdTF.text];
    if (!error) {
        NSLog(@"登录成功");
    }
}

@end
