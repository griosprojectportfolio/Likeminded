//
//  AdminViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UITableView *tbleVwCategory;
@property(nonatomic,retain)IBOutlet CustomTextField *txtFldCat;
@property(nonatomic,retain)IBOutlet UIButton* btnAdd;
@property(nonatomic,retain)IBOutlet UIButton*btnSaveSortOrder;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollVwCat;


@end
