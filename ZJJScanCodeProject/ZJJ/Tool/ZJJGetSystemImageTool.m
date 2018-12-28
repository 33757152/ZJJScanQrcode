//
//  ZJJGetSystemImageTool.m
//  ZJJPhotoImage
//
//  Created by 张锦江 on 2017/8/5.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import "ZJJGetSystemImageTool.h"

@interface ZJJGetSystemImageTool () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)  UIViewController *viewController;
@property (nonatomic, weak)  id <ZJJPassImageDelegate> zjjDelegate;

@end

@implementation ZJJGetSystemImageTool

- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType withDelegate:(id)object{
    self = [super init];
    if (self) {
        self.zjjDelegate = object;
        self.viewController = (UIViewController *)object;
        [self openSystemWithImageWithType:sourceType];
    }
    return self;
}

- (void)openSystemWithImageWithType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if ([self.zjjDelegate respondsToSelector:@selector(zjjPassImage:)]) {
        [self.zjjDelegate zjjPassImage:image];
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
