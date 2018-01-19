//
//  StatisticsReport.m
//  tf_camera_example
//
//  Created by 白龙 on 2018/1/16.
//  Copyright © 2018年 Google. All rights reserved.
//


#import "StatisticsReport.h"



static NSString *const kUsedCountSum = @"usedCountSum";
static NSString *const kUsedTimeSum = @"usedTimeSum";
static NSString *const kAlertCountSum = @"alertCountSum";
static NSString *const kGoodCountSum = @"goodCountSum";
static NSString *const kLeftCountSum = @"leftCountSum";
static NSString *const kRightCountSum = @"rightCountSum";
static NSString *const kBadCountSum = @"badCountSum";
static NSString *const kStandCountSum = @"standCountSum";
static NSString *const kLeaveCountSum = @"leaveCountSum";

@interface StatisticsSummary ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation StatisticsSummary
@synthesize usedCountSum = _usedCountSum;
@synthesize usedTimeSum = _usedTimeSum;
@synthesize alertCountSum = _alertCountSum;
@synthesize goodCountSum = _goodCountSum;
@synthesize leftCountSum = _leftCountSum;
@synthesize rightCountSum = _rightCountSum;
@synthesize badCountSum = _badCountSum;
@synthesize standCountSum = _standCountSum;
@synthesize leaveCountSum = _leaveCountSum;

+ (instancetype)sharedSummary
{
    static StatisticsSummary *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[StatisticsSummary alloc] init];
    });
    return _settings;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        [_userDefaults registerDefaults:@{kUsedCountSum: @0,
                                          kUsedTimeSum: @0.0,
                                          kAlertCountSum: @0,
                                          kGoodCountSum: @0,
                                          kLeftCountSum: @0,
                                          kRightCountSum: @0,
                                          kBadCountSum: @0,
                                          kStandCountSum: @0,
                                          kLeaveCountSum: @0,
                                          }];
        
    
        _usedCountSum = [_userDefaults integerForKey:kUsedCountSum];
        _usedTimeSum = [_userDefaults floatForKey:kUsedTimeSum];
        _alertCountSum = [_userDefaults integerForKey:kAlertCountSum];
        _goodCountSum = [_userDefaults integerForKey:kGoodCountSum];
        
         _leftCountSum = [_userDefaults integerForKey:kLeftCountSum];
         _rightCountSum = [_userDefaults integerForKey:kRightCountSum];
         _badCountSum = [_userDefaults integerForKey:kBadCountSum];
         _standCountSum = [_userDefaults integerForKey:kStandCountSum];
         _leaveCountSum = [_userDefaults integerForKey:kLeaveCountSum];
        
    }
    return self;
}


- (void)setUsedCountSum:(NSInteger)usedCountSum
{
    _usedCountSum = usedCountSum;
    [self.userDefaults setInteger:usedCountSum forKey:kUsedCountSum];
  
}

- (void)setUsedTimeSum:(float)usedTimeSum
{
    _usedTimeSum = usedTimeSum;
    [self.userDefaults setInteger:usedTimeSum forKey:kUsedTimeSum];
    
}
- (void)setAlertCountSum:(NSInteger)alertCountSum
{
    _alertCountSum = alertCountSum;
    [self.userDefaults setInteger:alertCountSum forKey:kAlertCountSum];
    
}
- (void)setGoodCountSum:(NSInteger)goodCountSum
{
    _goodCountSum = goodCountSum;
    [self.userDefaults setInteger:goodCountSum forKey:kGoodCountSum];
    
}
- (void)setLeftCountSum:(NSInteger)leftCountSum
{
    _leftCountSum = leftCountSum;
    [self.userDefaults setInteger:leftCountSum forKey:kLeftCountSum];
    
}
- (void)setRightCountSum:(NSInteger)rightCountSum
{
    _rightCountSum = rightCountSum;
    [self.userDefaults setInteger:rightCountSum forKey:kRightCountSum];
    
}
- (void)setBadCountSum:(NSInteger)badCountSum
{
    _badCountSum = badCountSum;
    [self.userDefaults setInteger:badCountSum forKey:kBadCountSum];
    
}

- (void)setStandCountSum:(NSInteger)standCountSum
{
    _standCountSum = standCountSum;
    [self.userDefaults setInteger:standCountSum forKey:kStandCountSum];
    
}

- (void)setLeaveCountSum:(NSInteger)leaveCountSum
{
    _leaveCountSum = leaveCountSum;
    [self.userDefaults setInteger:leaveCountSum forKey:kLeaveCountSum];
    
}
@end
