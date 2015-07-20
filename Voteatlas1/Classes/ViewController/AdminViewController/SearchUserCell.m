//
//  SearchUserCell.m
//  Voteatlas1
//
//  Created by GrepRuby on 10/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SearchUserCell.h"

@implementation SearchUserCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueOfSearchUser :(NSDictionary *)dict {
    self.lblUser.text = [dict valueForKey:@"email"];
}

@end
