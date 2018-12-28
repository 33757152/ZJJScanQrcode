//
//  ZJJScanViewController.m
//  ZJJScanCodeProject
//
//  Created by YD on 2018/12/27.
//  Copyright © 2018年 YD. All rights reserved.
//
#define S_WIDTH            [UIScreen mainScreen].bounds.size.width
#define S_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define NAV_STATUS_HEIGHT  (self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)
#define USEFUL_RECT        CGRectMake(30, (S_HEIGHT-NAV_STATUS_HEIGHT-S_WIDTH+60)/2, S_WIDTH-60, S_WIDTH-60)

#import "ZJJScanViewController.h"
#import "ZJJTranslucentView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZJJGetSystemImageTool.h"
#import "ZJJWebViewController.h"

@interface ZJJScanViewController () <AVCaptureMetadataOutputObjectsDelegate,ZJJPopBackDelegate> {
    UIImageView *_moveImageView;
    ZJJGetSystemImageTool *_tool;
}

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation ZJJScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    // 扫描区域
    [self setUpScanZone];
    // 提示文字
    [self setUpTipLabel];
    // 开始动画
    [self moveImageAnimationBegin];
    // 创建功能按钮
    [self setUpFunctionButtons];
    // 开始扫描
    [self beginScanning];
}

- (void)setUpScanZone {
    ZJJTranslucentView *lucentView = [[ZJJTranslucentView alloc] initWithFrame:CGRectMake(0, 0, S_WIDTH, S_HEIGHT-NAV_STATUS_HEIGHT) withLucencyRect:USEFUL_RECT];
    [self.view addSubview:lucentView];
    
    UIView *centerView = [[UIView alloc] initWithFrame:USEFUL_RECT];
    centerView.clipsToBounds = YES;
    [self.view addSubview:centerView];
    
    _moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, USEFUL_RECT.size.width, USEFUL_RECT.size.height)];
    _moveImageView.image = [UIImage imageNamed:@"scan_net"];
    [centerView addSubview:_moveImageView];
    
    CGFloat cornerImage_w = 20;
    
    UIImageView *topLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cornerImage_w, cornerImage_w)];
    topLeft.image = [UIImage imageNamed:@"scan_1"];
    [centerView addSubview:topLeft];
    
    UIImageView *topRight = [[UIImageView alloc] initWithFrame:CGRectMake(USEFUL_RECT.size.width-cornerImage_w, 0, cornerImage_w, cornerImage_w)];
    topRight.image = [UIImage imageNamed:@"scan_2"];
    [centerView addSubview:topRight];
    
    UIImageView *bottomLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, USEFUL_RECT.size.height-cornerImage_w, cornerImage_w, cornerImage_w)];
    bottomLeft.image = [UIImage imageNamed:@"scan_3"];
    [centerView addSubview:bottomLeft];
    
    UIImageView *bottomRight = [[UIImageView alloc] initWithFrame:CGRectMake(USEFUL_RECT.size.width-cornerImage_w, USEFUL_RECT.size.height-cornerImage_w, cornerImage_w, cornerImage_w)];
    bottomRight.image = [UIImage imageNamed:@"scan_4"];
    [centerView addSubview:bottomRight];
}

- (void)setUpTipLabel {
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, USEFUL_RECT.size.height+USEFUL_RECT.origin.y+5, S_WIDTH, 30)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
}

- (void)setUpFunctionButtons {
    // 相册按钮
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    albumBtn.frame = CGRectMake(30, USEFUL_RECT.size.height+USEFUL_RECT.origin.y+40, 50*130/174, 50);
    [albumBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    albumBtn.contentMode = UIViewContentModeScaleAspectFit;
    [albumBtn addTarget:self action:@selector(openMyPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    
    // 闪光灯按钮
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(S_WIDTH-30-albumBtn.frame.size.width, albumBtn.frame.origin.y, albumBtn.frame.size.width, albumBtn.frame.size.height);
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    flashBtn.contentMode = UIViewContentModeScaleAspectFit;
    [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
}

- (void)moveImageAnimationBegin {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 2;
    animation.keyPath = @"position";
    CGPoint fromePoint = CGPointMake(USEFUL_RECT.size.width/2, -USEFUL_RECT.size.height/2);
    CGPoint toPoint = CGPointMake(USEFUL_RECT.size.width/2, USEFUL_RECT.size.height*3/2);
    animation.fromValue = [NSValue valueWithCGPoint:fromePoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    [_moveImageView.layer addAnimation:animation forKey:@"moveImageView"];
}

- (void)beginScanning {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    output.rectOfInterest = [self caculateEffectiveArea];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code
                                   ];
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

// 扫描结果显示
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self stopScan];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSArray *array = [metadataObject.stringValue componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [self handleScanResult:[array firstObject]];
    }
}

- (void)openMyPhoto {
    _tool = [[ZJJGetSystemImageTool alloc] initWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum withDelegate:self];
}

#pragma mark - 获取到系统的相片
- (void)zjjPassImage:(UIImage *)image {
    [self stopScan];
    //初始化一个监测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        [self handleScanResult:scannedResult];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲!介个压根儿没有二维码..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startScan];
        }];
        [alert addAction:cancelAction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

#pragma mark-> 闪光灯
-(void)openFlash:(UIButton *)button{
    button.selected = !button.selected;
   [self turnTorchOn:button.selected];
}

#pragma mark-> 开关闪光灯
- (void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)handleScanResult:(NSString *)resultString {
    if ([resultString containsString:@"http"] || [resultString containsString:@"www"]) {
        ZJJWebViewController *web = [[ZJJWebViewController alloc] init];
        web.urlString = resultString;
        web.delegate = self;
        [self.navigationController pushViewController:web animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描成功" message:resultString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startScan];
        }];
        [alert addAction:action];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)startScan {
    [_session startRunning];
    [self moveImageAnimationBegin];
}

- (void)stopScan {
    [_session stopRunning];
    [_moveImageView.layer removeAnimationForKey:@"moveImageView"];
}

- (void)backHome {
    [self startScan];
}

- (CGRect)caculateEffectiveArea {
    return CGRectMake(USEFUL_RECT.origin.y/S_HEIGHT,
                      USEFUL_RECT.origin.x/S_WIDTH,
                      USEFUL_RECT.size.height/S_HEIGHT,
                      USEFUL_RECT.size.width/S_WIDTH);
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
