//
//  SoundController.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/27.
//  Copyright © 2017年 Google. All rights reserved.
//


#import "SoundController.h"
#import "PRAppSettings.h"

@interface SoundController ()
@property (assign, nonatomic) NSInteger       selIndex;      //单选选中的行
@property (strong, nonatomic) NSMutableArray    *selectIndexs;  //多选选中的行
@property (assign, nonatomic) NSString        *selTitle;      //单选选中的行标题
@property (nonatomic, assign) BOOL              isSingle;       //单选还是多选
@end

@implementation SoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择提示音";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"多选" style:UIBarButtonItemStylePlain target:self action:@selector(singleSelect)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
    self.selIndex=settings.soundAlert;

    
    //初始化多选数组
    _selectIndexs = [NSMutableArray new];
    //初始化刚启动是单选
    _isSingle = 1;
    //_selIndex=0;
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
   // cell.textLabel.text = [NSString stringWithFormat:@"第%zi组,第%zi行",indexPath.section+1,indexPath.row];
    NSInteger sectionIndex = indexPath.section;
    if (sectionIndex == 0) { // 第0组
        // 判断第0组的第几行
        NSInteger rowIndex = indexPath.row;
        
        if (rowIndex == 0) {
            cell.textLabel.text =@"小宝贝抬头-童声版";
        } else if (rowIndex ==1) {
            cell.textLabel.text =@"小弟抬头-姐姐温柔版";
        } else {
            cell.textLabel.text =@"大宝抬头-妈妈轻柔版";
        }
    }
    
    if (_isSingle) {            //单选
        if (_selIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else{                      //多选
        cell.accessoryType = UIAccessibilityTraitNone;
        for (NSIndexPath *index in _selectIndexs) {
            if (indexPath == index) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return cell;
}

//选中某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSingle) {       //单选
        //取消之前的选择
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selIndex inSection:0]];
        celled.accessoryType = UITableViewCellAccessoryNone;
        
        //记录当前的选择的位置
        _selIndex = indexPath.row;
        
        //当前选择的打钩
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        TaitouAppSettings *settings = [TaitouAppSettings sharedSettings];
       
        settings.soundAlert =_selIndex;
        settings.soundAlertTitle=cell.textLabel.text;
        
    }else{                      //多选
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { //如果为选中状态
            cell.accessoryType = UITableViewCellAccessoryNone; //切换为未选中
            [_selectIndexs removeObject:indexPath]; //数据移除
        }else { //未选中
            cell.accessoryType = UITableViewCellAccessoryCheckmark; //切换为选中
            [_selectIndexs addObject:indexPath]; //添加索引数据到数组
        }
    }
    
}

//组头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//单选还是多选按钮点击事件
-(void)singleSelect{
    _isSingle = !_isSingle;
    if (_isSingle) {
        self.navigationItem.rightBarButtonItem.title = @"多选";
        self.title = @"(单选)";
        
        [self.selectIndexs removeAllObjects];
        [self.tableView reloadData];
    }else{
        self.title = @"(多选)";
        self.navigationItem.rightBarButtonItem.title = @"单选";
    }
}

@end
