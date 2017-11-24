//
//  TableViewCell.h
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/21.
//  Copyright © 2017年 Google. All rights reserved.
//

#ifndef TableViewCell_h
#define TableViewCell_h


#endif /* TableViewCell_h */
#import <UIKit/UIKit.h>

@class SettingsItem;
@interface TableViewCell : UITableViewCell

@property(nonatomic,strong) SettingsItem *settingItem;

+(instancetype)initCellWithTableView:(UITableView *)tableView;
@end
