//
//  StatisticsReport.h
//  tf_camera_example
//
//  Created by 白龙 on 2018/1/16.
//  Copyright © 2018年 Google. All rights reserved.
//

#ifndef StatisticsReport_h
#define StatisticsReport_h


#endif /* StatisticsReport_h */
#import <Foundation/Foundation.h>

@interface StatisticsSummary: NSObject

+ (instancetype)sharedSummary;
@property (nonatomic) NSInteger  usedCountSum;
@property (nonatomic) float  usedTimeSum;
@property (nonatomic) NSInteger  alertCountSum;
@property (nonatomic) NSInteger  goodCountSum;
@property (nonatomic) NSInteger  leftCountSum;
@property (nonatomic) NSInteger  rightCountSum;
@property (nonatomic) NSInteger  badCountSum;
@property (nonatomic) NSInteger  standCountSum;
@property (nonatomic) NSInteger  leaveCountSum;
@end
