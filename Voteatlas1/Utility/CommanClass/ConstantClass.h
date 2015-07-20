//
//  ConstantClass.h
//  Voteatlas1
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantClass : NSObject

+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+ (BOOL)checkNetworkConection;
+ (UIImage *)imageAccordingToPhone;
+ (CGFloat)withOfDeviceScreen;
+ (CGRect)sizeOfString :(NSString *)strText withSize :(CGSize)size;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (UIImage *)mergeTwoImage:(UIImage*)image1 andImage2:(UIImage *)image2;

@end
