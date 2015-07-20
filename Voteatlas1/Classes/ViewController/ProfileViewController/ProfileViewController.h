//
//  ProfileViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 23/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController {

    IBOutlet UILabel *lblAgree;
    IBOutlet UILabel *lblTotVoate;
    IBOutlet UILabel *lblDisagree;
    IBOutlet UILabel *lblNotCommon;
    IBOutlet UILabel *lblfanmails;
    IBOutlet UILabel *lblCommaon;

    IBOutlet UILabel *lblAgreeHeading;
    IBOutlet UILabel *lblTotVoateHeading;
    IBOutlet UILabel *lblDisagreeHeading;
    IBOutlet UILabel *lblNotCommonHeading;
    IBOutlet UILabel *lblfanmailsHeading;
    IBOutlet UILabel *lblCommaonHeading;

    IBOutlet UIImageView *imgvwAgree;
    IBOutlet UIImageView *imgvwDisagree;
    IBOutlet UIImageView *imgvwTotVoate;
    IBOutlet UIImageView *imgvwNotCommon;
    IBOutlet UIImageView *imgvwFanmails;
    IBOutlet UIImageView *imgvwComman;

    IBOutlet UILabel *lblStatus;
    IBOutlet UIButton *btnMyAccount;
    IBOutlet UIButton *btnAdmin;
    IBOutlet UISegmentedControl *segmentSupposeOppose;
}

@property(nonatomic,strong)NSMutableDictionary *dictProfile;
@property(nonatomic,strong)IBOutlet UIImageView *imgProfil;
@property(nonatomic,strong)IBOutlet UITableView *tableVwSupposeOppose;
@property(nonatomic,strong)IBOutlet UITextView *txtVwAboutme;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollVwProfile;

- (IBAction)btnMyAccountTapped:(id)sender;

@end
