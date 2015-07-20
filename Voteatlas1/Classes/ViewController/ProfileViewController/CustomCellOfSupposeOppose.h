//
//  CustomCellOfSupposeOppose.h
//  Voteatlas1
//
//  Created by GrepRuby on 25/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "SupposeOppose.h"

@interface CustomCellOfSupposeOppose : UITableViewCell {

     IBOutlet UIButton *btnStatement;
     IBOutlet UILabel *lblStatement;
}

- (void)setSupposeOrOppose:(SupposeOppose*)objSupposeOppose withVwController:(ProfileViewController*)vwController;

@end
