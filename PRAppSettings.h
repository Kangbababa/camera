//
//  CPAppSettings.h
//  PlainReader
//
//  Created by guojiubo on 14-5-26.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CheckAccuracySize) {
    CheckAccuracySmall,
    CheckAccuracyNormal,
    CheckAccuracyBig
};

extern NSString *const PRAppSettingsThemeChangedNotification;

@interface TaitouAppSettings : NSObject

+ (instancetype)sharedSettings;
@property (nonatomic, getter = isImageWIFIOnly) BOOL imageWIFIOnly;
@property (nonatomic, assign) CheckAccuracySize checkAccuracy;
@property (nonatomic) BOOL leftAlert;
@property (nonatomic) NSInteger soundAlert;
@property (nonatomic) NSString  *soundAlertTitle;

@end
