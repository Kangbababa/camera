//
//  CPAppSettings.m
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/27.
//  Copyright © 2017年 Google. All rights reserved.
//

#import "PRAppSettings.h"

NSString *const PRAppSettingsThemeChangedNotification = @"PRAppSettingsThemeChangedNotification";


static NSString *const kImageWIFIOnlyKey = @"imageWIFIOnly";
static NSString *const kCheckAccuracyKey = @"checkAccuracy";
static NSString *const kLeftAlert = @"leftAlert";
static NSString *const kSoundAlert = @"soundAlert";
static NSString *const kSoundAlertTitle = @"soundAlertTitle";
static NSString *const kRestAlert = @"restAlert";
@interface TaitouAppSettings ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation TaitouAppSettings


@synthesize imageWIFIOnly = _imageWIFIOnly;
@synthesize checkAccuracy = _checkAccuracy;
@synthesize leftAlert = _leftAlert;
@synthesize soundAlert = _soundAlert;
@synthesize soundAlertTitle = _soundAlertTitle;
@synthesize restAlert = _restAlert;

+ (instancetype)sharedSettings
{
    static TaitouAppSettings *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[TaitouAppSettings alloc] init];
    });
    return _settings;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        [_userDefaults registerDefaults:@{kImageWIFIOnlyKey: @YES,
                                          kCheckAccuracyKey: @(CheckAccuracyNormal),
                                          kLeftAlert: @NO,
                                          kSoundAlert: @0,
                                          kSoundAlertTitle: @"小宝贝抬头-童声版",
                                          kRestAlert: @YES
                                          }];
        
     
        _imageWIFIOnly = [_userDefaults boolForKey:kImageWIFIOnlyKey];
        _checkAccuracy = [_userDefaults integerForKey:kCheckAccuracyKey];
        _leftAlert = [_userDefaults boolForKey:kLeftAlert];
        _soundAlert = [_userDefaults integerForKey:kSoundAlert];
        _soundAlertTitle = [_userDefaults stringForKey:kSoundAlertTitle];
        _restAlert = [_userDefaults boolForKey:kRestAlert];
       
    }
    return self;
}



- (BOOL)isImageWIFIOnly
{
    return _imageWIFIOnly;
}

- (void)setImageWIFIOnly:(BOOL)imageWIFIOnly
{
    _imageWIFIOnly = imageWIFIOnly;
    [self.userDefaults setBool:imageWIFIOnly forKey:kImageWIFIOnlyKey];
}

- (CheckAccuracySize)checkAccuracy
{
    return _checkAccuracy;
}

- (void)setCheckAccuracy:(CheckAccuracySize)checkAccuracy
{
    _checkAccuracy = checkAccuracy;
    [self.userDefaults setInteger:checkAccuracy forKey:kCheckAccuracyKey];
}



- (void)setLeftAlert:(BOOL)leftAlert
{
    _leftAlert = leftAlert;
    [self.userDefaults setBool:leftAlert forKey:kLeftAlert];
}
- (void)setRestAlert:(BOOL)restAlert
{
    _restAlert = restAlert;
    [self.userDefaults setBool:restAlert forKey:kRestAlert];
}

- (void)setSoundAlert:(NSInteger)soundAlert
{
    _soundAlert = soundAlert;
    [self.userDefaults setInteger:soundAlert forKey:kSoundAlert];
}

- (void)setSoundAlertTitle:(NSString *)soundAlertTitle
{
    _soundAlertTitle = soundAlertTitle;
    [self.userDefaults setObject:soundAlertTitle forKey:kSoundAlertTitle];
}



@end
