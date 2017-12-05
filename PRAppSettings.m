//
//  CPAppSettings.m
//  PlainReader
//
//  Created by guojiubo on 14-5-26.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRAppSettings.h"

NSString *const PRAppSettingsThemeChangedNotification = @"PRAppSettingsThemeChangedNotification";


static NSString *const kImageWIFIOnlyKey = @"imageWIFIOnly";
static NSString *const kCheckAccuracyKey = @"checkAccuracy";
static NSString *const kLeftAlert = @"leftAlert";
static NSString *const kSoundAlert = @"soundAlert";
static NSString *const kSoundAlertTitle = @"soundAlertTitle";

@interface TaitouAppSettings ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation TaitouAppSettings


@synthesize imageWIFIOnly = _imageWIFIOnly;
@synthesize checkAccuracy = _checkAccuracy;
@synthesize leftAlert = _leftAlert;
@synthesize soundAlert = _soundAlert;
@synthesize soundAlertTitle = _soundAlertTitle;

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
                                          kSoundAlertTitle: @"小宝贝抬头-童声版"}];
        
     
        _imageWIFIOnly = [_userDefaults boolForKey:kImageWIFIOnlyKey];
        _checkAccuracy = [_userDefaults integerForKey:kCheckAccuracyKey];
        _leftAlert = [_userDefaults boolForKey:kLeftAlert];
        _soundAlert = [_userDefaults integerForKey:kSoundAlert];
        _soundAlertTitle = [_userDefaults stringForKey:kSoundAlertTitle];
       
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
