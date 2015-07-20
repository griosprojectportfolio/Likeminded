//
//  CustomTextField.m
//  Voteatlas1
//
//  Created by GrepRuby on 01/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imgName {

    if (self) {
        self = [super initWithFrame:frame];
        [self setCustomImgVw:imgName withWidth:frame.size.width];
    }
    return self;
}

- (void)setCustomImgVw:(NSString*)imgName withWidth:(CGFloat)width {

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imgVwLeftPannelImg = [[UIImageView alloc]initWithFrame:CGRectMake(14, (self.frame.size.height - 22)/2, 22, 22)];
    imgVwLeftPannelImg.image = img;

    UIImageView *ImgVwLine = [[UIImageView alloc]initWithFrame:CGRectMake(46, (self.frame.size.height - 20)/2 , 1, 20)];
    ImgVwLine.backgroundColor = [UIColor setCustomColorOfTextField];

    UIView *vwLeftPannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 40)];
    [vwLeftPannel addSubview:imgVwLeftPannelImg];
    [vwLeftPannel addSubview:ImgVwLine];

    if (imgName.length == 0) {
        vwLeftPannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    }

    self.leftView = vwLeftPannel;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.layer.cornerRadius = 1;
    self.backgroundColor = [UIColor whiteColor];
}

@end
