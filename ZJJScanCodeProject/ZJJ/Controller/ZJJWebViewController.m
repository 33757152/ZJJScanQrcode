//
//  ZJJWebViewController.m
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/28.
//  Copyright © 2018年 YD. All rights reserved.
//

#import "ZJJWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZJJWebViewController ()

@end

@implementation ZJJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"加载网址";
    [self creatWebView];
}

- (void)viewDidDisappear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(backHome)]) {
        [self.delegate backHome];
    }
}

- (void)creatWebView {
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.frame];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
