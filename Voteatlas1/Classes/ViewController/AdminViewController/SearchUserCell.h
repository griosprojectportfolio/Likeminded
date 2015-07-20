//
//  SearchUserCell.h
//  Voteatlas1
//
//  Created by GrepRuby on 10/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchUserCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UILabel *lblUser;

- (void)setValueOfSearchUser :(NSDictionary *)dict;

@end
