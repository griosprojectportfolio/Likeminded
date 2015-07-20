//
//  SupportOpposeCell.m
//  Voteatlas1
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SupportOpposeCell.h"

@implementation SupportOpposeCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Set comment in list
- (void)setValueOfCommentsInTableVw:(Comment *)objComment withWidth:(int)width {

    if (self.objComment != nil)  {
        self.objComment = nil;
    }

    self.objComment = objComment;
    if(![objComment.name isKindOfClass:[NSNull class]]) {
        lblName.text = objComment.name;
    } else {
        lblName.text = @"Anonymous User";
    }
    lblName.textColor = [UIColor setCustomSignUpColor];

    imgVwProfile.image = [UIImage imageNamed:@"photo"];
    imgVwProfile.layer.cornerRadius = imgVwProfile.frame.size.width/2;
    [btnProfileImg addTarget:self action:@selector(profileBtnTapped) forControlEvents:UIControlEventTouchUpInside];

    NSString *strSuppose = [objComment.comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(width, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];

    lblComment.frame = CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, width, rect.size.height);
    lblComment.text = objComment.comment;

    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)profileBtnTapped {

    if ([self.delegate respondsToSelector:@selector(profileBtnTapped:)]) {
        [self.delegate profileBtnTapped:self.objComment];
    }
}

@end
