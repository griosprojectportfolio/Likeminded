//
//  SignUpViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate> {
    NSMutableArray *usersArray;
    NSDictionary *dicst;
    UITextField *activetextfield;
    NSMutableDictionary *dictlanguage;
    NSString *auth_token;
    NSString*strid;
    NSString*strProvider;
    NSString *strgender;
    IBOutlet UIImageView *imgVwLineOfGender;
}

@property(nonatomic)NSInteger btnTag;

@property(nonatomic)NSInteger btnUpdatetag;

@property (nonatomic, strong) IBOutlet UINavigationBar *navBarKeyboard;

@property (nonatomic, strong) IBOutlet UIView *vwGender;
@property(nonatomic,strong)NSString *language;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic,strong)NSString *password;
@property(nonatomic, retain)AppApi *api;

@property(nonatomic,strong)IBOutlet UIScrollView *vScrollView;
@property(nonatomic,strong)IBOutlet UIButton *btnSignUp;
@property(nonatomic,strong)IBOutlet UIButton *btnUpdate;
@property(nonatomic,strong)IBOutlet UIButton *btnPreferedLanguage;

@property(nonatomic,strong)IBOutlet CustomTextField *txtUserID;
@property(nonatomic,strong)IBOutlet CustomTextField *txtname;
@property(nonatomic,strong)IBOutlet CustomTextField *txtCountry;
@property(nonatomic,strong)IBOutlet CustomTextField *txtState;
@property(nonatomic,strong)IBOutlet CustomTextField *btnState;
@property(nonatomic,strong)IBOutlet CustomTextField *txtCity;
@property(nonatomic,strong)IBOutlet CustomTextField *btnCity;
@property(nonatomic,strong)IBOutlet CustomTextField *txtPostalCode;
@property(nonatomic,strong)IBOutlet CustomTextField *txtDOB;
@property(nonatomic,strong)IBOutlet CustomTextField *txtPLanguage;
@property(nonatomic,strong)IBOutlet CustomTextField *txtNewPassword;
@property(nonatomic,strong)IBOutlet CustomTextField *txtConfirmationPassword;

@property (nonatomic, strong) NSString *strGPlusMailId;
@property (nonatomic) BOOL isGoogle;

@property(nonatomic, strong) NSDictionary *dictUserDetail;

@property(nonatomic, strong) NSMutableDictionary *dictSocialUserDetail;

@property(nonatomic,strong)IBOutlet UISegmentedControl *segmentGender;

- (IBAction)btnSignUpTapped:(id)sender;

- (IBAction)UpdateTapped:(id)sender;

- (IBAction)genderSegmenttapped:(id)sender;


@end
