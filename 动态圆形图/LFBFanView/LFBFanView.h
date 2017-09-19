//
//  SYFanView.h
//  动态圆形图
//
//  Created by branon_liu on 2017/7/26.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBFanModel.h"

@interface LFBFanView : UIView

/**
 绑定数据

 @param model 存储数据的model
 */
- (void)bindDataWithModel:(LFBFanModel *)model;



@end
