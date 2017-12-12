//
//  CPAppSettings.h
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/27.
//  Copyright © 2017年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CheckAccuracySize) {
    CheckAccuracySmall,
    CheckAccuracyNormal,
    CheckAccuracyBig
};

extern NSString *const PRAppSettingsSoundChangedNotification;

@interface TaitouAppSettings : NSObject

+ (instancetype)sharedSettings;
@property (nonatomic, getter = isImageWIFIOnly) BOOL imageWIFIOnly;
@property (nonatomic, assign) CheckAccuracySize checkAccuracy;
@property (nonatomic) BOOL leftAlert;
@property (nonatomic) NSInteger soundAlert;
@property (nonatomic) NSString  *soundAlertTitle;
@property (nonatomic) BOOL restAlert;
@end
