//
//  CCQSettingsViewController.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSettingsViewController.h"

@interface CCQSettingsViewController ()<UITableViewDelegate>

@end

@implementation CCQSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 & indexPath.row == 0) {
        //执行退出登录
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
            //跳转根控制器
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[UIApplication sharedApplication].delegate window].rootViewController = [mainSB instantiateViewControllerWithIdentifier:@"CCQLogin"];
            
        }
        
    }
}


@end
