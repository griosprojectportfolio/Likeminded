//
//  ModeratorViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeratorViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tbleVwFlag;

- (IBAction)dismissFlag:(id)sender;
- (IBAction)deleteBelief:(id)sender;

@end
