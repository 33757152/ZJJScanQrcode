//
//  ZJJTranslucentView.m
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/27.
//  Copyright © 2018年 YD. All rights reserved.
//

#import "ZJJTranslucentView.h"

@interface ZJJTranslucentView ()

@property (nonatomic, assign) CGRect lucencyRect;

@end

@implementation ZJJTranslucentView

- (instancetype)initWithFrame:(CGRect)frame withLucencyRect:(CGRect)lucencyRect {
    self = [super initWithFrame:frame];
    if (self) {
        self.lucencyRect = lucencyRect;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

/**
 union: 并集
 CGRectUnion(CGRect r1, CGRect r2)
 */

/**
 Intersection: 交集
 CGRectIntersection(CGRect r1, CGRect r2)
 */
- (void)drawRect:(CGRect)rect {
    // 半透明区域
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    UIRectFill(rect);
    // 取出交集
    CGRect intersectionRect = CGRectIntersection(rect, _lucencyRect);
    // 全透明
    [[UIColor clearColor] setFill];
    UIRectFill(intersectionRect);
}

@end
