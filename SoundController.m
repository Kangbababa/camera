//
//  SoundController.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/27.
//  Copyright © 2017年 Google. All rights reserved.
//


#import "SettingController.h"
#import "SettingsItem.h"
#import "ArrowItem.h"
#import "SwitchItem.h"
#import "TableViewCell.h"
#import "SoundController.h"
#import "CheakItem.h"


@interface SoundController ()
@property(nonatomic,strong) NSMutableArray *cellData;

@end

@implementation SoundController


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

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //这个貌似没用
            UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithTitle:@"提醒音" style:UIBarButtonItemStylePlain target:self action:Nil];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSForegroundColorAttributeName] = [UIColor blackColor];
            [setting setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = setting;
    
    //第一组数据
//    SettingsItem *item1 = [ArrowItem itemWithIcon:@"Audio-Recorder"
//                                         andTitle:@"推送" ];//vcClass:[MessageViewController class]];
//    SettingsItem *item2 = [SwitchItem itemWithIcon:@"upload" andTitle:@"上传"];
//    SettingsItem *item3 = [ArrowItem itemWithIcon:@"sound" andTitle:@"提醒音"];
//    NSArray *group1 = @[item1,item2,item3];
    
//    SettingsItem *item4 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"检查版本"];
//    SettingsItem *item5 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"帮助"];
//    SettingsItem *item6 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"分享"];
//    SettingsItem *item7 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"产品推荐"];
//    SettingsItem *item8 = [ArrowItem itemWithIcon:@"tab_normal_4" andTitle:@"关于"];
//    NSArray *group2 = @[item4,item5,item6,item7,item8];
    
//    [self.cellData addObject:group1];
//    [self.cellData addObject:group2];
    
    // 大
    __weak typeof(self) weakSelf = self;
    CheakItem * __weak big = [CheakItem itemWithIcon:@"Audio-Recorder" andTitle:@"大"];
    big.option = ^{
        [weakSelf selItem:big];
    };
    
    // 中
    CheakItem * __weak middle = [CheakItem itemWithIcon:@"Audio-Recorder" andTitle:@"中"];
    
    middle.option = ^{
        [weakSelf selItem:middle];
    };
    //_selCheakItem = middle;
    // 小
    CheakItem * __weak small = [CheakItem itemWithIcon:@"Audio-Recorder" andTitle:@"小"];
    small.option = ^{
        [weakSelf selItem:small];
    };
    
    NSArray *group1 =  @[big,middle,small];
   
    [self.cellData addObject:group1];
    
    // 默认选中item
    //[self setUpSelItem:middle];
    
}

//- (void)setUpSelItem:(CheakItem *)item
//{
//    NSString *fontSizeStr =  [[NSUserDefaults standardUserDefaults] objectForKey: @"FontSizeKey"];
//    if (fontSizeStr == nil) {
//        [self selItem:item];
//        return;
//    }
//
//    for (NSArray *group in self.cellData) {
//        for (CheakItem *item in group) {
//            if ( [item.title isEqualToString:fontSizeStr]) {
//                [self selItem:item];
//            }
//
//        }
//
//    }
//}
//
- (void)selItem:(CheakItem *)item
{
//    _selCheakItem.isCheak = NO;
//    item.isCheak = YES;
//    _selCheakItem = item;
    [self.tableView reloadData];


    // 存储
    [[NSUserDefaults standardUserDefaults] setObject:item.title forKey:@"FontSizeKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 发出通知
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"FontSizeChangeNote" object:nil userInfo:@{@"FontSizeKey":item.title}];

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
    if (item.option) {
        item.option();
        return;
    }
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
