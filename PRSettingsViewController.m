//
//  SettingsViewController.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/27.
//  Copyright © 2017年 Google. All rights reserved.

#import "PRSettingsViewController.h"
//#import "PRRefreshHeader.h"
//#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "PRAppSettings.h"
#import "SoundController.h"
#import "GuideViewController.h"
//#import "PRDatabase.h"
//#import "PRAutoHamburgerButton.h"
//#import "PRBrowserViewController.h"

#import <EAIntroView/EAIntroView.h>
//
static NSString * const sampleDescription1 = @"【取景框】对准孩子背部，可以用双指手动调整焦距到合适的图像大小。";
static NSString * const sampleDescription2 = @"自动对焦，当发现孩子坐姿不好时，不打断学习过程，语音提醒孩子纠正坐姿。";
static NSString * const sampleDescription3 = @"智能检测，机器学习，越用越准。没有网络也能使用。";
static NSString * const sampleDescription4 = @"设置个性提醒音，检测精度，满足一对一的使用需要。";
//@interface GuideViewController () <EAIntroDelegate> {
//    UIView *rootView;
//    EAIntroView *_intro;
//}
//
//@end
UIView *rootView;
EAIntroView *_intro;
@interface PRSettingsViewController () <MFMailComposeViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UISwitch *prefetchSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *imageWIFIOnlySwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fontSizeSegment;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *cacheIndicator;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *fastScrollSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *autoStarSwitch;
//@property (nonatomic, weak) IBOutlet UISwitch *inclineSummarySwitch;

@end

@implementation PRSettingsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    rootView = self.navigationController.view;
    
    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
    [self.imageWIFIOnlySwitch setOn:settings.isImageWIFIOnly];
    [self.fontSizeSegment setSelectedSegmentIndex:settings.checkAccuracy];
    [self.versionLabel setText:@"1.0"];
    [self.fastScrollSwitch setOn:settings.leftAlert];
    [self.cacheSizeLabel setText:settings.soundAlertTitle];
    [self.autoStarSwitch setOn:settings.restAlert];
    //[self.inclineSummarySwitch setOn:settings.inclineSummary];
    //NSLog(@"Load:%@ %@", settings.isPrefetchOnWIFI, settings.fontSize);
}
- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//- (void)menuButtonAction:(id)sender
//{
//    [self.sideMenuViewController presentLeftMenuViewController];
//}

//- (void)didMoveToParentViewController:(UIViewController *)parent
//{
//    [super didMoveToParentViewController:parent];
//
//    PRRefreshHeader *header = [[PRRefreshHeader alloc] init];
//    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
//    header.title = @"设置";
//    [[parent view] addSubview:header];
//
//    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    PRAutoHamburgerButton *menuButton = [PRAutoHamburgerButton button];
//    [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [menuButton setCenter:CGPointMake(CGRectGetWidth(menuView.bounds)/2, CGRectGetHeight(menuView.bounds)/2)];
//    [menuView addSubview:menuButton];
//    [header setLeftView:menuView];
//
//    NSDictionary *viewDict = NSDictionaryOfVariableBindings(header);
//    [[parent view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:viewDict]];
//    [[parent view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(64)]" options:0 metrics:nil views:viewDict]];
//
//    UIEdgeInsets insets = [self.tableView contentInset];
//    insets.top += 64;
//    [self.tableView setContentInset:insets];
//}

- (void)viewWillAppear:(BOOL)animated
{
    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
     [self.cacheSizeLabel setText:settings.soundAlertTitle];

//    [super viewWillAppear:animated];
//    [self.cacheSizeLabel setText:@""];
//    [self.cacheIndicator startAnimating];
//    [[CWObjectCache sharedCache] calculateCacheSize:^(unsigned long long size) {
//        NSString *cacheSize = [NSString stringWithFormat:@"%.2fMB", size/1024.0/1024.0];
//        [self.cacheSizeLabel setText:cacheSize];
//        [self.cacheIndicator stopAnimating];
//    }];
    
}

#pragma mark - Actions

- (IBAction)switchValueChanged:(id)sender
{
    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
    //settings.prefetchOnWIFI = [self.prefetchSwitch isOn];
    settings.imageWIFIOnly = [self.imageWIFIOnlySwitch isOn];
    settings.leftAlert = [self.fastScrollSwitch isOn];
    settings.restAlert = [self.autoStarSwitch isOn];
//    settings.inclineSummary = [self.inclineSummarySwitch isOn];
    // NSLog(@"change on:%@ %@", settings.prefetchOnWIFI, settings.imageWIFIOnly);
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
    settings.checkAccuracy = [self.fontSizeSegment selectedSegmentIndex];
   // NSLog(@"change fontSize:%@ ", settings.prefetchOnWIFI, settings.imageWIFIOnly);
}

- (void)clearCache
{
    
    SoundController *vc = [[SoundController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.cacheSizeLabel setText:@""];
//    [self.cacheIndicator startAnimating];
    
//    [[CWObjectCache sharedCache] clearMemory];
//
//    [[CWObjectCache sharedCache] clearDiskOnCompletion:^{
//        [[PRDatabase sharedDatabase] clearExpiredArticles:^{
//            [self.cacheSizeLabel setText:@"0.00MB"];
//            [self.cacheIndicator stopAnimating];
//        }];
//    }];
}

- (void)contactMe
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的手机还没有配置邮箱" message:@"请配置好邮箱后重试，你也可以通过其他渠道发送邮件到974591189@qq.com来联系我" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    [vc setMailComposeDelegate:self];
    [vc setSubject:@"来自抬头"];
    [vc setToRecipients:@[@"974591189@qq.com"]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)about
{
//   NSURL *URL = [NSURL URLWithString:@"http://cnbeta.cocoawind.com/about.html"];
////    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    GuideViewController *vc = [[GuideViewController alloc] init];
//    //vc.request = request;
//    [self.navigationController pushViewController:vc animated:YES];
//
////    SoundController *vc = [[SoundController alloc] init];
////   [self.navigationController pushViewController:vc animated:YES];
 [self showIntroWithCrossDissolve];
    
}
- (void)showIntroWithCrossDissolve {
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

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
     [intro.skipButton setTitle:@"下一页" forState:UIControlStateNormal];
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButtonY = 80.f;
    intro.pageControlY = 42.f;

    [intro setDelegate:self];

    [intro showInView:rootView animateDuration:0.3];
}
#pragma mark - Mail callback

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"ClearCache"]) {
        [self clearCache];
        return;
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"ContactMe"]) {
        [self contactMe];
        return;
    }
    
    if ([[cell reuseIdentifier] isEqualToString:@"About"]) {
        [self about];
        return;
    }
}

@end
