//
//  LogInViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface LogInViewController : UIViewController<UITextFieldDelegate>{
    NSString *user;
    NSString *password;
    NSArray *userarr;
    NSArray *passwordarr;
    BOOL flag;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnTwitter;
    IBOutlet UIButton *btnGooglePlus;
}

@property(nonatomic)NSInteger btnTag;
@property(nonatomic,strong)NSString *auth_token;

@property(nonatomic,strong)NSMutableArray *userData;

@property(nonatomic,strong)IBOutlet UIImageView *imgViewEarth;
@property(nonatomic,strong)IBOutlet UIImageView *imgViewTextLogo;

@property(nonatomic,strong)IBOutlet UIButton *btnLogIn;
@property(nonatomic,strong)IBOutlet UIButton *btnSignUp;
@property(nonatomic,strong)IBOutlet UIButton *btnForgotPass;

@property(nonatomic,strong) M13Checkbox *btnCheckRemeber;
@property(nonatomic,strong)IBOutlet UILabel *lblRememberMe;

@property(nonatomic,strong)AppApi *api;

@property(nonatomic,strong)NSMutableArray *userDataArray;
@property(nonatomic,strong)NSDictionary   *userDataDisct;

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *password;

@property(nonatomic,strong)IBOutlet CustomTextField *txtUserID;
@property(nonatomic,strong)IBOutlet CustomTextField *txtPassword;
@property (nonatomic, strong) GPPSignInButton *signInButton;


-(IBAction)loginButtonTapped:(id)sender;
-(IBAction)signupButtonTapped:(id)sender;
-(IBAction)forgotPassButtonTapped:(id)sender;

@end
