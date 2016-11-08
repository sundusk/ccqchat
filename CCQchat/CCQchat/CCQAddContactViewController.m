//
//  CCQAddContactViewController.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQAddContactViewController.h"

@interface CCQAddContactViewController ()<UITextFieldDelegate>

@end

@implementation CCQAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //添加好友
    EMError *error = [[EMClient sharedClient].contactManager addContact:textField.text message:[NSString stringWithFormat:@"李四,我是三哥~"]];
    if (!error) {
        NSLog(@"好友请求发送成功");
        
    }
    
    return YES;
    
}

@end
