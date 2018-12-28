//
//  ViewController.m
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/26.
//  Copyright © 2018年 YD. All rights reserved.
//

#import "ViewController.h"
#import "ZJJCreateCodeViewController.h"
#import "ZJJScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"生成码" style:UIBarButtonItemStylePlain target:self action:@selector(createClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:UIBarButtonItemStylePlain target:self action:@selector(scanClick)];
    
}

- (void)createClick {
    ZJJCreateCodeViewController *create = [[ZJJCreateCodeViewController alloc] init];
    [self.navigationController pushViewController:create animated:YES];
}

- (void)scanClick {
    ZJJScanViewController *scan = [ZJJScanViewController new];
    [self.navigationController pushViewController:scan animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
