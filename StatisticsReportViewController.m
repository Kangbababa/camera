//
//  StatisticsReportViewController.m
//  tf_camera_example
//
//  Created by 白龙 on 2018/1/16.
//  Copyright © 2018年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsReportViewController.h"
#import "StatisticsReport.h"

@interface StatisticsReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countsSummary;
@property (weak, nonatomic) IBOutlet UILabel *timeSummary;
@property (nonatomic, weak) IBOutlet UILabel *alertCounts;
@property (weak, nonatomic) IBOutlet UILabel *good;
@property (weak, nonatomic) IBOutlet UILabel *left;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UILabel *down;
@property (weak, nonatomic) IBOutlet UILabel *stand;
@property (weak, nonatomic) IBOutlet UILabel *leave;
@property (weak, nonatomic) IBOutlet PYEchartsView *echartsView;
@end


StatisticsSummary *settings;

@implementation StatisticsReportViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   
    
     settings= [StatisticsSummary sharedSummary];
     [self.countsSummary setText:[NSString stringWithFormat:@"%ld", settings.usedCountSum]];
     [self.timeSummary setText:[NSString stringWithFormat:@"%.2f秒", settings.usedTimeSum]];
     [self.alertCounts setText:[NSString stringWithFormat:@"%ld", settings.alertCountSum]];
     [self.good setText:[NSString stringWithFormat:@"%ld", settings.goodCountSum]];
     [self.left setText:[NSString stringWithFormat:@"%ld", settings.leftCountSum]];
     [self.right setText:[NSString stringWithFormat:@"%ld", settings.rightCountSum]];
     [self.down setText:[NSString stringWithFormat:@"%ld", settings.badCountSum]];
     [self.stand setText:[NSString stringWithFormat:@"%ld", settings.standCountSum]];
     [self.leave setText:[NSString stringWithFormat:@"%ld", settings.leaveCountSum]];
    //NSLog(@"Load:%@ %@", settings.isPrefetchOnWIFI, settings.fontSize);
    
//    PYOption *option= [PYOption initPYOptionWithBlock:^(PYOption *option) {
//
//        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
//            title.textEqual(@"Event River").subtextEqual(@"Test subtext");
//        }])
//        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
//            tooltip.triggerEqual(PYTooltipTriggerItem).enterableEqual(YES);
//        }])
//        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
//            legend.dataEqual(@[@"first data", @"second data"]);
//        }])
//        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
//            toolbox.showEqual(YES).featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
//                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
//                    mark.showEqual(YES);
//                }])
//                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
//                    restore.showEqual(YES);
//                }]);
//            }]);
//        }])
////        .xAxisEqual([[NSMutableArray alloc] initWithArray:@[axis]])
////        .seriesEqual([[NSMutableArray alloc] initWithArray:@[series1, series2]])
//        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
//            grid.xEqual(@10)
//            .x2Equal(@30);
//        }]);
//    }];
//
    // 最后设置配置型以及加载
//    [self.echartsView setOption:option];
//    [self.echartsView loadEcharts];
    
    [self.echartsView setOption:[self standardLineOption]];
    
    [self.echartsView loadEcharts];

}


- (PYOption *)standardLineOption {
    
    
//    PYOption *option = [[PYOption alloc] init];
//    option.backgroundColor = [[PYColor alloc] initWithColor:[UIColor grayColor]];
//    option.calculable = NO;
//
//    PYTooltip *tooltip = [[PYTooltip alloc] init];
//    tooltip.trigger = @"axis";
//    option.tooltip = tooltip;
//
//    PYGrid *grid = [[PYGrid alloc] init];
//    grid.x = @(40);
//    grid.x2 = @(50);
//    option.grid = grid;
//
//    PYLegend *legend = [[PYLegend alloc] init];
//    legend.data = @[@"收益", @"预计收益"];
//    option.legend = legend;
//
//    PYAxis *xAxis = [[PYAxis alloc] init];
//    xAxis.type = @"category";
//    xAxis.boundaryGap = @(NO);
//    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
//    option.xAxis = [@[xAxis] mutableCopy];
//
//    PYAxis *yAxis = [[PYAxis alloc] init];
//    yAxis.type = @"value";
//    PYAxisLabel *axisLabel = [[PYAxisLabel alloc] init];
//    axisLabel.formatter = @"{value}";
//    yAxis.axisLabel = axisLabel;
//    option.yAxis = [@[yAxis] mutableCopy];
//
//    PYSeries *series = [[PYSeries alloc] init];
//    series.name = @"收益";
//    series.type = @"line";
//    series.data = @[@(11),@(11),@(15),@(13),@(12),@(13),@(10)];
//    PYSeries *serie2 = [[PYSeries alloc] init];
//    serie2.name = @"预计收益";
//    serie2.type = @"line";
//    serie2.data = @[@(1),@(202),@(2),@(5),@(3),@(2),@(0)];
//
//    option.series = [@[series, serie2] mutableCopy];
//
//    return option;
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"姿态分布情况")
            .subtextEqual(@"姿态占比")
            .xEqual(PYPositionCenter);
        }])
//        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
//            tooltip.triggerEqual(PYTooltipTriggerItem)
//            .formatterEqual(@"{a} <br/>{b} : {c} ({d}%)");
//        }])
//        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
//            legend.orientEqual(PYOrientVertical)
//            .xEqual(PYPositionLeft)
//            .dataEqual(@[@"正姿",@"偏左",@"偏右",@"趴下",@"站立"]);
//        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(NO)
            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
                    mark.showEqual(YES);
                }])
                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
                    dataView.showEqual(YES).readOnlyEqual(NO);
                }])
                .magicTypeEqual([PYToolboxFeatureMagicType initPYToolboxFeatureMagicTypeWithBlock:^(PYToolboxFeatureMagicType *magicType) {
                    magicType.showEqual(YES).typeEqual(@[PYSeriesTypePie, PYSeriesTypeFunnel]).optionEqual(@{@"funnel":@{@"x":@"25%",@"width":@"50%",@"funnelAlign":PYPositionLeft,@"max":@(1548)}});
                    
                }])
                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
                    restore.showEqual(YES);
                }]);
            }]);
        }])
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.radiusEqual(@"55%")
            .centerEqual(@[@"50%",@"60%"])
            .nameEqual(@"姿态")
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[@{@"value":@(settings.goodCountSum),@"name":@"正姿"},@{@"value":@(settings.leftCountSum),@"name":@"左姿"},@{@"value":@(settings.rightCountSum),@"name":@"右姿"},@{@"value":@(settings.badCountSum),@"name":@"趴姿"},@{@"value":@(settings.leaveCountSum),@"name":@"没人"}]);
           // ,@{@"value":@(settings.standCountSum),@"name":@"站立"}
        }]);
    }];
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
//    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
//    [self.cacheSizeLabel setText:settings.soundAlertTitle];
    
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
//    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
//    //settings.prefetchOnWIFI = [self.prefetchSwitch isOn];
//    settings.imageWIFIOnly = [self.imageWIFIOnlySwitch isOn];
//    settings.leftAlert = [self.fastScrollSwitch isOn];
//    settings.restAlert = [self.autoStarSwitch isOn];
    //    settings.inclineSummary = [self.inclineSummarySwitch isOn];
    // NSLog(@"change on:%@ %@", settings.prefetchOnWIFI, settings.imageWIFIOnly);
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
//    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
//    settings.checkAccuracy = [self.fontSizeSegment selectedSegmentIndex];
    // NSLog(@"change fontSize:%@ ", settings.prefetchOnWIFI, settings.imageWIFIOnly);
}

- (void)clearCache
{
    
//    SoundController *vc = [[SoundController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
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
//    if (![MFMailComposeViewController canSendMail]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的手机还没有配置邮箱" message:@"请配置好邮箱后重试，你也可以通过其他渠道发送邮件到974591189@qq.com来联系我" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
//    [vc setMailComposeDelegate:self];
//    [vc setSubject:@"来自抬头"];
//    [vc setToRecipients:@[@"974591189@qq.com"]];
//    [self presentViewController:vc animated:YES completion:nil];
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
//    [self showIntroWithCrossDissolve];
    
}


@end
