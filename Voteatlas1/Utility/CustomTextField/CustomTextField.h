//
//  CustomTextField.h
//  Voteatlas1
//
//  Created by GrepRuby on 01/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imgName;
- (void)setCustomImgVw:(NSString*)imgName withWidth:(CGFloat)width;

@end
