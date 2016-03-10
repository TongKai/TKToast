//
//  TKToast.m
//  TKToast
//
//  Created by TungKay on 16/3/8.
//  Copyright © 2016年 TungKay. All rights reserved.
//

#import "TKToast.h"

@implementation TKToast
{
    NSString *_msg;
    
    UILabel *_label;
    
    UIFont *_labelTextFont;
    
    TKToastStyle _style;
}

- (instancetype)initWithMsg:(NSString *)msg style:(TKToastStyle)style
{
    if (self = [super init]) {
        //设置字体大小
        _labelTextFont = [UIFont systemFontOfSize:14];
        
        _style = style;
        
        _label = [[UILabel alloc]init];
        _label.text = msg;
        _label.numberOfLines = 0;
        _label.font = _labelTextFont;
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        CGSize tempSize = [self labelTextSize];
        [self addSubview:_label];
        
        //这里改变toastview的大小
        if (_style == TKToastStyleBottom) {
            [_label setFrame:CGRectMake(16, 8, tempSize.width, tempSize.height)];
            self.bounds = CGRectMake(0, 0, tempSize.width + 32, tempSize.height + 16);
        }else {
            //这里改变toastview的大小
            [_label setFrame:CGRectMake(16, 20, tempSize.width, tempSize.height)];
            self.bounds = CGRectMake(0, 0, tempSize.width + 32, tempSize.height + 40);
        }
        
        self.layer.cornerRadius = 6;
    }
    return self;
}

- (CGSize)labelTextSize
{
    CGSize tempSize = CGSizeMake(MAXFLOAT, 20);
    
    NSDictionary *fontAttributeDict = @{NSFontAttributeName:_labelTextFont};
    
    return [_label.text boundingRectWithSize:tempSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttributeDict context:nil].size;
}

- (void)toast
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    self.alpha = 0.0;
    CGPoint center=[TKToast getWindow].center;
    
    if (_style == TKToastStyleBottom) {
        //这里改变toastview的位置
        center.y = [UIScreen mainScreen].bounds.size.height - 100;
        
    }

    self.center = center;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    //这里设置时间
    opacityAnimation.duration = 1.8f;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.values = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:0.0], nil];
    
    opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:0.08f],
                                 [NSNumber numberWithFloat:0.92f],
                                 [NSNumber numberWithFloat:1.0f], nil];
    
    
    opacityAnimation.timingFunctions = [NSArray arrayWithObjects:
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
    
    opacityAnimation.delegate = self;
    
   
    [self.layer addAnimation:opacityAnimation forKey:@"opacity"];

}


+ (UIWindow*)getWindow{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

+ (void)makeToast:(NSString *)msg style:(TKToastStyle)style 
{
    TKToast *toastView = [[TKToast alloc]initWithMsg:msg style:style];
    
    [[self getWindow] addSubview:toastView];
    
    [toastView toast];
}

//代理方法，动画停止时移除view
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[TKToast getWindow].subviews.lastObject removeFromSuperview];
}

@end
