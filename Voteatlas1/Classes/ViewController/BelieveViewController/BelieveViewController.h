//
//  BelieveViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 16/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BelieveViewController : UIViewController<UITextFieldDelegate> {

    UITextField *activetextfield;

    IBOutlet UILabel *lblWebLink;
    IBOutlet UILabel *lblAddImageOrVideo;
    IBOutlet UILabel *lblUploadFrom;

    IBOutlet UILabel * lblPrivacyHeading;
    IBOutlet UILabel * lblShowAsAuthor;
    IBOutlet UILabel * lblShowOnProfile;
    IBOutlet UILabel * lblPublishStmtHeading;
    IBOutlet UILabel * lblPublishStmt;
    IBOutlet UILabel * lblRelevantHeading;

    M13Checkbox *chkAuthor;
    M13Checkbox *chkShowOnProfile;
}

@property(nonatomic,strong)NSString *userID;

@property(nonatomic,strong)IBOutlet UIButton *btnOK;

@property(nonatomic,strong)IBOutlet CustomTextField *txtstatement;
@property(nonatomic,strong)IBOutlet CustomTextField *txtlanguage;
@property(nonatomic,strong)IBOutlet CustomTextField *txtFldWebLink;
@property(nonatomic,strong)IBOutlet CustomTextField *txtFldPathOfUploadFile;

@property(nonatomic,strong)IBOutlet UISwitch *swtPublish;
@property(nonatomic,strong)IBOutlet UISegmentedControl *segUpload;
@property(nonatomic,strong)IBOutlet UISegmentedControl *segPublishStatement;
@property(nonatomic,strong)IBOutlet UIScrollView *vScrollView;

-(IBAction)tappedOKButton:(id)sender;

@end
