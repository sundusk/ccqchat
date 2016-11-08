//
//  AppDelegate.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate>
//好友请求数
@property (nonatomic, assign) NSInteger friendRequestCount;@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1101161108115711#ccqchat"];
    options.apnsCertName = nil;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //添加回调监听代理:
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //判断是否可以自动登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {//自动登录，修改根控制器
        // 获取tabBarVc
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // 设置根控制器
        [self window].rootViewController = [mainSB instantiateViewControllerWithIdentifier:@"CCQTabBar"];
    }
    return YES;
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

#pragma mark - EMContactManagerDelegate

/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    //接收到好友请求后,添加通讯录角标
    UITabBarController *tabBarVc = self.window.rootViewController;
    tabBarVc.viewControllers[1].tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", ++self.friendRequestCount];
    
    //让用户选择是否加好友
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@想要添加您为好友,备注:%@", aUsername, aMessage] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //同意请求
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送同意成功");
            //如果角标为0,则设置nil
            if (--self.friendRequestCount == 0) {
                
                tabBarVc.viewControllers[1].tabBarItem.badgeValue = nil;
            }else {
                
                tabBarVc.viewControllers[1].tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", self.friendRequestCount];
            }
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拒绝请求
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    //进行modal展示
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}


/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    //对方同意好友请求
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@已经成为您的好友", aUsername] preferredStyle:UIAlertControllerStyleAlert];
    //进行modal展示
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    //延迟销毁
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    //对方拒绝好友请求
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@拒绝成为您的好友", aUsername] preferredStyle:UIAlertControllerStyleAlert];
    //进行modal展示
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    //延迟销毁
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - EMClientDelegate
/*!
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    
    if (aError) {
        NSLog(@"自动登录失败%@",aError);
    }else{
        NSLog(@"自动登录成功");
    }
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    
    switch (aConnectionState) {
        case EMConnectionConnected:
            NSLog(@"已经连接");
            break;
        case EMConnectionDisconnected:
            NSLog(@"断开连接");
            break;
        default:
            break;
    }
}
/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{
    NSLog(@"其他设备已经登录该账号");
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer{
    NSLog(@"该账号不存在");
}


@end
