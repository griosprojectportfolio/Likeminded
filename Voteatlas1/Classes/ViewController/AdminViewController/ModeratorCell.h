//
//  ModeratorCell.h
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeratorViewController.h"

@interface ModeratorCell : UITableViewCell {

    IBOutlet UILabel *lblBeliefHeading;
    IBOutlet UILabel *lblBelief;
    IBOutlet UILabel *lblFReasonHeading;
    IBOutlet UILabel *lblFReason;
    IBOutlet UILabel *lblFlagBy;
}

@property (nonatomic, strong) IBOutlet UIButton *btnDeleteBelief;
@property (nonatomic, strong) IBOutlet UIButton *btnDismissFlag;

- (void)setFlagValues:(NSDictionary *)dictModerator target:(ModeratorViewController *)vwController forRow:(NSInteger)row;

@end
