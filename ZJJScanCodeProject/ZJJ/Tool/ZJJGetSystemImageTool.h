//
//  ZJJGetSystemImageTool.h
//  ZJJPhotoImage
//
//  Created by 张锦江 on 2017/8/5.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZJJPassImageDelegate <NSObject>

- (void)zjjPassImage:(UIImage *)image;

@end

@interface ZJJGetSystemImageTool : NSObject

- (instancetype)initWithSourceType:(UIImagePickerControllerSourceType)sourceType withDelegate:(id)object;

@end
