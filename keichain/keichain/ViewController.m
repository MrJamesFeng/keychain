//
//  ViewController.m
//  keichain
//
//  Created by LDY on 17/4/26.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LAContext *context = [[LAContext alloc] init];
    // 当指纹识别失败一次后，弹框会多出一个选项，而这个属性就是用来设置那个选项的内容
    context.localizedFallbackTitle = @"使用密码登录";
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) { // 该设备支持指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"身份验证需要解锁指纹识别功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {  // 验证成功
                
            }else {
                
                NSLog(@"%@", error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        NSLog(@"身份验证被系统取消（验证时当前APP被移至后台或者点击了home键导致验证退出时提示）");
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"身份验证被用户取消（当用户点击取消按钮时提示）");
                        break;
                    case LAErrorAuthenticationFailed:
                        NSLog(@"身份验证没有成功，因为用户未能提供有效的凭据(连续3次验证失败时提示)");
                        break;
                    case LAErrorPasscodeNotSet:
                        NSLog(@"Touch ID无法启动，因为没有设置密码（当系统没有设置密码的时候，Touch ID也将不会开启）");
                        break;
                    case LAErrorTouchIDNotAvailable:
                        NSLog(@"无法启动身份验证");  // 这个没有检测到，应该是出现硬件损坏才会出现
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        NSLog(@"无法启动身份验证，因为触摸标识没有注册的手指");  // 这个暂时没检测到
                        break;
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");   // 5次失败进入,如果继续验证，则需要输入密码解锁
                        }];
                        break;
                    }
                }
            }
        }
         ];
        
    }else {
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"设备Touch ID不可用");
                break;
            case LAErrorPasscodeNotSet:
                NSLog(@"系统未设置密码");
                break;
            default:
                NSLog(@"TouchID不可用或已损坏");
                break;
        }
        
        NSLog(@"%@", error.localizedDescription);
    }
    
    
}

-(void)add{
    
}
-(void)delete{
    
}
-(void)update{
    
}
-(void)search{
    
}
-(void)share{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
