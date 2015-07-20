//
//  SupportOpposeCell.h
//  Voteatlas1
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@protocol CommentDelegate <NSObject>

- (void)profileBtnTapped:(Comment*)comment;

@end

@interface SupportOpposeCell : UITableViewCell {

    IBOutlet UILabel *lblComment;
    IBOutlet UILabel *lblName;
    IBOutlet UIImageView *imgVwProfile;
    IBOutlet UIButton *btnProfileImg;
}

@property (nonatomic, strong) Comment *objComment;
@property (unsafe_unretained) id <CommentDelegate>delegate;

- (void)setValueOfCommentsInTableVw:(Comment *)objComment withWidth:(int)width;

@end
