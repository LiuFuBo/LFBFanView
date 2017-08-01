//
//  SYFanView.m
//  动态圆形图
//
//  Created by branon_liu on 2017/7/26.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBFanView.h"
#import <QuartzCore/QuartzCore.h>

#define kMargin 5.0f
#define DEGREES_TO_RADIANS(degrees) (degrees+90) / 180.0 * M_PI
#define RGBs(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface LFBFanView ()<CAAnimationDelegate>

/** 开始角度 */
@property (nonatomic, assign) CGFloat startAngle;

/** 结束角度 */
@property (nonatomic, assign) CGFloat endAngle;
/** 圆弧线宽 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 圆弧填充颜色 */
@property (nonatomic, strong) UIColor *fillColor;
/** 内圆和外扇形的圆心距 */
@property (nonatomic, assign) CGFloat distance;
/** 外部扇形的长度*/
@property (nonatomic, assign) CGFloat fanHeight;


@end


@implementation LFBFanView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];//初始化数据
        [self setNeedsDisplay];
    }
    return self;
}

- (void)initialize{
    self.barCount = 82;
    self.startAngle = 45.0f;
    self.endAngle = 315.0f;
    self.lineWidth = 1.5f;
    self.fillColor = RGBs(245,146,139);
    self.distance = 5.0f;
    self.fanHeight = 14.0f;
    self.energyPercent = 70.0f;
    self.normalColor = RGBs(245, 146, 139);
    self.hightlightColor = [UIColor whiteColor];
}

+ (instancetype)shareInstance{
    static LFBFanView *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [LFBFanView new];
    });
    return share;
}

- (void)setFanColors:(UIColor *)fanColors{
    _fanColors = fanColors;
    self.backgroundColor = fanColors;
}

- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRangeCircle:context];
}


- (void)drawRangeCircle:(CGContextRef)context{
    
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeZero, 0.0);
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint circleCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
     //开始绘画
     //1.绘制内圆
    UIBezierPath *centerPath = [UIBezierPath bezierPath];
    [centerPath addArcWithCenter:circleCenter radius:boundsWidth/2 - self.fanHeight - kMargin - self.lineWidth startAngle:DEGREES_TO_RADIANS(self.startAngle) endAngle:DEGREES_TO_RADIANS(self.endAngle) clockwise:YES];
    [self.fillColor setStroke];
    centerPath.lineWidth = self.lineWidth;
    [centerPath stroke];
    //绘制外部底色扇形虚线
    [self drawShadowFan];
    //绘制外部实线扇形虚线
    [self drawCoverFan];
    //绘制电量扇形
    [self drawElectricityFan];
    //绘制环绕电量的外框
    [self drawOutFrameWorks];
}

#pragma mark - P 绘制底层阴影扇形
- (void)drawShadowFan{

    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint circleCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = self.bounds;
    replicator.position = CGPointMake(boundsWidth/2, boundsHeight/2);
    replicator.instanceColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:replicator];
    replicator.anchorPoint = CGPointMake(0.5, 0.5);
    replicator.instanceCount = self.barCount;
    
    CAShapeLayer *layers = [CAShapeLayer layer];
    layers.lineWidth = self.fanHeight;
    layers.fillColor = [UIColor clearColor].CGColor;
    layers.strokeColor = self.normalColor.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:boundsWidth/2 - self.fanHeight + 5 startAngle:DEGREES_TO_RADIANS(self.startAngle) endAngle:DEGREES_TO_RADIANS(self.startAngle + 1.2) clockwise:YES];
    layers.path = [path CGPath];
    [replicator addSublayer:layers];
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 0, 0);
    transform = CATransform3DRotate(transform, M_PI / 54.0, 0, 0, 1);
    replicator.instanceTransform = transform;
}

#pragma mark - P 绘制百分比扇形 -- (最上面带颜色的扇形)
- (void)drawCoverFan{

    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint circleCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    if (self.percent != 0) {
        
        CAReplicatorLayer *coverLayer = [CAReplicatorLayer layer];
        coverLayer.bounds = self.bounds;
        coverLayer.position = CGPointMake(boundsWidth/2, boundsHeight/2);
        coverLayer.instanceColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:coverLayer];
        coverLayer.instanceCount = self.barCount * (self.percent/ 100.0f);
        coverLayer.anchorPoint = CGPointMake(0.5, 0.5);
        coverLayer.instanceDelay = 0.3f;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = self.fanHeight;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = self.hightlightColor.CGColor;
        shapeLayer.strokeEnd = 1.0f;
        
        UIBezierPath *shapPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:boundsWidth/2 - self.fanHeight + 5 startAngle:DEGREES_TO_RADIANS(self.startAngle) endAngle:DEGREES_TO_RADIANS(self.startAngle + 1.2) clockwise:YES];
        shapeLayer.path = [shapPath CGPath];
        [coverLayer addSublayer:shapeLayer];
        
        CATransform3D coverTransForm = CATransform3DIdentity;
        coverTransForm = CATransform3DTranslate(coverTransForm, 0, 0, 0);
        coverTransForm = CATransform3DRotate(coverTransForm, M_PI / 54.0, 0, 0, 1);
        coverLayer.instanceTransform = coverTransForm;
        //开始动画
        [self startAnimationWithLayer:coverLayer];
    }
}

#pragma mark - P 绘制电量图
- (void)drawElectricityFan{
  
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint circleCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    UIBezierPath *energyPath = [UIBezierPath bezierPath];
    //当为YES是按照顺时针方向画图，当为NO则按照逆时针画图
    BOOL clockwise = NO;
    [energyPath addArcWithCenter:circleCenter radius:boundsWidth/2 - self.fanHeight startAngle:DEGREES_TO_RADIANS(35) endAngle:DEGREES_TO_RADIANS(-35) clockwise:clockwise];
    [RGBs(254, 191, 182) setStroke];
    energyPath.lineWidth = 8;
    [energyPath stroke];
    
    UIBezierPath *currentPath = [UIBezierPath bezierPath];
    [currentPath addArcWithCenter:circleCenter radius:boundsWidth/2 - self.fanHeight startAngle:DEGREES_TO_RADIANS(35) endAngle:DEGREES_TO_RADIANS(35-(70 * (self.energyPercent / 100))) clockwise:NO];
    currentPath.lineWidth = 8;
    [RGBs(127, 216, 44) setStroke];
    [currentPath stroke];
    
}

#pragma mark - P 绘制环绕电量的外框
- (void)drawOutFrameWorks{

    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint circleCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    //左边弧线
    UIBezierPath *leftAnglePath = [UIBezierPath bezierPath];
    [leftAnglePath addArcWithCenter:circleCenter radius:boundsWidth/2 - self.fanHeight + 2 startAngle:DEGREES_TO_RADIANS(39) endAngle:DEGREES_TO_RADIANS(37) clockwise:NO];
    [self.fillColor setStroke];
    leftAnglePath.lineWidth = 10;
    [leftAnglePath stroke];
    //中间弧线
    UIBezierPath *framePath = [UIBezierPath bezierPath];
    [framePath addArcWithCenter:circleCenter radius:boundsWidth/2 - 7  startAngle:DEGREES_TO_RADIANS(39) endAngle:DEGREES_TO_RADIANS(-39) clockwise:NO];
    [self.fillColor setStroke];
    framePath.lineWidth = 3;
    [framePath stroke];
    //右边弧线
    UIBezierPath *rightAnglePath = [UIBezierPath bezierPath];
    [rightAnglePath addArcWithCenter:circleCenter radius:boundsWidth/2 - self.fanHeight + 2  startAngle:DEGREES_TO_RADIANS(-37) endAngle:DEGREES_TO_RADIANS(-39) clockwise:NO];
    [self.fillColor setStroke];
    rightAnglePath.lineWidth = 10;
    [rightAnglePath stroke];

}

#pragma mark - P 开始对layer的复制次数做动画
- (void)startAnimationWithLayer:(CAReplicatorLayer *)layer{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"instanceCount"];
    animation.duration = 5.0f;
    animation.repeatCount = 0;
    animation.fromValue = @(0);
    animation.toValue = @(self.barCount * (self.percent/ 100.0f));
    animation.autoreverses = NO;//是否翻转
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
}



@end
