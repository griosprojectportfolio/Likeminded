//
//  ModeratorCell.m
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ModeratorCell.h"

@implementation ModeratorCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Set value in list
- (void)setFlagValues:(NSDictionary *)dictModerator target:(ModeratorViewController *)vwController forRow:(NSInteger)row {

    lblBeliefHeading.frame = CGRectMake(10, 5, self.contentView.frame.size.width - 20, 21);
    lblBeliefHeading.text = @"Belief";
    lblBeliefHeading.font = [UIFont boldSystemFontOfSize:14.0];

    NSString *strBelief =[[dictModerator valueForKey:@"belief"]valueForKey:@"text"];
    CGRect rect =[strBelief boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    lblBelief.frame = CGRectMake(10, lblBeliefHeading.frame.size.height + lblBeliefHeading.frame.origin.y +3, self.contentView.frame.size.width - 20, rect.size.height);
    lblBelief.text = strBelief;
    lblBelief.font = [UIFont systemFontOfSize:14.0];

    lblFReasonHeading.frame = CGRectMake(10, lblBelief.frame.size.height + lblBelief.frame.origin.y +3, self.contentView.frame.size.width - 20, 21);
    lblFReasonHeading.text = @"Flag Reason";
    lblFReasonHeading.font = [UIFont boldSystemFontOfSize:14.0];

    NSString *strReason = [dictModerator valueForKey:@"text"];
    CGRect rectReason =[strReason boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    lblFReason.frame = CGRectMake(10, lblFReasonHeading.frame.size.height + lblFReasonHeading.frame.origin.y +3, self.contentView.frame.size.width - 20, rectReason.size.height);
    lblFReason.text = strReason;
    lblFReason.font = [UIFont systemFontOfSize:14.0];

    lblFlagBy.frame = CGRectMake(10, lblFReason.frame.size.height + lblFReason.frame.origin.y +3, self.contentView.frame.size.width - 20, 21);
    lblFlagBy.text = [[dictModerator valueForKey:@"user"]valueForKey:@"email"];
    lblFlagBy.font = [UIFont systemFontOfSize:14.0];

    self.btnDeleteBelief.frame = CGRectMake(self.frame.size.width - 240, lblFlagBy.frame.size.height + lblFlagBy.frame.origin.y +10, 105, 25);
    [self.btnDeleteBelief setTitle:@"Delete Belief" forState:UIControlStateNormal];
    self.btnDeleteBelief.tag = row;
    [self.btnDeleteBelief setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnDeleteBelief.layer.cornerRadius = 5.0;
    self.btnDeleteBelief.backgroundColor = [UIColor setCustomRedColor];

    self.btnDismissFlag.frame = CGRectMake(self.frame.size.width - 130, lblFlagBy.frame.size.height + lblFlagBy.frame.origin.y +10, 105, 25);
    [self.btnDismissFlag setTitle:@"Dismiss Flag" forState:UIControlStateNormal];
    self.btnDismissFlag.tag = row;
    [self.btnDismissFlag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnDismissFlag.layer.cornerRadius = 5.0;
    self.btnDismissFlag.backgroundColor = [UIColor setCustomColorOfTextField];

    [self.btnDismissFlag addTarget:vwController action:@selector(dismissFlag:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDeleteBelief addTarget:vwController action:@selector(deleteBelief:) forControlEvents:UIControlEventTouchUpInside];
}

@end
