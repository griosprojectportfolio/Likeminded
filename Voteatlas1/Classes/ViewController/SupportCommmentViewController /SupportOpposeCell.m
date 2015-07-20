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

    // Configure the view for the selected state
}

#pragma mark - Set comment in list
- (void)setValueOfCommentsInTableVw:(Comment *)objComment {

    lblName.text = objComment.name;
    lblName.textColor = [UIColor setCustomSignUpColor];
    NSString *strSuppose = objComment.comment;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];

    lblComment.frame = CGRectMake(lblComment.frame.origin.x, lblComment.frame.origin.y, self.frame.size.width, rect.size.height);
    lblComment.text = objComment.comment;

    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

@end
