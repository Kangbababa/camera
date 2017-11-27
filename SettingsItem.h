//
//  SettingsItem.h
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/21.
//  Copyright © 2017年 Google. All rights reserved.
//

#ifndef SettingsItem_h
#define SettingsItem_h


#endif /* SettingsItem_h */
#import <Foundation/Foundation.h>

typedef void (^SettingItemOption) ();

@interface SettingsItem : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,assign) Class vcClass; //要跳转的控制器
@property (nonatomic, copy) SettingItemOption option;
-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title vcClass:(Class) vcClass;

@end
