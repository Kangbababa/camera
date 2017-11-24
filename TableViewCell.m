//
//  TableViewCell.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/21.
//  Copyright © 2017年 Google. All rights reserved.
//

#import "TableViewCell.h"
#import "SettingsItem.h"
#import "ArrowItem.h"
#import "SwitchItem.h"

@implementation TableViewCell

+(instancetype)initCellWithTableView:(UITableView *)tableView{
    NSString *identify = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    return cell;
}


-(void)setSettingItem:(SettingsItem *)settingItem{
    _settingItem = settingItem;
    self.textLabel.text = settingItem.title;
    self.imageView.image = [UIImage imageNamed:settingItem.icon];
    
    if ([settingItem isKindOfClass:[ArrowItem class]]) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }else if([settingItem isKindOfClass:[SwitchItem class]]){
        self.accessoryView = [[UISwitch alloc]init];
    }
    
}

@end
