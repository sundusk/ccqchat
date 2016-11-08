//
//  CCQProfileViewController.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQProfileViewController.h"

@interface CCQProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end

@implementation CCQProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNameLabel.text = [EMClient sharedClient].currentUsername;
}


@end
