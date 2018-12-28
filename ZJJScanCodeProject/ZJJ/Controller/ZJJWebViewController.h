//
//  ZJJWebViewController.h
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/28.
//  Copyright © 2018年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJJPopBackDelegate <NSObject>

- (void)backHome;

@end

@interface ZJJWebViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, weak) id <ZJJPopBackDelegate> delegate;

@end
