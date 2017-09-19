//
//  ViewController.m
//  动态圆形图
//
//  Created by branon_liu on 2017/7/26.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "ViewController.h"
#import "LFBFanView.h"
#import "LFBFanModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *button = [[UIButton alloc]init];
    button.bounds = CGRectMake(0, 0, 120, 40);
    button.center = CGPointMake(self.view.center.x, 60);
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
}

- (void)respondsToButton:(UIButton *)sender{

    LFBFanModel *model = [LFBFanModel new];
    model.fanColors =[UIColor colorWithRed:243/255.0f green:125/255.0f blue:88/255.0f alpha:1];
    model.percent = 90;
    model.energyPercent = 80;
    LFBFanView *fan = [LFBFanView new];
    fan.bounds = CGRectMake(0, 0, 205, 205);
    fan.center = self.view.center;
    [fan bindDataWithModel:model];
    [self.view addSubview:fan];
}





@end
