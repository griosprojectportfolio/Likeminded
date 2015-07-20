//
//  UIColor+CustomColor.m
//  Voteatlas1
//
//  Created by GrepRuby on 01/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor *)setCustomColorOfTextField {
    UIColor *color = [UIColor colorWithRed:86/256.0f green:163/256.0f blue:211/256.0f alpha:1.0];
    return color;
}

+ (UIColor *)setCustomRedColor {
    UIColor *color = [UIColor colorWithRed:200/256.0f green:79/256.0f blue:40/256.0f alpha:1.0];
    return color;
}

+ (UIColor *)setCustomSignUpColor {
    UIColor *color = [UIColor colorWithRed:103/256.0f green:140/256.0f blue:205/256.0f alpha:1.0];
    return color;
}
@end
