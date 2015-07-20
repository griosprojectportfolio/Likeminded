//
//  SearchDetailViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 27/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailViewController : UIViewController {

    IBOutlet CustomTextField *txtFldJustAdded;
    IBOutlet CustomTextField *txtFldGlobal;
    IBOutlet CustomTextField *txtFldAll;
    IBOutlet UIImageView *imgVwBgImg;
    IBOutlet UISegmentedControl *segmentTrash;
    IBOutlet UIButton *btnApply;
    IBOutlet UIButton *btnNotApply;
}

@end
