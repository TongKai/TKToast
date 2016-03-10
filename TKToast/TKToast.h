//
//  TKToast.h
//  TKToast
//
//  Created by TungKay on 16/3/8.
//  Copyright © 2016年 TungKay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TKToastStyle) {
    TKToastStyleMid,
    TKToastStyleBottom
};

@interface TKToast: UIView

+ (void)makeToast:(NSString *)msg style:(TKToastStyle)style;

@end
