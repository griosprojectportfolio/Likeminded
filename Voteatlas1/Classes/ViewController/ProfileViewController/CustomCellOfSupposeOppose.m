//
//  CustomCellOfSupposeOppose.m
//  Voteatlas1
//
//  Created by GrepRuby on 25/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "CustomCellOfSupposeOppose.h"

@implementation CustomCellOfSupposeOppose

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Method to set comment in table view
- (void)setSupposeOrOppose:(SupposeOppose*)objSupposeOppose withVwController:(ProfileViewController*)vwController {

    NSString *strOppose = objSupposeOppose.statement;
    CGRect rect =[strOppose boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width- 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    lblStatement.numberOfLines = 0;
    lblStatement.textColor = [UIColor darkGrayColor];
    lblStatement.frame = CGRectMake(lblStatement.frame.origin.x, lblStatement.frame.origin.y, rect.size.width, rect.size.height);
    lblStatement.text = objSupposeOppose.statement;
    lblStatement.userInteractionEnabled = NO;
}

@end
