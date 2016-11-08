//
//  AppDelegate.m
//  CCQchat
//
//  Created by 夜兔神威 on 2016/11/8.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<EMClientDelegate>

@end

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
