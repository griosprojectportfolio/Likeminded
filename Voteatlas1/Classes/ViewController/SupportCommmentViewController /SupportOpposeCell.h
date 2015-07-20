//
//  SupportOpposeCell.h
//  Voteatlas1
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface SupportOpposeCell : UITableViewCell {

    IBOutlet UILabel *lblComment;
    IBOutlet UILabel *lblName;
}

- (void)setValueOfCommentsInTableVw:(Comment *)objComment;

@end
