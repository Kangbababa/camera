//
//  SettingsItem.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/21.
//  Copyright © 2017年 Google. All rights reserved.
//

#import "SettingsItem.h"

@implementation SettingsItem

-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title{
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    return self;
}


+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title{
    return [[self alloc] initWithIcon:icon andTitle:title];
    
}

+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title vcClass:(Class) vcClass{
    SettingsItem *item = [self itemWithIcon:icon andTitle:title];
    item.vcClass = vcClass;
    return item;
}

@end

