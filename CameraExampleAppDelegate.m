// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "CameraExampleAppDelegate.h"
#import <EAIntroView/EAIntroView.h>


@implementation CameraExampleAppDelegate

@synthesize window = _window;


//
static NSString * const sampleDescription1 = @"【取景框】对准孩子背部，可以用双指手动调整焦距到合适的图像大小。";
static NSString * const sampleDescription2 = @"自动对焦，当发现孩子坐姿不好时，不打断学习过程，语音提醒孩子纠正坐姿。";
static NSString * const sampleDescription3 = @"智能检测，机器学习，越用越准。没有网络也能使用。";
static NSString * const sampleDescription4 = @"设置个性提醒音，检测精度，满足一对一的使用需要。";

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self.window makeKeyAndVisible];
    
//    //    利用NSUserDefaults实现
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        NSLog(@"首次启动");
//        FirstUseViewController *vc = [[FirstUseViewController alloc] init];
//        self.window.rootViewController = vc;
//    }else {
//        NSLog(@"非首次启动");
//        LaunchViewController *vc = [[LaunchViewController alloc] init];
//        self.window.rootViewController = vc;
//    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        EAIntroPage *page1 = [EAIntroPage page];
        page1.title = @"抬头正姿";
        page1.desc = sampleDescription1;
        page1.bgImage = [UIImage imageNamed:@"bg1"];
        page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
        EAIntroPage *page2 = [EAIntroPage page];
        page2.title = @"语音提醒";
        page2.desc = sampleDescription2;
        page2.bgImage = [UIImage imageNamed:@"bg2"];
        page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
        EAIntroPage *page3 = [EAIntroPage page];
        page3.title = @"智能检测";
        page3.desc = sampleDescription3;
        page3.bgImage = [UIImage imageNamed:@"bg3"];
        page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
        EAIntroPage *page4 = [EAIntroPage page];
        page4.title = @"个性的功能";
        page4.desc = sampleDescription4;
        page4.bgImage = [UIImage imageNamed:@"bg4"];
        page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.rootViewController.view.bounds andPages:@[page1,page2,page3,page4]];
        [intro.skipButton setTitle:@"下一页" forState:UIControlStateNormal];
        intro.skipButtonAlignment = EAViewAlignmentCenter;
        intro.skipButtonY = 80.f;
        intro.pageControlY = 42.f;
    
        [intro setDelegate:self];
    
        [intro showInView:self.window.rootViewController.view animateDuration:0.3];
    
    }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
