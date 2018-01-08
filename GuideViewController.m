//
//  GuideViewController.m
//  tf_camera_example
//
//  Created by 白龙 on 2018/1/8.
//  Copyright © 2018年 Google. All rights reserved.
//

#import "GuideViewController.h"
#import <UIKit/UIKit.h>

//@interface GuideViewController ()
//{
//    UIScrollView *_scrollView;
//    NSArray      *_imageArr;
//}
//@end

//
//@implementation GuideViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    self.strNavTitle = RCSLocalizedString(@"kLocSettingNoviceGuide");
//
//    _imageArr = @[@"noviceGuide_1", @"noviceGuide_2", @"noviceGuide_3", @"noviceGuide_4", @"noviceGuide_5"];//, @"noviceGuide_6"
//
//    [self setView];
//}
//
//- (void)setView
//{
//    CGFloat height = ScreenHeight - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height;
//    CGRect rect = CGRectMake(0, 0, ScreenWidth, height);
//    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
//    _scrollView.contentSize   = CGSizeMake(_imageArr.count * CGRectGetWidth(rect), CGRectGetHeight(rect));
//    _scrollView.delegate      = self;
//    _scrollView.pagingEnabled = YES;
//    _scrollView.bounces       = NO;
//
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator   = NO;
//    [self.view addSubview:_scrollView];
//
//    for (int i = 0; i < _imageArr.count; i++) {
//
//        UIImage *img = [UIImage imageNamed:_imageArr[i]];
//        if (img.size.width == 0) {
//
//            continue;
//        }
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * i, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
//        [_scrollView addSubview:scrollView];
//
//        CGFloat imgViewHeight = (CGRectGetWidth(_scrollView.frame) * img.size.height) / img.size.width;
//        UIImageView *imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), imgViewHeight)];
//        imgView.image = img;
//        [scrollView addSubview:imgView];
//
//        scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), imgViewHeight);
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//@end
