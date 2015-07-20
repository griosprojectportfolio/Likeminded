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
                                                        8, bytesPerRow, colourSpace, kCGImageAlphaNone);
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


@end
