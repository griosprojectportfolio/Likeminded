//
//  ConstantClass.m
//  Voteatlas1
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ConstantClass.h"

@implementation ConstantClass

#pragma mark - Methof to mask image

+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {

    CGImageRef imgRef  = [image CGImage];
    CGImageRef maskRef = [maskImage CGImage];


    int maskWidth      = (int) CGImageGetWidth(maskRef);
    int maskHeight     = (int) CGImageGetHeight(maskRef);
        //  round bytesPerRow to the nearest 16 bytes, for performance's sake
    int bytesPerRow    = (maskWidth + 15) & 0xfffffff0;
    int bufferSize     = bytesPerRow * maskHeight;

        //  allocate memory for the bits
    CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CFDataSetLength(dataBuffer, bufferSize);

        //  the data will be 8 bits per pixel, no alpha
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx            = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                                        maskWidth, maskHeight,
                                                        8, bytesPerRow, colourSpace, (int)kCGImageAlphaNone);
        //  drawing into this context will draw into the dataBuffer.
    CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), maskRef);
    CGContextRelease(ctx);

        //  now make a mask from the data.
    CGDataProviderRef dataProvider  = CGDataProviderCreateWithCFData(dataBuffer);
    CGImageRef mask                 = CGImageMaskCreate(maskWidth, maskHeight, 8, 8, bytesPerRow,
                                                        dataProvider, NULL, FALSE);

    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colourSpace);
    CFRelease(dataBuffer);

    CGImageRef masked = CGImageCreateWithMask(imgRef, mask);
    UIImage *imgMasked = [UIImage imageWithCGImage:masked];
    CFRelease(mask);
    return imgMasked;
}

+ (BOOL)checkNetworkConection {

    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:ERROR_CONNECTING
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}


+ (UIImage *)imageAccordingToPhone {

  UIImage *imgBG;
  if (IS_IPHONE_4_OR_LESS) {
    imgBG = [UIImage imageNamed:@"BG4.png"];
  } else if (IS_IPHONE_5) {
   imgBG = [UIImage imageNamed:@"BG5.png"];
  } else if (IS_IPHONE_6) {
    imgBG = [UIImage imageNamed:@"BG6.png"];
  } else if (IS_IPHONE_6P) {
    imgBG = [UIImage imageNamed:@"BG6Pluse.png"];
  }
  return imgBG;
}

+ (CGFloat)withOfDeviceScreen {

    CGFloat width;
    if (IS_IPHONE_6) {
        width = 375;
    } else if (IS_IPHONE_6P) {
        width = 414;
    } else {
        width = 320;
    }
    return width;
}

+ (CGRect)sizeOfString :(NSString *)strText withSize :(CGSize)size {

  CGRect rect =[strText boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];
  return rect;
}

#pragma mark - Rotate image

+ (UIImage *)scaleAndRotateImage:(UIImage *)image {

  NSLog(@"%f", image.size.width);
  int kMaxResolution = 320; // Or whatever

  CGImageRef imgRef = image.CGImage;

  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);

  CGAffineTransform transform = CGAffineTransformIdentity;
  CGRect bounds = CGRectMake(0, 0, width, height);
  if (width > kMaxResolution || height > kMaxResolution) {
    CGFloat ratio = width/height;
    if (ratio > 1) {
      bounds.size.width = kMaxResolution;
      bounds.size.height = roundf(bounds.size.width / ratio);
    } else {
      bounds.size.height = kMaxResolution;
      bounds.size.width = roundf(bounds.size.height * ratio);
    }
  }

  CGFloat scaleRatio = bounds.size.width / width;
  CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
  CGFloat boundHeight;
  UIImageOrientation orient = image.imageOrientation;
  switch(orient) {

    case UIImageOrientationUp: //EXIF = 1
      transform = CGAffineTransformIdentity;
      break;

    case UIImageOrientationUpMirrored: //EXIF = 2
      transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;

    case UIImageOrientationDown: //EXIF = 3
      transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;

    case UIImageOrientationDownMirrored: //EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;

    case UIImageOrientationLeftMirrored: //EXIF = 5
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;

    case UIImageOrientationLeft: //EXIF = 6
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;

    case UIImageOrientationRightMirrored: //EXIF = 7
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;

    case UIImageOrientationRight: //EXIF = 8
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;

    default:
      [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
  }

  UIGraphicsBeginImageContext(bounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  }
  else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }

  CGContextConcatCTM(context, transform);

  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
  UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();

  NSLog(@"123copy  %f %f", imageCopy.size.width, image.size.height);
  UIGraphicsEndImageContext();

  return imageCopy;
}

+(UIImage *)mergeTwoImage:(UIImage*)image1 andImage2:(UIImage *)image2 {

  CGSize newSize = CGSizeMake(image1.size.width, image1.size.height);
  UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
  [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity if applicable
  [image2 drawInRect:CGRectMake((newSize.width-130)/2,(newSize.height-130)/2,130,130) blendMode:kCGBlendModeNormal alpha:0.8];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return newImage;
}

@end
