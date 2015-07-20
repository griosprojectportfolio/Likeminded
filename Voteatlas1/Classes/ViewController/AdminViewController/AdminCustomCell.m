//
//  AdminCustomCell.m
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "AdminCustomCell.h"

@implementation AdminCustomCell

- (void)awakeFromNib {

    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Set value in list
- (void)setValuesOfAdminCell:(NSDictionary *)dictCat forRow:(NSInteger)row listCount:(NSInteger)listCount {

    NSString *strSuppose =  [dictCat valueForKey:@"name"];
    // CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(200, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil];

    self.lblCategory.text = strSuppose;
    self.lblCategory.numberOfLines = 0;
    //  self.lblCategory.frame = CGRectMake(self.lblCategory.frame.origin.x, 11, 200, rect.size.height);

   self.tag = row;
    count = listCount;

    self.btnEdit.backgroundColor = [UIColor setCustomSignUpColor];
    self.btnEdit.layer.borderWidth = 0.5;
    self.btnEdit.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnEdit.layer.cornerRadius = 5.0;

    self.btnUp.backgroundColor = [UIColor whiteColor];
    self.btnUp.layer.borderWidth = 0.5;
    self.btnUp.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnUp.layer.cornerRadius = 5.0;

    self.btnDown.backgroundColor = [UIColor whiteColor];
    self.btnDown.layer.borderWidth = 0.5;
    self.btnDown.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnDown.layer.cornerRadius = 5.0;

    self.btnDelete.backgroundColor = [UIColor setCustomRedColor];
    self.btnDelete.layer.borderWidth = 0.5;
    self.btnDelete.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnDelete.layer.cornerRadius = 5.0;

    [self.btnUp addTarget:self action:@selector(handleUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDown addTarget:self action:@selector(handleDownEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelete addTarget:self action:@selector(handleDeleteEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEdit addTarget:self action:@selector(handleEditEvent:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Delegates
- (void)handleUpEvent:(id)sender {
    if (self.tag == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(handleUpEvent:)]) {
        [self.delegate handleUpEvent:self.tag];
    }
    self.tag = self.tag - 1;
}

- (void)handleDownEvent:(id)sender {
    if (self.tag == count-1) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(handleDownEvent:)]) {
        [self.delegate handleDownEvent:self.tag];
    }
    self.tag = self.tag + 1;
}

- (void)handleDeleteEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleDeleteEvent:)]) {
        [self.delegate handleDeleteEvent:self.tag];
    }
}

- (void)handleEditEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleEditEvent:)]) {
        [self.delegate handleEditEvent:self.tag];
    }
}

@end
