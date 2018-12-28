//
//  ZJJCreateCodeViewController.m
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/28.
//  Copyright © 2018年 YD. All rights reserved.
//
#define S_WIDTH            [UIScreen mainScreen].bounds.size.width
#define S_HEIGHT           [UIScreen mainScreen].bounds.size.height

#import "ZJJCreateCodeViewController.h"

@interface ZJJCreateCodeViewController () {
    UITextField *_myTF;
    UIImageView *_codeImageView;
}

@end

@implementation ZJJCreateCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"生成二维码";
    [self creatView];
}

- (void)creatView {
    _myTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, S_WIDTH-20, 40)];
    _myTF.font = [UIFont systemFontOfSize:15.f];
    _myTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_myTF];
    
    UIButton *creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    creatBtn.backgroundColor = [UIColor greenColor];
    creatBtn.frame = CGRectMake(50, 100, S_WIDTH-100, 50);
    [creatBtn setTitle:@"开始" forState:UIControlStateNormal];
    [creatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creatBtn addTarget:self action:@selector(creatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatBtn];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, S_HEIGHT-S_WIDTH+60-100, S_WIDTH-60, S_WIDTH-60)];
    [self.view addSubview:_codeImageView];
}

- (void)creatClick {
    [self.view endEditing:YES];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [_myTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:S_WIDTH-60];
    _codeImageView.image = image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
