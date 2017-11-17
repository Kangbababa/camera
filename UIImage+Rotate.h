//
//  UIImage+Rotate.h
//  tf_camera_example
//
//  Created by 白龙 on 2017/11/10.
//  Copyright © 2017年 Google. All rights reserved.
//

#ifndef UIImage_Rotate_h
#define UIImage_Rotate_h


#endif /* UIImage_Rotate_h */
#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

@end
