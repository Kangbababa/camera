//
//  SettingController.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/21.
//  Copyright © 2017年 Google. All rights reserved.
//


#import "SettingController.h"
#import "SettingsItem.h"
#import "ArrowItem.h"
#import "SwitchItem.h"
#import "TableViewCell.h"
//#import "WQMessageViewController.h"

@interface SettingController ()
@property(nonatomic,strong) NSMutableArray *cellData;

@end

@implementation SettingController


-(NSMutableArray *)cellData{
    if (!_cellData) {
        _cellData = [NSMutableArray array];
    }
    return _cellData;
}

- (void)setting {
    SettingController *setVc = [[SettingController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"settingPage viewLoad:");
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [setting setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = setting;
    
    //第一组数据
    SettingsItem *item1 = [ArrowItem itemWithIcon:@"tab_normal_4"
                                         andTitle:@"推送" ];//vcClass:[MessageViewController class]];
    SettingsItem *item2 = [SwitchItem itemWithIcon:@"tab_normal_4" andTitle:@"摇一摇"];
    SettingsItem *item3 = [SwitchItem itemWithIcon:@"tab_normal_4" andTitle:@"声音和效果"];
    NSArray *group1 = @[item1,item2,item3];
    
    SettingsItem *item4 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"检查版本"];
    SettingsItem *item5 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"帮助"];
    SettingsItem *item6 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"分享"];
    SettingsItem *item7 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"产品推荐"];
    SettingsItem *item8 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"关于"];
    NSArray *group2 = @[item4,item5,item6,item7,item8];
    
    [self.cellData addObject:group1];
    [self.cellData addObject:group2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.cellData[section];
    return array.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [TableViewCell initCellWithTableView:tableView];
    NSArray *array = self.cellData[indexPath.section];
    SettingsItem *item = array[indexPath.row];
    [cell setSettingItem:item];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.cellData[indexPath.section];
    SettingsItem *item = array[indexPath.row];
    if (item.vcClass) {
        id vc = [[item.vcClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @" ";
}

@end
