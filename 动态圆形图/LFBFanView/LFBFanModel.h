//
//  LFBFanModel.h
//  动态圆形图
//
//  Created by branon_liu on 2017/9/19.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LFBFanModel : NSObject

/**
 有效运动百分比
 */
@property (nonatomic, assign) CGFloat percent;

/**
 条数
 */
@property (nonatomic, assign) NSInteger barCount;

/**
 低层扇形条的颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 高亮扇形条的颜色
 */
@property (nonatomic, strong) UIColor *hightlightColor;

/**
 整个视图背景颜色
 */
@property (nonatomic, strong) UIColor *fanColors;

/**
 电量所剩百分比
 */
@property (nonatomic, assign) CGFloat energyPercent;

@end
